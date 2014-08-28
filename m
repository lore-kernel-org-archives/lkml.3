Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaH1PCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:02:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38090 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaH1PCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:02:13 -0400
Date: Thu, 28 Aug 2014 16:01:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Chris Zhong <zyw@rock-chips.com>, Zhang Qing <zhanqging@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140828150141.GC29327@sirena.org.uk>
References: <1409231089.10292.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Content-Disposition: inline
In-Reply-To: <1409231089.10292.0.camel@phoenix>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: rk808: Fix memory leak
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 28, 2014 at 09:04:49PM +0800, Axel Lin wrote:
> The memory allocated in rk808_regulator_probe() needs to be freed when the
> module is unloaded. Thus pass &pdev->dev rather than &client->dev to
> devm_kzalloc.

Applied, thanks.

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/0RSAAoJELSic+t+oim9tJQP/2+5G/mn+q14mRS7uDWqofB3
U72gmz4pOS32zSC3papJcjrY4AMt3zBckqKuufkbzU66sWp51tMaiKB4yqVFlwlG
qCEcWmb0WKSUF+3MXCDuKxz+6oeQw/HH+Dsa0/ou7EnGaeEk0zTu4/n6I7OEz11F
WcVzm7ycBhOVydwI0MjWqOmIacdM2L8AMZ850dIbXRQFqPswjyG7IhWYadlLeO/9
wrzV7w4SxBbZS7WbF7YkCnDR/Sja9BUFAY1u/FZ2KR5Fhqfc6Cq4KBwDCw28UxIv
oYD/SiCzL2ioIprvM64T9k7U+EcTGSuOsPuZvySFp2PCsyFA8Qyv1193ezeEcYC3
C/oaDTiHRz/lvBriOpPAmX/643m/W3nnMP3o03YUWX0ItqHISzSpdSnjT9GVcTTL
gngONlrh4CMiTqrEmyyGwPCBokhP3Li9pPjnYRACFbherbQ5aTTy7JTp/QzGdwZH
AbEVmC5Jm6bRFVCHPuUri0wkaS2RoOVae0sNk8Ww5DX1HgY86mSVUhacaxzEJLTZ
3xyIr8UAkGLBzwqtEajffGXidYq9Xn2+1MUhnO9cVNLPuJL5Om1mRjlCXNfQeYQr
ysecbSsrAXxJsBSm49TdtAuRAd1lL4gfA9saFwsSwv5vTXjcHsnnGRVPqSNRmGKe
nRHFu3jTr6nabWK+KpOn
=KQIr
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
