Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3F1Fwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 01:52:37 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:50180
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124Ab3F1Fwf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 01:52:35 -0400
X-Forefront-Antispam-Report: CIP:192.19.193.42;KIP:(null);UIP:(null);IPV:NLI;H:paledge01.lsi.com;RD:paledge01.lsi.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hza3hz8275bhz2fh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
To: James Georgas <soulpa7ch@gmail.com>,
        DL-MegaRAID Linux <megaraidlinux@lsi.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Fri, 28 Jun 2013 11:22:26 +0530
Subject: RE: [PATCH 1/1] scsi/megaraid: minor cut and paste error fixed.
Thread-Topic: [PATCH 1/1] scsi/megaraid: minor cut and paste error fixed.
Thread-Index: Ac5yl8s22n+uS62kSfWipWWUP+jcbgBKxeHw
Message-ID: <088E451FE1854947BD9145EF8C016FF4139FF3C4BC@inbmail01.lsi.com>
References: <1372269799-9835-1-git-send-email-soulpa7ch@gmail.com>
In-Reply-To: <1372269799-9835-1-git-send-email-soulpa7ch@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks James for pointing this out, there is no harm with this change.

Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

Sumit

>-----Original Message-----
>From: James Georgas [mailto:soulpa7ch@gmail.com]
>Sent: Wednesday, June 26, 2013 11:33 PM
>To: DL-MegaRAID Linux; JBottomley@parallels.com
>Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; James
>Georgas
>Subject: [PATCH 1/1] scsi/megaraid: minor cut and paste error fixed.
>
>This looks like a cut and paste typo to me. Both of the
>megasas_read_fw_status_reg_* functions involved are identical though, so
>there was no bad behaviour. I changed it for consistency and clarity.
>
>Signed-off-by: James Georgas <soulpa7ch@gmail.com>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 3a9ddae..87591cd 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -583,7 +583,7 @@ megasas_clear_intr_skinny(struct
>megasas_register_set __iomem *regs)
> 	/*
> 	 * Check if it is our interrupt
> 	 */
>-	if ((megasas_read_fw_status_reg_gen2(regs) & MFI_STATE_MASK) ==
>+	if ((megasas_read_fw_status_reg_skinny(regs) & MFI_STATE_MASK) ==
> 	    MFI_STATE_FAULT) {
> 		mfiStatus = MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;
> 	} else
>--
>1.8.1.5
>


