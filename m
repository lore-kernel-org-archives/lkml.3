Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3CKJ1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:27:48 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:59268 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752724Ab3CKJ1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:27:47 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 3.9-rc2  this dont compile / link    dwc3_gadget ,
 usb_gadget_map_request
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 11 Mar 2013 05:27:40 -0400
Message-ID: <web-853669895@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



   MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x2a64a): Section mismatch in 
reference from the function apply_microcode_early() to the 
function .cpuinit.text:print_ucode()
The function apply_microcode_early() references
the function __cpuinit print_ucode().
This is often because apply_microcode_early lacks a 
__cpuinit
annotation or the annotation of print_ucode is wrong.

WARNING: vmlinux.o(.text+0x76e662): Section mismatch in 
reference from the function acpi_sleep_dmi_check() to the 
variable .init.data:acpisleep_dmi_table
The function acpi_sleep_dmi_check() references
the variable __initdata acpisleep_dmi_table.
This is often because acpi_sleep_dmi_check lacks a 
__initdata
annotation or the annotation of acpisleep_dmi_table is 
wrong.

WARNING: vmlinux.o(.text+0x9e3716): Section mismatch in 
reference from the function cpqarray_register_ctlr() to 
the function .init.text:ida_procinit()
The function cpqarray_register_ctlr() references
the function __init ida_procinit().
This is often because cpqarray_register_ctlr lacks a 
__init
annotation or the annotation of ida_procinit is wrong.

WARNING: vmlinux.o(.text+0xa4197f): Section mismatch in 
reference from the function bmp085_init_client() to the 
function .init.text:bmp085_get_of_properties()
The function bmp085_init_client() references
the function __init bmp085_get_of_properties().
This is often because bmp085_init_client lacks a __init
annotation or the annotation of bmp085_get_of_properties 
is wrong.

WARNING: vmlinux.o(.data+0xa5c78): Section mismatch in 
reference from the variable sim710_eisa_driver to the 
function .init.text:sim710_eisa_probe()
The variable sim710_eisa_driver references
the function __init sim710_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: vmlinux.o(.data+0xe16b0): Section mismatch in 
reference from the variable el3_eisa_driver to the 
function .init.text:el3_eisa_probe()
The variable el3_eisa_driver references
the function __init el3_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: vmlinux.o(.data+0xe1d74): Section mismatch in 
reference from the variable vortex_eisa_driver to the 
function .init.text:vortex_eisa_probe()
The variable vortex_eisa_driver references
the function __init vortex_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: vmlinux.o(.data+0xe6b1c): Section mismatch in 
reference from the variable de4x5_eisa_driver to the 
function .init.text:de4x5_eisa_probe()
The variable de4x5_eisa_driver references
the function __init de4x5_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: vmlinux.o(.data+0xe73a0): Section mismatch in 
reference from the variable hp100_eisa_driver to the 
function .init.text:hp100_eisa_probe()
The variable hp100_eisa_driver references
the function __init hp100_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

   GEN     .version
   CHK     include/generated/compile.h
   UPD     include/generated/compile.h
   CC      init/version.o
   LD      init/built-in.o
drivers/built-in.o: In function 
`__dwc3_gadget_kick_transfer':
gadget.c:(.text+0xbb21d9): undefined reference to 
`usb_gadget_unmap_request'
drivers/built-in.o: In function `__dwc3_gadget_ep_queue':
gadget.c:(.text+0xbb22a9): undefined reference to 
`usb_gadget_map_request'
drivers/built-in.o: In function `dwc3_gadget_giveback':
(.text+0xbb24db): undefined reference to 
`usb_gadget_unmap_request'
drivers/built-in.o: In function `dwc3_gadget_exit':
(.text+0xbb2e52): undefined reference to 
`usb_del_gadget_udc'
drivers/built-in.o: In function `dwc3_gadget_init':
(.text+0xbb3a88): undefined reference to 
`usb_add_gadget_udc'
drivers/built-in.o: In function 
`__dwc3_ep0_do_control_data':
ep0.c:(.text+0xbb3f10): undefined reference to 
`usb_gadget_map_request'
ep0.c:(.text+0xbb3f6a): undefined reference to 
`usb_gadget_map_request'
make: [vmlinux] Error 1 (ignored)
   CC      arch/x86/boot/a20.o
   AS      arch/x86/boot/bioscall.o
   CC      arch/x86/boot/cmdline.o
   AS      arch/x86/boot/copy.o
   HOSTCC  arch/x86/boot/mkcpustr
   CPUSTR  arch/x86/boot/cpustr.h
   CC      arch/x86/boot/cpu.o
   CC      arch/x86/boot/cpucheck.o
   CC      arch/x86/boot/early_serial_console.o
   CC      arch/x86/boot/edd.o
make[1]: *** No rule to make target `vmlinux', needed by 
`arch/x86/boot/voffset.h'.
---
Professional hosting for everyone - http://www.host.ru
