Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab3E0NYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:24:51 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:37244 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab3E0NYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:24:49 -0400
MIME-Version: 1.0
In-Reply-To: <8856294.KaD55h4g0a@vostro.rjw.lan>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
	<20130524132036.7e7d5ffe@amdc308.digital.local>
	<CAKohpo=Kw4RsDJL8BdH1uE7Aj-X=K5A7af5NRqJXyjRUNvv5ag@mail.gmail.com>
	<8856294.KaD55h4g0a@vostro.rjw.lan>
Date: Mon, 27 May 2013 18:54:49 +0530
Message-ID: <CAKohpom4sSwJG7r67+aNMjAdr7CToAqCbdcbd+vSCTEQkiTkcg@mail.gmail.com>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 May 2013 17:30, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Well, this really looks like software turbo modes, so let's call them
> "TURBO" instead of "OVERDRIVE"

Yes, it looks better.

> and I seem to remember having a switch for
> disabling/enabling turbo modes already.

This was added in intel_pstate driver and shows up in
/sys/devices/system/cpu/cpufreq/ directory..

But this feature belongs to a governor instance and so
will be present inside governor directory..

Specially for big LITTLE we want it to be per policy
specific. So may need to add a new one.
