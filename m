Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3C1HLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:11:42 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:56720 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab3C1HLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:11:41 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1302251820431.3030@axis700.grange>
References: <Pine.LNX.4.64.1302251820431.3030@axis700.grange>
Date: Thu, 28 Mar 2013 12:41:40 +0530
X-Google-Sender-Auth: OjZMhkyZEi0c3Vb_AdcNRN1aKtU
Message-ID: <CAOh2x=nnafMWKFqsi+6JUA38nKT-x4dZ0fimfiKS12vhK5tHmg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: use the exact frequency for clk_set_rate()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 10:52 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> clk_set_rate() isn't supposed to accept approximate frequencies, instead
> a supported frequency should be obtained from clk_round_rate() and then
> used to set the clock.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> Applies on top of my previous patch to fix unsigned freq_Hz "cpufreq: fix
> sign check of an unsigned variable in cpufreq-cpu0"
>
>  drivers/cpufreq/cpufreq-cpu0.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
