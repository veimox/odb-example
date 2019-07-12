#pragma once

#include <odb/core.hxx>
#include <string>

#pragma db object table("usersetttings")
class UserSettings {
 public:
  UserSettings();

 private:
  friend class odb::access;

#pragma db id auto
  unsigned int id_;
#pragma db null
  std::string language_;
#pragma db null
  std::string font_size_;
#pragma db null
  std::string color_scheme_;
};
