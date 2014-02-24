Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaBXFyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:54:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50622 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaBXFy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:54:26 -0500
Date: Mon, 24 Feb 2014 14:54:16 +0900
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jason Cooper <jason@lakedaemon.net>,
        andrew@lunn.ch, gregory.clement@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Message-ID: <20140224055416.GB25940@sirena.org.uk>
References: <20140224133752.bc1ffffa4e81edb76a76e555@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gQmjQz8lQ7hwrZL9"
Content-Disposition: inline
In-Reply-To: <20140224133752.bc1ffffa4e81edb76a76e555@canb.auug.org.au>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: manual merge of the sound-asoc tree with the mvebu
 tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gQmjQz8lQ7hwrZL9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 24, 2014 at 01:37:52PM +1100, Stephen Rothwell wrote:

> I fixed it up (Probably incorrectly - see below) and can carry the fix as
> necessary (no action is required).

That looks right (or at least like it won't do any harm or cause
bisection problems), thanks.

--gQmjQz8lQ7hwrZL9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCt6FAAoJELSic+t+oim9VCcP/37OSHXG5z0AVYA2zAEmSRWx
rx/PBQ/xdnFW+cN3IGPbB9VNeaI5NKAlhLH3XPOCn9IbTuK7M9HsmWDamkLrQD9g
Sma0RjnIjRDA5FpbG3e3k+lavMHPR9Gl2eLZQNP7pJtrvvPatfZxZ4sY5tO3/msf
NOqja2oAq5DrEgdiErZP5Y0Mfo2HqBawMyVokgUZ+ZpH4d4bvl5E2tvuzp8mWmt8
RsBadPX2z2sw32G+MaBqFzZrI+U6l9mUHyG52Y+65i02aQRbaUYNPdjniV8BWqz1
UfPWYyqoQRHZkqYju4gdZuFZSeBZ0MQVPg0XREJ3rEQ6fBGmK6c/pkKqRkv7ng+q
D46rXzLXVo6GWYV9qP/9vrrzLKlLSkROZsFXwJGH00hCaNjxUin6eA/PcavxOV5J
MvMxYwRgC9g4m/BPeH05lIBEtJNSUlSVYEbR3XP8CuiLCXQFI3r9k4AgEIJ5nxm+
v9Lr3jsWmlQoCLE8YmIoyDxv+BraNn+iIlT44HHfMiXLTbc7oKvbMsJYm23678kg
kArOe88FRdap5Sb2JJsPpPjm1hUGtHb0mwypgOqknMBza6iTJw+eUBko6dTvp0Bz
Wp7bP5VKHt7dwjSe1g7ZFGKlIn+AYZ2Z74nq4uCkSBy7uBfIyEoW3xE1DeHQFLFS
QmHoKEbS0bUQb2QumPRu
=o3SL
-----END PGP SIGNATURE-----

--gQmjQz8lQ7hwrZL9--
