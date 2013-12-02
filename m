Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3LBXMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:12:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11382 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3LBXMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:12:12 -0500
X-AuditID: cbfee691-b7f666d0000048b0-8c-529d13cb9aa6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Roland Dreier'" <roland@kernel.org>,
        "'Samuel Iglesias Gonsalvez'" <siglesias@igalia.com>,
        linux-rdma@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 12/39] IB: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:12:11 +0900
Message-id: <002101ceefb3$ee0ac230$ca204690$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAomNA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zY93TwnODDM4+k7ZoXryezeLywkus
	Fpd3zWGzeHaol8ViZ0MDk8WhpeoObB4TZnezeWxa1cnmsX/uGnaPvi2rGD0+b5ILYI3isklJ
	zcksSy3St0vgyngz4RFzwVfuin3bV7I0MC7g6mLk5JAQMJG4934rI4QtJnHh3nq2LkYuDiGB
	ZYwSb/qXscEUndj5hAkisYhRYsq3k8wQzi9Giadz+lhBqtgE1CS+fDnMDmKLCJhKbHw/hRGk
	iFlgL6PE/rdHwXYICdhKTH+xGWgUBwengJ1E36dakLCwgL3ExnX7mUFsFgFVidndjWDlvEDl
	U88fYIOwBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8hICQF1iUd/dSFOMJK4cKWVHaJERGLf
	i3dg50gIvGWX+Lr7LdQuAYlvkw+xQPTKSmw6wAzxsKTEwRU3WCYwSsxCsnkWks2zkGyehWTF
	AkaWVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxghMTtxB+P9A9aHGJOB1k9klhJNzgfGfF5J
	vKGxmZGFqYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MPL5pvz+
	93z1ob27KiM1Q/qa/3h/U3X+vcWtYafZ/A3uB8skHu6JqWt/tvL6+60H790WuMNbstnNSzRd
	OZLv1NKgl79OT3ylqVp+a46FHFfpkwPVU2a+e6FcJbqycG3OjFY5//+LDjUovd62hGXFPdMP
	01yfH9i18oHdmvxjFkdMBf0blzVLB85QYinOSDTUYi4qTgQA5WGace8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jAd3TwnODDPpviFs0L17PZnF54SVW
	i8u75rBZPDvUy2Kxs6GByeLQUnUHNo8Js7vZPDat6mTz2D93DbtH35ZVjB6fN8kFsEY1MNpk
	pCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2gpFCWmFMK
	FApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8x4M+ERc8FX7op921eyNDAu4Opi5OSQ
	EDCROLHzCROELSZx4d56ti5GLg4hgUWMElO+nWSGcH4xSjyd08cKUsUmoCbx5cthdhBbRMBU
	YuP7KYwgRcwCexkl9r89ygiSEBKwlZj+YjPQWA4OTgE7ib5PtSBhYQF7iY3r9jOD2CwCqhKz
	uxvBynmByqeeP8AGYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQkRIC6hKP/upCnGAkceFK
	KztEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95Pzc
	TYzghPBMagfjygaLQ4wCHIxKPLwPts8JEmJNLCuuzD3EKMHBrCTC28kzN0iINyWxsiq1KD++
	qDQntfgQYzLQoxOZpUST84HJKq8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakF
	qUUwW5g4OKUaGGXj4/LWCE/Nyt4+9/wf9VvV/LNXzrr5cNWl1+WN2Utmp0hqhycWKMySbU+P
	+9SzaLqB4orl86oPqzvP2Kqlo8BiO5Nb/PDveU9rb2x9LnRWTKHOfRnjzsmGf/9PUyzYclE1
	q75x5/eiG1+4dOPOnlc+f+BAc8/iMOft62PzZNz+xk/8f+ejyDolluKMREMt5qLiRADKMYLx
	TAMAAA==
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
 drivers/infiniband/hw/mlx5/main.c    |    2 +-
 drivers/infiniband/hw/qib/qib_init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3065341..8d021f3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1484,7 +1484,7 @@ static void remove_one(struct pci_dev *pdev)
 	ib_dealloc_device(&dev->ib_dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(mlx5_ib_pci_table) = {
+static const struct pci_device_id mlx5_ib_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 4113) }, /* MT4113 Connect-IB */
 	{ 0, }
 };
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 24e802f..fcd322c 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1184,7 +1184,7 @@ static int qib_init_one(struct pci_dev *, const struct pci_device_id *);
 #define DRIVER_LOAD_MSG "Intel " QIB_DRV_NAME " loaded: "
 #define PFX QIB_DRV_NAME ": "
 
-static DEFINE_PCI_DEVICE_TABLE(qib_pci_tbl) = {
+static const struct pci_device_id qib_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_PATHSCALE, PCI_DEVICE_ID_QLOGIC_IB_6120) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_IB_7220) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_IB_7322) },
-- 
1.7.10.4


