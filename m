Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab3GDG24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:28:56 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38556 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3GDG2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:28:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130704074307.282a53dc@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-6-git-send-email-l.majewski@samsung.com>
	<CAKohpo=EwapTp8epok30=_ZYLPeCR8_LhpBF5H724dE=+SwMLg@mail.gmail.com>
	<20130627125819.5c90da30@amdc308.digital.local>
	<CAKohpo=JKg17YWjTrOh25hHW=sXn8-TW=D8rhrovonwZBDarBg@mail.gmail.com>
	<20130627164204.370dc4a6@amdc308.digital.local>
	<CAKohpomrPP9Lzk+fMn+Ba+J+2N740LR5NurVMomx8zww3AWLww@mail.gmail.com>
	<20130628085457.05d64878@amdc308.digital.local>
	<20130701101516.7945e387@amdc308.digital.local>
	<CAKohponiy3ebnt0_Cdaan5=DkAfA3U4g=m4NnYGLA-a+tPJJQg@mail.gmail.com>
	<20130704074307.282a53dc@amdc308.digital.local>
Date: Thu, 4 Jul 2013 11:58:53 +0530
Message-ID: <CAKohpomcaDS93zka0FK5_JMGY96sW0tLhGzMbr_FFM6wQYPh1A@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] cpufreq: Calculate number of busy CPUs
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

On 4 July 2013 11:13, Lukasz Majewski <l.majewski@samsung.com> wrote:
> This is a possible solution, but I've already modified thermal code a
> bit and found a solution for the problem.
>
> I use thermal workqueue (which is already in place anyway) to enable the
> boost again.
> Due to that I can provide behaviour similar to HW controlled boost.
>
> Patches with this solution are already prepared. I will post them in a
> few hours. Ok?

I don't see any harm in checking them out :)
Please send them.
