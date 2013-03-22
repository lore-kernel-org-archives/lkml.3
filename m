Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab3CVLrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:47:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33358 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab3CVLrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:47:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com
Subject: Re: [PATCH V3 2/4] cpufreq: governor: Implement per policy instances of governors
Date: Fri, 22 Mar 2013 12:55:09 +0100
Message-ID: <1483775.d1txvSJx9o@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpomDK+FQvhZsy672P+Q4U1s2AGtJ2QizFTaNqjMRh19G0g@mail.gmail.com>
References: <cover.1362381470.git.viresh.kumar@linaro.org> <2565053.YP0dCLmaW9@vostro.rjw.lan> <CAKohpomDK+FQvhZsy672P+Q4U1s2AGtJ2QizFTaNqjMRh19G0g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 22, 2013 07:50:54 AM Viresh Kumar wrote:
> On 22 March 2013 05:14, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, March 20, 2013 10:59:13 AM Viresh Kumar wrote:
> 
> >> I have queued all patches i had for 3.10 here:
> >>
> >> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-3.10
> >
> > OK, applied these to linux-pm.git/bleeding-edge.
> 
> Thanks.
> 
> > At the moment bleeding-edge and linux-next diverged slightly on cpufreq, but
> > I hope the bleeding-edge material won't cause build problems to occur, so I'll
> > be able to move it to linux-next shortly.
> 
> There shouldn't be any build problems not because i have done all build testing
> properly BUT because my tree is under continuously surveillance by Fengguang's
> bot. And any problem with my branches is reported very early :)
> 
> >> commit f02fca9a2478088c4f7dadf82d998ae007a56285
> >> Author: Viresh Kumar <viresh.kumar@linaro.org>
> >> Date:   Wed Mar 20 10:50:33 2013 +0530
> >>
> >>     fixup! cpufreq: governor: Implement per policy instances of governors
> >
> > I'd actually prefer you to post complete updated patches instead of these
> > fixups.  They are real PITA for me and probably for everybody else trying
> > to follow the cpufreq development recently.
> 
> Hmm... I always thought fixups are way easy to review (and i still
> believe that's
> true) as they just contain what got changed and so people don't have to review
> whole patch again.

They won't have to if you write in the preamble what the differences from
previous versions are.

> BUT people who are looking for complete patches to apply
> would be annoyed by this and hence i always show them path of my repo
> where they can find it.

The problem with this approach is that the complete patches never make it to
the mailing lists and people have problems with connecting commits to
previously posted patches.

Moreover, it is *much* more convenient to me to take patches from kernel.org
patchwork than from your repos, with all due respect.

> So, what i may do is, post fixups and then resend
> patches. So that reviewer knows what changed and others can have complete
> patches too.

Sure, that will work too.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
