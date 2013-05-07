Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab3EGH66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:58:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39452 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3EGH64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:58:56 -0400
Date: Tue, 7 May 2013 08:58:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, balbi@ti.com,
        ldewangan@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        gg@slimlogic.co.uk, ruchika@ti.com, tony@atomide.com,
        sameo@linux.intel.com
Message-ID: <20130507075824.GM7478@sirena.org.uk>
References: <1362662506-14823-4-git-send-email-kishon@ti.com>
 <1367846225-15685-1-git-send-email-kishon@ti.com>
 <20130506144010.GF13472@opensource.wolfsonmicro.com>
 <51888D55.3090907@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bPrm2PuLP7ysUh6c"
Content-Disposition: inline
In-Reply-To: <51888D55.3090907@ti.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] extcon: Palmas Extcon Driver
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bPrm2PuLP7ysUh6c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 07, 2013 at 10:42:53AM +0530, Kishon Vijay Abraham I wrote:
> On Monday 06 May 2013 08:10 PM, Mark Brown wrote:
> >On Mon, May 06, 2013 at 06:47:04PM +0530, Kishon Vijay Abraham I wrote:
> >
> >>+		if (palmas_usb->linkstat != PALMAS_USB_STATE_VBUS) {
> >>+			if (palmas_usb->vbus_reg) {
> >>+				ret = regulator_enable(palmas_usb->vbus_reg);
> >>+				if (ret) {
> >>+					dev_dbg(palmas_usb->dev,
> >>+						"regulator enable failed\n");
> >>+					goto ret0;

> >This is very bad karma, why is the regulator optional?

> The platform can provide it's own vbus control in which case this is
> not needed.

So why is there no interaction with this external VBUS control and how
does the driver distinguish between that and an error getting the
regulator?

--bPrm2PuLP7ysUh6c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRiLQdAAoJELSic+t+oim9IcgP/REeNr48hy+v4SL4nbnVylm0
nnDouNmr9htqqqXgGxJsphHt6IhcS78yjFESwvcxe9m4YsYDZHjXNuW5oXVgPxwV
XdD3ExXDqkljbY0UtB7VQ7HGQPIqP38CEmPStwWKFKeOmlb0hvTFpKoMgUnYSeCV
1i5YadxZg4jtgczvL63feCE2yqX/+etQcesk8+rmFj+oJ/niegGLCXdcO+Y8wrl3
fJlbOBpud4/+NmnC3Q5wYLOyiQ9Idq+Bv/gcBF84kCijhprUOiqjabB9jkwyM37d
M3a6KbTJuY/LBCrhUcdADsD3dEvOXTOgQFV7/jOvAcJHqqqEuxANuO50yDmktxk1
u0KRxZVBdkXRaD7rrSJLVCY7tXnt4FBOSp3xknq6ZDwdDfxEQGvn2KSObmZxan5z
ugNErUiS/QVkspxG4OEuXc58CAP+XnIEkRNUPYs0DoGi4M6IKZKAzkxxuZ5HKg91
zS1aUNTGK4CNtD1cQ30Tn9TYMRmIcr6QTk+iIsVWJue3CdM2stW2LNr1yKrtpt7D
c7Uw4QmpEYW6ZRiHHv+4P+L2+x9FfEY2sx90TGyHNcPWL7vOQyQMpRwhN3wbCW+q
Tnrqd+UzqGCXHX2nYoRFSbcc9kXA2nelEWWQICCzpBLW6lvWm/7B3kBPa7lvXUKo
WPWjs52yEfwG+WK+P6j5
=lQrk
-----END PGP SIGNATURE-----

--bPrm2PuLP7ysUh6c--
