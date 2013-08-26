Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3HZNB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:01:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34882 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3HZNBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:01:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: Re: [PATCH v7 1/7] cpufreq: Add boost frequency support in core
Date: Mon, 26 Aug 2013 15:12:33 +0200
Message-ID: <2003732.zyaEDD5Bdr@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130826091114.78ea4f61@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <CAKohpondC1BuODMauBsBKZtL=9sSDUSB6nXFKSoLWJG_xgO+iw@mail.gmail.com> <20130826091114.78ea4f61@amdc308.digital.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 26, 2013 09:11:14 AM Lukasz Majewski wrote:
> On Mon, 26 Aug 2013 12:36:47 +0530 Viresh Kumar viresh.kumar@linaro.org
> wrote,
> > On 26 August 2013 12:32, Lukasz Majewski <l.majewski@samsung.com>
> > wrote:
> > > On Mon, 26 Aug 2013 10:58:53 +0530 Viresh Kumar
> > > viresh.kumar@linaro.org wrote,
> > >> Some minor nitpicking, nothing much :)
> > >
> > > Is there any chance to pull those corrected patches to v3.12?
> > 
> > Only Rafael can decide :)
> 
> :-)

Well, 3.11 is a week away and the 3.12 merge window will open then.

Honestly, I'd prefer this stuff to spend a couple of weeks in linux-next
before pushing it to Linus, so this means 3.13 I'm afraid.

Thanks,
Rafael

