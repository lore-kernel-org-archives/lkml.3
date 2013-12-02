Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3LBXU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:20:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12756 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3LBXUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:20:54 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-0d-529d15d53b30
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 22/39] pcmcia: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:20:53 +0900
Message-id: <002b01ceefb5$25792b20$706b8160$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAA8VJw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zA92ronODDJrvW1g0L17PZnF54SVW
	i8u75rA5MHvsn7uG3aNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgyfnQvZCy4LFpxZeJh5gbG
	+UJdjJwcEgImEjMnTmaHsMUkLtxbz9bFyMUhJLCMUeLY5CYWmKLl938xQSSmM0psWTufFcL5
	xSix4NFNVpAqNgE1iS9fDoONEhEwldj4fgpjFyMHB7OAi8TRaSIgYSEBW4npLzYzgYQ5Bewk
	+j7VgoSFBZwlHs/oYAKxWQRUJVacXgJm8wKVf+3ZxAJhC0r8mHwPzGYW0JJYv/M4E4QtL7F5
	zVtmkJESAuoSj/7qQhxgJPFv2nxWiBIRiX0v3jFCvHKIXeJigxTEKgGJb5MPsUC0ykpsOsAM
	USIpcXDFDZYJjBKzkCyehWTxLCSLZyHZsICRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZG
	SPT17WC8ecD6EGMy0PqJzFKiyfnA6M0riTc0NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0xJLU
	7NTUgtSi+KLSnNTiQ4xMHJxSDYybBMVWeGfNX/u4xGSB9z8rhj8MctZ61RvLv+Z3XZHlz+xK
	kZYpPL7++J0Twq+cTUXmOj7wNDAz6Dnzwnh70yxWrVq/Fx83Jc3PYgp5zpctPFljzobVdzq2
	iRWsnf9HY02f9myTXylB/jMjDLfrlQb8mVQvEHAw+IlpnUuOS5NDwZLLc39XGSixFGckGmox
	FxUnAgA8RFAx1AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd2ronODDHremFg0L17PZnF54SVW
	i8u75rA5MHvsn7uG3aNvyypGj8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCesYM350L2QsuCxacWXiYeYGxvlCXYycHBICJhLL7/9igrDFJC7cW8/WxcjFISQwnVFi
	y9r5rBDOL0aJBY9usoJUsQmoSXz5cpgdxBYRMJXY+H4KYxcjBwezgIvE0WkiIGEhAVuJ6S82
	M4GEOQXsJPo+1YKEhQWcJR7P6ADbxSKgKrHi9BIwmxeo/GvPJhYIW1Dix+R7YDazgJbE+p3H
	mSBseYnNa94yg4yUEFCXePRXF+IAI4l/0+azQpSISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYw
	sqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7uZ1I7GFc2WBxiFOBgVOLhfbB9TpAQa2JZ
	cWXuIUYJDmYlEd5OnrlBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTDx5JfGGxiZmRpZG
	ZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cCobma57JRkqDcXY+XGNLlvot03
	3Z5zCO+bJfr36N+w0HWvus+/zHyx4sxMkQ0qcy4lP+L/fHn3tljL+jVO16vS5i7ovfTVk8/i
	qHd2f+wtA7GDFm3f6xU6DH7+3Xhi66yjJcKzdXvfGc6onMk8tbKlw63v1O1n+mlRX2N4vwpf
	+MHV1FF3Y1a2EktxRqKhFnNRcSIAkVLpEzIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pcmcia/bcm63xx_pcmcia.c |    2 +-
 drivers/pcmcia/i82092.c         |    2 +-
 drivers/pcmcia/pd6729.c         |    2 +-
 drivers/pcmcia/vrc4173_cardu.c  |    2 +-
 drivers/pcmcia/yenta_socket.c   |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pcmcia/bcm63xx_pcmcia.c b/drivers/pcmcia/bcm63xx_pcmcia.c
index 0c6aac1..0802e0b 100644
--- a/drivers/pcmcia/bcm63xx_pcmcia.c
+++ b/drivers/pcmcia/bcm63xx_pcmcia.c
@@ -475,7 +475,7 @@ static void bcm63xx_cb_exit(struct pci_dev *dev)
 	bcm63xx_cb_dev = NULL;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(bcm63xx_cb_table) = {
+static const struct pci_device_id bcm63xx_cb_table[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_BROADCOM,
 		.device		= BCM6348_CPU_ID,
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index 519c4d6..ddb79f8 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -25,7 +25,7 @@
 MODULE_LICENSE("GPL");
 
 /* PCI core routines */
-static DEFINE_PCI_DEVICE_TABLE(i82092aa_pci_ids) = {
+static const struct pci_device_id i82092aa_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82092AA_0) },
 	{ }
 };
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index 622dd6f..34ace48 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -764,7 +764,7 @@ static void pd6729_pci_remove(struct pci_dev *dev)
 	kfree(socket);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pd6729_pci_ids) = {
+static const struct pci_device_id pd6729_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_6729) },
 	{ }
 };
diff --git a/drivers/pcmcia/vrc4173_cardu.c b/drivers/pcmcia/vrc4173_cardu.c
index d926920..9fb0c3a 100644
--- a/drivers/pcmcia/vrc4173_cardu.c
+++ b/drivers/pcmcia/vrc4173_cardu.c
@@ -563,7 +563,7 @@ static int vrc4173_cardu_setup(char *options)
 
 __setup("vrc4173_cardu=", vrc4173_cardu_setup);
 
-static DEFINE_PCI_DEVICE_TABLE(vrc4173_cardu_id_table) = {
+static const struct pci_device_id vrc4173_cardu_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NEC, PCI_DEVICE_ID_NEC_NAPCCARD) },
         {0, }
 };
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index dc18a3a..7f84ec6 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1352,7 +1352,7 @@ static const struct dev_pm_ops yenta_pm_ops = {
 		.driver_data	= CARDBUS_TYPE_##type,	\
 	}
 
-static DEFINE_PCI_DEVICE_TABLE(yenta_table) = {
+static const struct pci_device_id yenta_table[] = {
 	CB_ID(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_1031, TI),
 
 	/*
-- 
1.7.10.4


