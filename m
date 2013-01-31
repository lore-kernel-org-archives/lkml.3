Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab3AaLBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:01:19 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:62699 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab3AaLBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:01:17 -0500
MIME-Version: 1.0
In-Reply-To: <1359554017-28620-1-git-send-email-fabio.baltieri@linaro.org>
References: <1359554017-28620-1-git-send-email-fabio.baltieri@linaro.org>
Date: Thu, 31 Jan 2013 16:23:06 +0530
Message-ID: <CAKohpomTNkEOrnyQWKJ8siajg67-fpe4EnYxiipgmN8STMSwAQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governors: clean timer init and exit code
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 January 2013 19:23, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> Drop unused arguments from dbs_timer_init and clean dbs_timer_exit and
> cpufreq_governor_dbs to remove non necessary special cases.
>
> Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

As discussed over IRC, you will fix following in few days:
- Code redundancy within governors
- Removing second_time: label and cdbs->enable field
- Fixing params to timer init and exit to make them more efficient.

And here is my ack for this patch:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
