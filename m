Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3EUNJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:09:39 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:62176 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3EUNJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:09:37 -0400
Message-ID: <519B720F.9020705@cogentembedded.com>
Date: Tue, 21 May 2013 17:09:35 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Libo Chen <libo.chen@huawei.com>
CC: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, lizefan@huawei.com
Subject: Re: [PATCH 15/19] drivers/net/irda: add missing platform_driver owner
References: <1369104163-38628-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1369104163-38628-1-git-send-email-libo.chen@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-05-2013 6:42, Libo Chen wrote:

> set the owner of platform_driver, to ensure that the
> caller of driver holds a module refernece

> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>   drivers/net/irda/bfin_sir.c   |    1 +
>   drivers/net/irda/sh_irda.c    |    1 +
>   drivers/net/irda/sh_sir.c     |    1 +
>   drivers/net/irda/smsc-ircc2.c |    1 +
>   4 files changed, 4 insertions(+), 0 deletions(-)

> diff --git a/drivers/net/irda/bfin_sir.c b/drivers/net/irda/bfin_sir.c
> index 22b4527..bf976f3 100644
> --- a/drivers/net/irda/bfin_sir.c
> +++ b/drivers/net/irda/bfin_sir.c
> @@ -806,6 +806,7 @@ static struct platform_driver bfin_ir_driver = {
>   	.resume  = bfin_sir_resume,
>   	.driver  = {
>   		.name = DRIVER_NAME,
> +		.owner	= THIS_MODULE,

    Either indent last = with space as above, or indent both = with tabs.

WBR, Sergei

