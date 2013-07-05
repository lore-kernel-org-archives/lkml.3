Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3GEWsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:48:10 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37250 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3GEWsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:48:08 -0400
Message-ID: <51D74D23.8030805@cogentembedded.com>
Date: Sat, 06 Jul 2013 02:48:03 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>
CC: linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH] arm: Convert sa1111 platform and bus legacy pm_ops to
 dev_pm_ops
References: <1373064297-13582-1-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <1373064297-13582-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/06/2013 02:44 AM, Shuah Khan wrote:

> Convert arch/arm/common/sa1111 platform and bus legacy pm_ops to dev_pm_ops.
> This change also updates the use of COMFIG_PM to CONFIG_PM_SLEEP as this
> platform and bus code implements PM_SLEEP ops and not the PM_RUNTIME ops.
> Compile tested.

    It may be compile tested but the patch description doesn't match the 
patch (which is a simple trailing space fix).

> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>   arch/arm/common/sa1111.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
> index 2a64c12..95594f0 100644
> --- a/arch/arm/common/sa1111.c
> +++ b/arch/arm/common/sa1111.c
> @@ -1321,7 +1321,7 @@ static int sa1111_bus_resume(struct device *dev)
>   }
>   static SIMPLE_DEV_PM_OPS(sa1111_bus_dev_pm_ops, sa1111_bus_suspend,
>   			 sa1111_bus_resume);
> -#endif
> +#endif

WBR, Sergei


