Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaFDFKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 01:10:33 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:48603 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaFDFKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 01:10:32 -0400
MIME-Version: 1.0
In-Reply-To: <1401820203-21556-1-git-send-email-sboyd@codeaurora.org>
References: <1401820203-21556-1-git-send-email-sboyd@codeaurora.org>
Date: Wed, 4 Jun 2014 10:40:31 +0530
Message-ID: <CAKohpokGNr0vnxz_DKhviGiurdRv1y2bVWM7M+h9xVS0Bb_+Ow@mail.gmail.com>
Subject: Re: [PATCH] unicore32: Remove ARCH_HAS_CPUFREQ config option
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2014 00:00, Stephen Boyd <sboyd@codeaurora.org> wrote:
> This config exists entirely to hide the cpufreq menu from the
> kernel configuration unless a platform has selected it. Nothing
> is actually built if this config is 'Y' and it just leads to more
> patches that add a select under a platform Kconfig so that some
> other CPUfreq option can be chosen. Let's remove the option so
> that we can always enable CPUfreq drivers on unicore32 platforms.
>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/unicore32/Kconfig | 6 ------
>  1 file changed, 6 deletions(-)

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
