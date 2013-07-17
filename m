Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3GQNBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:01:22 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:44331 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3GQNBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:01:21 -0400
MIME-Version: 1.0
In-Reply-To: <2509113.ybUsa2l9tg@vostro.rjw.lan>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<6633375.dICiDrHJgK@vostro.rjw.lan>
	<CAKohpokw-bSWEgKvx0jd2QZ0RCz5dORHM9z+VYbTdKoCmKFvsg@mail.gmail.com>
	<2509113.ybUsa2l9tg@vostro.rjw.lan>
Date: Wed, 17 Jul 2013 18:31:19 +0530
Message-ID: <CAKohpo=1Qov8p3f2xZkfOqaFRNJPJN60KeK4SOXcL9Hw82MkAg@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lukasz Majewski <l.majewski@majess.pl>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 July 2013 17:01, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> First off, I'm not sure how many applications actually use it and I think,
> if any, they should be able cope with the attribute not being present.
>
> Of course, if it turns out that yes, there are applications using it and no,
> they cannot cope with the missing attribute, we'll need to address this.
> That said such applications wouldn't work with earlier kernels in which that
> attribute wasn't present at all, so I suppose this is really unlikely.
>
> So, do whichever makes more sense to you: Design things to preserve the old
> behavior (which is sightly confusing) or design them to expose the attribute
> if the feature is actually supported and be prepared to address the (unlikely)
> case when some hypothetical applications break because of that.

Okay. Its better to keep it the way Lukasz designed it in his last patchset.
