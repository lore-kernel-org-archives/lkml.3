Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab3FTFNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:13:11 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:60942 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3FTFNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-3-git-send-email-l.majewski@samsung.com>
Date: Thu, 20 Jun 2013 10:43:08 +0530
Message-ID: <CAKohpo=5ZJp6JBVVA0NinTMO5FUwtfy3QAabcTwVOW6TmEfs9g@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 22:42, Lukasz Majewski <l.majewski@samsung.com> wrote:

> Boost sysfs attribute is always exported (to support legacy API). By
> default boost is exported as read only. One global attribute is available at:
> /sys/devices/system/cpu/cpufreq/boost.

You asked me and Rafael a question and posted your next version without
even waiting for our replies? That will waste your time and ours too
reviewing it.
