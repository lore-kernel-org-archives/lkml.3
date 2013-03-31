Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3CaEBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 00:01:44 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38974 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3CaEBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 00:01:43 -0400
MIME-Version: 1.0
In-Reply-To: <27c30dd79c668dc3471d37fce2c83a4504d8b18c.1364229828.git.viresh.kumar@linaro.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
	<27c30dd79c668dc3471d37fce2c83a4504d8b18c.1364229828.git.viresh.kumar@linaro.org>
Date: Sun, 31 Mar 2013 09:31:42 +0530
Message-ID: <CAKohpo=MCn4qBMg9ZsSzmDvg0-7eE063u6g=btuCgC6G8x2rmQ@mail.gmail.com>
Subject: Re: [PATCH 7/9] unicore2: cpufreq: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
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
> This patch moves cpufreq driver of UNICORE-2 architecture to drivers/cpufreq.
>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  arch/unicore32/kernel/Makefile                                         | 1 -
>  drivers/cpufreq/Makefile                                               | 1 +
>  arch/unicore32/kernel/cpu-ucv2.c => drivers/cpufreq/unicore2-cpufreq.c | 2 +-
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename arch/unicore32/kernel/cpu-ucv2.c => drivers/cpufreq/unicore2-cpufreq.c (96%)

Guan,

Can i have your ack for this?
