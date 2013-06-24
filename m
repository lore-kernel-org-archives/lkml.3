Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab3FXKtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:49:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48928 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab3FXKtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:49:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [GIT PULL] ARM: CPUFreq updates for 3.11
Date: Mon, 24 Jun 2013 12:59:07 +0200
Message-ID: <7195611.gCcafMWC85@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpomThmZFKTufBzWpmokqqZJ8C6DtGTKTzBY=OxJPNT-BmA@mail.gmail.com>
References: <CAKohpo=v4qPDH32Y4ithr_p007nTn5AOUzkUCiHTGgQN6-=BEw@mail.gmail.com> <1524748.bV9OZAOR0D@vostro.rjw.lan> <CAKohpomThmZFKTufBzWpmokqqZJ8C6DtGTKTzBY=OxJPNT-BmA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 04:12:29 PM Viresh Kumar wrote:
> On 24 June 2013 16:19, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, June 24, 2013 11:20:35 AM Viresh Kumar wrote:
> >> Hi Rafael,
> >>
> >> This is part of my patchset "CPUFreq: Fix {PRE|POST}CHANGE notification
> >> sequence". It contains changes specific to cpufreq core and ARM drivers.
> >>
> >> I have left changes to non-ARM cpufreq drivers from this pull request. See if
> >> you can take them for 3.11.
> >>
> >> The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:
> >>
> >>   Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)
> >>
> >> are available in the git repository at:
> >>
> >>   git://git.linaro.org/people/vireshk/linux.git cpufreq-fix-notification-arm
> >>
> >> for you to fetch changes up to f2d65dd0d573e6961165f0be35bac84997b9e707:
> >
> > Well, this contains changes that aren't specific to ARM as far as I can say.
> 
> Yeah, the first patch touches core. How do you want to proceed with this one
> then? You will apply them from mail? Or you will apply first patch (core cpufreq
> one) and I should send pull request without it?

In your original series that patch was the last one.  What made you change your
mind and put it in front?

Rafael

