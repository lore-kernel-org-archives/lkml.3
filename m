Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3GEKT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:19:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44901 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab3GEKTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:19:54 -0400
Date: Fri, 5 Jul 2013 11:19:46 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Rutland <Mark.Rutland@arm.com>, nicolas.pitre@linaro.org
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130705101946.GA5584@e102568-lin.cambridge.arm.com>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
 <20130628171532.GD30603@e102568-lin.cambridge.arm.com>
 <20130628200333.GA2756@lukather>
 <CAOesGMgsD+tK4+ywvLzsWd+mngrP7zGgSFn0naWjSsQLGaUn2Q@mail.gmail.com>
 <20130629193819.GD3353@n2100.arm.linux.org.uk>
 <20130630094846.GA27559@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
In-Reply-To: <20130630094846.GA27559@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 05 Jul 2013 10:19:49.0993 (UTC) FILETIME=[2E8E5590:01CE7969]
X-MC-Unique: 113070511195201801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 30, 2013 at 10:48:46AM +0100, Lorenzo Pieralisi wrote:
> On Sat, Jun 29, 2013 at 08:38:19PM +0100, Russell King - ARM Linux wrote:
> > On Fri, Jun 28, 2013 at 01:05:42PM -0700, Olof Johansson wrote:
> > > On Fri, Jun 28, 2013 at 1:03 PM, Maxime Ripard
> > > <maxime.ripard@free-electrons.com> wrote:
> > > > On Fri, Jun 28, 2013 at 06:15:32PM +0100, Lorenzo Pieralisi wrote:
> > > >> The patch above should already be queued in next/dt right ?
> > > >
> > > > Indeed.
> > > >
> > > > Then why the latest patch of your patchset got in 3.10, while the
> > > > patches actually fixing the DT it would have impacted were delayed to
> > > > 3.11?
> > > >
> > > > (And why was it merged so late in the development cycle?)
> > > 
> > > This. So now we have to scramble because some device trees will
> > > produce warnings at boot.
> > > 
> > > Russell, the alternative is to revert Lorenzo's patch for 3.10 (and
> > > re-introduce it for 3.11). Do you have a preference?
> > 
> > Sorry but I really don't understand what all the fuss in this thread
> > is about.
> > 
> > This thread seems to be saying that two development patches were
> > merged, which were 7762/1 and 7763/1, and that 7764/1 is a fix?
> > Are you sure about that, because that's not how they're described,
> > and not how they look either.
> 
> As Olof's warning downgrade is being merged (thanks for that and apologies for
> failing to explain patches dependencies properly and stable related issues),
> 7764/1 won't apply cleanly anymore. Can you please drop it from the patch
> system, I will update it and test it first thing tomorrow and send a
> final version to the patch system.

Patch 7779/1, replacing 7764/1 is in the patch system now, and is ready
to get merged.

Unfortunately cpu/cpus bindings documentation updates, following:

https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-June/036735.html
https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-May/033779.html

were not pulled in the kernel. This is an issue since this means that
we still have no reference in the kernel or wherever it has to be, to
the final cpus/cpu bindings for ARM and ARM64 provided in the pull
request link above (that has been reviewed to death and acknowledged).

It is a significant overhaul of cpu/cpus bindings standard for ARM/ARM64,
covering all CPUs harking back to arm926 and beyond, and should be final.

dts updates following that standard have already been pulled into 3.11
through arm-soc.

IMHO the bindings contained in pull request above must be merged in the
kernel asap, I would like to ask you please what should I do to get them in
please. If we want to move bindings documentation elsewhere let's do it,
as long as there is a published standard I am happy and will stop annoying
you with this stuff.

Thank you very much,
Lorenzo

