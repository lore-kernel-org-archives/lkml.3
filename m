Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3DQQcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:32:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35642 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab3DQQcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:32:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Axel Lin <axel.lin@ingics.com>
Cc: "myungjoo.ham" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH 1/3] PM / devfreq: exynos4_bus: Fix missing mutex_unlock if opp_find_freq_floor fails
Date: Wed, 17 Apr 2013 18:39:59 +0200
Message-ID: <3176661.8CFuf9SsWS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAFRkauAD9H_euMUWqw2mgHDFT-B+gfHP5_tz+2LoOz5t_BPn7Q@mail.gmail.com>
References: <1365746058.4025.1.camel@phoenix> <2583577.Kz0O4QXtvD@vostro.rjw.lan> <CAFRkauAD9H_euMUWqw2mgHDFT-B+gfHP5_tz+2LoOz5t_BPn7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 13, 2013 09:40:49 AM Axel Lin wrote:
> 2013/4/13 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Friday, April 12, 2013 09:11:00 PM myungjoo.ham wrote:
> >> > On Friday, April 12, 2013 11:52:01 AM 함명주 wrote:
> >> > > > On Friday, April 12, 2013 01:54:18 PM Axel Lin wrote:
> >> > > > > We need to call mutex_unlock() in the error path.
> >> > > > >
> >> > > > > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> >> > > >
> >> > > > All three patches applied to linux-pm.git/linux-next.
> >> > > >
> >> > > > Exynos maintainers, if you have any objections, please holler.
> >> > > >
> >> > > > Thanks,
> >> > > > Rafael
> >> > >
> >> > > This patch was included in the last pull-request patchset
> >> > > though the path was updated. (its precedessor patch moved
> >> > > exynos drivers to /drivers/devfreq/exynos/* after adding
> >> > > Exynos common driver files)
> >> >
> >> > OK, so do you want me to drop it?
> >> >
> >> > What about the remaining two?
> >>
> >> Yes, please drop 1/3. It's duplicated.
> >>
> >> The patches 2~3/3 can wait. They are actually not bugfixes.
> >
> > OK, I've dropped all three.
> >
> > Axel, please push [2-3/3] thorugh the Exynos tree.
> 
> I thought I already Cc all devfreq maintainers.
> Is there any other thing I need to do?

Just please let them know that you'd like them to take the patches, not me. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
