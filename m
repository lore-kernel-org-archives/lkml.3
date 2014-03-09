Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaCIInW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:43:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55946 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaCIInQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:43:16 -0400
Date: Sun, 9 Mar 2014 08:43:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: ks.giri@samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140309084309.GS28112@sirena.org.uk>
References: <1394125539-28062-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20140307024841.GV13126@sirena.org.uk>
 <20140307091908.GJ8570@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="li6R/r59jzh/oGCG"
Content-Disposition: inline
In-Reply-To: <20140307091908.GJ8570@opensource.wolfsonmicro.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.89.236
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/s3c64xx: Update DT binding documentation to match
 code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--li6R/r59jzh/oGCG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 07, 2014 at 09:19:08AM +0000, Charles Keepax wrote:
> On Fri, Mar 07, 2014 at 10:48:41AM +0800, Mark Brown wrote:
> > On Thu, Mar 06, 2014 at 05:05:39PM +0000, Charles Keepax wrote:

> > > It updated the device tree binding to require a "cs-gpio" property to be
> > > specified on the spi controller node if chip selects will be given as
> > > GPIOs per slave, rather than the controller having a dedicated internal
> > > chip select pin.

> > No, it doesn't - it's saying that if the device has a "cs-gpio" property
> > then to use that as the chip select.  It's not a boolean, it's a GPIO
> > specifier.  Looking at the code it looks like the intention is to search
> > all children for a cs-gpio during the controller probe, it's possible
> > that this isn't working correctly.

> That is basically part of my question is the current setup doing
> what it is intended to? The Samsung binding has controller-data
> blocks on each of the slaves that specify the gpio for that
> slave.

Right, which is also clearly the intention of the code.

--li6R/r59jzh/oGCG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHCmaAAoJELSic+t+oim9bzEP/2d8LnLK+ycQt7vt2mUjOF6s
opypYPiTwueddLe2ye8JpHMcq5fwKHNmASm3PBhxQhXLKm/ILRzUOv/xT7H0J4Nv
wDIBlzjTv5ZGIGnK5X9gScX2DAY89+PDj7xOQhQ/BRDyrDojAevwjespne9roUR5
XgfAhDUAkue2as5qgcCnl+6RJuJeqvNrluDbDx7OyHj24v9OXNkFrPrsrBaqLf1M
Zj6cx8W9k+yaquNRU5SHgzQq8bWrUvVB7dSiq/HA28EWji0WOr2y5E03UEUW2dkk
Hk1yuqp95UneVaObksEHzUcjINO0MIbs8zBDA1ioIOW2yiV6DWIzFKCVR6DepbOd
4DJzPfSDkGcx+aXNRGqwqOmEPkiDouJUn0MryIh1zbZc9qDhdVarDnoEfCVoezGm
Lv6ST184pmQt/SO1+ltxH6PYiVyRTJjOLL2/nfrNw9aludAppzkA3iL8DJMhB1nn
B2PJ1MA8cZctBP3kNIWrlFp1g0vkp9a76wg+tBJ6e9uDBh7STbqmHEdTBFyunALL
NY9nMZENycP29E/JDomxJxE/eEdS/Jd0U70X3XeXRXZlwU5JBr9AjVFfh8hgheDN
JkVzR1ThGB2NlF0gueri6hBVd9biMwAgcg+t9NuVw3DfwyLHqrjfIhb28589GOLX
LNOcm/bN/aAG1lriPIrd
=yTNy
-----END PGP SIGNATURE-----

--li6R/r59jzh/oGCG--
