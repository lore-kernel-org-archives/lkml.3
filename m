Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3LBXJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:09:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:28354 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3LBXJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:09:45 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-3d-529d1338e575
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'David Airlie'" <airlied@linux.ie>, dri-devel@lists.freedesktop.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 09/39] drm: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:09:43 +0900
Message-id: <001e01ceefb3$96526610$c2f73230$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAi1SA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zI10L4blBBhc7BS16z51ksrjy9T2b
	RfPi9WwWlxdeYrW4vGsOmwOrx/ZvD1g99s9dw+5xv/s4k0ffllWMHp83yQWwRnHZpKTmZJal
	FunbJXBlTF58ia3gglzFljU6DYztUl2MnBwSAiYSd+c8YoSwxSQu3FvP1sXIxSEksIxRovfM
	JGaYoueTtjFBJKYzShyYcw7K+cUocexrHxtIFZuAmsSXL4fZQWwRAVOJje+nMIIUMQt0MUos
	mbMWrEhIwFZi+ovNQN0cHJwCdhJ9n2pBwsICDhIX769iAbFZBFQlVvxbCHYSL1D5ylVv2SFs
	QYkfk++B1TALaEms33mcCcKWl9i85i0zyEgJAXWJR391IU4wkni1pAOqRERi34t3UF/eY5dY
	3CwGsUpA4tvkQywQrbISmw5A/SspcXDFDZYJjBKzkCyehWTxLCSLZyHZsICRZRWjaGpBckFx
	UnqRoV5xYm5xaV66XnJ+7iZGSJz27mC8fcD6EGMy0PqJzFKiyfnAOM8riTc0NjOyMDUxNTYy
	tzQjTVhJnDfpYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbHlpPy9vXyMs/Vtp5+0CuV
	4OZdW/1dyIe/3vWyt9uyvKar6/4xOtrqiE3VF7+X6h6iHqb5fEn5X/nLK+f5xEVodCbvaF5/
	2WxZrYa0zUP1WGPR2VznJNcwcr3ewn+S7+WOgDcXum+JlZW0MBlX8qjtCirOSmBKtTlWpSa0
	2uSupJh6IYOuEktxRqKhFnNRcSIA/Iq8NekCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV0L4blBBu9O8Fj0njvJZHHl63s2
	i+bF69ksLi+8xGpxedccNgdWj+3fHrB67J+7ht3jfvdxJo++LasYPT5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJi8+BJbwQW5ii1rdBoY26W6GDk5JARMJJ5P
	2sYEYYtJXLi3nq2LkYtDSGA6o8SBOeeYIJxfjBLHvvaxgVSxCahJfPlymB3EFhEwldj4fgoj
	SBGzQBejxJI5a8GKhARsJaa/2AzUzcHBKWAn0fepFiQsLOAgcfH+KhYQm0VAVWLFv4WMIDYv
	UPnKVW/ZIWxBiR+T74HVMAtoSazfeZwJwpaX2LzmLTPISAkBdYlHf3UhTjCSeLWkA6pERGLf
	i3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAaeCa1
	g3Flg8UhRgEORiUe3gfb5wQJsSaWFVfmHmKU4GBWEuHt5JkbJMSbklhZlVqUH19UmpNafIgx
	GejRicxSosn5wBSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2Ms56EW3ntrzly6mpCk8a2ovmrk+JePQjLyb2UvOmfvY8lT8X35CmmddZvk39Kr/zp13A2
	dypLz9T9vj8Dygo1xfV3xbXM/S3AWLXSPldrppNWtc6udTwntIROWm288j5pd13D7rWLhb9/
	me2Qe+vLhsd5dV2vOXt+pVjZb71Qx2Hmqh/WeMRSiaU4I9FQi7moOBEAKGSDHUcDAAA=
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
 drivers/gpu/drm/ast/ast_drv.c          |    2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c    |    2 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c |    2 +-
 drivers/gpu/drm/gma500/psb_drv.c       |    2 +-
 drivers/gpu/drm/mgag200/mgag200_drv.c  |    2 +-
 drivers/gpu/drm/qxl/qxl_drv.c          |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.c b/drivers/gpu/drm/ast/ast_drv.c
index 5137f15..6f10488 100644
--- a/drivers/gpu/drm/ast/ast_drv.c
+++ b/drivers/gpu/drm/ast/ast_drv.c
@@ -51,7 +51,7 @@ static struct drm_driver driver;
 	.subdevice = PCI_ANY_ID,		\
 	.driver_data = (unsigned long) info }
 
-static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
+static const struct pci_device_id pciidlist[] = {
 	AST_VGA_DEVICE(PCI_CHIP_AST2000, NULL),
 	AST_VGA_DEVICE(PCI_CHIP_AST2100, NULL),
 	/*	AST_VGA_DEVICE(PCI_CHIP_AST1180, NULL), - don't bind to 1180 for now */
diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.c b/drivers/gpu/drm/cirrus/cirrus_drv.c
index 953fc8a..98ef119 100644
--- a/drivers/gpu/drm/cirrus/cirrus_drv.c
+++ b/drivers/gpu/drm/cirrus/cirrus_drv.c
@@ -28,7 +28,7 @@ module_param_named(modeset, cirrus_modeset, int, 0400);
 static struct drm_driver driver;
 
 /* only bind to the cirrus chip in qemu */
-static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
+static const struct pci_device_id pciidlist[] = {
 	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, 0x1af4, 0x1100, 0,
 	  0, 0 },
 	{0,}
diff --git a/drivers/gpu/drm/gma500/oaktrail_hdmi.c b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
index 3815314..58a4f83 100644
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
@@ -681,7 +681,7 @@ failed_connector:
 	kfree(gma_encoder);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(hdmi_ids) = {
+static const struct pci_device_id hdmi_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080d) },
 	{ 0 }
 };
diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
index 1199180..46f4292 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -45,7 +45,7 @@ MODULE_PARM_DESC(trap_pagefaults, "Error and reset on MMU pagefaults");
 module_param_named(trap_pagefaults, drm_psb_trap_pagefaults, int, 0600);
 
 
-static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
+static const struct pci_device_id pciidlist[] = {
 	{ 0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &psb_chip_ops },
 	{ 0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &psb_chip_ops },
 #if defined(CONFIG_DRM_GMA600)
diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.c b/drivers/gpu/drm/mgag200/mgag200_drv.c
index f15ea3c..2d75d6d 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.c
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.c
@@ -28,7 +28,7 @@ module_param_named(modeset, mgag200_modeset, int, 0400);
 
 static struct drm_driver driver;
 
-static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
+static const struct pci_device_id pciidlist[] = {
 	{ PCI_VENDOR_ID_MATROX, 0x522, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_SE_A },
 	{ PCI_VENDOR_ID_MATROX, 0x524, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_SE_B },
 	{ PCI_VENDOR_ID_MATROX, 0x530, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_EV },
diff --git a/drivers/gpu/drm/qxl/qxl_drv.c b/drivers/gpu/drm/qxl/qxl_drv.c
index fee8748..6c68a89 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.c
+++ b/drivers/gpu/drm/qxl/qxl_drv.c
@@ -38,7 +38,7 @@
 #include "qxl_object.h"
 
 extern int qxl_max_ioctls;
-static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
+static const struct pci_device_id pciidlist[] = {
 	{ 0x1b36, 0x100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8,
 	  0xffff00, 0 },
 	{ 0x1b36, 0x100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_OTHER << 8,
-- 
1.7.10.4


