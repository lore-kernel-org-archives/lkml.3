Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3HBVL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:11:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52652 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab3HBVL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:11:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.11-rc4
Date: Fri, 02 Aug 2013 23:21:37 +0200
Message-ID: <1820071.Lqgn6ZcLbB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMP44s2a2HqohWL9d+i3cpifJiUfidTw_ZfO3PttvhMn_hGE1A@mail.gmail.com>
References: <2052880.bHfzt6NKt5@vostro.rjw.lan> <CAMP44s2a2HqohWL9d+i3cpifJiUfidTw_ZfO3PttvhMn_hGE1A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 02:12:49 PM Felipe Contreras wrote:
> On Fri, Aug 2, 2013 at 9:29 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > ---------------
> >
> > Colin Cross (1):
> >       freezer: set PF_SUSPEND_TASK flag on tasks that call freeze_processes
> >
> > Lan Tianyu (1):
> >       ACPI / battery: Fix parsing _BIX return value
> >
> > Rafael J. Wysocki (3):
> >       Revert "cpuidle: Quickly notice prediction failure in general case"
> >       Revert "cpuidle: Quickly notice prediction failure for repeat mode"
> >       cpufreq: Fix cpufreq driver module refcount balance after suspend/resume
> >
> > ---------------
> 
> You forgot this patch:
> 
> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&id=3706231332d57072e0e2c0e59975443f3f18e673
> 
> Or do you think it's fine to boot these machines into a black screen?

Seriously, what's wrong with you?!

I didn't forget about it, I just didn't include it into this particular
pull request.

And I'm not even sure I will push it for 3.11, because I prefer to revert
efaa14c for 3.11 if that's necessary to make your broken box work as before.

Well, perhaps I just won't push it at all so that you actually can go and
complain to Linus about that ...

