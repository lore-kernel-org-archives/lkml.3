Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947408Ab3BHXuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:50:13 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35584 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947361Ab3BHXuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:50:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: valdis.kletnieks@vt.edu, artem.savkov@gmail.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
Date: Sat, 09 Feb 2013 00:56:31 +0100
Message-ID: <2792362.JXCag4GJsR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1653071.l2kN4Hy2U6@vostro.rjw.lan>
References: <cover.1360232293.git.viresh.kumar@linaro.org> <CAKohpokp4YrxKHibewdt+3-WF7P2Fa_bvRidHpjd9SpsT6bPpw@mail.gmail.com> <1653071.l2kN4Hy2U6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 08, 2013 09:02:37 PM Rafael J. Wysocki wrote:
> On Friday, February 08, 2013 08:06:52 PM Viresh Kumar wrote:
> > On 8 February 2013 18:02, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > So as I said, please rework the fixes on top of linux-pm.git/pm-cpufreq.
> > 
> > I already did. Please check for-rafael branch
> 
> Cool.  This is the one I'm supposed to apply, then?

OK, applied to bleeding-edge.  Hopefully it will be build-tested over the
weekend and I can move it to linux-next.

I dropped the rwlock/RCU patches from Nathan, though, because I had some
doubts about the correctness of the RCU one and the rwlock one alone would
conflict with your further changes.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
