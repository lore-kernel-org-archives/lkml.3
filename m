Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaETMbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:31:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54387 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753083AbaETMbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:31:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: linux-next: manual merge of the pm tree with the samsung tree
Date: Tue, 20 May 2014 14:48:27 +0200
Message-ID: <3571098.myqhuVX7FX@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <013b01cf73c2$5bbe1fb0$133a5f10$@samsung.com>
References: <20140519125124.6504764d@canb.auug.org.au> <1911725.FzcK6v311f@vostro.rjw.lan> <013b01cf73c2$5bbe1fb0$133a5f10$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 20, 2014 09:27:58 AM Kukjin Kim wrote:
> Rafael J. Wysocki wrote:
> > 
> > On Monday, May 19, 2014 12:51:24 PM Stephen Rothwell wrote:
> > >
> > > --Sig_/n+GoYBpTr9ERl.sTIEYr/Og
> > > Content-Type: text/plain; charset=US-ASCII
> > > Content-Transfer-Encoding: quoted-printable
> > >
> > > Hi Rafael,
> > >
> > > Today's linux-next merge of the pm tree got conflicts in
> > > drivers/cpufreq/exynos-cpufreq.c and drivers/cpufreq/exynos-cpufreq.h
> > > between commit 2b07f4085479 ("cpufreq: exynos: Fix the compile error")
> > > from the samsung tree and commit e5eaa445b0dc ("cpufreq: exynos: Use
> > > dev_err/info function instead of pr_err/info") from the pm tree.
> > >
> > > I fixed it up (see below) and can carry the fix as necessary (no action
> > > is required).
> > 
> > Thanks for fixing that Stephen!
> > 
> Same here ;-)
> 
> > Kukjin, are you going to handle all Exynos cpufreq commits in the future?
> > 
> If you're OK, would be better to us I think.

OK, I'll leave them to you, then.  Please ask Viresh for ACKs if needed. :-)


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
