Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaHULgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:36:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbaHULeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:34:01 -0400
Message-ID: <53F5D920.1080800@redhat.com>
Date: Thu, 21 Aug 2014 13:33:52 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
CC: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 12/13] pmcraid: Get rid of a redundant assignment
References: <cover.1408335523.git.agordeev@redhat.com> <8058dca6525ca29845019ea9922c37f3416c0c7a.1408335523.git.agordeev@redhat.com>
In-Reply-To: <8058dca6525ca29845019ea9922c37f3416c0c7a.1408335523.git.agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 08:01 AM, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/pmcraid.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 6f3275d..6e575ed 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -4746,7 +4746,6 @@ pmcraid_isr_legacy:
>  	pinstance->hrrq_vector[0].drv_inst = pinstance;
>  	pinstance->hrrq_vector[0].vector = pdev->irq;
>  	pinstance->num_hrrq = 1;
> -	rc = 0;
>  
>  	rc = request_irq(pdev->irq, pmcraid_isr, IRQF_SHARED,
>  			 PMCRAID_DRIVER_NAME, &pinstance->hrrq_vector[0]);

Patch looks good to me.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

