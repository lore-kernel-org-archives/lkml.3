Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaEGIMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:12:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41957 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751152AbaEGIML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:12:11 -0400
Message-ID: <1399450326.3706.9.camel@hornet>
Subject: Re: [PATCH 5/5] regulator: vexpress: Make of_device_id array const
From: Pawel Moll <pawel.moll@arm.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 07 May 2014 09:12:06 +0100
In-Reply-To: <01ef01cf69cb$a1a66d30$e4f34790$%han@samsung.com>
References: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
	 <01ef01cf69cb$a1a66d30$e4f34790$%han@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-07 at 09:09 +0100, Jingoo Han wrote:
> Make of_device_id array const, because all OF functions
> handle it as const.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/vexpress.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/vexpress.c b/drivers/regulator/vexpress.c
> index f3ae28a..147ecc7 100644
> --- a/drivers/regulator/vexpress.c
> +++ b/drivers/regulator/vexpress.c
> @@ -123,7 +123,7 @@ static int vexpress_regulator_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static struct of_device_id vexpress_regulator_of_match[] = {
> +static const struct of_device_id vexpress_regulator_of_match[] = {
>  	{ .compatible = "arm,vexpress-volt", },
>  	{ }
>  };

Acked-by: Pawel Moll <pawel.moll@arm.com>

Thanks!

Pawel

