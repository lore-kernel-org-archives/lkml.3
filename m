Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbaHHMs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:48:29 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37029 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbaHHMs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:48:28 -0400
From: Panos Vlachos <panosvlchs@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Panos Vlachos <panosvlchs@gmail.com>
Subject: [PATCH] Staging:bcm:verndorspecificficextn.c: fixed five styling issues
Date: Fri,  8 Aug 2014 15:48:12 +0300
Message-Id: <1407502092-18967-1-git-send-email-panosvlchs@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following styling issues:
vendorspecificextn.c:14: WARNING: line over 80 characters
vendorspecificextn.c:64: WARNING: line over 80 characters
vendorspecificextn.c:91: WARNING: line over 80 characters
vendorspecificextn.c:115: WARNING: line over 80 characters
vendorspecificextn.c:138: WARNING: line over 80 characters

Signed-off-by: Panagiotis Vlachos <panosvlchs@gmail.com>
---
 drivers/staging/bcm/vendorspecificextn.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/bcm/vendorspecificextn.c b/drivers/staging/bcm/vendorspecificextn.c
index 2c57a16..ddb9f30 100644
--- a/drivers/staging/bcm/vendorspecificextn.c
+++ b/drivers/staging/bcm/vendorspecificextn.c
@@ -11,7 +11,8 @@
  *		STATUS_SUCCESS/STATUS_FAILURE
  *
  */
-INT vendorextnGetSectionInfo(PVOID  pContext, struct bcm_flash2x_vendor_info *pVendorInfo)
+INT vendorextnGetSectionInfo(PVOID  pContext,
+	struct bcm_flash2x_vendor_info *pVendorInfo)
 {
 	return STATUS_FAILURE;
 }
@@ -61,7 +62,8 @@ INT vendorextnExit(struct bcm_mini_adapter *Adapter)
  *		arg	-input parameter sent by vendor
  *
  * Returns:
- *		CONTINUE_COMMON_PATH in case it is not meant to be processed by vendor ioctls
+ *		CONTINUE_COMMON_PATH in case it is not meant to be processed by
+ *		vendor ioctls
  *		STATUS_SUCCESS/STATUS_FAILURE as per the IOCTL return value
  */
 
@@ -88,7 +90,8 @@ INT vendorextnIoctl(struct bcm_mini_adapter *Adapter, UINT cmd, ULONG arg)
  *		STATUS_SUCCESS/STATUS_FAILURE
  */
 
-INT vendorextnReadSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_section_val SectionVal,
+INT vendorextnReadSection(PVOID  pContext, PUCHAR pBuffer,
+	enum bcm_flash2x_section_val SectionVal,
 			UINT offset, UINT numOfBytes)
 {
 	return STATUS_FAILURE;
@@ -112,7 +115,8 @@ INT vendorextnReadSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_sect
  * Returns:
  *		STATUS_SUCCESS/STATUS_FAILURE
  */
-INT vendorextnWriteSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_section_val SectionVal,
+INT vendorextnWriteSection(PVOID  pContext, PUCHAR pBuffer,
+			enum bcm_flash2x_section_val SectionVal,
 			UINT offset, UINT numOfBytes, bool bVerify)
 {
 	return STATUS_FAILURE;
@@ -135,7 +139,8 @@ INT vendorextnWriteSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_sec
  * Returns:
  *		STATUS_SUCCESS/STATUS_FAILURE
  */
-INT vendorextnWriteSectionWithoutErase(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_section_val SectionVal,
+INT vendorextnWriteSectionWithoutErase(PVOID  pContext,
+			PUCHAR pBuffer, enum bcm_flash2x_section_val SectionVal,
 			UINT offset, UINT numOfBytes)
 {
 	return STATUS_FAILURE;
-- 
1.7.10.4

