Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaDRRj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:39:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38169 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDRRjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:39:54 -0400
Date: Fri, 18 Apr 2014 18:39:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140418173924.GU12304@sirena.org.uk>
References: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1397638902-7576-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7U1RSSkRXGczHgJj"
Content-Disposition: inline
In-Reply-To: <1397638902-7576-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/6] regulator: arizona-ldo1: Add processing of init_data
 from device tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7U1RSSkRXGczHgJj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 10:01:39AM +0100, Charles Keepax wrote:
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Applied, but again you really need better changelogs - processing of
init_data for what?  For most regulators init_data is handled totally
transparently so this isn't normal.

--7U1RSSkRXGczHgJj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUWNJAAoJELSic+t+oim9MjkP/RnP/zjU6sXXm8wclKFZXc67
iETLVzdf4ix0BS7/oB2TIeXQ14iujDyn+gw+UB68WnTc/F/A4P2dzw/TgEX2kOJH
gRpug53VyoKyC0dD242xt05BAyBmzIoVRI3vTAInKph7Ov+viwRf8pD3aIRKCXL4
/ibETP5u7Ovf+TXvjDqN+Th1GZkdcse+2Ku9Fj8ADgTWS8RfONFi1p91T0KwRlUQ
D7wfWTk8DruW/OMX+3t4IXfO5acPRWhJp3SZqwZVGGajKODaSm6yPAuW0LVFFF/N
AElLgUEGal7M552ZPFWaixp0i7EUnokO4nQeUVJRXRMbdN2di2c5Vuonlm3C8RBN
iJzJlKudSdRehA58tOEfKiURe5HBw1TQK3hbgfIfhPGjfKlt81c6ATyQusdcGDJy
6hwxUf+nYWvAqaDy177Ch2tjMYoum4IDYHBiILjmXn/38jV7gA2K+YOHPV0zRpwf
LxuA+01cgrrRyXIBJFS8wI+RXFKF7YF8QtZAj8RrjoTJwSKWFXFDlqIJ8uqdKhhu
euMepxazB6O4iQFqo0dIEUqR/NIqxMNuYlPYEmldqTflavn3lO+OF/5AXMfUeX4o
I2x2ZcqtGP8g3rrrTStuw5MqJ0c2JI3IK0JILAzbd3LVZbasy1GU1pidq0TrNnry
VlIMxzuJFfMIQXr+f2/q
=iVCr
-----END PGP SIGNATURE-----

--7U1RSSkRXGczHgJj--
