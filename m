Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3DVLts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:49:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40591 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3DVLtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:49:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 0/5] dmaengine: add ACPI DMA helpers and use them in dw_dmac
Date: Mon, 22 Apr 2013 13:57:49 +0200
Message-ID: <2382527.O0vcbyEZOf@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAHp75Ve+c01kSoOwUSW=D9tq+svuOTzkkEhM0Amn1vL9VdiXWg@mail.gmail.com>
References: <1365505547-10552-1-git-send-email-andriy.shevchenko@linux.intel.com> <20130422055612.GE6081@intel.com> <CAHp75Ve+c01kSoOwUSW=D9tq+svuOTzkkEhM0Amn1vL9VdiXWg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 22, 2013 01:07:39 PM Andy Shevchenko wrote:
> On Mon, Apr 22, 2013 at 8:56 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Tue, Apr 16, 2013 at 08:11:57PM +0200, Rafael J. Wysocki wrote:
> >> On Tuesday, April 16, 2013 03:14:47 PM Andy Shevchenko wrote:
> >> > On Mon, 2013-04-15 at 22:06 +0530, Vinod Koul wrote:
> >> > > On Tue, Apr 09, 2013 at 02:05:42PM +0300, Andy Shevchenko wrote:
> >> > > > There is a patch series which introduces ACPI DMA helpers in similar way like
> >> > > > we have for DeviceTree.
> >> > > >
> >> > > > In addition it applies this to the first user, namely dw_dmac driver.
> >> > > Applied w/o 3 & 5.2 they failed, can you pls rebase and resend
> >> > >
> >> >
> >> > Actually those two (at least 5/5) can't be applied on top of slave-dma.
> >> > The patches requires slave-dma and linux-pm together. I heard it's
> >> > usually achieved by creating a specific branch in one subsystem
> >> > (linux-pm in our case) for another.
> >> >
> >> > Rafael, what could we do here?
> >>
> >> I suppose Vinod can pull from my acpi-lpss (which is guaranteed not to be
> >> rebased at this point) and apply the series on top of that.
> > Or I can wait for rc1 and apply afterwards...?
> 
> Mika and I have no objections to go this way.

That'd be fine by me too.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
