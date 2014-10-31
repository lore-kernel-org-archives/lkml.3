Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbaJaOMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:12:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50800 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbaJaOMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:12:42 -0400
Date: Fri, 31 Oct 2014 09:11:58 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>, Peter Chen <peter.chen@freescale.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <stern@rowland.harvard.edu>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/7] usb: move the OTG state from the USB PHY to the
 OTG structure
Message-ID: <20141031141158.GK1273@saruman>
Reply-To: <balbi@ti.com>
References: <1414514141-31767-2-git-send-email-antoine.tenart@free-electrons.com>
 <20141030163148.GF10130@saruman>
 <20141030163513.GI10130@saruman>
 <20141030174254.GA6764@kwain>
 <20141030174734.GA6652@saruman>
 <20141031003812.GA3692@peterchendt>
 <20141031004710.GA17652@saruman>
 <20141031133319.GC1273@saruman>
 <20141031134751.GE1273@saruman>
 <20141031135535.GB11522@kwain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lildS9pRFgpM/xzO"
Content-Disposition: inline
In-Reply-To: <20141031135535.GB11522@kwain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lildS9pRFgpM/xzO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 31, 2014 at 02:55:35PM +0100, Antoine Tenart wrote:
> > > > > > > > > > Before using the PHY framework instead of the USB
> > > > > > > > > > PHY one, we need to move the OTG state into another
> > > > > > > > > > place, since it won't be available when USB PHY
> > > > > > > > > > isn't used. This patch moves the OTG state into the
> > > > > > > > > > OTG structure, and makes all the needed
> > > > > > > > > > modifications in the drivers using the OTG state.
> > > > > > > > > >=20
> > > > > > > > > > Signed-off-by: Antoine Tenart <antoine.tenart@free-elec=
trons.com>
> > > > > > > > > > Acked-by: Peter Chen <peter.chen@freescale.com>
> > > > > > > > >=20
> > > > > > > > > Acked-by: Felipe Balbi <balbi@ti.com>
> > > > > > > >=20
> > > > > > > > Please rebase on my testing/next and I'll take the
> > > > > > > > series. When rebasing, then add Peter's
> > > > > > > > Tested-by/Acked-by where they're missing.
> > > > > > >=20
> > > > > > > I just re-sent the series, rebased on your testing/next
> > > > > > > branch.
> > > > > >=20
> > > > > > Thanks, I put them on my testing/next and I'm running build
> > > > > > tests.
> > > > > >=20
> > > > >=20
> > > > > I see them, I will rebase your testing/next tree for coming
> > > > > chipidea dev, thanks.
> > > >=20
> > > > I fixed a build breakage caused by $subject which I fixed,
> > > > updated patch below: (Aaro, can I get a tested-by by any chance
> > > > ?)
> > >=20
> > > two more build regressions found (did you build test your patches
> > > ??)
> >=20
> > and yet another one on phy-isp1301-omap.c. Seriously, if I find
> > another build regression I'll drop your series from my queue and
> > defer it to 3.20. This is ridiculous already.
>=20
> Sorry for the inconvenience, the series modify quite a lot of files
> and testing all of them is quite difficult. If you'd like I can fully
> test

how come ? build testing is difficult ? if you have x86 and ARM
compilers you can build all of these modules with make allmodconfig.

You know, I have a very a simple 20-line script running randconfigs and
saving the output, after that I just grep for "error" on the logs and
look at what's broken.

> it and send a new version early next week.
>=20
> Deferring it to 3.20 will not solve the issue and will raise the same
> errors as these build failures. The series has been sent for quite a
> long time now, without having any comments on the latests revisions
> and was therefore delayed. Each time it is delayed, it makes it more
> difficult to ensure everything is working fine because of all the
> modifications done in this subsystem... I tried to keep it up with all
> the other patches introduced between my revisions, but this is not as
> easy as it sounds.

all the places I fixed haven't been touched for months, in some cases
years. This is a broken argument.

> Again, sorry for these failures, I can send to you a new version early
> next week so that no other patches comes in between, breaking the
> build...

nevermind, I already fixed so many of these mistakes anyway, it's
probably all clean now.

--=20
balbi

--lildS9pRFgpM/xzO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUU5iuAAoJEIaOsuA1yqREQXUP/03C4wf/405FZ5laxzo13F+2
SNVDi6DjSYzwmnrKQIKa2izZQlYPEQripgTLeeF723T4sihQKxFJy6bP5z/ozbmI
IBT+sSMkYHTS1I/cLza1kRi5PLC2yCwon1Wxe4+LVPhBHteE2EfKqsUP3+nUQf6J
uhquwuNB5A5MYxeFeUEzEnOg3IK1RMyrPEaflvyTCAjSEXzKGANyn7JHIozGFhuw
kiQeB1aVTsuRZTXWJyPysAhxoHveISVT08U1R3AhSM1rWPanIuqvQ3sTDLRBE8LF
FI0VDXHdqYHI+P3Iaxrhd2w0g0yX+RBrVOUMHA2L5OpDsrQC2n1ytRcuCkxD3fP6
tZ5s9MPDMGyQgVF3QobKuV9C5hTu6mFJJbdZuKwerxiueIE0N0WauXYMIHBmrqPq
yzk6tsq8IDRhvtqQL5ZBOn/PWGeAKETbnRxTagwlJxfFnzuAQ6D4Y3xIIHbNtYVQ
mfdxRJJ3xzts0DVk8V4Fz2JCaQ2C9USMk8QXZtoTJqJtKe19IxiCQM3lepFyz+J5
mbrFStQUnCQKPrJZpRKdFQMT4OkjCHInPXAFiigsd6zg+MEuYuxsxIxlpFc7KWTS
2E//mRuE/eaJV87qf7Axs32ragH2sbYC7olergAXN7HCMouoxvbHkqSho4skIfrc
gZ+0A4xd2UhegaR6r7ol
=8aB0
-----END PGP SIGNATURE-----

--lildS9pRFgpM/xzO--
