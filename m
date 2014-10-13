Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaJMKcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:32:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50120 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaJMKcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:32:53 -0400
Date: Mon, 13 Oct 2014 12:32:33 +0200
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141013103233.GI27755@sirena.org.uk>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
 <1413042040-28222-8-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4MTjg8yAiOaLjoFv"
Content-Disposition: inline
In-Reply-To: <1413042040-28222-8-git-send-email-vinod.koul@intel.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/12] spi/spi-dw-mid.c: use dmaengine_slave_config() API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4MTjg8yAiOaLjoFv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 11, 2014 at 09:10:36PM +0530, Vinod Koul wrote:
> The drivers should use dmaengine_slave_config() API instead of
> accessing the device_control which will be deprecated soon

Applied, thanks.

--4MTjg8yAiOaLjoFv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO6pAAAoJECTWi3JdVIfQpOUH/iilgElY6zXJ4FSI9jORpB9n
NjePb/AJrafy39bQmCApCphpMtwQKrTqJVQTW1dT2eQ7wkNezUkQGWrvKJ1SRh2P
/xo4fsMnBYFjjKF/hpTABcHE9aJ0XdC2XDNHCe4JiBJ+d6FBH/v369X/+15MCUpr
1e7JPC1lo8co1nEOqZSPr/PzRCkh/5ghz70wDffaHzb+Nb3hp2K+NGk+8EJseSoX
/Whkqea8Yrie/W9tKyafIG04Hcf3f6H0IW1JDC+NMHY5UPMHXg8Lzl3pcs0r2LP1
0/VSPWzbRpDalRxLT6aLCKQj34V7rOHbxk8rbSwhgiqs2aVTitfAP1tZ5WDP87A=
=PPSK
-----END PGP SIGNATURE-----

--4MTjg8yAiOaLjoFv--
