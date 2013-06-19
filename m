Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561Ab3FSJ6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:58:22 -0400
Received: from sauhun.de ([89.238.76.85]:57554 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933873Ab3FSJ6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:58:20 -0400
Date: Wed, 19 Jun 2013 12:00:20 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mark Brown <broonie@kernel.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 1/2] mfd: tps65910: Fix crash in i2c_driver .probe
Message-ID: <20130619100020.GC2950@katana>
References: <1371550481-28126-1-git-send-email-ttynkkynen@nvidia.com>
 <1371550481-28126-2-git-send-email-ttynkkynen@nvidia.com>
 <20130619081859.GA22998@laptop>
 <20130619082740.GT7161@zurbaran>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Content-Disposition: inline
In-Reply-To: <20130619082740.GT7161@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2013 at 10:27:40AM +0200, Samuel Ortiz wrote:
> Hi Lee,
>=20
> On Wed, Jun 19, 2013 at 09:18:59AM +0100, Lee Jones wrote:
> > On Tue, 18 Jun 2013, Tuomas Tynkkynen wrote:
> >=20
> > > Commit "i2c: core: make it possible to match a pure device tree drive=
r"
> > > changed semantics of the i2c probing for device tree devices.
> > > Device tree probed devices now get a NULL i2c_device_id pointer.
> > > This caused kernel panics due to NULL dereference.
> > >=20
> > > Moves the of_match_device call from tps65910_parse_dt to .probe to
> > > allow the chip type to be detected from device tree but with the
> > > device parameters coming from platform data.
> > >=20
> > > Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> >=20
> > Applied with Stephen's Reviewed-by, thanks.
> According to Wolfgang, this is not needed as he will revert the i2c
> commits that are causing those crashes.
> I would not take it for now.

"Wolfram", please ;) Otherwise correct.

Thanks.


--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwYE0AAoJEBQN5MwUoCm26BIP/Rnfk30uyVtIwGdLYyTsCT+u
JJqeYOxXjBHVh9IEXu7h0aSj5o6YHvyhwiTTdxhWCFxcrxre54ZtYzI0qNcQBDr1
fOYPERAHRz3Lk4ESFtpuaPjLVhqjGPAV1H5M97jQdHAt1hgQBHkkW9jeHhLRndxG
qvBiajWk0HxChKabCx7I0DCNkRvT/v9EOBIU9zfa67//EQKj9m2M9PdUCdMOVh8X
FJzAqkYg2+Ffcv79IkG5aQt6al1F81CEwWX3n2BSgag38DZ6XTdAO4/kcHjfaf7b
Nd2W5V6yPhLqOJn8CjHIT5O5lN1u9lW1WANxjLQLILWb2dzU/xV9u8g3WHFx4NMe
SjH+LL6z5eXJSVENr/+8aNSjTnqFAEYbwLiJCBbyYC/4H/6BXc1PTq4TaZNDkzjH
tVbGsv4/A4CcYLRwTc/hKrSXOFmJ4hYf9nHUjyAAo6jxa7fRP0sIfxQkqfvuBvMO
4NfQuhd9KN2Ke6s7haOwRVEz7zAgedRkSxy+kaLVhLEW8qzSaTHp3/rotlHZTyfO
UI01XMUCbkjs+ByFz4Ply/Y2b5iP0i6rX+kDccnAsafzvDse9BD6ZSnFHN7/DRP/
gcvYVHhqFjNtEdOxxW2yhtnB/seQN32GL8a5Fvhu59SJrojVXFopmWh4V9nsHuQi
2GtAMjChMlRcanY5IdAS
=hec7
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
