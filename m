Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbaIWJGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:06:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbaIWJGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:06:10 -0400
Message-ID: <542137E4.2030808@redhat.com>
Date: Tue, 23 Sep 2014 11:05:40 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>, Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] ahci-platform: Bump max number of clocks to 5
References: <1411416586-18320-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1411416586-18320-1-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks, this new set looks good to me, and is:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


On 09/22/2014 10:09 PM, Kumar Gala wrote:
> Qualcomm IPQ806x SoCs with SATA controllers need 5 clocks to be enabled.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
> v4/v5:
> * Updated to upstream changes
> 
>  drivers/ata/ahci.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 59ae0ee..90156ff 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -53,7 +53,7 @@
>  
>  enum {
>  	AHCI_MAX_PORTS		= 32,
> -	AHCI_MAX_CLKS		= 4,
> +	AHCI_MAX_CLKS		= 5,
>  	AHCI_MAX_SG		= 168, /* hardware max is 64K */
>  	AHCI_DMA_BOUNDARY	= 0xffffffff,
>  	AHCI_MAX_CMDS		= 32,
> 
