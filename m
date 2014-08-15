Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaHOPvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:51:04 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:40790 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaHOPvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:51:02 -0400
From: Ramesh Basukala <basukalaramesh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ramesh Basukala <basukalaramesh@gmail.com>
Subject: [PATCH] Staging: bcm: fix coding style warning
Date: Fri, 15 Aug 2014 11:50:53 -0400
Message-Id: <1408117853-20400-1-git-send-email-basukalaramesh@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20140815065506.GA26102@kroah.com>
References: <20140815065506.GA26102@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the vendorspecificextn.c that fixes coding style
warning message line over 80 characters found by checkpatch.pl script.
I am submitting this patch as required by Eudyptula Challenge.

Signed-off-by: Ramesh Basukala <basukalaramesh@gmail.com>
---
 drivers/staging/bcm/vendorspecificextn.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/bcm/vendorspecificextn.c b/drivers/staging/bcm/vendorspecificextn.c
index 2c57a16..1d9bef6 100644
--- a/drivers/staging/bcm/vendorspecificextn.c
+++ b/drivers/staging/bcm/vendorspecificextn.c
@@ -11,7 +11,8 @@
  *		STATUS_SUCCESS/STATUS_FAILURE
  *
  */
-INT vendorextnGetSectionInfo(PVOID  pContext, struct bcm_flash2x_vendor_info *pVendorInfo)
+INT vendorextnGetSectionInfo(PVOID  pContext,
+			struct bcm_flash2x_vendor_info *pVendorInfo)
 {
 	return STATUS_FAILURE;
 }
@@ -61,7 +62,8 @@ INT vendorextnExit(struct bcm_mini_adapter *Adapter)
  *		arg	-input parameter sent by vendor
  *
  * Returns:
- *		CONTINUE_COMMON_PATH in case it is not meant to be processed by vendor ioctls
+ *		CONTINUE_COMMON_PATH in case it is not meant to be processed
+ *		by vendor ioctls
  *		STATUS_SUCCESS/STATUS_FAILURE as per the IOCTL return value
  */
 
@@ -88,8 +90,8 @@ INT vendorextnIoctl(struct bcm_mini_adapter *Adapter, UINT cmd, ULONG arg)
  *		STATUS_SUCCESS/STATUS_FAILURE
  */
 
-INT vendorextnReadSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_section_val SectionVal,
-			UINT offset, UINT numOfBytes)
+INT vendorextnReadSection(PVOID  pContext, PUCHAR pBuffer,
+	enum bcm_flash2x_section_val SectionVal, UINT offset, UINT numOfBytes)
 {
 	return STATUS_FAILURE;
 }
@@ -112,8 +114,9 @@ INT vendorextnReadSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_sect
  * Returns:
  *		STATUS_SUCCESS/STATUS_FAILURE
  */
-INT vendorextnWriteSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_section_val SectionVal,
-			UINT offset, UINT numOfBytes, bool bVerify)
+INT vendorextnWriteSection(PVOID  pContext, PUCHAR pBuffer,
+	enum bcm_flash2x_section_val SectionVal, UINT offset,
+	UINT numOfBytes, bool bVerify)
 {
 	return STATUS_FAILURE;
 }
@@ -135,8 +138,8 @@ INT vendorextnWriteSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_sec
  * Returns:
  *		STATUS_SUCCESS/STATUS_FAILURE
  */
-INT vendorextnWriteSectionWithoutErase(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_section_val SectionVal,
-			UINT offset, UINT numOfBytes)
+INT vendorextnWriteSectionWithoutErase(PVOID  pContext, PUCHAR pBuffer,
+	enum bcm_flash2x_section_val SectionVal, UINT offset, UINT numOfBytes)
 {
 	return STATUS_FAILURE;
 }
-- 
1.7.1

