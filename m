Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaBXRhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:37:54 -0500
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:40128 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbaBXRhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:37:52 -0500
Message-ID: <530B836D.6000508@emulex.com>
Date: Mon, 24 Feb 2014 12:37:49 -0500
From: James Smart <james.smart@emulex.com>
Reply-To: <james.smart@emulex.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Daeseok Youn <daeseok.youn@gmail.com>
CC: <JBottomley@parallels.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] [SCSI] lpfc 8.3.43: use NULL instead of 0 for pointer
References: <1790992.BDi3De8mQ2@daeseok-laptop.cloud.net>
In-Reply-To: <1790992.BDi3De8mQ2@daeseok-laptop.cloud.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: James Smart   <james.smart@emulex.com>

-- james s



On 2/20/2014 8:10 PM, Daeseok Youn wrote:
> >From 9e7478f6e953fac5b2bef0f5abe76fe8dc9e59d1 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Fri, 21 Feb 2014 09:03:32 +0900
> Subject: [PATCH] [SCSI] lpfc 8.3.43: use NULL instead of 0 for pointer
>
> sparse says:
> drivers/scsi/lpfc/lpfc_sli.c:16547:37: warning:
>   Using plain integer as NULL pointer
>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 8f580fd..a218ecd 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -16544,7 +16544,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
>   {
>   	LIST_HEAD(completions);
>   	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
> -	struct lpfc_iocbq *piocbq = 0;
> +	struct lpfc_iocbq *piocbq = NULL;
>   	unsigned long iflags = 0;
>   	char *fail_msg = NULL;
>   	struct lpfc_sglq *sglq;

