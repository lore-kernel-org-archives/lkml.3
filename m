Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaJLUBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:01:01 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64769 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752523AbaJLUA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:00:57 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>,
        linux-pm@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [REPOST PATCH v4 1/2] PM / QoS: Add PM_QOS_MEMORY_BANDWIDTH class
Date: Sun, 12 Oct 2014 22:21:10 +0200
Message-ID: <3322444.Yf2zmy7yVQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAObsKBuDRQy7=zLkmRj9O+Ka0K_z-ejXCyzwttEXmQVkXn2hw@mail.gmail.com>
References: <1409759373-22696-1-git-send-email-tomeu.vizoso@collabora.com> <2373913.b8GhYem2Rt@vostro.rjw.lan> <CAAObsKBuDRQy7=zLkmRj9O+Ka0K_z-ejXCyzwttEXmQVkXn2hw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 10, 2014 08:59:22 AM Tomeu Vizoso wrote:
> On 26 September 2014 01:51, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Wednesday, September 24, 2014 03:31:55 PM Tomeu Vizoso wrote:
> >> On 24 September 2014 15:32, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> > On Wednesday, September 24, 2014 10:42:13 AM Tomeu Vizoso wrote:
> >> >> On 14 September 2014 19:06, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> >> > On Friday, September 12, 2014 11:11:25 AM Tomeu Vizoso wrote:
> >> >> >> On 3 September 2014 17:49, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
> >> >> >> > Also adds a class type PM_QOS_SUM that aggregates the values by summing them.
> >> >> >> >
> >> >> >> > It can be used by memory controllers to calculate the optimum clock frequency
> >> >> >> > based on the bandwidth needs of the different memory clients.
> >> >> >> >
> >> >> >> > Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> >> >> >> > Acked-by: Pavel Machek <pavel@ucw.cz>
> >> >> >>
> >> >> >> Hi Rafael,
> >> >> >>
> >> >> >> will you take this one for 3.18?
> >> >> >
> >> >> > Quite likely, but I'm traveling now, so I'll do that after I'm back home
> >> >> > in a few days.  I'll write to you if there are any problems.
> >> >>
> >> >> Don't want to be annoying, but thought I might ping you just in case
> >> >> this fell through the cracks.
> >> >
> >> > No, it didn't.
> >> >
> >> > I'm wondering about patch [2/2], though.  I'm assuming that you'll push you
> >> > later through the Tegra DRM driver, right?
> >>
> >> Yes, that was Stephen's suggestion:
> >>
> >> https://lkml.org/lkml/2014/8/25/439
> >
> > OK, patch [1/2] queued up for 3.18, thanks!
> 
> Hi Rafael,
> 
> I don't see this one in linux-next yet.

My bad, I skipped the pm-qos branch by mistake.  Sorry about that.

This week I'm attending conferences, but I'll push it to Linus next week
if the merge windown is still open then.

Rafael

