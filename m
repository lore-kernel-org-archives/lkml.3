Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3EPWNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:13:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:48226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab3EPWNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:13:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="338561110"
Date: Fri, 17 May 2013 00:13:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Leon Romanovsky <leon@leon.nu>
Cc: sbkim73@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: mfd: sec-code: Fix sizeof argument
Message-ID: <20130516221321.GG22822@zurbaran>
References: <1368615236-21345-1-git-send-email-leon@leon.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368615236-21345-1-git-send-email-leon@leon.nu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leon,

On Wed, May 15, 2013 at 01:53:56PM +0300, Leon Romanovsky wrote:
> Signed-off-by: Leon Romanovsky <leon@leon.nu>
> ---
>  drivers/mfd/sec-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index 77ee26ef..5b740a3 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -121,7 +121,7 @@ static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
>  {
>  	struct sec_platform_data *pd;
>  
> -	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
> +	pd = devm_kzalloc(dev, sizeof(struct sec_platform_data), GFP_KERNEL);
How is that fixing anything ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
