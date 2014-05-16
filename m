Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaEPLRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 07:17:36 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59873 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932132AbaEPLRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 07:17:35 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Alexander Shiyan <shc_work@mail.ru>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] cpuidle: new driver for Cirrus Logic for 3.16
Date: Fri, 16 May 2014 13:34:24 +0200
Message-ID: <2465369.ul6KCqXmnx@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5375CB0D.2080309@linaro.org>
References: <5360CF57.9050202@linaro.org> <5375CB0D.2080309@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 16, 2014 10:23:41 AM Daniel Lezcano wrote:
> 
> Hi Rafael,
> 
> just a head up in case you missed it.

Pulled now, thanks!


> On 04/30/2014 12:24 PM, Daniel Lezcano wrote:
> >
> > Hi Rafael,
> >
> > this pull request is based on top 3.15-rc3
> >
> >   * Alexander Shiyan added a new driver for the Cirrus Logic clps711x
> >
> > Thanks
> >    -- Daniel
> >
> > The following changes since commit
> > d1db0eea852497762cab43b905b879dfcd3b8987:
> >
> >    Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)
> >
> > are available in the git repository at:
> >
> >    git://git.linaro.org/people/daniel.lezcano/linux.git cpuidle/3.16
> >
> > for you to fetch changes up to 7c7f8f7f2c6bf078874e5de35d7e2c66467fc664:
> >
> >    ARM: clps711x: Add cpuidle driver (2014-04-30 01:33:02 +0200)
> >
> > ----------------------------------------------------------------
> > Alexander Shiyan (1):
> >        ARM: clps711x: Add cpuidle driver
> >
> >   drivers/cpuidle/Kconfig.arm        |    6 ++++
> >   drivers/cpuidle/Makefile           |    1 +
> >   drivers/cpuidle/cpuidle-clps711x.c |   64
> > ++++++++++++++++++++++++++++++++++++
> >   3 files changed, 71 insertions(+)
> >   create mode 100644 drivers/cpuidle/cpuidle-clps711x.c
> >
> 
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
