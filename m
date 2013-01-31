Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab3AaKrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:47:15 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:38295 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3AaKrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:47:11 -0500
MIME-Version: 1.0
In-Reply-To: <1359628759-15006-1-git-send-email-fabio.baltieri@linaro.org>
References: <1359628759-15006-1-git-send-email-fabio.baltieri@linaro.org>
Date: Thu, 31 Jan 2013 16:17:08 +0530
Message-ID: <CAKohpokq3p9Yz5771nuz0AiOfavg59t6xamdob-=5h02vOPK=g@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governors: fix misuse of cdbs.cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2013 16:09, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> Fix governors code to set all cpu's cdbs->cpu to the the actual cpu id
> and use cur_policy->cpu istead of cdbs->cpu to track current governor's
> leader cpu.
>
> Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  drivers/cpufreq/cpufreq_conservative.c | 5 +++--
>  drivers/cpufreq/cpufreq_governor.c     | 2 +-
>  drivers/cpufreq/cpufreq_ondemand.c     | 5 +++--
>  3 files changed, 7 insertions(+), 5 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
