Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3AUTAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 14:00:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55112 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab3AUTA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 14:00:28 -0500
Date: Mon, 21 Jan 2013 21:00:14 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 12/15] USB: gadget/freescale: disable non-multiplatform
 drivers
Message-ID: <20130121190014.GA11827@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <1358788568-11137-13-git-send-email-arnd@arndb.de>
 <20130121184138.GB10106@arwen.pp.htv.fi>
 <20130121185716.GA26754@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20130121185716.GA26754@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 10:57:16AM -0800, Greg Kroah-Hartman wrote:
> On Mon, Jan 21, 2013 at 08:41:38PM +0200, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Jan 21, 2013 at 05:16:05PM +0000, Arnd Bergmann wrote:
> > > Both the fsl_mxc gadget and the imx_udc gadget drivers fail to build
> > > without the mach/hardware.h file that is not available when building
> > > for multiplatform. Let's disable these drivers for v3.8 in combination
> > > with CONFIG_ARCH_MULTIPLATFORM, and fix them properly in v3.9 unless
> > > someone has an better solution.
> > >=20
> > > Without this patch, building allyesconfig results in:
> > >=20
> > > drivers/usb/gadget/fsl_mxc_udc.c:21:27: fatal error: mach/hardware.h:=
 No such file or directory
> > >=20
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Felipe Balbi <balbi@ti.com>
> > > Cc: Shawn Guo <shawn.guo@linaro.org>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: linux-usb@vger.kernel.org
> >=20
> > NAK, I prefer to see a real fix for the problem (which in fact is
> > already in my fixes branch).
>=20
> I'll pull that branch now, sorry for the delay.

no problem ;-)

--=20
balbi

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/ZA9AAoJEIaOsuA1yqRE8KgP/iGgsJ+iFWr2GKXvZVgNQMP2
3O8SHpQs/2niXM+udVITymVLbqGpWc2x9fvh1cOqhZWVCF/X3dSokSNAHgV4MfbQ
7z9gjGOAmXA0LLNVypUaCfZBNE6JLu0tUpXdtBgoEj8nin8fwYslFRSraymL8TxW
ArfJimECtTe+zI+hpnjyUc+KlxY/f3HwzsjWFvi8rD88Ds8SFq6zv0hIHPLFbQRV
crxaZVCX/IQvjlu/LHb/A46vxNtNUY13Hu0FSXEUX+9/HMQSF0WZtynerCmIxPiU
xGgK5rGSwnZb85hjt6pGPYT/K4QrSmNoHUpidp2iBG93cLNp3WHLI9yOWYbDaigM
EQquDi0ckUY5QvXufcTM23vKSkuWAanQFG589HgFWSbcmj/s4f+4E/fjIE4Fu+dd
dVdVsT4ECf4vFIAgvb+tqMujuqOR/bglNvSDtOra3N4OYX4M4FQF13juT57hQliK
PlBO68BNIe0j/I/dHn5UYnfzuNY81PfksiXIVDlOi2AF84l96xaWO/zC01dZaDQO
SKmnbVrDnhnBewOpiXO6qqiRw9c2OnSJAnfkgfQzYuuPGX40xL4fcp3ViKbAM2Pn
MqBCB8MZehwX8fhXLYl/nie4MA8u45cgkcX/s/2KDZSWj2k4NctYU56mPkEm360x
NsaRa1a65yvZLJraJIuu
=ZhvT
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
