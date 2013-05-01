Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510Ab3EAPrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:47:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60816 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3EAPrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:47:31 -0400
Date: Wed, 1 May 2013 16:47:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Mehar Bajwa <mehar.bajwa@ti.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        liam.r.girdwood@intel.com, navada@ti.com
Message-ID: <20130501154715.GQ26160@sirena.org.uk>
References: <1366119860-9754-1-git-send-email-mehar.bajwa@ti.com>
 <1366119899-9789-1-git-send-email-mehar.bajwa@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WZLuFERxa6Y0cbOt"
Content-Disposition: inline
In-Reply-To: <1366119899-9789-1-git-send-email-mehar.bajwa@ti.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.78
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 3/4] mfd: I2C interface with AIC platform
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WZLuFERxa6Y0cbOt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2013 at 07:14:59PM +0530, Mehar Bajwa wrote:

>  config MFD_AIC_IRQ
>  	bool "Support of IRQ for AIC"
>  	depends on MFD_AIC
> +	default y
>  	help

Squash into the previous commit (but doesn't look like it should be
separate at all).

--WZLuFERxa6Y0cbOt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgTkAAAoJELSic+t+oim9YpcQAJbQ6yC89RKQGL108P0I7Op7
ihOnFACOrbj1cupRI+Cs3d1o7ho2QURyzlWiJ8k1HQM4P73lcGtqWMuNQQcE604F
rHaZPs3G1E3BBdsSqvUJY4AqFo5LaYNBzcvxJ7zTI3/QH7mcOSvZBOj81vT3S2P4
NPw4+Stzl48D/RLckRlPmqgKirFHv8dXlnWqUXwIyq3B6LZdr0pWnSdkcfIxzRbD
IzO9zwj0hgU1H1pS68z6mzgEu7e7Wk7SPr+VHPzuM0/FzYyAnpesjCjQ+dwKFVUb
AkNdtnI6DzCo5ibi5+srcwtQ+Zu1GJnsk3biZDMCoQ1UdNmmfrMpipxa/Nfg0eiI
oi1y0IxWVY4DZoMyk7f2aMGg0RGctmU9vjLy2xkfByjFStDD123bILbY3PY43f2k
EDx/zs7bQneDq80IlfA91XWQmx0nqN79uwk5KRku3U/RIDtJZrdHesVRGBhhtBtX
DBp9ZJrVs++jMeZjwqnhsI2qX5QJ2MN2cN36SGK44xzGKk80Y4vBTFPIDV4I6v5T
VqjpiDHbC2mb1sxeKbPkd6ey+aVJtsRH+4thTHINT8MB2T4mNlw7xgV8NBLwmbgP
oqt0cL4MT/La8CldePQfd6wWzDZTiqT11kQks6uHk3EO3D9jAS5B2lrHHv0qB1b4
bUqTSKHACMiMlLbL9pns
=fIoK
-----END PGP SIGNATURE-----

--WZLuFERxa6Y0cbOt--
