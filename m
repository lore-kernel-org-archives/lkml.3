Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3EVAOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:14:17 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43028 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3EVAOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:14:15 -0400
From: Severin Gsponer <svgsponer@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kevin McKinney <klmckinney1@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Severin Gsponer <svgsponer@gmail.com>
Subject: [PATCH 2/2] Staging: bcm: Change comment style to C89 in vendorspecificextn.c
Date: Wed, 22 May 2013 02:13:58 +0200
Message-Id: <1369181638-6309-1-git-send-email-svgsponer@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the comment style to C89 in vendorspecificextn.c. Found with checkpatch.pl

Signed-off-by: Severin Gsponer <svgsponer@gmail.com>
---
 drivers/staging/bcm/vendorspecificextn.c |  198 +++++++++++++++---------------
 1 file changed, 97 insertions(+), 101 deletions(-)

diff --git a/drivers/staging/bcm/vendorspecificextn.c b/drivers/staging/bcm/vendorspecificextn.c
index be1f91d..d38a06f 100644
--- a/drivers/staging/bcm/vendorspecificextn.c
+++ b/drivers/staging/bcm/vendorspecificextn.c
@@ -1,70 +1,70 @@
 #include "headers.h"
-//-----------------------------------------------------------------------------
-// Procedure:	vendorextnGetSectionInfo
-//
-// Description: Finds the type of NVM used.
-//
-// Arguments:
-//		Adapter    - ptr to Adapter object instance
-//		pNVMType   - ptr to NVM type.
-// Returns:
-//		STATUS_SUCCESS/STATUS_FAILURE
-//
-//-----------------------------------------------------------------------------
+/*
+ * Procedure:	vendorextnGetSectionInfo
+ *
+ * Description: Finds the type of NVM used.
+ *
+ * Arguments:
+ *		Adapter    - ptr to Adapter object instance
+ *		pNVMType   - ptr to NVM type.
+ * Returns:
+ *		STATUS_SUCCESS/STATUS_FAILURE
+ *
+ */
 INT vendorextnGetSectionInfo(PVOID  pContext, struct bcm_flash2x_vendor_info *pVendorInfo)
 {
 	return STATUS_FAILURE;
 }
 
-//-----------------------------------------------------------------------------
-// Procedure:   vendorextnInit
-//
-// Description: Initializing the vendor extension NVM interface
-//
-// Arguments:
-//              Adapter   - Pointer to MINI Adapter Structure.
-
-// Returns:
-//              STATUS_SUCCESS/STATUS_FAILURE
-//
-//-----------------------------------------------------------------------------
+/*
+ * Procedure:   vendorextnInit
+ *
+ * Description: Initializing the vendor extension NVM interface
+ *
+ * Arguments:
+ *              Adapter   - Pointer to MINI Adapter Structure
+ * Returns:
+ *             STATUS_SUCCESS/STATUS_FAILURE
+ *
+ *
+ */
 INT vendorextnInit(struct bcm_mini_adapter *Adapter)
 {
 	return STATUS_SUCCESS;
 }
 
-//-----------------------------------------------------------------------------
-// Procedure:   vendorextnExit
-//
-// Description: Free the resource associated with vendor extension NVM interface
-//
-// Arguments:
-//              Adapter   - Pointer to MINI Adapter Structure.
-
-// Returns:
-//              STATUS_SUCCESS/STATUS_FAILURE
-//
-//-----------------------------------------------------------------------------
+/*
+ * Procedure:   vendorextnExit
+ *
+ * Description: Free the resource associated with vendor extension NVM interface
+ *
+ * Arguments:
+ *
+ * Returns:
+ *              STATUS_SUCCESS/STATUS_FAILURE
+ *
+ *
+ */
 INT vendorextnExit(struct bcm_mini_adapter *Adapter)
 {
 	return STATUS_SUCCESS;
 }
 
-//------------------------------------------------------------------------
-// Procedure:	vendorextnIoctl
-//
-// Description: 	execute the vendor extension specific ioctl
-//
-//Arguments:
-//		Adapter -Beceem private Adapter Structure
-//		cmd 	-vendor extension specific Ioctl commad
-//		arg		-input parameter sent by vendor
-//
-// Returns:
-//		CONTINUE_COMMON_PATH in case it is not meant to be processed by vendor ioctls
-//		STATUS_SUCCESS/STATUS_FAILURE as per the IOCTL return value
-//
-//--------------------------------------------------------------------------
+/*
+ * Procedure:	vendorextnIoctl
+ *
+ * Description: execute the vendor extension specific ioctl
+ *
+ * Arguments:
+ *		Adapter -Beceem private Adapter Structure
+ *		cmd	-vendor extension specific Ioctl commad
+ *		arg	-input parameter sent by vendor
+ *
+ * Returns:
+ *		CONTINUE_COMMON_PATH in case it is not meant to be processed by vendor ioctls
+ *		STATUS_SUCCESS/STATUS_FAILURE as per the IOCTL return value
+ */
+
 INT vendorextnIoctl(struct bcm_mini_adapter *Adapter, UINT cmd, ULONG arg)
 {
 	return CONTINUE_COMMON_PATH;
@@ -72,22 +72,21 @@ INT vendorextnIoctl(struct bcm_mini_adapter *Adapter, UINT cmd, ULONG arg)
 
 
 
-//------------------------------------------------------------------
-// Procedure:	vendorextnReadSection
-//
-// Description: Reads from a section of NVM
-//
-// Arguments:
-//		pContext - ptr to Adapter object instance
-//		pBuffer - Read the data from Vendor Area to this buffer
-//		SectionVal   - Value of type of Section
-//		Offset - Read from the Offset of the Vendor Section.
-//		numOfBytes - Read numOfBytes from the Vendor section to Buffer
-//
-// Returns:
-//		STATUS_SUCCESS/STATUS_FAILURE
-//
-//------------------------------------------------------------------
+/*
+ * Procedure:	vendorextnReadSection
+ *
+ * Description: Reads from a section of NVM
+ *
+ * Arguments:
+ *		pContext - ptr to Adapter object instance
+ *		pBuffer - Read the data from Vendor Area to this buffer
+ *		SectionVal   - Value of type of Section
+ *		Offset - Read from the Offset of the Vendor Section.
+ *		numOfBytes - Read numOfBytes from the Vendor section to Buffer
+ *
+ * Returns:
+ *		STATUS_SUCCESS/STATUS_FAILURE
+ */
 
 INT vendorextnReadSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_section_val SectionVal,
 			UINT offset, UINT numOfBytes)
@@ -97,23 +96,22 @@ INT vendorextnReadSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_sect
 
 
 
-//------------------------------------------------------------------
-// Procedure:	vendorextnWriteSection
-//
-// Description: Write to a Section of NVM
-//
-// Arguments:
-//		pContext - ptr to Adapter object instance
-//		pBuffer - Write the data provided in the buffer
-//		SectionVal   - Value of type of Section
-//		Offset - Writes to the Offset of the Vendor Section.
-//		numOfBytes - Write num Bytes after reading from pBuffer.
-//		bVerify - the Buffer Written should be verified.
-//
-// Returns:
-//		STATUS_SUCCESS/STATUS_FAILURE
-//
-//------------------------------------------------------------------
+/*
+ * Procedure:	vendorextnWriteSection
+ *
+ * Description: Write to a Section of NVM
+ *
+ * Arguments:
+ *		pContext - ptr to Adapter object instance
+ *		pBuffer - Write the data provided in the buffer
+ *		SectionVal   - Value of type of Section
+ *		Offset - Writes to the Offset of the Vendor Section.
+ *		numOfBytes - Write num Bytes after reading from pBuffer.
+ *		bVerify - the Buffer Written should be verified.
+ *
+ * Returns:
+ *		STATUS_SUCCESS/STATUS_FAILURE
+ */
 INT vendorextnWriteSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_section_val SectionVal,
 			UINT offset, UINT numOfBytes, BOOLEAN bVerify)
 {
@@ -122,25 +120,23 @@ INT vendorextnWriteSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_sec
 
 
 
-//------------------------------------------------------------------
-// Procedure:	vendorextnWriteSectionWithoutErase
-//
-// Description: Write to a Section of NVM without erasing the sector
-//
-// Arguments:
-//		pContext - ptr to Adapter object instance
-//		pBuffer - Write the data provided in the buffer
-//		SectionVal   - Value of type of Section
-//		Offset - Writes to the Offset of the Vendor Section.
-//		numOfBytes - Write num Bytes after reading from pBuffer.
-//
-// Returns:
-//		STATUS_SUCCESS/STATUS_FAILURE
-//
-//------------------------------------------------------------------
+/*
+ * Procedure:	vendorextnWriteSectionWithoutErase
+ *
+ * Description: Write to a Section of NVM without erasing the sector
+ *
+ * Arguments:
+ *		pContext - ptr to Adapter object instance
+ *		pBuffer - Write the data provided in the buffer
+ *		SectionVal   - Value of type of Section
+ *		Offset - Writes to the Offset of the Vendor Section.
+ *		numOfBytes - Write num Bytes after reading from pBuffer.
+ *
+ * Returns:
+ *		STATUS_SUCCESS/STATUS_FAILURE
+ */
 INT vendorextnWriteSectionWithoutErase(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_section_val SectionVal,
 			UINT offset, UINT numOfBytes)
 {
 	return STATUS_FAILURE;
 }
-
-- 
1.7.10.4

