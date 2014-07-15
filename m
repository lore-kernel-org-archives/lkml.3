Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbaGOUVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:21:24 -0400
Received: from [74.50.51.50] ([74.50.51.50]:59899 "EHLO utopia.booyaka.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758132AbaGOUVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:21:22 -0400
Date: Tue, 15 Jul 2014 20:21:21 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mugunthan V N <mugunthanvnm@ti.com>
cc: devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Re-send PATCH 1/1] arm: dra7xx: Add hwmod data for MDIO and
 CPSW
In-Reply-To: <20140709100147.GB25154@breakpoint.cc>
Message-ID: <alpine.DEB.2.02.1407152019020.21432@utopia.booyaka.com>
References: <1404825399-10330-1-git-send-email-mugunthanvnm@ti.com> <20140709095552.GA25154@breakpoint.cc> <20140709100147.GB25154@breakpoint.cc>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-788041059-1405455633=:21432"
Content-ID: <alpine.DEB.2.02.1407152020410.21432@utopia.booyaka.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-788041059-1405455633=:21432
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.02.1407152020411.21432@utopia.booyaka.com>

Hi Sebastian,

On Wed, 9 Jul 2014, Sebastian Andrzej Siewior wrote:

> On 2014-07-09 11:55:52 [+0200], Sebastian Andrzej Siewior wrote:
> > On 2014-07-08 18:46:39 [+0530], Mugunthan V N wrote:
> > > Adding hwmod data for CPSW and MDIO which is present in DRA7xx SoC
> >=20
> > I reverted my patch, applied this one and after boot I got:
> Oh me dum dum. I had --dry-run=E2=80=A6
>=20
> Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
>=20
> This is basically what Tony hasked me to do: No IRQ numbers & iomem.

Sorry - I'm a bit confused - Sebastian, did you test this one?  If so, is=
=20
it okay to add a Tested-by from you?

Mugunthan, could you please get a Reviewed-by: from one of the folks on=20
the DRA7xx SoC integration reviewers list that I sent earlier?


- Paul
--843723315-788041059-1405455633=:21432--
