Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaJ1Tl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:41:58 -0400
Received: from mx1.riseup.net ([198.252.153.129]:35050 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaJ1Tl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:41:56 -0400
MIME-Version: 1.0
Date: Tue, 28 Oct 2014 17:41:53 -0200
Message-ID: <CA+bYFQZ2T4XPVhnZzfB5yWt6J11SDWf_5KzguEX0VZqmkVxYhQ@mail.gmail.com>
Subject: Errors: Compiling 3.18-rc2
From: Albino Biasutti Neto <bino@riseup.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I was compile kernel version 3.18-rc2, very errors:

# make -j2

fs/open.c:822:1: error: expected identifier or ‘(’ before ‘<<’ token
 <<<<<<< HEAD
 ^
fs/open.c: In function ‘build_open_flags’:
fs/open.c:847:1: error: expected declaration specifiers before ‘>>’ token
 >>>>>>> 88e237610b426897f0e9935adb6a60bd38bfe6c6
 ^
fs/open.c:847:9: error: invalid suffix
"b426897f0e9935adb6a60bd38bfe6c6" on floating constant
 >>>>>>> 88e237610b426897f0e9935adb6a60bd38bfe6c6
         ^
fs/open.c:926:77: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 struct file *file_open_name(struct filename *name, int flags, umode_t mode) {
                                                                             ^
fs/open.c:943:71: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 struct file *filp_open(const char *filename, int flags, umode_t mode) {
                                                                       ^
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
fs/open.c:947:15: error: storage class specified for parameter ‘filp_open’
 EXPORT_SYMBOL(filp_open);
               ^
include/linux/export.h:57:21: note: in definition of macro ‘__EXPORT_SYMBOL’
  extern typeof(sym) sym;     \
                     ^
fs/open.c:947:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_open);
 ^
include/linux/export.h:46:25: error: storage class specified for
parameter ‘__crc_filp_open’
  extern __visible void *__crc_##sym __attribute__((weak));  \
                         ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:947:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_open);
 ^
fs/open.c:947:1: warning: ‘weak’ attribute ignored [-Wattributes]
fs/open.c:947:1: warning: ‘externally_visible’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: storage class specified for
parameter ‘__kcrctab_filp_open’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:947:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_open);
 ^
fs/open.c:947:1: error: parameter ‘__kcrctab_filp_open’ is initialized
fs/open.c:947:1: warning: ‘__used__’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: section attribute not allowed for
‘__kcrctab_filp_open’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:947:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_open);
 ^
include/linux/export.h:59:20: error: storage class specified for
parameter ‘__kstrtab_filp_open’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:947:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_open);
 ^
fs/open.c:947:1: error: parameter ‘__kstrtab_filp_open’ is initialized
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:59:20: error: section attribute not allowed for
‘__kstrtab_filp_open’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:947:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_open);
 ^
include/linux/export.h:59:20: error: alignment may not be specified
for ‘__kstrtab_filp_open’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:947:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_open);
 ^
include/linux/export.h:62:36: error: storage class specified for
parameter ‘__ksymtab_filp_open’
  extern const struct kernel_symbol __ksymtab_##sym; \
                                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:947:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_open);
 ^
In file included from include/linux/compiler-gcc.h:106:0,
                 from include/linux/compiler.h:54,
                 from include/linux/string.h:5,
                 from fs/open.c:7:
include/linux/compiler-gcc4.h:65:19: error: expected declaration
specifiers before ‘__attribute__’
 #define __visible __attribute__((externally_visible))
                   ^
include/linux/export.h:63:2: note: in expansion of macro ‘__visible’
  __visible const struct kernel_symbol __ksymtab_##sym \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:947:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_open);
 ^
fs/open.c:947:25: error: expected declaration specifiers before ‘;’ token
 EXPORT_SYMBOL(filp_open);
                         ^
fs/open.c:951:1: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 {
 ^
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
fs/open.c:963:15: error: storage class specified for parameter ‘file_open_root’
 EXPORT_SYMBOL(file_open_root);
               ^
include/linux/export.h:57:21: note: in definition of macro ‘__EXPORT_SYMBOL’
  extern typeof(sym) sym;     \
                     ^
fs/open.c:963:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(file_open_root);
 ^
include/linux/export.h:46:25: error: storage class specified for
parameter ‘__crc_file_open_root’
  extern __visible void *__crc_##sym __attribute__((weak));  \
                         ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:963:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(file_open_root);
 ^
fs/open.c:963:1: warning: ‘weak’ attribute ignored [-Wattributes]
fs/open.c:963:1: warning: ‘externally_visible’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: storage class specified for
parameter ‘__kcrctab_file_open_root’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:963:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(file_open_root);
 ^
fs/open.c:963:1: error: parameter ‘__kcrctab_file_open_root’ is initialized
fs/open.c:963:1: warning: ‘__used__’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: section attribute not allowed for
‘__kcrctab_file_open_root’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:963:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(file_open_root);
 ^
include/linux/export.h:59:20: error: storage class specified for
parameter ‘__kstrtab_file_open_root’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:963:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(file_open_root);
 ^
fs/open.c:963:1: error: parameter ‘__kstrtab_file_open_root’ is initialized
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:59:20: error: section attribute not allowed for
‘__kstrtab_file_open_root’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:963:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(file_open_root);
 ^
include/linux/export.h:59:20: error: alignment may not be specified
for ‘__kstrtab_file_open_root’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:963:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(file_open_root);
 ^
include/linux/export.h:62:36: error: storage class specified for
parameter ‘__ksymtab_file_open_root’
  extern const struct kernel_symbol __ksymtab_##sym; \
                                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:963:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(file_open_root);
 ^
In file included from include/linux/compiler-gcc.h:106:0,
                 from include/linux/compiler.h:54,
                 from include/linux/string.h:5,
                 from fs/open.c:7:
include/linux/compiler-gcc4.h:65:19: error: expected declaration
specifiers before ‘__attribute__’
 #define __visible __attribute__((externally_visible))
                   ^
include/linux/export.h:63:2: note: in expansion of macro ‘__visible’
  __visible const struct kernel_symbol __ksymtab_##sym \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:963:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(file_open_root);
 ^
fs/open.c:963:30: error: expected declaration specifiers before ‘;’ token
 EXPORT_SYMBOL(file_open_root);
                              ^
fs/open.c:966:1: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 {
 ^
In file included from fs/open.c:26:0:
include/linux/syscalls.h:152:21: error: storage class specified for
parameter ‘types__open’
  static const char *types_##sname[] = {   \
                     ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
fs/open.c:993:1: error: parameter ‘types__open’ is initialized
fs/open.c:993:1: warning: initialization from incompatible pointer
type [enabled by default]
fs/open.c:993:1: warning: (near initialization for ‘types__open’)
[enabled by default]
fs/open.c:993:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:993:1: warning: (near initialization for ‘types__open’)
[enabled by default]
fs/open.c:993:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:993:1: warning: (near initialization for ‘types__open’)
[enabled by default]
In file included from fs/open.c:26:0:
include/linux/syscalls.h:155:21: error: storage class specified for
parameter ‘args__open’
  static const char *args_##sname[] = {   \
                     ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
fs/open.c:993:1: error: parameter ‘args__open’ is initialized
fs/open.c:993:1: warning: initialization from incompatible pointer
type [enabled by default]
fs/open.c:993:1: warning: (near initialization for ‘args__open’)
[enabled by default]
fs/open.c:993:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:993:1: warning: (near initialization for ‘args__open’)
[enabled by default]
fs/open.c:993:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:993:1: warning: (near initialization for ‘args__open’)
[enabled by default]
In file included from fs/open.c:26:0:
include/linux/syscalls.h:120:33: error: storage class specified for
parameter ‘__syscall_meta__open’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:122:4: error: storage class specified for
parameter ‘event_enter__open’
    event_enter_##sname = {     \
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:121:16: error: parameter ‘event_enter__open’
is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:121:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:133:4: error: storage class specified for
parameter ‘__event_enter__open’
   *__event_enter_##sname = &event_enter_##sname;
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:131:16: error: parameter
‘__event_enter__open’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:131:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:133:4: error: section attribute not allowed
for ‘__event_enter__open’
   *__event_enter_##sname = &event_enter_##sname;
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:158:34: error: expected declaration
specifiers before ‘;’ token
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
                                  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:136:33: error: storage class specified for
parameter ‘__syscall_meta__open’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:136:33: error: redefinition of parameter
‘__syscall_meta__open’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:120:33: note: previous definition of
‘__syscall_meta__open’ was here
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:138:4: error: storage class specified for
parameter ‘event_exit__open’
    event_exit_##sname = {     \
    ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:137:16: error: parameter ‘event_exit__open’
is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:137:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:149:3: error: storage class specified for
parameter ‘__event_exit__open’
  *__event_exit_##sname = &event_exit_##sname;
   ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:147:16: error: parameter ‘__event_exit__open’
is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:147:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:149:3: error: section attribute not allowed
for ‘__event_exit__open’
  *__event_exit_##sname = &event_exit_##sname;
   ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:159:33: error: expected declaration
specifiers before ‘;’ token
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
                                 ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:161:4: error: storage class specified for
parameter ‘__syscall_meta__open’
    __syscall_meta_##sname = {    \
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:160:16: error: parameter
‘__syscall_meta__open’ is initialized
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:160:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:161:4: error: redefinition of parameter
‘__syscall_meta__open’
    __syscall_meta_##sname = {    \
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:136:33: note: previous definition of
‘__syscall_meta__open’ was here
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:173:4: error: storage class specified for
parameter ‘__p_syscall_meta__open’
   *__p_syscall_meta_##sname = &__syscall_meta_##sname;
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:171:16: error: parameter
‘__p_syscall_meta__open’ is initialized
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:171:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:173:4: error: section attribute not allowed
for ‘__p_syscall_meta__open’
   *__p_syscall_meta_##sname = &__syscall_meta_##sname;
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:171:16: warning: ‘alias’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:197:21: error: storage class specified for
parameter ‘SYSC_open’
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:197:21: warning: parameter ‘SYSC_open’
declared ‘inline’ [enabled by default]
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:197:21: error: ‘no_instrument_function’
attribute applies only to functions
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
include/linux/syscalls.h:200:2: error: expected ‘=’, ‘,’, ‘;’, ‘asm’
or ‘__attribute__’ before ‘{’ token
  {        \
  ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:184:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
                                    ^
fs/open.c:993:1: note: in expansion of macro ‘SYSCALL_DEFINE3’
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 ^
fs/open.c:994:1: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 {
 ^
In file included from fs/open.c:26:0:
include/linux/syscalls.h:152:21: error: storage class specified for
parameter ‘types__openat’
  static const char *types_##sname[] = {   \
                     ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
fs/open.c:1001:1: error: parameter ‘types__openat’ is initialized
fs/open.c:1001:1: warning: initialization from incompatible pointer
type [enabled by default]
fs/open.c:1001:1: warning: (near initialization for ‘types__openat’)
[enabled by default]
fs/open.c:1001:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:1001:1: warning: (near initialization for ‘types__openat’)
[enabled by default]
fs/open.c:1001:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:1001:1: warning: (near initialization for ‘types__openat’)
[enabled by default]
fs/open.c:1001:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:1001:1: warning: (near initialization for ‘types__openat’)
[enabled by default]
In file included from fs/open.c:26:0:
include/linux/syscalls.h:155:21: error: storage class specified for
parameter ‘args__openat’
  static const char *args_##sname[] = {   \
                     ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
fs/open.c:1001:1: error: parameter ‘args__openat’ is initialized
fs/open.c:1001:1: warning: initialization from incompatible pointer
type [enabled by default]
fs/open.c:1001:1: warning: (near initialization for ‘args__openat’)
[enabled by default]
fs/open.c:1001:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:1001:1: warning: (near initialization for ‘args__openat’)
[enabled by default]
fs/open.c:1001:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:1001:1: warning: (near initialization for ‘args__openat’)
[enabled by default]
fs/open.c:1001:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:1001:1: warning: (near initialization for ‘args__openat’)
[enabled by default]
In file included from fs/open.c:26:0:
include/linux/syscalls.h:120:33: error: storage class specified for
parameter ‘__syscall_meta__openat’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:122:4: error: storage class specified for
parameter ‘event_enter__openat’
    event_enter_##sname = {     \
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:121:16: error: parameter
‘event_enter__openat’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:121:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:133:4: error: storage class specified for
parameter ‘__event_enter__openat’
   *__event_enter_##sname = &event_enter_##sname;
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:131:16: error: parameter
‘__event_enter__openat’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:131:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:133:4: error: section attribute not allowed
for ‘__event_enter__openat’
   *__event_enter_##sname = &event_enter_##sname;
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:158:34: error: expected declaration
specifiers before ‘;’ token
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
                                  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:136:33: error: storage class specified for
parameter ‘__syscall_meta__openat’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:136:33: error: redefinition of parameter
‘__syscall_meta__openat’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:120:33: note: previous definition of
‘__syscall_meta__openat’ was here
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:138:4: error: storage class specified for
parameter ‘event_exit__openat’
    event_exit_##sname = {     \
    ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:137:16: error: parameter ‘event_exit__openat’
is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:137:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:149:3: error: storage class specified for
parameter ‘__event_exit__openat’
  *__event_exit_##sname = &event_exit_##sname;
   ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:147:16: error: parameter
‘__event_exit__openat’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:147:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:149:3: error: section attribute not allowed
for ‘__event_exit__openat’
  *__event_exit_##sname = &event_exit_##sname;
   ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:159:33: error: expected declaration
specifiers before ‘;’ token
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
                                 ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:161:4: error: storage class specified for
parameter ‘__syscall_meta__openat’
    __syscall_meta_##sname = {    \
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:160:16: error: parameter
‘__syscall_meta__openat’ is initialized
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:160:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:161:4: error: redefinition of parameter
‘__syscall_meta__openat’
    __syscall_meta_##sname = {    \
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:136:33: note: previous definition of
‘__syscall_meta__openat’ was here
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:173:4: error: storage class specified for
parameter ‘__p_syscall_meta__openat’
   *__p_syscall_meta_##sname = &__syscall_meta_##sname;
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:171:16: error: parameter
‘__p_syscall_meta__openat’ is initialized
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:171:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:173:4: error: section attribute not allowed
for ‘__p_syscall_meta__openat’
   *__p_syscall_meta_##sname = &__syscall_meta_##sname;
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:171:16: warning: ‘alias’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:197:21: error: storage class specified for
parameter ‘SYSC_openat’
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:197:21: warning: parameter ‘SYSC_openat’
declared ‘inline’ [enabled by default]
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:197:21: error: ‘no_instrument_function’
attribute applies only to functions
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
include/linux/syscalls.h:200:2: error: expected ‘=’, ‘,’, ‘;’, ‘asm’
or ‘__attribute__’ before ‘{’ token
  {        \
  ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:185:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1001:1: note: in expansion of macro ‘SYSCALL_DEFINE4’
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 ^
fs/open.c:1003:1: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 {
 ^
In file included from fs/open.c:26:0:
include/linux/syscalls.h:152:21: error: storage class specified for
parameter ‘types__creat’
  static const char *types_##sname[] = {   \
                     ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
fs/open.c:1016:1: error: parameter ‘types__creat’ is initialized
fs/open.c:1016:1: warning: initialization from incompatible pointer
type [enabled by default]
fs/open.c:1016:1: warning: (near initialization for ‘types__creat’)
[enabled by default]
fs/open.c:1016:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:1016:1: warning: (near initialization for ‘types__creat’)
[enabled by default]
In file included from fs/open.c:26:0:
include/linux/syscalls.h:155:21: error: storage class specified for
parameter ‘args__creat’
  static const char *args_##sname[] = {   \
                     ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
fs/open.c:1016:1: error: parameter ‘args__creat’ is initialized
fs/open.c:1016:1: warning: initialization from incompatible pointer
type [enabled by default]
fs/open.c:1016:1: warning: (near initialization for ‘args__creat’)
[enabled by default]
fs/open.c:1016:1: warning: excess elements in scalar initializer
[enabled by default]
fs/open.c:1016:1: warning: (near initialization for ‘args__creat’)
[enabled by default]
In file included from fs/open.c:26:0:
include/linux/syscalls.h:120:33: error: storage class specified for
parameter ‘__syscall_meta__creat’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:122:4: error: storage class specified for
parameter ‘event_enter__creat’
    event_enter_##sname = {     \
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:121:16: error: parameter ‘event_enter__creat’
is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:121:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:133:4: error: storage class specified for
parameter ‘__event_enter__creat’
   *__event_enter_##sname = &event_enter_##sname;
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:131:16: error: parameter
‘__event_enter__creat’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:131:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:133:4: error: section attribute not allowed
for ‘__event_enter__creat’
   *__event_enter_##sname = &event_enter_##sname;
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:158:34: error: expected declaration
specifiers before ‘;’ token
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
                                  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:136:33: error: storage class specified for
parameter ‘__syscall_meta__creat’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:136:33: error: redefinition of parameter
‘__syscall_meta__creat’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:120:33: note: previous definition of
‘__syscall_meta__creat’ was here
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:138:4: error: storage class specified for
parameter ‘event_exit__creat’
    event_exit_##sname = {     \
    ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:137:16: error: parameter ‘event_exit__creat’
is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:137:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:149:3: error: storage class specified for
parameter ‘__event_exit__creat’
  *__event_exit_##sname = &event_exit_##sname;
   ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:147:16: error: parameter
‘__event_exit__creat’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:147:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:149:3: error: section attribute not allowed
for ‘__event_exit__creat’
  *__event_exit_##sname = &event_exit_##sname;
   ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:159:33: error: expected declaration
specifiers before ‘;’ token
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
                                 ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:161:4: error: storage class specified for
parameter ‘__syscall_meta__creat’
    __syscall_meta_##sname = {    \
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:160:16: error: parameter
‘__syscall_meta__creat’ is initialized
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:160:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:161:4: error: redefinition of parameter
‘__syscall_meta__creat’
    __syscall_meta_##sname = {    \
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:136:33: note: previous definition of
‘__syscall_meta__creat’ was here
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:173:4: error: storage class specified for
parameter ‘__p_syscall_meta__creat’
   *__p_syscall_meta_##sname = &__syscall_meta_##sname;
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:171:16: error: parameter
‘__p_syscall_meta__creat’ is initialized
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:171:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:173:4: error: section attribute not allowed
for ‘__p_syscall_meta__creat’
   *__p_syscall_meta_##sname = &__syscall_meta_##sname;
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:171:16: warning: ‘alias’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:197:21: error: storage class specified for
parameter ‘SYSC_creat’
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:197:21: warning: parameter ‘SYSC_creat’
declared ‘inline’ [enabled by default]
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:197:21: error: ‘no_instrument_function’
attribute applies only to functions
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
include/linux/syscalls.h:200:2: error: expected ‘=’, ‘,’, ‘;’, ‘asm’
or ‘__attribute__’ before ‘{’ token
  {        \
  ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:183:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1016:1: note: in expansion of macro ‘SYSCALL_DEFINE2’
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 ^
fs/open.c:1016:70: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
                                                                      ^
fs/open.c:1025:50: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 int filp_close(struct file *filp, fl_owner_t id) {
                                                  ^
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
fs/open.c:1044:15: error: storage class specified for parameter ‘filp_close’
 EXPORT_SYMBOL(filp_close);
               ^
include/linux/export.h:57:21: note: in definition of macro ‘__EXPORT_SYMBOL’
  extern typeof(sym) sym;     \
                     ^
fs/open.c:1044:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_close);
 ^
include/linux/export.h:46:25: error: storage class specified for
parameter ‘__crc_filp_close’
  extern __visible void *__crc_##sym __attribute__((weak));  \
                         ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1044:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_close);
 ^
fs/open.c:1044:1: warning: ‘weak’ attribute ignored [-Wattributes]
fs/open.c:1044:1: warning: ‘externally_visible’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: storage class specified for
parameter ‘__kcrctab_filp_close’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1044:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_close);
 ^
fs/open.c:1044:1: error: parameter ‘__kcrctab_filp_close’ is initialized
fs/open.c:1044:1: warning: ‘__used__’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: section attribute not allowed for
‘__kcrctab_filp_close’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1044:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_close);
 ^
include/linux/export.h:59:20: error: storage class specified for
parameter ‘__kstrtab_filp_close’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1044:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_close);
 ^
fs/open.c:1044:1: error: parameter ‘__kstrtab_filp_close’ is initialized
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:59:20: error: section attribute not allowed for
‘__kstrtab_filp_close’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1044:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_close);
 ^
include/linux/export.h:59:20: error: alignment may not be specified
for ‘__kstrtab_filp_close’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1044:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_close);
 ^
include/linux/export.h:62:36: error: storage class specified for
parameter ‘__ksymtab_filp_close’
  extern const struct kernel_symbol __ksymtab_##sym; \
                                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1044:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_close);
 ^
In file included from include/linux/compiler-gcc.h:106:0,
                 from include/linux/compiler.h:54,
                 from include/linux/string.h:5,
                 from fs/open.c:7:
include/linux/compiler-gcc4.h:65:19: error: expected declaration
specifiers before ‘__attribute__’
 #define __visible __attribute__((externally_visible))
                   ^
include/linux/export.h:63:2: note: in expansion of macro ‘__visible’
  __visible const struct kernel_symbol __ksymtab_##sym \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1044:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(filp_close);
 ^
fs/open.c:1044:26: error: expected declaration specifiers before ‘;’ token
 EXPORT_SYMBOL(filp_close);
                          ^
In file included from fs/open.c:26:0:
include/linux/syscalls.h:152:21: error: storage class specified for
parameter ‘types__close’
  static const char *types_##sname[] = {   \
                     ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
fs/open.c:1051:1: error: parameter ‘types__close’ is initialized
fs/open.c:1051:1: warning: initialization from incompatible pointer
type [enabled by default]
fs/open.c:1051:1: warning: (near initialization for ‘types__close’)
[enabled by default]
In file included from fs/open.c:26:0:
include/linux/syscalls.h:155:21: error: storage class specified for
parameter ‘args__close’
  static const char *args_##sname[] = {   \
                     ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
fs/open.c:1051:1: error: parameter ‘args__close’ is initialized
fs/open.c:1051:1: warning: initialization from incompatible pointer
type [enabled by default]
fs/open.c:1051:1: warning: (near initialization for ‘args__close’)
[enabled by default]
In file included from fs/open.c:26:0:
include/linux/syscalls.h:120:33: error: storage class specified for
parameter ‘__syscall_meta__close’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:122:4: error: storage class specified for
parameter ‘event_enter__close’
    event_enter_##sname = {     \
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:121:16: error: parameter ‘event_enter__close’
is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:121:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:133:4: error: storage class specified for
parameter ‘__event_enter__close’
   *__event_enter_##sname = &event_enter_##sname;
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:131:16: error: parameter
‘__event_enter__close’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:131:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:133:4: error: section attribute not allowed
for ‘__event_enter__close’
   *__event_enter_##sname = &event_enter_##sname;
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:158:34: error: expected declaration
specifiers before ‘;’ token
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
                                  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:136:33: error: storage class specified for
parameter ‘__syscall_meta__close’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:136:33: error: redefinition of parameter
‘__syscall_meta__close’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:120:33: note: previous definition of
‘__syscall_meta__close’ was here
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:138:4: error: storage class specified for
parameter ‘event_exit__close’
    event_exit_##sname = {     \
    ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:137:16: error: parameter ‘event_exit__close’
is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:137:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:149:3: error: storage class specified for
parameter ‘__event_exit__close’
  *__event_exit_##sname = &event_exit_##sname;
   ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:147:16: error: parameter
‘__event_exit__close’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:147:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:149:3: error: section attribute not allowed
for ‘__event_exit__close’
  *__event_exit_##sname = &event_exit_##sname;
   ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:159:33: error: expected declaration
specifiers before ‘;’ token
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
                                 ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:161:4: error: storage class specified for
parameter ‘__syscall_meta__close’
    __syscall_meta_##sname = {    \
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:160:16: error: parameter
‘__syscall_meta__close’ is initialized
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:160:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:161:4: error: redefinition of parameter
‘__syscall_meta__close’
    __syscall_meta_##sname = {    \
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:136:33: note: previous definition of
‘__syscall_meta__close’ was here
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:173:4: error: storage class specified for
parameter ‘__p_syscall_meta__close’
   *__p_syscall_meta_##sname = &__syscall_meta_##sname;
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:171:16: error: parameter
‘__p_syscall_meta__close’ is initialized
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:171:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:173:4: error: section attribute not allowed
for ‘__p_syscall_meta__close’
   *__p_syscall_meta_##sname = &__syscall_meta_##sname;
    ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:171:16: warning: ‘alias’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:190:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(sname, x, __VA_ARGS__)   \
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:197:21: error: storage class specified for
parameter ‘SYSC_close’
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:197:21: warning: parameter ‘SYSC_close’
declared ‘inline’ [enabled by default]
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:197:21: error: ‘no_instrument_function’
attribute applies only to functions
  static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
                     ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
include/linux/syscalls.h:200:2: error: expected ‘=’, ‘,’, ‘;’, ‘asm’
or ‘__attribute__’ before ‘{’ token
  {        \
  ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
fs/open.c:1051:42: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 SYSCALL_DEFINE1(close, unsigned int, fd) {
                                          ^
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
fs/open.c:1063:15: error: storage class specified for parameter ‘sys_close’
 EXPORT_SYMBOL(sys_close);
               ^
include/linux/export.h:57:21: note: in definition of macro ‘__EXPORT_SYMBOL’
  extern typeof(sym) sym;     \
                     ^
fs/open.c:1063:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(sys_close);
 ^
fs/open.c:1063:15: error: redefinition of parameter ‘sys_close’
 EXPORT_SYMBOL(sys_close);
               ^
include/linux/export.h:57:21: note: in definition of macro ‘__EXPORT_SYMBOL’
  extern typeof(sym) sym;     \
                     ^
fs/open.c:1063:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(sys_close);
 ^
In file included from fs/open.c:26:0:
include/linux/syscalls.h:195:18: note: previous definition of
‘sys_close’ was here
  asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__)) \
                  ^
include/linux/syscalls.h:191:2: note: in expansion of macro ‘__SYSCALL_DEFINEx’
  __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
  ^
include/linux/syscalls.h:182:36: note: in expansion of macro ‘SYSCALL_DEFINEx’
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                    ^
fs/open.c:1051:1: note: in expansion of macro ‘SYSCALL_DEFINE1’
 SYSCALL_DEFINE1(close, unsigned int, fd) {
 ^
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:46:25: error: storage class specified for
parameter ‘__crc_sys_close’
  extern __visible void *__crc_##sym __attribute__((weak));  \
                         ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1063:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(sys_close);
 ^
fs/open.c:1063:1: warning: ‘weak’ attribute ignored [-Wattributes]
fs/open.c:1063:1: warning: ‘externally_visible’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: storage class specified for
parameter ‘__kcrctab_sys_close’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1063:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(sys_close);
 ^
fs/open.c:1063:1: error: parameter ‘__kcrctab_sys_close’ is initialized
fs/open.c:1063:1: warning: ‘__used__’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: section attribute not allowed for
‘__kcrctab_sys_close’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1063:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(sys_close);
 ^
include/linux/export.h:59:20: error: storage class specified for
parameter ‘__kstrtab_sys_close’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1063:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(sys_close);
 ^
fs/open.c:1063:1: error: parameter ‘__kstrtab_sys_close’ is initialized
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:59:20: error: section attribute not allowed for
‘__kstrtab_sys_close’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1063:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(sys_close);
 ^
include/linux/export.h:59:20: error: alignment may not be specified
for ‘__kstrtab_sys_close’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1063:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(sys_close);
 ^
include/linux/export.h:62:36: error: storage class specified for
parameter ‘__ksymtab_sys_close’
  extern const struct kernel_symbol __ksymtab_##sym; \
                                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1063:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(sys_close);
 ^
In file included from include/linux/compiler-gcc.h:106:0,
                 from include/linux/compiler.h:54,
                 from include/linux/string.h:5,
                 from fs/open.c:7:
include/linux/compiler-gcc4.h:65:19: error: expected declaration
specifiers before ‘__attribute__’
 #define __visible __attribute__((externally_visible))
                   ^
include/linux/export.h:63:2: note: in expansion of macro ‘__visible’
  __visible const struct kernel_symbol __ksymtab_##sym \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1063:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(sys_close);
 ^
fs/open.c:1063:25: error: expected declaration specifiers before ‘;’ token
 EXPORT_SYMBOL(sys_close);
                         ^
In file included from fs/open.c:26:0:
include/linux/syscalls.h:152:21: error: storage class specified for
parameter ‘types__vhangup’
  static const char *types_##sname[] = {   \
                     ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
fs/open.c:1069:1: error: parameter ‘types__vhangup’ is initialized
fs/open.c:1069:1: error: empty scalar initializer
fs/open.c:1069:1: error: (near initialization for ‘types__vhangup’)
In file included from fs/open.c:26:0:
include/linux/syscalls.h:155:21: error: storage class specified for
parameter ‘args__vhangup’
  static const char *args_##sname[] = {   \
                     ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
fs/open.c:1069:1: error: parameter ‘args__vhangup’ is initialized
fs/open.c:1069:1: error: empty scalar initializer
fs/open.c:1069:1: error: (near initialization for ‘args__vhangup’)
In file included from fs/open.c:26:0:
include/linux/syscalls.h:120:33: error: storage class specified for
parameter ‘__syscall_meta__vhangup’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:122:4: error: storage class specified for
parameter ‘event_enter__vhangup’
    event_enter_##sname = {     \
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:121:16: error: parameter
‘event_enter__vhangup’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:121:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:133:4: error: storage class specified for
parameter ‘__event_enter__vhangup’
   *__event_enter_##sname = &event_enter_##sname;
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:131:16: error: parameter
‘__event_enter__vhangup’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:131:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:133:4: error: section attribute not allowed
for ‘__event_enter__vhangup’
   *__event_enter_##sname = &event_enter_##sname;
    ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:158:34: error: expected declaration
specifiers before ‘;’ token
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
                                  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:136:33: error: storage class specified for
parameter ‘__syscall_meta__vhangup’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:136:33: error: redefinition of parameter
‘__syscall_meta__vhangup’
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:120:33: note: previous definition of
‘__syscall_meta__vhangup’ was here
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:158:2: note: in expansion of macro
‘SYSCALL_TRACE_ENTER_EVENT’
  SYSCALL_TRACE_ENTER_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:138:4: error: storage class specified for
parameter ‘event_exit__vhangup’
    event_exit_##sname = {     \
    ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:137:16: error: parameter
‘event_exit__vhangup’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:137:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:149:3: error: storage class specified for
parameter ‘__event_exit__vhangup’
  *__event_exit_##sname = &event_exit_##sname;
   ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:147:16: error: parameter
‘__event_exit__vhangup’ is initialized
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:147:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct ftrace_event_call __used    \
                ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:149:3: error: section attribute not allowed
for ‘__event_exit__vhangup’
  *__event_exit_##sname = &event_exit_##sname;
   ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:159:33: error: expected declaration
specifiers before ‘;’ token
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
                                 ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:161:4: error: storage class specified for
parameter ‘__syscall_meta__vhangup’
    __syscall_meta_##sname = {    \
    ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:160:16: error: parameter
‘__syscall_meta__vhangup’ is initialized
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:160:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:161:4: error: redefinition of parameter
‘__syscall_meta__vhangup’
    __syscall_meta_##sname = {    \
    ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:136:33: note: previous definition of
‘__syscall_meta__vhangup’ was here
  static struct syscall_metadata __syscall_meta_##sname;  \
                                 ^
include/linux/syscalls.h:159:2: note: in expansion of macro
‘SYSCALL_TRACE_EXIT_EVENT’
  SYSCALL_TRACE_EXIT_EVENT(sname);   \
  ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:173:4: error: storage class specified for
parameter ‘__p_syscall_meta__vhangup’
   *__p_syscall_meta_##sname = &__syscall_meta_##sname;
    ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:171:16: error: parameter
‘__p_syscall_meta__vhangup’ is initialized
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:171:16: warning: ‘__used__’ attribute ignored
[-Wattributes]
  static struct syscall_metadata __used   \
                ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:173:4: error: section attribute not allowed
for ‘__p_syscall_meta__vhangup’
   *__p_syscall_meta_##sname = &__syscall_meta_##sname;
    ^
include/linux/syscalls.h:179:2: note: in expansion of macro ‘SYSCALL_METADATA’
  SYSCALL_METADATA(_##sname, 0);    \
  ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
include/linux/syscalls.h:179:31: error: expected declaration
specifiers before ‘;’ token
  SYSCALL_METADATA(_##sname, 0);    \
                               ^
fs/open.c:1069:1: note: in expansion of macro ‘SYSCALL_DEFINE0’
 SYSCALL_DEFINE0(vhangup) {
 ^
fs/open.c:1069:26: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 SYSCALL_DEFINE0(vhangup) {
                          ^
fs/open.c:1083:65: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 int generic_file_open(struct inode * inode, struct file * filp) {
                                                                 ^
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
fs/open.c:1089:15: error: storage class specified for parameter
‘generic_file_open’
 EXPORT_SYMBOL(generic_file_open);
               ^
include/linux/export.h:57:21: note: in definition of macro ‘__EXPORT_SYMBOL’
  extern typeof(sym) sym;     \
                     ^
fs/open.c:1089:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(generic_file_open);
 ^
include/linux/export.h:46:25: error: storage class specified for
parameter ‘__crc_generic_file_open’
  extern __visible void *__crc_##sym __attribute__((weak));  \
                         ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1089:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(generic_file_open);
 ^
fs/open.c:1089:1: warning: ‘weak’ attribute ignored [-Wattributes]
fs/open.c:1089:1: warning: ‘externally_visible’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: storage class specified for
parameter ‘__kcrctab_generic_file_open’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1089:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(generic_file_open);
 ^
fs/open.c:1089:1: error: parameter ‘__kcrctab_generic_file_open’ is initialized
fs/open.c:1089:1: warning: ‘__used__’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: section attribute not allowed for
‘__kcrctab_generic_file_open’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1089:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(generic_file_open);
 ^
include/linux/export.h:59:20: error: storage class specified for
parameter ‘__kstrtab_generic_file_open’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1089:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(generic_file_open);
 ^
fs/open.c:1089:1: error: parameter ‘__kstrtab_generic_file_open’ is initialized
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:59:20: error: section attribute not allowed for
‘__kstrtab_generic_file_open’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1089:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(generic_file_open);
 ^
include/linux/export.h:59:20: error: alignment may not be specified
for ‘__kstrtab_generic_file_open’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1089:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(generic_file_open);
 ^
include/linux/export.h:62:36: error: storage class specified for
parameter ‘__ksymtab_generic_file_open’
  extern const struct kernel_symbol __ksymtab_##sym; \
                                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1089:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(generic_file_open);
 ^
In file included from include/linux/compiler-gcc.h:106:0,
                 from include/linux/compiler.h:54,
                 from include/linux/string.h:5,
                 from fs/open.c:7:
include/linux/compiler-gcc4.h:65:19: error: expected declaration
specifiers before ‘__attribute__’
 #define __visible __attribute__((externally_visible))
                   ^
include/linux/export.h:63:2: note: in expansion of macro ‘__visible’
  __visible const struct kernel_symbol __ksymtab_##sym \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1089:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(generic_file_open);
 ^
fs/open.c:1089:33: error: expected declaration specifiers before ‘;’ token
 EXPORT_SYMBOL(generic_file_open);
                                 ^
fs/open.c:1097:62: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘{’ token
 int nonseekable_open(struct inode *inode, struct file *filp) {
                                                              ^
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
fs/open.c:1102:15: error: storage class specified for parameter
‘nonseekable_open’
 EXPORT_SYMBOL(nonseekable_open);
               ^
include/linux/export.h:57:21: note: in definition of macro ‘__EXPORT_SYMBOL’
  extern typeof(sym) sym;     \
                     ^
fs/open.c:1102:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(nonseekable_open);
 ^
include/linux/export.h:46:25: error: storage class specified for
parameter ‘__crc_nonseekable_open’
  extern __visible void *__crc_##sym __attribute__((weak));  \
                         ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1102:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(nonseekable_open);
 ^
fs/open.c:1102:1: warning: ‘weak’ attribute ignored [-Wattributes]
fs/open.c:1102:1: warning: ‘externally_visible’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: storage class specified for
parameter ‘__kcrctab_nonseekable_open’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1102:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(nonseekable_open);
 ^
fs/open.c:1102:1: error: parameter ‘__kcrctab_nonseekable_open’ is initialized
fs/open.c:1102:1: warning: ‘__used__’ attribute ignored [-Wattributes]
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:47:29: error: section attribute not allowed for
‘__kcrctab_nonseekable_open’
  static const unsigned long __kcrctab_##sym  \
                             ^
include/linux/export.h:58:2: note: in expansion of macro ‘__CRC_SYMBOL’
  __CRC_SYMBOL(sym, sec)     \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1102:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(nonseekable_open);
 ^
include/linux/export.h:59:20: error: storage class specified for
parameter ‘__kstrtab_nonseekable_open’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1102:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(nonseekable_open);
 ^
fs/open.c:1102:1: error: parameter ‘__kstrtab_nonseekable_open’ is initialized
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from fs/open.c:8:
include/linux/export.h:59:20: error: section attribute not allowed for
‘__kstrtab_nonseekable_open’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1102:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(nonseekable_open);
 ^
include/linux/export.h:59:20: error: alignment may not be specified
for ‘__kstrtab_nonseekable_open’
  static const char __kstrtab_##sym[]   \
                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1102:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(nonseekable_open);
 ^
include/linux/export.h:62:36: error: storage class specified for
parameter ‘__ksymtab_nonseekable_open’
  extern const struct kernel_symbol __ksymtab_##sym; \
                                    ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1102:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(nonseekable_open);
 ^
In file included from include/linux/compiler-gcc.h:106:0,
                 from include/linux/compiler.h:54,
                 from include/linux/string.h:5,
                 from fs/open.c:7:
include/linux/compiler-gcc4.h:65:19: error: expected declaration
specifiers before ‘__attribute__’
 #define __visible __attribute__((externally_visible))
                   ^
include/linux/export.h:63:2: note: in expansion of macro ‘__visible’
  __visible const struct kernel_symbol __ksymtab_##sym \
  ^
include/linux/export.h:69:2: note: in expansion of macro ‘__EXPORT_SYMBOL’
  __EXPORT_SYMBOL(sym, "")
  ^
fs/open.c:1102:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(nonseekable_open);
 ^
fs/open.c:1102:32: error: expected declaration specifiers before ‘;’ token
 EXPORT_SYMBOL(nonseekable_open);
                                ^
fs/open.c:846:19: error: old-style parameter declarations in
prototyped function definition
 static inline int build_open_flags(int flags, umode_t mode, struct
open_flags *op)
                   ^
fs/open.c:1102:32: error: expected ‘{’ at end of input
 EXPORT_SYMBOL(nonseekable_open);
                                ^
fs/open.c:1102:32: warning: no return statement in function returning
non-void [-Wreturn-type]
make[1]: ** [fs/open.o] Erro 1
make: ** [fs] Erro 2
make: ** Esperando que outros processos terminem.
  CC      kernel/watchdog.o
  CC      kernel/seccomp.o
  CC      kernel/relay.o
  CC      kernel/utsname_sysctl.o
  CC      kernel/delayacct.o
  CC      kernel/taskstats.o
  CC      kernel/tsacct.o
  CC      kernel/tracepoint.o
  CC      kernel/latencytop.o
  CC      kernel/elfcore.o
  CC      kernel/irq_work.o
  CC      kernel/user-return-notifier.o
  CC      kernel/padata.o
  CC      kernel/crash_dump.o
  CC      kernel/jump_label.o
  LD      kernel/built-in.o


                          Albino
                          binoanb.eti.br
