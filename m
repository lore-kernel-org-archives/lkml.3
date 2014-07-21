Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaGUPRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:17:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58431 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbaGUPRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:17:06 -0400
Date: Mon, 21 Jul 2014 10:15:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <linux-kernel@vger.kernel.org>,
        <marek.belisko@gmail.com>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <hns@goldelico.com>
Subject: Re: [PATCH v3 0/2] usb: fix controller-PHY binding for OMAP3 platform
Message-ID: <20140721151557.GH6852@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387209225-11520-1-git-send-email-kishon@ti.com>
 <20131216223826.GG26293@atomide.com>
 <20131216234829.GC29284@saruman.home>
 <2288457.9ZfWAQMUao@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gTtJ75FAzB1T2CN6"
Content-Disposition: inline
In-Reply-To: <2288457.9ZfWAQMUao@avalon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gTtJ75FAzB1T2CN6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 21, 2014 at 05:04:57PM +0200, Laurent Pinchart wrote:
> Hi Felipe,
>=20
> What happened to these two patches ?

looks like I lost them.

> On Monday 16 December 2013 17:48:29 Felipe Balbi wrote:
> > On Mon, Dec 16, 2013 at 02:38:27PM -0800, Tony Lindgren wrote:
> > > * Felipe Balbi <balbi@ti.com> [131216 13:31]:
> > > > On Mon, Dec 16, 2013 at 09:23:43PM +0530, Kishon Vijay Abraham I wr=
ote:
> > > > > After the platform devices are created using PLATFORM_DEVID_AUTO,=
 the
> > > > > device names given in usb_bind_phy (in board file) does not match=
 with
> > > > > the actual device name causing the USB PHY library not to return =
the
> > > > > PHY reference when the MUSB controller request for the PHY in the
> > > > > non-dt boot case.
> > > > > So removed creating platform devices using PLATFORM_DEVID_AUTO in
> > > > > omap2430.c.
> > > > >=20
> > > > > Did enumeration testing in omap3 beagle.
> > > > >=20
> > > > > Changes from v2:
> > > > > * Fixed the commit log
> > > > >=20
> > > > > Changes from v1:
> > > > > * refreshed to the latested mainline kernel
> > > > > * added musb_put_id from omap2430 remove.
> > > >=20
> > > > Tony, how do you want to handle this ? You want me to provide you a
> > > > branch which we both merge ?
> > >=20
> > > Yes that would be great thanks. For the mach-omap2 touching parts:
> > >=20
> > > Acked-by: Tony Lindgren <tony@atomide.com>
> >=20
> > Here it is, let me know if you prefer a signed tag:
> >=20
> > The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e=
42ae:
> >=20
> >   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
> > usb-phy-binding-omap3
> >=20
> > for you to fetch changes up to 23ada3130cf4e56acb86fdff4c26113188d52d18:
> >=20
> >   arm: omap: remove *.auto* from device names given in usb_bind_phy
> > (2013-12-16 17:44:43 -0600)
> >=20
> > ----------------------------------------------------------------
> > Kishon Vijay Abraham I (2):
> >       usb: musb: omap: remove using PLATFORM_DEVID_AUTO in omap2430.c
> >       arm: omap: remove *.auto* from device names given in usb_bind_phy

Kishon, are these still valid ?

--=20
balbi

--gTtJ75FAzB1T2CN6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTzS6tAAoJEIaOsuA1yqRELdMQAJQ0rLgSyeNEaxL0+pJF897C
eF0hZZ/GEG84CD4PdudSftepAXT3+DeJCAl13utLsl8IQmBHVqz+mAQb5NlWYFPS
yE7FEF6NnsUxt4nvGcd5eiJzysYN94C9YOLhhrmL3Y35B5E+CSZY90WdGpq/TKTE
iDYAXa904nX0XwH2YAkTPbTllQKfJ51Cf5dhuHBcLA1zi42JDTa3uiG+lS3RnX1S
3mwt/85ZqNWY1jzLa3eIOByT7v2/PTnW2muIxNncS1cdlTxGpcBY2lqMukxkzF2K
LkKZ+a//XGgwbgSEJ5KFTs6Uk1MGhFZTd3/SVTRV3yHUV9rjkE176dE8b7IEaHsW
ZT0POir7QPHodZ3/yC0BgL+k/ae1auA6iZzU43PmfGjlCfHAfvwRLmnB+5vmAKFT
FW4wljqQtlfYjUDRSl99rdR53dhI65ABFUVBSkO2UgF1Jm41XsG1Gi2N4bGWFGgO
y6OGQUqR6eFgoyuHmV/NuQ1vsgzSE6WuAGq9CE6EvwacV3+mIbjVCCCMQmK/D2i+
bQwUlt1rHTvBaIAYNeJLcfzoe4AMX60FAVJGnyuRlkhUxpubaGi/4K5WsxC9gX7H
0l/KAxzdVEUgMgtMIvkK4gyrURPgbSppTXQlf+qkt6ghB/96PeiNkKDwLrP1Co+w
9/aQsuU/6KX5q2cS9/B0
=3vLy
-----END PGP SIGNATURE-----

--gTtJ75FAzB1T2CN6--
