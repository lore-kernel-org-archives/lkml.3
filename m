Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaKYLrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:47:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37923 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaKYLq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:46:58 -0500
Date: Tue, 25 Nov 2014 11:44:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        linux-spi@vger.kernel.org
Message-ID: <20141125114449.GO7712@sirena.org.uk>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
 <1416868422-22103-15-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7Vi1RbbjZdZQ982c"
Content-Disposition: inline
In-Reply-To: <1416868422-22103-15-git-send-email-grant.likely@linaro.org>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 14/14] spi/of: Add OF notifier handler
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7Vi1RbbjZdZQ982c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 10:33:42PM +0000, Grant Likely wrote:
> From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>=20
> Add OF notifier handler needed for creating/destroying spi devices
> according to dynamic runtime changes in the DT live tree. This code is
> enabled when CONFIG_OF_DYNAMIC is selected.

Reviwed-by: Mark Brown <broonei@kernel.org>

--7Vi1RbbjZdZQ982c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdGuwAAoJECTWi3JdVIfQ6jAH/RUW0vMc+HnqwgvwlpuMhXAd
ySikOk64bpyL07YkzTirUTv0ikWj83T2I9LfCru8kBY7uPmZtKJp7i0+/TY2XZ0J
HxZUgzjyce2KVg30tGPJ7tFU3yWbJc2cxSSxtuDixUEghd0QABSddVpjWVpMK7Rr
SY0YnnhZ++vr0T0DGePCl/U+E+eKe8AWIYF53wOy0pRYc0qnQSx2wvtO8pjetp09
DYqwViiql4UaqnbsDxaejQfBVzCZs9Yrl5LOy1w1ABfqTy9yoQoQbthG6sOYP7Th
fK9WEkRP/OkvIGHdWnRWKb7q8QRZT8vi7o4WBFwY+vaUgzICf6buuRBVeJS+MkY=
=jsVk
-----END PGP SIGNATURE-----

--7Vi1RbbjZdZQ982c--
