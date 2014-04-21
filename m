Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaDURLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:11:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52627 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbaDURLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:11:07 -0400
Date: Mon, 21 Apr 2014 12:08:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tim Bird <tbird20d@gmail.com>
CC: <balbi@ti.com>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        <linux-arm-msm@vger.kernel.org>, Kumar Gala <galak@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Tim Bird <tim.bird@sonymobile.com>
Subject: Re: [PATCH] usb: phy: msm: Select secondary PHY via TCSR
Message-ID: <20140421170833.GG22794@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396649891-2880-1-git-send-email-tim.bird@sonymobile.com>
 <20140421161442.GC22794@saruman.home>
 <CA+bK7J7Psj=7nORhidbV6MrifmCY9ZgE0GjYzAPaaKK7=wHgvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AGZzQgpsuUlWC1xT"
Content-Disposition: inline
In-Reply-To: <CA+bK7J7Psj=7nORhidbV6MrifmCY9ZgE0GjYzAPaaKK7=wHgvg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AGZzQgpsuUlWC1xT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 21, 2014 at 10:03:28AM -0700, Tim Bird wrote:
> On Mon, Apr 21, 2014 at 9:14 AM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Fri, Apr 04, 2014 at 03:18:11PM -0700, Tim Bird wrote:
> >> Select the secondary PHY using the TCSR register, if phy-num=3D1
> >> in the DTS (or phy_number is set in the platform data).  The
> >> SOC has 2 PHYs which can be used with the OTG port, and this
> >> code allows configuring the correct one.
> >>
> >> Note: This resolves the problem I was seeing where I couldn't
> >> get the USB driver working at all on a dragonboard, from cold
> >> boot.  This patch depends on patch 5/14 from Ivan's msm USB
> >> patch set.  It does not use DT for the register address, as
> >> there's no evidence that this address changes between SoC
> >> versions.
> >>
> >> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
> >
> > doesn't apply:
> >
> > checking file drivers/usb/phy/phy-msm-usb.c
> > Hunk #1 succeeded at 1412 with fuzz 2 (offset -106 lines).
> > Hunk #2 FAILED at 1581.
> > 1 out of 2 hunks FAILED
> > checking file include/linux/usb/msm_hsusb_hw.h
>=20
> Sorry about that.
>=20
> Did you apply this on top of Ivan's USB patch set?  That's a pre-requisit=
e.

hehe, probably not :-)

> I've communicated privately with Ivan, and he's preparing an updated
> patch set which incorporates this fix and a few other things. This should
> be showing up soon-ish.

alright, thanks

--=20
balbi

--AGZzQgpsuUlWC1xT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVVCRAAoJEIaOsuA1yqRE4UwQALCPts0f1pc5sxwdsiTXVCXd
vHvtoYvwAH5FWWGXP3g/kLfz01ArQp/Hyc7ToF4jUhGBcjs95trCcaOORX+NYyn7
shXNzO3c5Hooz787/YXuy5rJjyMPuYSSGC2KrwYUZ6C+MGR8SAZMuiZuFz1GAat3
75HoJs3JOEjiQIKu+smokjfngEdjC+3+44kXEQ1tQCbkdDNhq57A6QaamZ82um3q
1UaIBi+6DppEwGcqtMq//PWyI1vOjQvs89nE2iXJ/8IAzBhhGhWkrHClv/Bo2ghQ
WCu81spIQea1GIOy57emUBm8afy17BiyE3MU0o4HqfSr4b8rq26Fr1XpHnQHy+ox
VLHojsQGFCk+d8iNa1znugcZ+L5p6wuMUY8UxvxuQARmr77HObX4f+gQHHA7QcHa
JVcUrOBgqUUg6gh9j4fmfqoyHWrz83zWraQ64e042jApbvgq86+ly6KXtBMoXa8d
4IIfpqfBO9ig7QxZfd0F+HmYXvf4+zf0yKdM1kJA5+cQAOM3f/Q7V/kORHBQvBIp
ZpDQ+1T6YKrHY5Yo7E0Gdcrgk9aPTCUZViz5Ra7cAXJT+pMRiESuIRewtBxxcnCt
30//Cz225yxW70AuIxsqOZD2csXV7SQonqoX7EZahIuPZFb2mijXa1Dlq8YICRSY
H1qKwkovK6iA6Hjbc2uf
=Vd3C
-----END PGP SIGNATURE-----

--AGZzQgpsuUlWC1xT--
