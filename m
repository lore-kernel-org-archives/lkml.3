Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaG2Qkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:40:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46927 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaG2Qki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:40:38 -0400
Date: Tue, 29 Jul 2014 11:39:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tony Lindgren <tony@atomide.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <marek.belisko@gmail.com>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <hns@goldelico.com>
Subject: Re: [PATCH v3 0/2] usb: fix controller-PHY binding for OMAP3 platform
Message-ID: <20140729163935.GH17808@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387209225-11520-1-git-send-email-kishon@ti.com>
 <20140721151557.GH6852@saruman.home>
 <53CF7978.4090709@ti.com>
 <14357891.vooz1N5zDC@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RwGu8mu1E+uYXPWP"
Content-Disposition: inline
In-Reply-To: <14357891.vooz1N5zDC@avalon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RwGu8mu1E+uYXPWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 29, 2014 at 02:38:24PM +0200, Laurent Pinchart wrote:
> On Wednesday 23 July 2014 14:29:36 Kishon Vijay Abraham I wrote:
> > On Monday 21 July 2014 08:45 PM, Felipe Balbi wrote:
> > > On Mon, Jul 21, 2014 at 05:04:57PM +0200, Laurent Pinchart wrote:
> > >> Hi Felipe,
> > >>=20
> > >> What happened to these two patches ?
> > >=20
> > > looks like I lost them.
> > >=20
> > >> On Monday 16 December 2013 17:48:29 Felipe Balbi wrote:
> > >>> On Mon, Dec 16, 2013 at 02:38:27PM -0800, Tony Lindgren wrote:
> > >>>> * Felipe Balbi <balbi@ti.com> [131216 13:31]:
> > >>>>> On Mon, Dec 16, 2013 at 09:23:43PM +0530, Kishon Vijay Abraham I=
=20
> wrote:
> > >>>>>> After the platform devices are created using PLATFORM_DEVID_AUTO=
, the
> > >>>>>> device names given in usb_bind_phy (in board file) does not match
> > >>>>>> with the actual device name causing the USB PHY library not to r=
eturn
> > >>>>>> the PHY reference when the MUSB controller request for the PHY i=
n the
> > >>>>>> non-dt boot case.
> > >>>>>> So removed creating platform devices using PLATFORM_DEVID_AUTO in
> > >>>>>> omap2430.c.
> > >>>>>>=20
> > >>>>>> Did enumeration testing in omap3 beagle.
> > >>>>>>=20
> > >>>>>> Changes from v2:
> > >>>>>> * Fixed the commit log
> > >>>>>>=20
> > >>>>>> Changes from v1:
> > >>>>>> * refreshed to the latested mainline kernel
> > >>>>>> * added musb_put_id from omap2430 remove.
> > >>>>>=20
> > >>>>> Tony, how do you want to handle this ? You want me to provide you=
 a
> > >>>>> branch which we both merge ?
> > >>>>=20
> > >>>> Yes that would be great thanks. For the mach-omap2 touching parts:
> > >>>>=20
> > >>>> Acked-by: Tony Lindgren <tony@atomide.com>
> > >>>=20
> > >>> Here it is, let me know if you prefer a signed tag:
> > >>>=20
> > >>> The following changes since commit=20
> 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:
> > >>>   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
> > >>>=20
> > >>> are available in the git repository at:
> > >>>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
> > >>>=20
> > >>> usb-phy-binding-omap3
> > >>>=20
> > >>> for you to fetch changes up to 23ada3130cf4e56acb86fdff4c26113188d5=
2d18:
> > >>>   arm: omap: remove *.auto* from device names given in usb_bind_phy
> > >>>=20
> > >>> (2013-12-16 17:44:43 -0600)
> > >>>=20
> > >>> ----------------------------------------------------------------
> > >>>=20
> > >>> Kishon Vijay Abraham I (2):
> > >>>       usb: musb: omap: remove using PLATFORM_DEVID_AUTO in omap2430=
=2Ec
> > >>>       arm: omap: remove *.auto* from device names given in usb_bind=
_phy
> > >=20
> > > Kishon, are these still valid ?
> >=20
> > Looks like board-2430sdp.c got removed. Apart from that the reset of the
> > patch series is still applicable for non-dt boot.
>=20
> Felipe, do you plan to apply the patch without the baord-2430sdp.c change=
, or=20
> would you like Kishon to rebase and resubmit it ?

Not sure if Tony still wants board-* modifications. Tony ?

--=20
balbi

--RwGu8mu1E+uYXPWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT185HAAoJEIaOsuA1yqREPqwP/3nMP0/R4gCQwbAoWuKtLAMN
Nr7eG2TX1hqSY81DJ0ncsyc1x3DaUju+Vh2as3Th1hR+8I8d9k2RIfYPb+spW2NB
Aolvy1wGBZIKdyGLgG2lZHyH9/Nh7SaA/zk7AqirgQRkJ5oDpx+aqhy3Mvp/FMZL
ppLmTBQRSlErECeyiHQ0PNambRc/8QPfpz5CItYX7OKL7qNvklhLvLKeDByyI7wC
wB8OgAspObrAKdFUsuocVWYWu1bvO34iwcKROERB1RVnuY6WqMybE67M7eAl8w70
YXWERW8HBUo11XICrXNcO9ajBGgioR0QH0qUUgOWuMpklMLGZMyN9Qaa3flXYssj
MpGoPoRjGYhci8cewtNMEl9IIH2YwvljNKYHvLyoARxJpxEbCWMlSgPi8f/tcV2k
VDTVSrxMMuXoOoO6aJQ8B14k2jO1IQpx+xrfOb7K9c/OU7iSWaNL28BuYk+iPjpL
MHlbd5Zw2cAM6ncJOEDbls4a7yp2ZYEUsrlFE0kNcyyjF7EaZ9cznVUvuvbIQjjG
5FXLcPRql+okkQo7x8Gl9PPZXwW1Hj6CTKlPtmlKSb7fc2crf5pEc1eWNiG9n3bG
wMgFQVPLRiGsF7RPVmmojEufPxs0gFPCs5ts+4zViZUoGJxn8NF44ZUuTXlw2srW
rCPIRy6YasBC3KjSMu3m
=jCEn
-----END PGP SIGNATURE-----

--RwGu8mu1E+uYXPWP--
