Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3F2TjG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 15:39:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35071 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3F2TjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 15:39:03 -0400
Date: Sat, 29 Jun 2013 20:38:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130629193819.GD3353@n2100.arm.linux.org.uk>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com> <20130628171532.GD30603@e102568-lin.cambridge.arm.com> <20130628200333.GA2756@lukather> <CAOesGMgsD+tK4+ywvLzsWd+mngrP7zGgSFn0naWjSsQLGaUn2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgsD+tK4+ywvLzsWd+mngrP7zGgSFn0naWjSsQLGaUn2Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 01:05:42PM -0700, Olof Johansson wrote:
> On Fri, Jun 28, 2013 at 1:03 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Fri, Jun 28, 2013 at 06:15:32PM +0100, Lorenzo Pieralisi wrote:
> >> The patch above should already be queued in next/dt right ?
> >
> > Indeed.
> >
> > Then why the latest patch of your patchset got in 3.10, while the
> > patches actually fixing the DT it would have impacted were delayed to
> > 3.11?
> >
> > (And why was it merged so late in the development cycle?)
> 
> This. So now we have to scramble because some device trees will
> produce warnings at boot.
> 
> Russell, the alternative is to revert Lorenzo's patch for 3.10 (and
> re-introduce it for 3.11). Do you have a preference?

Sorry but I really don't understand what all the fuss in this thread
is about.

This thread seems to be saying that two development patches were
merged, which were 7762/1 and 7763/1, and that 7764/1 is a fix?
Are you sure about that, because that's not how they're described,
and not how they look either.
