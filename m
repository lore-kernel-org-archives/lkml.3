Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab3KNPln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:41:43 -0500
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:48651 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3KNPlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:41:36 -0500
Message-ID: <5284EF2E.7010600@emulex.com>
Date: Thu, 14 Nov 2013 10:41:34 -0500
From: James Smart <james.smart@emulex.com>
Reply-To: <james.smart@emulex.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Felipe Pena <felipensp@gmail.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: scsi: lpfc_debugfs: Fix wrong assignment
References: <1382138137-4088-1-git-send-email-felipensp@gmail.com>
In-Reply-To: <1382138137-4088-1-git-send-email-felipensp@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

Acked-by:   James Smart  <james.smart@emulex.com>

-- james s


On 10/18/2013 7:15 PM, Felipe Pena wrote:
> On lpfc_debugfs_initialize function the dumpHostSlim member setup happens
> when 'phba->sli_rev < LPFC_SLI_REV4' is true, however when it is false NULL
> has been assigned to debug_dumpHBASlim instead of debug_dumpHostSlim.
>
> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_debugfs.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
> index 60084e6..b800cc9 100644
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> @@ -4001,7 +4001,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
>   				goto debug_failed;
>   			}
>   		} else
> -			phba->debug_dumpHBASlim = NULL;
> +			phba->debug_dumpHostSlim = NULL;
>
>   		/* Setup dumpData */
>   		snprintf(name, sizeof(name), "dumpData");
> --
> 1.7.10.4
>
>
>

