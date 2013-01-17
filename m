Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab3AQMtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:49:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45976 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab3AQMs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:48:59 -0500
Date: Thu, 17 Jan 2013 14:48:32 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 15/22] mfd: omap-usb-host: Manage HSIC clocks for HSIC
 mode
Message-ID: <20130117124832.GQ18978@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
 <1358422231-24736-16-git-send-email-rogerq@ti.com>
 <20130117114522.GF18978@arwen.pp.htv.fi>
 <50F7EA2A.2080705@ti.com>
 <20130117122757.GO18978@arwen.pp.htv.fi>
 <50F7F25C.3060909@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XG0jWBK27HhJN4nS"
Content-Disposition: inline
In-Reply-To: <50F7F25C.3060909@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XG0jWBK27HhJN4nS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 02:45:16PM +0200, Roger Quadros wrote:
> On 01/17/2013 02:27 PM, Felipe Balbi wrote:
> > On Thu, Jan 17, 2013 at 02:10:18PM +0200, Roger Quadros wrote:
> >> On 01/17/2013 01:45 PM, Felipe Balbi wrote:
> >>> Hi,
> >>>
> >>> On Thu, Jan 17, 2013 at 01:30:24PM +0200, Roger Quadros wrote:
> >>>> @@ -598,6 +639,24 @@ static int usbhs_omap_probe(struct platform_dev=
ice *pdev)
> >>>>  				clkname, PTR_ERR(pclk));
> >>>>  		else
> >>>>  			omap->utmi_clk[i] =3D pclk;
> >>>> +
> >>>> +		snprintf(clkname, sizeof(clkname),
> >>>> +				"usb_host_hs_hsic480m_p%d_clk", i + 1);
> >>>
> >>> do we really need to know the exact clock node name ?
> >>>
> >> I think so. Do you have a better suggestion?
> >=20
> > update CLKDEV entries ? I mean, what if we have a new OMAP or AMxxxx
> > device with a different clock name ? That will be a big bummer.
> >=20
>=20
> In that case we simply need to add the relevant CLKDEV entries/aliases
> for the new platform. I don't think anything needs to be changed in the
> driver. We are still using clk_get(dev, clk_name), so the CLKDEV
> framework will return the best matching clock for the device.

fair enough ;-)

--=20
balbi

--XG0jWBK27HhJN4nS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9/MgAAoJEIaOsuA1yqREmD8P/j8pbZMy2QYYe5dk754MRwfU
sfOg3WGKM2nDwr/U06D4Dvz5rBv1r1dAE/2k/DivXCudCnh+77p+/4/QYnlMggzM
6CU1MSoVc+Km3P10KnkqnaudLrJ29WVptvGBVCQQyB5oToZmM1zVn9/C808aiQGr
2L3eIZhw6XoHL2Vc9enAtHPKD5YM+hSsjVoBWJR2ejB73lsNwXA4k3KnFecmc4Nt
AMH+RD6zKbm6EBBQud9U2CfqhJMiTdZEF7mH0zOp2r5dzvlVOiR1HUlhn9YZqegN
/fB4Bt3CkoW6oMJ9LB5xgKgFRioJ3hTYJyWnSiOi54DLUyReyrthz8HrDkZPgk71
GCgkCgPtYfM1dIH5l88/jJDSkg+TIoZKjUyBHUnDFVdTjKqxXAmhZ8qE2RoPAvTd
ebRNT71rllQ5E8j9eEXZjWYaqX3bSCmlgfVkvj2K/pfb8wzmJfvtpk6f7FRzorfd
8JNnZkZkfs7RO03f+0O3EV+p3I0z3eJwFRBkHdVA3j/kZ+JuiZBNLNOLV78xo34P
mBEVynOP7Hsu3xls8Z1HEo6oEbEg1GHwr+HoJzSiAuPivgI9veX131iBhvlrMEhx
B860GiNIQ34Cgm1xuuFr8+eCoE9L6SUVQkpEVyLL3IRijxUgi8xG1D1Nr8CU1iT/
Jo+pVyYe/3nIvRcX3K83
=Fwpr
-----END PGP SIGNATURE-----

--XG0jWBK27HhJN4nS--
