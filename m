Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3C0Nzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:55:32 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36317 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab3C0Nza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:55:30 -0400
MIME-Version: 1.0
In-Reply-To: <2ece6d9fe8dfb6882a1c83a1cb2404bacc40b22d.1364138740.git.viresh.kumar@linaro.org>
References: <2ece6d9fe8dfb6882a1c83a1cb2404bacc40b22d.1364138740.git.viresh.kumar@linaro.org>
Date: Wed, 27 Mar 2013 14:55:29 +0100
Message-ID: <CACRpkdbsOq_5NoS-OP4XXWo1ae6RjCcJLnSaa1qyWHsOxXA2dg@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: drivers: don't check range of target freq in .target()
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Sekhar Nori <nsekhar@ti.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 4:29 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Cpufreq core checks the range of target_freq before calling driver->target() and
> so we don't need to do it again.
>
> Remove it.
>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
