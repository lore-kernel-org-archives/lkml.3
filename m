Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381Ab3GRUjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:39:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40855 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196Ab3GRUjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:39:46 -0400
Date: Thu, 18 Jul 2013 21:39:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Trent Piepho <tpiepho@gmail.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>,
        spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        linux-omap@vger.kernel.org, rnayak@ti.com,
        linux-kernel@vger.kernel.org, balbi@ti.com
Message-ID: <20130718203934.GT22506@sirena.org.uk>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
 <CA+7tXij7W_F0ZTQZ=YvK+qOLO+O-6WpTKxLerv8NXyrdydt7FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HjItbSCiIUf1YjO/"
Content-Disposition: inline
In-Reply-To: <CA+7tXij7W_F0ZTQZ=YvK+qOLO+O-6WpTKxLerv8NXyrdydt7FA@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HjItbSCiIUf1YjO/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 12:08:30PM -0700, Trent Piepho wrote:
> On Thu, Jul 18, 2013 at 3:01 AM, Sourav Poddar <sourav.poddar@ti.com> wrote:

> > +- ti,hwmods: Name of the hwmod associated to the QSPI

> What is ti,hwmods?  It's not clear from the description.  It also
> doesn't appear to be used in the driver.  At least, I did not find any
> occurrence of "hwmods" in the driver code.

It's a generic thing for all OMAPs which is handled by the core SoC
support transparently on TI chips.

--HjItbSCiIUf1YjO/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR6FKDAAoJELSic+t+oim9GN8P/RWnj01XQmNXFQzqipgyVrP7
LmVdQBBwRHaIlsY/6qqK2Nd0DzKbcUrJVZE2T6RYwT7cfgffOiSx2yj7ac9Sb6wt
4rUzqjBcjWlf5nEeeAgfwzybIq610dHNMTzegiua8WlNEO1y4ecK/OCUBO8wWf4J
oSgZIpiass68E0mMqRUmbUHqwTduNYJU4jMBhS1uH0RNXs9nQJwVge5KLL0C43U+
xZHrJIRy6YJm38KZDStUuhU87ojaVEbXMySG8S3bLEnH90KvU3i4xWPhe+4Fba1/
09cKL00sz+mleydmJbq4iSVpXnTB702ehG40TUQ6e7umI9DODFPHHdjiWBbfG+aM
ezdMc8oBmi+s8Ht2nAY+DZwVkLpeM/QEXjrm2VPbSTfoXbhAWRvDOm3bHqwVYc25
DENL0gczBMSIe5uzvrG7I7W35TqlFN7/Mcz2cDyhAWGnu4WiJnK8eKd9sbur6XBX
wbOvYUncGt/gZo98rkJ80Lu78Q8YrnFSpUChJfjije93Sbw+laBajW/WQHXBCeTx
c93PLi/PrzkNbwgRgzPD5YeyyrfscTwuwpXTflEiJvCI779KXKG2MYEZTNsZbiIy
e5uTpL5KnVvPuUvUiEOVnCMgjOBm3O4KtVGLa9fWaHxKJhrJufDWF5irvaZRz/G3
9MnWtc1VJyYMOTbE08mK
=CjTo
-----END PGP SIGNATURE-----

--HjItbSCiIUf1YjO/--
