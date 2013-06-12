Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab3FLWpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:45:53 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35442 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005Ab3FLWpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:45:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 00/11] CPUFreq Kconfig fixes
Date: Thu, 13 Jun 2013 00:55:03 +0200
Message-ID: <1869545.pIVrdam01k@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <201306121649.41656.arnd@arndb.de>
References: <cover.1371022830.git.viresh.kumar@linaro.org> <CAKohpont-8ZNDWx0n1G8ks=evfoJi3kQ5idjmeguyT8BWgTY4w@mail.gmail.com> <201306121649.41656.arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 12, 2013 04:49:41 PM Arnd Bergmann wrote:
> On Wednesday 12 June 2013, Viresh Kumar wrote:
> > 
> > On 12 June 2013 18:16, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Wednesday 12 June 2013, Viresh Kumar wrote:
> > >> Recently Arnd sent few fixes where drivers were using APIs from freq_table.c but
> > >> haven't selected CPU_FREQ_TABLE. Based on that, I just crossed checked all the
> > >> places where it should be selected and where it shouldn't be. These are fixes
> > >> around that.
> > >>
> > >> I have applied these in my cpufreq-kconfig-fixes branch. Will send you a pull
> > >> request separately once I get some Acks (will wait for few days).
> > >
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > >
> > > I don't see a patch for big.LITTLE in either linux-next or this series. Did you
> > > miss that or has it just not made into linux-next yet?
> > 
> > My ARM branch was pulled in by Rafael, 2 days back. Don't know why didn't
> > you saw that.
> 
> 
> Ah, it seems we haven't had a new linux-next since friday.

Yup, no linux-next this week.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
