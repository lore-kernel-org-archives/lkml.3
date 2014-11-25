Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbaKYS22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:28:28 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63937 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaKYS21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:28:27 -0500
From: Siddharth Kannan <kannan.siddharth12@gmail.com>
To: gregkh@linuxfoundation.org
Cc: mail@beyermatthias.de, rickard_strandqvist@spectrumdigital.se,
        ztugcesirin@gmail.com, fanwlexca@gmail.com, rashika.kheria@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        klmckinney1@gmail.com, kannan.siddharth12@gmail.com
Subject: [PATCH] staging: bcm: nvm: Fixed spelling errors, that may break grep.
Date: Tue, 25 Nov 2014 23:58:18 +0530
Message-Id: <1416940098-7491-1-git-send-email-kannan.siddharth12@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the following:

Adapater -> Adapter
STATUS_SUCESS -> STATUS_SUCCESS

Signed-off-by: Siddharth Kannan <kannan.siddharth12@gmail.com>
---
 drivers/staging/bcm/nvm.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index ce09473..3cb6eed 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -2953,7 +2953,7 @@ int BcmFlash2xBulkWrite(struct bcm_mini_adapter *Adapter,
  * @Adapter :-Drivers private Data Structure
  *
  * Return Value:-
- * Return STATUS_SUCESS if get success in setting the right DSD else negative error code
+ * Return STATUS_SUCCESS if get success in setting the right DSD else negative error code
  *
  */
 
@@ -2994,7 +2994,7 @@ static int BcmGetActiveDSD(struct bcm_mini_adapter *Adapter)
  * @Adapter : Driver private Data Structure
  *
  * Return Value:-
- * Sucsess:- STATUS_SUCESS
+ * Success:- STATUS_SUCCESS
  * Failure- : negative erro code
  *
  */
@@ -3083,7 +3083,7 @@ static int BcmDumpFlash2xSectionBitMap(struct bcm_flash2x_bitmap *psFlash2xBitMa
  * @Adapter:-Driver private Data Structure
  *
  * Return value:-
- * Success:- STATUS_SUCESS
+ * Success:- STATUS_SUCCESS
  * Failure:- negative error code
  */
 
@@ -3330,7 +3330,7 @@ int BcmGetFlash2xSectionalBitMap(struct bcm_mini_adapter *Adapter, struct bcm_fl
  * BcmSetActiveSection :- Set Active section is used to make priority field highest over other
  * section of same type.
  *
- * @Adapater :- Bcm Driver Private Data Structure
+ * @Adapter :- Bcm Driver Private Data Structure
  * @eFlash2xSectionVal :- Flash section val whose priority has to be made highest.
  *
  * Return Value:- Make the priorit highest else return erorr code
@@ -3510,7 +3510,7 @@ int BcmSetActiveSection(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_secti
 
 /*
  * BcmCopyISO - Used only for copying the ISO section
- * @Adapater :- Bcm Driver Private Data Structure
+ * @Adapter :- Bcm Driver Private Data Structure
  * @sCopySectStrut :- Section copy structure
  *
  * Return value:- SUCCESS if copies successfully else negative error code
@@ -3792,7 +3792,7 @@ out:
 /*
  * BcmFlash2xCorruptSig : this API is used to corrupt the written sig in Bcm Header present in flash section.
  * It will corrupt the sig, if Section is writable, by making first bytes as zero.
- * @Adapater :- Bcm Driver Private Data Structure
+ * @Adapter :- Bcm Driver Private Data Structure
  * @eFlash2xSectionVal :- Flash section val which has header
  *
  * Return Value :-
@@ -3820,7 +3820,7 @@ int BcmFlash2xCorruptSig(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_sect
 /*
  *BcmFlash2xWriteSig :-this API is used to Write the sig if requested Section has
  *					  header and  Write Permission.
- * @Adapater :- Bcm Driver Private Data Structure
+ * @Adapter :- Bcm Driver Private Data Structure
  * @eFlashSectionVal :- Flash section val which has header
  *
  * Return Value :-
@@ -3882,7 +3882,7 @@ int BcmFlash2xWriteSig(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_sectio
 /*
  * validateFlash2xReadWrite :- This API is used to validate the user request for Read/Write.
  *						      if requested Bytes goes beyond the Requested section, it reports error.
- * @Adapater :- Bcm Driver Private Data Structure
+ * @Adapter :- Bcm Driver Private Data Structure
  * @psFlash2xReadWrite :-Flash2x Read/write structure pointer
  *
  * Return values:-Return TRUE is request is valid else false.
@@ -3950,7 +3950,7 @@ int validateFlash2xReadWrite(struct bcm_mini_adapter *Adapter, struct bcm_flash2
 
 /*
  * IsFlash2x :- check for Flash 2.x
- * Adapater :- Bcm Driver Private Data Structure
+ * Adapter :- Bcm Driver Private Data Structure
  *
  * Return value:-
  *	return TRUE if flah2.x of hgher version else return false.
@@ -3966,7 +3966,7 @@ int IsFlash2x(struct bcm_mini_adapter *Adapter)
 
 /*
  * GetFlashBaseAddr :- Calculate the Flash Base address
- * @Adapater :- Bcm Driver Private Data Structure
+ * @Adapter :- Bcm Driver Private Data Structure
  *
  * Return Value:-
  *	Success :- Base Address of the Flash
@@ -4005,7 +4005,7 @@ static int GetFlashBaseAddr(struct bcm_mini_adapter *Adapter)
  * BcmCopySection :- This API is used to copy the One section in another. Both section should
  *				    be contiuous and of same size. Hence this Will not be applicabe to copy ISO.
  *
- * @Adapater :- Bcm Driver Private Data Structure
+ * @Adapter :- Bcm Driver Private Data Structure
  * @SrcSection :- Source section From where data has to be copied
  * @DstSection :- Destination section to which data has to be copied
  * @offset :- Offset from/to  where data has to be copied from one section to another.
@@ -4112,7 +4112,7 @@ int BcmCopySection(struct bcm_mini_adapter *Adapter,
 
 /*
  * SaveHeaderIfPresent :- This API is use to Protect the Header in case of Header Sector write
- * @Adapater :- Bcm Driver Private Data Structure
+ * @Adapter :- Bcm Driver Private Data Structure
  * @pBuff :- Data buffer that has to be written in sector having the header map.
  * @uiOffset :- Flash offset that has to be written.
  *
@@ -4181,7 +4181,7 @@ static int SaveHeaderIfPresent(struct bcm_mini_adapter *Adapter, PUCHAR pBuff, u
 
 /*
  * BcmDoChipSelect : This will selcet the appropriate chip for writing.
- * @Adapater :- Bcm Driver Private Data Structure
+ * @Adapter :- Bcm Driver Private Data Structure
  *
  * OutPut:-
  *	Select the Appropriate chip and retrn status Success
-- 
1.7.9.5

