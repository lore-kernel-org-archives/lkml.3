Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbbA0MOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:14:49 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36110 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbbA0MOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:14:46 -0500
Date: Tue, 27 Jan 2015 12:14:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150127121424.GS21293@sirena.org.uk>
References: <1421941147-9682-1-git-send-email-wens@csie.org>
 <1421941147-9682-4-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="z3XR48OWYS228AZl"
Content-Disposition: inline
In-Reply-To: <1421941147-9682-4-git-send-email-wens@csie.org>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v9 3/5] regulators: axp20x: Use "clock-frequency"
 property for dcdc work frequency
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z3XR48OWYS228AZl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2015 at 11:39:05PM +0800, Chen-Yu Tsai wrote:
> Since the dcdc regulator work frequency is a property of the regulators
> DT sub-tree, there is no issue of naming collisions, so we can use the
> standard "clock-frequency" binding for this.
>=20
> The driver sets a reasonable default value (same as the datasheet), and
> only 1 dts has the old binding, with the default value.

I don't see any benefit from this change - not only is this an
incompatible change (which may affect out of tree users as well as in
tree users) but it's not really doing anything with the clock API which
I'd expect to be happening for a clock API property.  What's the goal
here?

--z3XR48OWYS228AZl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx4EfAAoJECTWi3JdVIfQxVEIAIBZUkhYIKUYUlp2lbbE2U39
988UjOv7eAPlV/4oQP71bcaY4oFhzhmvX1Q76xiAK00CE38fVrrOf8izwwZB3zQy
1jQr8sy4zB8lkZdM9l7jWJpGYVUlvWewbnZleZC/dj1p+4c64DNwb4tEb3Sg42Dm
JjLTYtcWalPBwYWe4LLddt8urCgxTEyZKalBJj5akqaiuLs3IDTj0ggKqwqRFitR
ulKn36Zx6T5BJdAsgAZSBc2NG7Y1KPbBkCIr9Y8/p+ZW8zm6L4cK/xIzUVtFiTws
X0ME8hpvul39eZmF3fmfTUUj6pV3p0cOl3kwQQ+4LEMlMIHsz3V+QsRAxPAH4pk=
=ymXa
-----END PGP SIGNATURE-----

--z3XR48OWYS228AZl--
