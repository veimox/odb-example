#pragma once

#include <memory>
#include <odb/core.hxx>
#include <string>

#include "odb-example/constants.h"

#ifdef ODB_COMPILER
#include "odb-example/objects/user_settings.h"
#endif

class UserSettings;

#pragma db object table("user")
class User {
 public:
  User();

 private:
  friend class odb::access;

#pragma db id auto
  unsigned int id_;
#pragma db not_null type(VARCHAR_MEDIUM)
  std::string name_;
#pragma db not_null type(VARCHAR_MEDIUM)
  std::string message_;

#pragma db column("user_settings") not_null on_delete(cascade)
  std::shared_ptr<UserSettings> user_settings_;
};
