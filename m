Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaCZTAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:00:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34091 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaCZTAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:00:52 -0400
Date: Wed, 26 Mar 2014 16:53:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jin Park <jinyoungp@nvidia.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140326165315.GE14287@sirena.org.uk>
References: <1395665138.4779.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lteA1dqeVaWQ9QQl"
Content-Disposition: inline
In-Reply-To: <1395665138.4779.1.camel@phoenix>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.55.122.183
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: aat2870: Use regulator_map_voltage_ascend
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lteA1dqeVaWQ9QQl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 24, 2014 at 08:45:38PM +0800, Axel Lin wrote:
> The voltages in aat2870_ldo_voltages table are in ascendant order, so use
> regulator_map_voltage_ascend.

Applied, thanks.

--lteA1dqeVaWQ9QQl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTMwX4AAoJELSic+t+oim9SggP/17zRA7LN5XpeVJnmi0n6o4v
tDZ2yxj3K50Fy463vFIbGP6NkLU2C6pikL654793o2pO+gBSNwdgOpV1iMXT1T8R
EiDm/ih4uQCYuNW3w3H5t714wi8dwRtspLxClTncN/BZwUr+9CJGcKQKHLzSn6Bq
6PUw9g6mSrpgBOLLvedu1CFuVcoESbuXVm7rwQ2TArA5pT2ZMGdgftqLKe8g/wQG
qNTICN7MZUZAE5VGgGyjmn9lnIxCjBkq8AR/xZ7hR2s9FKMONl+E/csXIXm5klFp
uoD39pwKt/j3fv4eNDAkfZiBvpplYOabZ4vvKu8moafE6gmPt9n3ms7BnC4iDXJl
DjeZ1BW3CB+QRsL0D/9zNgaVOQEb41LkOqm33qdaHNxhzlSpjEX0jFI9GSM93Hly
X7JWnJNVn8VePtIKeB7ryoPPWdwpvha72+MnG+W1Uyi/tCqvxqy38YqVr2uzno9C
OpBspAt1bwxmPzP7uqyS4INISbSGi6E+qkYx9BAjb8DrJz9bFptoVHE2sndMIwtQ
b4WSOgSmizdxSdaDGdy+g+Rc3QYJu2gUtlUYeX63NRjsefG1n38MSNR+YmVuKVEB
CjyHzwbUWWczLxw++63qGrz0NewLDzvcLuzD1ATgrEhU4aRa4JX/HTCc5eH+c6/V
B9syNC1jsVWkEXWmtHVN
=HQe5
-----END PGP SIGNATURE-----

--lteA1dqeVaWQ9QQl--
