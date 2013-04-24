Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab3DXX5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:57:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12584 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab3DXX5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:57:52 -0400
X-AuditID: cbfee68d-b7f016d000007930-83-5178717ec2e6
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Aaro Koskinen'" <aaro.koskinen@iki.fi>,
        "'Mikael Pettersson'" <mikpe@it.uu.se>,
        "'Russell King'" <linux@arm.linux.org.uk>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] ARM: 7692/1: iop3xx: move
 IOP3XX_PERIPHERAL_VIRT_BASE
Date: Thu, 25 Apr 2013 08:57:50 +0900
Message-id: <001401ce4147$87010ec0$95032c40$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAAEqHoAC1cPGAA1jCBmA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zY926wopAgwtLVCzWvHCwWNLMbXF5
	1xw2i9uXeS2eNF9ntFiw8RGjA5tHS3MPm8fhrwtZPP6/PMLm0bdlFaPH501yAaxRXDYpqTmZ
	ZalF+nYJXBl3Dh5lKjggW7FtzX32BsY/4l2MnBwSAiYSTZMXM0LYYhIX7q1nA7GFBJYxSlzt
	j4GpWbFvCXMXIxdQfBGjxMkPfSwQzl9GiYs7rzGDVLEJ6EocW7+FFcQWEfCWODXlF1gHs8Bk
	Rond/f+AEhxAHdwSq5uDQGo4BXgk1v3pBOsVFgiWuPDqAjuIzSKgKvH0/y4wm1fATmLa0Yks
	ELagxI/J98BsZgEtifU7jzNB2PISm9e8ZQYZLyGgLvHory7ECX4SzYtPM0OUiEjse/GOEeQc
	CYFH7BLPZyxmg9glIPFt8iEWiF5ZiU0HmCEelpQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiy
	ilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMkWnt3MN4+YH2IMRlo/URmKdHkfGC055XEGxqb
	GVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcXLDooMKmx7/
	E5HeU5106E3TTSZvzV9/Np79vNZj+2Utq41HbR8fkGtQcexa9EH7lt3d12Fd9csa902wWhfo
	lH9+stqU/sfrjv0vmTRXtC7gWeuPDzcnGt85H2lV+u1B1DT9y66/Fr+WLbGzSWhT494UfLDo
	rF5lc8HHlu2/zJp1A9333Hu10ViJpTgj0VCLuag4EQAyOeiq7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAd26wopAg3k35C3WvHCwWNLMbXF5
	1xw2i9uXeS2eNF9ntFiw8RGjA5tHS3MPm8fhrwtZPP6/PMLm0bdlFaPH501yAaxRDYw2GamJ
	KalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUD7lRTKEnNKgUIB
	icXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZdw4eZSo4IFuxbc199gbGP+JdjJwcEgIm
	Eiv2LWGGsMUkLtxbz9bFyMUhJLCIUeLkhz4WCOcvo8TFndfAqtgEdCWOrd/CCmKLCHhLnJry
	ixmkiFlgMqPE7v5/QAkOoA5uidXNQSA1nAI8Euv+dIL1CgsES1x4dYEdxGYRUJV4+n8XmM0r
	YCcx7ehEFghbUOLH5HtgNrOAlsT6nceZIGx5ic1r3jKDjJcQUJd49FcX4gQ/iebFp5khSkQk
	9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEJ4Nn
	UjsYVzZYHGIU4GBU4uEVeFUeKMSaWFZcmXuIUYKDWUmEd5lDRaAQb0piZVVqUX58UWlOavEh
	xmSgRycyS4km5wMTVV5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBx
	cEo1MLrZlxlV+64OOrjkWy0zp9Tb0IP/4n8zbWJJWXO2m+XQ3l/+fP+qrFfPl9rN7W6z+/ps
	X9H0E0yCXpnXIwslJ++bU3/H4nrE9lC/33cj2o7yvD3M5+Uve3uTg/WUj6J/9rhnxCruk1v/
	en3O1aC1nxalfv/0/ifviQ271lxrDklavdrhZUrSpmAlluKMREMt5qLiRAANDA5jSgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Aaro Koskinen <aaro.koskinen@iki.fi>"

commit f5d6a1441a5045824f36ff7c6b6bbae0373472a6 upstream

Currently IOP3XX_PERIPHERAL_VIRT_BASE conflicts with PCI_IO_VIRT_BASE:

					address         size
	PCI_IO_VIRT_BASE                0xfee00000      0x200000
	IOP3XX_PERIPHERAL_VIRT_BASE     0xfeffe000      0x2000

Fix by moving IOP3XX_PERIPHERAL_VIRT_BASE below PCI_IO_VIRT_BASE.

The patch fixes the following kernel panic with 3.9-rc1 on iop3xx boards:

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc1-iop32x (aaro@blackmetal) (gcc version
4.7.2 (GCC) ) #20 PREEMPT Tue Mar 5 16:44:36 EET 2013
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] ------------[ cut here ]------------
[    0.000000] kernel BUG at mm/vmalloc.c:1145!
[    0.000000] Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
[    0.000000] Modules linked in:
[    0.000000] CPU: 0    Not tainted  (3.9.0-rc1-iop32x #20)
[    0.000000] PC is at vm_area_add_early+0x4c/0x88
[    0.000000] LR is at add_static_vm_early+0x14/0x68
[    0.000000] pc : [<c03e74a8>]    lr : [<c03e1c40>]    psr: 800000d3
[    0.000000] sp : c03ffee4  ip : dfffdf88  fp : c03ffef4
[    0.000000] r10: 00000002  r9 : 000000cf  r8 : 00000653
[    0.000000] r7 : c040eca8  r6 : c03e2408  r5 : dfffdf60  r4 : 00200000
[    0.000000] r3 : dfffdfd8  r2 : feffe000  r1 : ff000000  r0 : dfffdf60
[    0.000000] Flags: Nzcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM
Segment kernel
[    0.000000] Control: 0000397f  Table: a0004000  DAC: 00000017
[    0.000000] Process swapper (pid: 0, stack limit = 0xc03fe1b8)
[    0.000000] Stack: (0xc03ffee4 to 0xc0400000)
[    0.000000] fee0:          00200000 c03fff0c c03ffef8 c03e1c40 c03e7468
00200000 fee00000
[    0.000000] ff00: c03fff2c c03fff10 c03e23e4 c03e1c38 feffe000 c0408ee4
ff000000 c0408f04
[    0.000000] ff20: c03fff3c c03fff30 c03e2434 c03e23b4 c03fff84 c03fff40
c03e2c94 c03e2414
[    0.000000] ff40: c03f8878 c03f6410 ffff0000 000bffff 00001000 00000008
c03fff84 c03f6410
[    0.000000] ff60: c04227e8 c03fffd4 a0008000 c03f8878 69052e30 c02f96eb
c03fffbc c03fff88
[    0.000000] ff80: c03e044c c03e268c 00000000 0000397f c0385130 00000001
ffffffff c03f8874
[    0.000000] ffa0: dfffffff a0004000 69052e30 a03f61a0 c03ffff4 c03fffc0
c03dd5cc c03e0184
[    0.000000] ffc0: 00000000 00000000 00000000 00000000 00000000 c03f8878
0000397d c040601c
[    0.000000] ffe0: c03f8874 c0408674 00000000 c03ffff8 a0008040 c03dd558
00000000 00000000
[    0.000000] Backtrace:
[    0.000000] [<c03e745c>] (vm_area_add_early+0x0/0x88) from [<c03e1c40>]
(add_static_vm_early+0x14/0x68)

Tested-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/include/asm/hardware/iop3xx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/hardware/iop3xx.h
b/arch/arm/include/asm/hardware/iop3xx.h
index 02fe2fb..ed94b1a 100644
--- a/arch/arm/include/asm/hardware/iop3xx.h
+++ b/arch/arm/include/asm/hardware/iop3xx.h
@@ -37,7 +37,7 @@ extern int iop3xx_get_init_atu(void);
  * IOP3XX processor registers
  */
 #define IOP3XX_PERIPHERAL_PHYS_BASE	0xffffe000
-#define IOP3XX_PERIPHERAL_VIRT_BASE	0xfeffe000
+#define IOP3XX_PERIPHERAL_VIRT_BASE	0xfedfe000
 #define IOP3XX_PERIPHERAL_SIZE		0x00002000
 #define IOP3XX_PERIPHERAL_UPPER_PA (IOP3XX_PERIPHERAL_PHYS_BASE +\
 					IOP3XX_PERIPHERAL_SIZE - 1)
-- 
1.7.9.5

