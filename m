Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab3LFVJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:09:42 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50830 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab3LFVJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:09:40 -0500
Date: Fri, 6 Dec 2013 15:08:35 -0600
From: Felipe Balbi <balbi@ti.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] arm: omap: remove *.auto* from device names given
 in usb_bind_phy
Message-ID: <20131206210835.GM21086@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386331571-30903-1-git-send-email-kishon@ti.com>
 <1386331571-30903-3-git-send-email-kishon@ti.com>
 <CABxcv=n67gNq6ayx+t_mfZ0++UBKkXpH9avXvRKFEH4VUrwy0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fDP66DSfTvWAYVew"
Content-Disposition: inline
In-Reply-To: <CABxcv=n67gNq6ayx+t_mfZ0++UBKkXpH9avXvRKFEH4VUrwy0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fDP66DSfTvWAYVew
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 06, 2013 at 01:14:38PM +0100, Javier Martinez Canillas wrote:
> On Fri, Dec 6, 2013 at 1:06 PM, Kishon Vijay Abraham I <kishon@ti.com> wr=
ote:
> > Previously MUSB wrapper (OMAP) device used PLATFORM_DEVID_AUTO while cr=
eating
> > MUSB core device. So in usb_bind_phy (binds the controller with the PHY=
), the
> > device name of the controller had *.auto* in it. Since with using
> > PLATFORM_DEVID_AUTO, there is no way to know the exact device name in a=
dvance,
> > the data given in usb_bind_phy became obsolete and usb_get_phy was fail=
ing.
> > So MUSB wrapper was modified not to use PLATFORM_DEVID_AUTO. Correspond=
ing
> > change is done in board file here.
> >
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > ---
> >  arch/arm/mach-omap2/board-2430sdp.c        |    2 +-
> >  arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
> >  arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
> >  arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
> >  arch/arm/mach-omap2/board-ldp.c            |    2 +-
> >  arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
> >  arch/arm/mach-omap2/board-omap3logic.c     |    2 +-
> >  arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
> >  arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
> >  arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
> >  arch/arm/mach-omap2/board-overo.c          |    2 +-
> >  arch/arm/mach-omap2/board-rx51.c           |    2 +-
> >  12 files changed, 12 insertions(+), 12 deletions(-)
> >
>=20
> You can drop this patch since boards files are being removed for v3.14

if we can drop this patch, the whole series is invalid, since we'll be
using DT phandles to find PHYs going forward, no ?

--=20
balbi

--fDP66DSfTvWAYVew
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSojzTAAoJEIaOsuA1yqRE8T4P/jwAf8Yb/jDL7Gu68Agv5e0m
m2jINigFPqU3yhRFH5G6LG31N9d8VqjkLBILwxronUE9FI6Bq/QXzpYMgLvtFLQ+
G9+DurB4aNRBa4zfkN96zDwlUInyb9TaTpOp9Qf7bPxXWuBpmZnoG/46C5Rq+Mac
oPQApXbgiB279VwlWog/pzX2sqs2FfT6mrT9Jtreto5kI2MF7Ki4dmkdqFaSss5e
DgOn4eWQspjjEEg2useOxqdEWPWPSchyRo9cGypQbLLqKjoGD8IYCr6fsW2fCXjo
IBhJV2OyDzwQckLfm7Bg0nvvXtVRTkV4DSjXBNoyt4M1YysYan98LwkjjAnODRBx
belP32PVXD+pAEEMuGc1CfQYMwO9XAX/WpiXasvi5rStD/b+j/CBxLtyrXk84SbZ
uMWqr5LA1/TSz+5M2ust82bfjdWJo6NfaCCC9D/KUGJPqy3LqRbIBsW84pllJBbG
+247WszTbNfwjHrBSI8swhpMSTC47pTHO4OOvGIscLmNfRY9/aJ5hYlgCVA7rfDo
npe+KcRvJGpsjEjm2fGgXjYxtrqc+r6m9iwL91LhEh55KVIgRAemE8kHlboDSRHD
jnG7QaD7Q808kHPuhPF/ri2eDO6h/vR2Vrp4Vb2N4ZP4L7pNP7yRvdczeYcxbcQ0
+f2gmtglpZeVgSzP0xqj
=f4a+
-----END PGP SIGNATURE-----

--fDP66DSfTvWAYVew--
