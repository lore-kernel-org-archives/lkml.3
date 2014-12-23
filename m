Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaLWNuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:50:18 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:63976 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbaLWNuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:50:16 -0500
Message-ID: <54997314.5030203@acm.org>
Date: Tue, 23 Dec 2014 07:50:12 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
CC: openipmi-developer@lists.sourceforge.net, Jeremy Kerr <jk@ozlabs.org>
Subject: Re: [PATCH 04/28] char: ipmi: drop owner assignment from platform_drivers
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de> <1419196495-9626-5-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1419196495-9626-5-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

On 12/21/2014 03:14 PM, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Generated with coccinelle. SmPL file is in the introductory msg. The big
> cleanup was pulled in this merge window. This series catches the bits fallen
> through. The patches shall go in via the subsystem trees.
>
>  drivers/char/ipmi/ipmi_powernv.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/char/ipmi/ipmi_powernv.c b/drivers/char/ipmi/ipmi_powernv.c
> index 79524ed2a3cb..d7acb04d3982 100644
> --- a/drivers/char/ipmi/ipmi_powernv.c
> +++ b/drivers/char/ipmi/ipmi_powernv.c
> @@ -294,7 +294,6 @@ static const struct of_device_id ipmi_powernv_match[] = {
>  static struct platform_driver powernv_ipmi_driver = {
>  	.driver = {
>  		.name		= "ipmi-powernv",
> -		.owner		= THIS_MODULE,
>  		.of_match_table	= ipmi_powernv_match,
>  	},
>  	.probe	= ipmi_powernv_probe,

