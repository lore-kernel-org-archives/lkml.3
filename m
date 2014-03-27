Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbaC0PDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:03:15 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53690 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756698AbaC0PDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:03:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] arm64: Fix duplicated Kconfig entries again
Date: Thu, 27 Mar 2014 16:18:43 +0100
Message-ID: <2765234.k5FCzWzCDz@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53341ADF.2050904@linaro.org>
References: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org> <5334078A.9010408@arm.com> <53341ADF.2050904@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 27, 2014 08:34:39 PM Hanjun Guo wrote:
> On 2014-3-27 19:12, Sudeep Holla wrote:
> > Hi Hanjun,
> > 
> > On 25/03/14 11:09, Hanjun Guo wrote:
> >> Hi Sudeep,
> >>
> >> On 2014-3-25 18:00, Sudeep Holla wrote:
> >>> Hi Hanjun,
> >>>
> >>> On 25/03/14 09:00, Hanjun Guo wrote:
> >>>> After commit 74397174989e5 (arm64: Fix duplicated Kconfig entries),
> >>>> I still get a duplicate Power management options section in linux-next
> >>>> git repo, may be due to some merge conflicts, anyway, fix that in this
> >>>> patch.
> >>>>
> >>> I reported this and Mark Brown posted the patch[1].
> >>> I assumed it is already pulled, but looks like that's not the case.
> >> [...]
> >>> [1] http://www.spinics.net/lists/arm-kernel/msg314472.html
> > 
> > [...]
> > 
> >> here is the link:
> >> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm64/Kconfig
> >>
> > 
> > Just had a look at the linux-next tree and looks like the original commit:
> > "cpufreq: enable ARM drivers on arm64" is pulled by both Catalin and Rafael
> > which has resulted in the fixup patch[1] not removing the duplicate entry
> > cleanly.
> > 
> > If not too late it better to ask either Rafael or Catalin to drop both patches
> > from their tree, instead of creating 4 patches in total to enable cpufreq :)
> 
> Rafael is on vacation now.
> 
> Catalin, could you please handle this?

Well, not really, I'm at a conference now.

Anyway, I'd rather not drop anything, but if you send me a revert, I can apply it.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
