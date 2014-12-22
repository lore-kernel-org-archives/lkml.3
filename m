Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaLVBo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:44:59 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:52908 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaLVBo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:44:57 -0500
MIME-Version: 1.0
In-Reply-To: <1419196495-9626-6-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
	<1419196495-9626-6-git-send-email-wsa@the-dreams.de>
Date: Mon, 22 Dec 2014 07:14:56 +0530
Message-ID: <CAKohpok_G3Gf3XbcK06ELM3ocWQmNPepx1i72VXR8sNbK1L81Q@mail.gmail.com>
Subject: Re: [PATCH 05/28] cpufreq: drop owner assignment from platform_drivers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 December 2014 at 02:44, Wolfram Sang <wsa@the-dreams.de> wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Generated with coccinelle. SmPL file is in the introductory msg. The big
> cleanup was pulled in this merge window. This series catches the bits fallen
> through. The patches shall go in via the subsystem trees.
>
>  drivers/cpufreq/ls1x-cpufreq.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/cpufreq/ls1x-cpufreq.c b/drivers/cpufreq/ls1x-cpufreq.c
> index 25fbd6a1374f..f0913eee2f50 100644
> --- a/drivers/cpufreq/ls1x-cpufreq.c
> +++ b/drivers/cpufreq/ls1x-cpufreq.c
> @@ -210,7 +210,6 @@ out:
>  static struct platform_driver ls1x_cpufreq_platdrv = {
>         .driver = {
>                 .name   = "ls1x-cpufreq",
> -               .owner  = THIS_MODULE,
>         },
>         .probe          = ls1x_cpufreq_probe,
>         .remove         = ls1x_cpufreq_remove,

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
