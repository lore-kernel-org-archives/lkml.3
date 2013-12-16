Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab3LPXtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:49:42 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58294 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab3LPXtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:49:40 -0500
Date: Mon, 16 Dec 2013 17:48:29 -0600
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>, <marek.belisko@gmail.com>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <hns@goldelico.com>
Subject: Re: [PATCH v3 0/2] usb: fix controller-PHY binding for OMAP3 platform
Message-ID: <20131216234829.GC29284@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387209225-11520-1-git-send-email-kishon@ti.com>
 <20131216212918.GH12896@saruman.home>
 <20131216223826.GG26293@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
Content-Disposition: inline
In-Reply-To: <20131216223826.GG26293@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 16, 2013 at 02:38:27PM -0800, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [131216 13:31]:
> > Hi,
> >=20
> > On Mon, Dec 16, 2013 at 09:23:43PM +0530, Kishon Vijay Abraham I wrote:
> > > After the platform devices are created using PLATFORM_DEVID_AUTO, the
> > > device names given in usb_bind_phy (in board file) does not match with
> > > the actual device name causing the USB PHY library not to return the
> > > PHY reference when the MUSB controller request for the PHY in the non=
-dt boot
> > > case.
> > > So removed creating platform devices using PLATFORM_DEVID_AUTO in oma=
p2430.c.
> > >=20
> > > Did enumeration testing in omap3 beagle.
> > >=20
> > > Changes from v2:
> > > * Fixed the commit log
> > >=20
> > > Changes from v1:
> > > * refreshed to the latested mainline kernel
> > > * added musb_put_id from omap2430 remove.
> >=20
> > Tony, how do you want to handle this ? You want me to provide you a
> > branch which we both merge ?
>=20
> Yes that would be great thanks. For the mach-omap2 touching parts:
>=20
> Acked-by: Tony Lindgren <tony@atomide.com>

Here it is, let me know if you prefer a signed tag:

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git usb-phy-bindi=
ng-omap3

for you to fetch changes up to 23ada3130cf4e56acb86fdff4c26113188d52d18:

  arm: omap: remove *.auto* from device names given in usb_bind_phy (2013-1=
2-16 17:44:43 -0600)

----------------------------------------------------------------
Kishon Vijay Abraham I (2):
      usb: musb: omap: remove using PLATFORM_DEVID_AUTO in omap2430.c
      arm: omap: remove *.auto* from device names given in usb_bind_phy

 arch/arm/mach-omap2/board-2430sdp.c        |  2 +-
 arch/arm/mach-omap2/board-3430sdp.c        |  2 +-
 arch/arm/mach-omap2/board-cm-t35.c         |  2 +-
 arch/arm/mach-omap2/board-devkit8000.c     |  2 +-
 arch/arm/mach-omap2/board-ldp.c            |  2 +-
 arch/arm/mach-omap2/board-omap3beagle.c    |  2 +-
 arch/arm/mach-omap2/board-omap3logic.c     |  2 +-
 arch/arm/mach-omap2/board-omap3pandora.c   |  2 +-
 arch/arm/mach-omap2/board-omap3stalker.c   |  2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c |  2 +-
 arch/arm/mach-omap2/board-overo.c          |  2 +-
 arch/arm/mach-omap2/board-rx51.c           |  2 +-
 drivers/usb/musb/musb_core.c               | 31 ++++++++++++++++++++++++++=
+++-
 drivers/usb/musb/musb_core.h               |  2 ++
 drivers/usb/musb/omap2430.c                | 19 ++++++++++++++++--
 15 files changed, 61 insertions(+), 15 deletions(-)

--=20
balbi

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSr5FNAAoJEIaOsuA1yqREpuUP/2VjTDVk9MWK90IebR9g446H
XDjD9rMFSEt8718NVHistir6PZpXtjsHvm+/BR7tgnwfs91RKLx4F6Hj94LDjUUC
ZDISNG0tm3R3JUohp9wZQ0ZeHST8WVYj69GhzamEyKYZYbKGgNTZvM9/4jtOi9Rn
1fBt/JZVoTsuruB4g6pIpnp/Yi5Qi0IM4GeGXGNMLGK5NUVAiNBO2LskcMiD235D
bRDWe8OntXxQmTCnDA0N4NaFXQ+vArKxJ/mcMPkfOfXci/wfpMpBtzaLVKlBTMO4
D/vS72qEtcNkMkbsoMs4jrLZftujYH1pdkEt4LdJLkGtH5qQmF/KggooS772U/3r
Jt5IkLoNM19FokS7oruIra2t2s6oyfzd1kUMip0yDVjiG9bo65arAVIai+1s2nbv
PRIooTvBxttkxGRVm71fYNKO4yPp3Unwe22VUTPBux0XcpT3Hjpc0TS5HO4E5apt
OIYki7D8I2Z2qbRiL2ED24MyhKDLEYGcxtgRdW+L3ODFVXv1kt8cm1Sh7prvjzZ7
BB5tjxcmuxT/LKhd8ECLtR6A8/ioyZ5oZRqdfoj02Hv8JcU4WL/c5O52kqBACHfH
lgHR+V5ISAZNB53MNdARjXoNBnBufSasORCuM4yXw4uZ0W707bbmL0JeHlkUYIi8
42ajmtuOXz8SHITYpVp0
=iOwf
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--
