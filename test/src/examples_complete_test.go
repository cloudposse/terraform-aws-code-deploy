package test

import (
	"math/rand"
	"strconv"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano())
	randID := strconv.Itoa(rand.Intn(100000))
	attributes := []string{randID}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		// We always include a random attribute so that parallel tests
		// and AWS resources do not interfere with each other
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	id := terraform.Output(t, terraformOptions, "id")
	name := terraform.Output(t, terraformOptions, "name")
	groupID := terraform.Output(t, terraformOptions, "group_id")
	deploymentConfigName := terraform.Output(t, terraformOptions, "deployment_config_name")
	deploymentConfigID := terraform.Output(t, terraformOptions, "deployment_config_id")

	assert.Equal(t, "cdp-test-ecs-alb-"+randID, name)
	assert.Equal(t, "cdp-test-ecs-alb-"+randID, deploymentConfigName)
	assert.Contains(t, id, "cdp-test-ecs-alb-"+randID, "ID should contains substring 'cdp-test-ecs-alb-'")
	assert.NotEmpty(t, groupID)
	assert.NotEmpty(t, deploymentConfigID)
}
