Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3BILiE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 06:38:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36148 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab3BILiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 06:38:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, valdis.kletnieks@vt.edu,
        artem.savkov@gmail.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
Date: Sat, 09 Feb 2013 12:44:23 +0100
Message-ID: <4156001.9630YezyCK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpomSSKRmhmmYk5dn4d84yk9qSs0U-9S=W=CT0yjjzJJ3=g@mail.gmail.com>
References: <cover.1360232293.git.viresh.kumar@linaro.org> <51159391.2020002@gmail.com> <CAKohpomSSKRmhmmYk5dn4d84yk9qSs0U-9S=W=CT0yjjzJJ3=g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 09, 2013 07:40:26 AM Viresh Kumar wrote:
> On 9 February 2013 05:38, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> > On 02/08/2013 03:56 PM, Rafael J. Wysocki wrote:
> >>
> >> On Friday, February 08, 2013 09:02:37 PM Rafael J. Wysocki wrote:
> >>>
> >>> On Friday, February 08, 2013 08:06:52 PM Viresh Kumar wrote:
> >>>>
> >>>> On 8 February 2013 18:02, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>>>>
> >>>>> So as I said, please rework the fixes on top of
> >>>>> linux-pm.git/pm-cpufreq.
> >>>>
> >>>>
> >>>> I already did. Please check for-rafael branch
> >>>
> >>>
> >>> Cool.  This is the one I'm supposed to apply, then?
> >>
> >>
> >> OK, applied to bleeding-edge.  Hopefully it will be build-tested over the
> >> weekend and I can move it to linux-next.
> >>
> >> I dropped the rwlock/RCU patches from Nathan, though, because I had some
> >> doubts about the correctness of the RCU one and the rwlock one alone would
> >> conflict with your further changes.
> 
> As soon as i read Rafael's mail, i realized Dirk's patch might be broken
> and immediately i saw your mail :)
> 
> @Rafael: Sorry for not reviewing Nathan's patch well. I didn't knew much about
> RCU then. I am going through its lwn articles now ;)

No biggie, I overlooked that myself first time.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
