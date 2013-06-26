Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3FZHwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:52:12 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:47648 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3FZHwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130626094811.1986e875@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-1-git-send-email-l.majewski@samsung.com>
	<20130626094811.1986e875@amdc308.digital.local>
Date: Wed, 26 Jun 2013 13:22:08 +0530
X-Google-Sender-Auth: RgxheK9n55wa7xqehFX10J50glM
Message-ID: <CAOh2x=nts3VF11fWp4TNf8f5wLdWM1Eyooi+zdp+ZsQgTnF8eg@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] cpufreq:boost: CPU Boost mode support
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

On Wed, Jun 26, 2013 at 1:18 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:
> If this is not a problem, I'd like to kindly ask You to review those
> patches.
>
> Rafael has expressed his opinion about "boost" attribute clearly at the
> other mail (as a response to v4 patches):
> "Simple: Export it only when supported."
>
> Despite the change about the "boost" attribute visibility there were
> many other changes, which deserve maintainer's look.

I haven't got time to review it until now.. I will try to do it this week.
