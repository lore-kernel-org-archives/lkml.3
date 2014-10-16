Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaJPX1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 19:27:37 -0400
Received: from rgout06.bt.lon5.cpcloud.co.uk ([65.20.0.183]:4251 "EHLO
	rgout06.bt.lon5.cpcloud.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbaJPX1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 19:27:35 -0400
X-CTCH-RefID: str=0001.0A090203.5440545C.00AA,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-Junkmail-Premium-Raw: score=28/50,refid=2.7.2:2014.10.10.74220:17:28.905,ip=81.154.41.49,rules=__HAS_FROM,
 __PHISH_FROM2, __FRAUD_WEBMAIL_FROM, __TO_MALFORMED_2, __TO_NO_NAME,
 __MULTIPLE_RCPTS_CC_X2, __SUBJ_ALPHA_END, __HAS_MSGID, __SANE_MSGID,
 __HAS_X_MAILER, __ANY_URI, __FRAUD_BODY_WEBMAIL, __URI_NO_WWW, __URI_NO_PATH,
 BODY_SIZE_700_799, BODYTEXTP_SIZE_3000_LESS, __MIME_TEXT_ONLY,
 RDNS_GENERIC_POOLED, __URI_NS, SXL_IP_DYNAMIC[49.41.154.81.fur], HTML_00_01,
 HTML_00_10, BODY_SIZE_5000_LESS, RDNS_SUSP_GENERIC, __PHISH_FROM,
 MULTIPLE_RCPTS, __PHISH_SPEAR_STRUCTURE_1, BODY_SIZE_1000_LESS, RDNS_SUSP,
 BODY_SIZE_2000_LESS, __FRAUD_WEBMAIL, BODY_SIZE_7000_LESS
X-CTCH-Spam: Unknown
From: Mike Roocroft <mike.linux@btinternet.com>
To: gregkh@linuxfoundation.org
Cc: fabio.falzoi84@gmail.com, micky_ching@realsil.com.cn,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mike Roocroft <mike.linux@btinternet.com>
Subject: [PATCH] Staging: rts5208: rtsx_scsi: Fixed a brace coding style issue
Date: Fri, 17 Oct 2014 00:30:51 +0100
Message-Id: <1413502251-32223-1-git-send-email-mike.linux@btinternet.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Mike Roocroft <mike.linux@btinternet.com>
---
 drivers/staging/rts5208/rtsx_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
index bbbf796..1161082 100644
--- a/drivers/staging/rts5208/rtsx_scsi.c
+++ b/drivers/staging/rts5208/rtsx_scsi.c
@@ -584,9 +584,8 @@ static int start_stop_unit(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	case MAKE_MEDIUM_READY:
 	case LOAD_MEDIUM:
-		if (check_card_ready(chip, lun)) {
+		if (check_card_ready(chip, lun))
 			return TRANSPORT_GOOD;
-		}
 		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 
-- 
2.1.2

