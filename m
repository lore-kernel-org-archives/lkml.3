Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab3EQXb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 19:31:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57732 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab3EQXbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 19:31:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 0/3] CPUFreq Fixes for 3.10-rc2
Date: Sat, 18 May 2013 01:40:27 +0200
Message-ID: <3949011.nZfu3g41l4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=bNzYw5ire+6XnM+cv6fnPBDN-CX0DRonc5qhpKC01yA@mail.gmail.com>
References: <cover.1368679353.git.viresh.kumar@linaro.org> <10164364.7LZaY8si4T@vostro.rjw.lan> <CAKohpo=bNzYw5ire+6XnM+cv6fnPBDN-CX0DRonc5qhpKC01yA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 17, 2013 07:22:05 PM Viresh Kumar wrote:
> On 17 May 2013 17:46, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, May 17, 2013 10:13:37 AM Viresh Kumar wrote:
> >> On 17 May 2013 02:21, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > While I kind of understand why you want [3/3] to go into 3.10, I'm wondering
> >> > about the other two patches.  Why exactly are they needed now?
> >>
> >> First one:
> >>
> >>   cpufreq: Add EXPORT_SYMBOL_GPL for have_governor_per_policy
> >>
> >> is required so that governors can be compiled as module. Otherwise they
> >> may break.. I haven't tried that but I believe that is the case.
> >
> > Did you try to build them as modules?
> 
> That's what: "I haven't tried that but I believe that is the case."..
> Modules need variables to be exported with EXPORT_SYMBOL_GPL
> to be used by them.. And I thought this is pretty straight forward.

Well, I actually meant "can you please verify your belief?". :-)

And that's because I'm wondering why the zero-day build testing doesn't
catch this problem.  Apparently, it doesn't build .configs with cpufreq
governors configured as modules, although I believe it does test
"make allmodconfig" for a couple of architectures at least.  What gives?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
