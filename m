Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3CDSfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:35:46 -0500
Received: from zfrontend1.aha.ru ([195.2.83.147]:41212 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754493Ab3CDSfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:35:45 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: 3.9-rc1   ath wil6210  ,    lp8788 charger  problems
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 04 Mar 2013 14:35:39 -0400
Message-ID: <web-851594569@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wil6210 don't compile , lp8788-charger  don't link good  , 
several section mismatchs.
Perhaps someone want to correct that

wl






cc1: warnings being treated as errors
drivers/net/wireless/ath/wil6210/txrx.c: In function 
'wil_vring_free':
drivers/net/wireless/ath/wil6210/txrx.c:142: warning: 
passing argument 3 of 'dma_free_attrs' discards qualifiers 
from pointer target type
make[5]: [drivers/net/wireless/ath/wil6210/txrx.o] Error 1 
(ignored)
   LD [M]  drivers/net/wireless/ath/wil6210/wil6210.o
ld: drivers/net/wireless/ath/wil6210/txrx.o: No such file: 
No such file or directory
make[5]: [drivers/net/wireless/ath/wil6210/wil6210.o] 
Error 1 (ignored)




drivers/built-in.o: In function 
`lp8788_release_adc_channel':
lp8788-charger.c:(.text+0xcd3148): undefined reference to 
`iio_channel_release'
drivers/built-in.o: In function 
`lp8788_setup_adc_channel':
lp8788-charger.c:(.text+0xcd3235): undefined reference to 
`iio_channel_get'
lp8788-charger.c:(.text+0xcd3253): undefined reference to 
`iio_channel_get'
drivers/built-in.o: In function 
`lp8788_get_battery_temperature':
lp8788-charger.c:(.text+0xcd331f): undefined reference to 
`iio_read_channel_processed'
drivers/built-in.o: In function `lp8788_get_vbatt_adc':
lp8788-charger.c:(.text+0xcd3352): undefined reference to 
`iio_read_channel_processed'
make: [vmlinux] Error 1 (ignored)




WARNING: vmlinux.o(.text+0x2a656): Section mismatch in 
reference from the function apply_microcode_early() to the 
function .cpuinit.text:print_ucode()
The function apply_microcode_early() references
the function __cpuinit print_ucode().
This is often because apply_microcode_early lacks a 
__cpuinit
annotation or the annotation of print_ucode is wrong.

WARNING: vmlinux.o(.text+0x769a8e): Section mismatch in 
reference from the function acpi_sleep_dmi_check() to the 
variable .init.data:acpisleep_dmi_table
The function acpi_sleep_dmi_check() references
the variable __initdata acpisleep_dmi_table.
This is often because acpi_sleep_dmi_check lacks a 
__initdata
annotation or the annotation of acpisleep_dmi_table is 
wrong.

WARNING: vmlinux.o(.text+0x9de64e): Section mismatch in 
reference from the function cpqarray_register_ctlr() to 
the function .init.text:ida_procinit()
The function cpqarray_register_ctlr() references
the function __init ida_procinit().
This is often because cpqarray_register_ctlr lacks a 
__init
annotation or the annotation of ida_procinit is wrong.

WARNING: vmlinux.o(.text+0xa3c8e3): Section mismatch in 
reference from the function bmp085_init_client() to the 
function .init.text:bmp085_get_of_properties()
The function bmp085_init_client() references
the function __init bmp085_get_of_properties().
This is often because bmp085_init_client lacks a __init
annotation or the annotation of bmp085_get_of_properties 
is wrong.

WARNING: vmlinux.o(.data+0xa5c1c): Section mismatch in 
reference from the variable sim710_eisa_driver to the 
function .init.text:sim710_eisa_probe()
The variable sim710_eisa_driver references
the function __init sim710_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: vmlinux.o(.data+0xe1654): Section mismatch in 
reference from the variable el3_eisa_driver to the 
function .init.text:el3_eisa_probe()
The variable el3_eisa_driver references
the function __init el3_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: vmlinux.o(.data+0xe1d18): Section mismatch in 
reference from the variable vortex_eisa_driver to the 
function .init.text:vortex_eisa_probe()
The variable vortex_eisa_driver references
the function __init vortex_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: vmlinux.o(.data+0xe6ac0): Section mismatch in 
reference from the variable de4x5_eisa_driver to the 
function .init.text:de4x5_eisa_probe()
The variable de4x5_eisa_driver references
the function __init de4x5_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: vmlinux.o(.data+0xe7344): Section mismatch in 
reference from the variable hp100_eisa_driver to the 
function .init.text:hp100_eisa_probe()
The variable hp100_eisa_driver references
the function __init hp100_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

---
Professional hosting for everyone - http://www.host.ru
