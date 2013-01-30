Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3A3LSC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:18:02 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51880 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3A3LR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:17:59 -0500
MIME-Version: 1.0
In-Reply-To: <20130130110429.GC32315@balto.lan>
References: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
	<1356620142-8680-2-git-send-email-fabio.baltieri@linaro.org>
	<CAOh2x==SG32h-BbrnLN8gwiYNz7bS-REVcmXN67fdYPqFVmCiA@mail.gmail.com>
	<20130130091453.GA32315@balto.lan>
	<20130130110429.GC32315@balto.lan>
Date: Wed, 30 Jan 2013 16:47:58 +0530
Message-ID: <CAKohpo=_oim1FN+Cu+kMKLRpH1c+6-wuQACEdpVS8yHoANHhcA@mail.gmail.com>
Subject: Re: [PATCH 1/5] cpufreq: handle SW coordinated CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 January 2013 16:34, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> Small sidenote, actually what I'm going to drop here i *cdbs, as I need
> cpu for schedule_delayed_work_on and can't use cdbs->cpu for that as
> it's the master's one.

I can't find code which would do j_cdbs->cpu = j and so j_cdbs->cpu is
un-initialized. So, if that's true, you can initialize that and drop
cpu param too.
