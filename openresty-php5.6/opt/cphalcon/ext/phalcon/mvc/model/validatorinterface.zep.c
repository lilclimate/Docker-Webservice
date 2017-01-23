
#ifdef HAVE_CONFIG_H
#include "../../../ext_config.h"
#endif

#include <php.h>
#include "../../../php_ext.h"
#include "../../../ext.h"

#include <Zend/zend_exceptions.h>

#include "kernel/main.h"


/**
 * Phalcon\Mvc\Model\ValidatorInterface
 *
 * Interface for Phalcon\Mvc\Model validators
 */
ZEPHIR_INIT_CLASS(Phalcon_Mvc_Model_ValidatorInterface) {

	ZEPHIR_REGISTER_INTERFACE(Phalcon\\Mvc\\Model, ValidatorInterface, phalcon, mvc_model_validatorinterface, phalcon_mvc_model_validatorinterface_method_entry);

	return SUCCESS;

}

/**
 * Returns messages generated by the validator
 *
 * @return array
 */
ZEPHIR_DOC_METHOD(Phalcon_Mvc_Model_ValidatorInterface, getMessages);

/**
 * Executes the validator
 *
 * @param \Phalcon\Mvc\ModelInterface record
 * @return boolean
 */
ZEPHIR_DOC_METHOD(Phalcon_Mvc_Model_ValidatorInterface, validate);
