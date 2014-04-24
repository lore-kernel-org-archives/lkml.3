Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbaDXLRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:17:01 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:46706 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaDXLQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:16:53 -0400
Message-ID: <5358F2A1.40106@cogentembedded.com>
Date: Thu, 24 Apr 2014 15:16:49 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/6] PM / clock_ops: Add helpers combining generic runtime
 and generic clock PM
References: <1398335198-26555-1-git-send-email-geert+renesas@glider.be> <1398335198-26555-2-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1398335198-26555-2-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-04-2014 14:26, Geert Uytterhoeven wrote:

> Add helpers pm_generic_runtime_clk_suspend() and
> pm_generic_clk_runtime_resume(), combining generic runtime PM and generic
> clock PM.

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

[...]

> diff --git a/include/linux/pm_clock.h b/include/linux/pm_clock.h
> index 6981aa288c45..bf1e4d09a0ca 100644
> --- a/include/linux/pm_clock.h
> +++ b/include/linux/pm_clock.h
> @@ -35,6 +35,8 @@ extern int pm_clk_add_clk(struct device *dev, struct clk *clk);
>   extern void pm_clk_remove(struct device *dev, const char *con_id);
>   extern int pm_clk_suspend(struct device *dev);
>   extern int pm_clk_resume(struct device *dev);
> +extern int pm_generic_runtime_clk_suspend(struct device *dev);
> +extern int pm_generic_clk_runtime_resume(struct device *dev);

    Shouldn't these function names be symmetric? I think '_clk' and '_runtime' 
need swapping in one case.

WBR, Sergei

