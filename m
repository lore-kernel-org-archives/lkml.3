Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaKCP4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:56:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35616 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaKCP4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:56:18 -0500
Date: Mon, 3 Nov 2014 15:54:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141103155443.GS3815@sirena.org.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wnBGVoaGQwxWUIo6"
Content-Disposition: inline
In-Reply-To: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 00/14] Add max77802 regulator operating mode support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wnBGVoaGQwxWUIo6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 03:40:35PM +0100, Javier Martinez Canillas wrote:
> Hello Mark,
>=20
> This is the fourth version of the series that adds operating modes
> support for the regulators in the max77802 PMIC. This version uses

No, it's not.  This is a a patch series doing a whole bunch of different
things, there's at least bug fixes to existing drivers, new features and
also this new driver in what I've glanced at so far.  These things
shouldn't just be being thrown together into a single patch series, and
the patch series shouldn't then be described as just being what is in
the end a minor part of the collection.

Doing this makes things more manageable from the review side, avoids
pointless dependencies and avoids setting off alarm bells.  My first
thought when seeing this was "how can a regulator driver be so complex
as to need 14 patches, there must be something seriously wrong here".

The whole thing about making sure that what you're doing makes sense
beyond just giving the correct test results also applies to sending the
patches - think if what's being said to the people reviewing the patches
is sensible.

--wnBGVoaGQwxWUIo6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV6VCAAoJECTWi3JdVIfQQY8H/1RJ4m2DkloO8XnjbgdOTKam
ZY+ZuD/3YaCRSFi0/CYXYw4rxg3EbhgORYIMCT2DWo/KyQx3xsbTr+WQ+8Pv6RU8
4Zyxjf5amaX/WoNZL/gxaCOg04mzhPe/gh/bQb+rFWNoI0rw8g9Ss6sgn5PbZ1kj
TkJglkG/fI0QXxcoslSK6Noc8f8Zz8onGZHXlrg98rsgmyeoJvxq0ozDoSQ65oLh
N9stMbtCgCNK8Bf7LaA1GWf40G2Gq1hKe1X24Q620eUharkoBPYdqgI424KhVLtw
fKzAaavIQ7O5WXSpSmO/d0dk91sJGNlMpZkLlCOzQyCslXpdl9U/dKgjrlq8D1k=
=eFRu
-----END PGP SIGNATURE-----

--wnBGVoaGQwxWUIo6--
