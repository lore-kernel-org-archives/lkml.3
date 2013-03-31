Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab3CaEAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 00:00:08 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:65142 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3CaEAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 00:00:06 -0400
MIME-Version: 1.0
In-Reply-To: <ba21f31410c122d160698a6d18266e3f695f6011.1364229828.git.viresh.kumar@linaro.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
	<ba21f31410c122d160698a6d18266e3f695f6011.1364229828.git.viresh.kumar@linaro.org>
Date: Sun, 31 Mar 2013 09:30:04 +0530
Message-ID: <CAKohpo=R4r5BGcXUosVj-LGD6iQ_fqXoqLPWO1FdfB9Rnh7j=w@mail.gmail.com>
Subject: Re: [PATCH 3/9] cris: cpufreq: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 March 2013 22:24, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This patch moves cpufreq drivers of CRIS architecture to drivers/cpufreq.
>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: linux-cris-kernel@axis.com
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  arch/cris/arch-v32/mach-a3/Makefile                                     | 1 -
>  arch/cris/arch-v32/mach-fs/Makefile                                     | 1 -
>  drivers/cpufreq/Makefile                                                | 2 ++
>  .../mach-a3/cpufreq.c => drivers/cpufreq/cris-artpec3-cpufreq.c         | 0
>  .../mach-fs/cpufreq.c => drivers/cpufreq/cris-etraxfs-cpufreq.c         | 0
>  5 files changed, 2 insertions(+), 2 deletions(-)
>  rename arch/cris/arch-v32/mach-a3/cpufreq.c => drivers/cpufreq/cris-artpec3-cpufreq.c (100%)
>  rename arch/cris/arch-v32/mach-fs/cpufreq.c => drivers/cpufreq/cris-etraxfs-cpufreq.c (100%)

Jesper/Mikael,

Can i have your views or Ack for this?
