Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaKJOnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:43:40 -0500
Received: from sauhun.de ([89.238.76.85]:54182 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbaKJOnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:43:37 -0500
Date: Mon, 10 Nov 2014 15:44:41 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jerry Cao <jerry.cao@amlogic.com>, Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH v2 1/2] i2c: add support for Amlogic Meson I2C controller
Message-ID: <20141110144440.GB10422@katana>
References: <1412540232-26168-1-git-send-email-b.galvani@gmail.com>
 <1412540232-26168-2-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <1412540232-26168-2-git-send-email-b.galvani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 05, 2014 at 10:17:11PM +0200, Beniamino Galvani wrote:
> This is a driver for the I2C controller found in Amlogic Meson SoCs.
>=20
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

Thanks. Looking very good already!

> +static void meson_i2c_prepare_xfer(struct meson_i2c *i2c, bool write)

Instead of the bool, maybe you could query i2c->state in the function?
You decide, I am not forcing you to do this.

> +static u32 meson_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> +}

Have you tested 0-byte transfers, too (i2cdetect -q)? What was your test
scenario in general?

Just minor questions. It is good to go already!


--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUYM9YAAoJEBQN5MwUoCm28x8P/izwmjTbddAKKzeFuH18eatu
N+iXyQF0AFLsQJPOeE6HixqsHXoFBOMQ9zBp7UGfkUl62xS31fweaVSVXkVtorEB
CRnXGWOmjmHYRGRA4MJnPJuxwTGceJFmyzkHwl1+GARNS0tjQeagGCY9u+e0R7Y0
Jf/dFz90Ks3sTiX/3U5+R0WpjXjqxl9IC2KgrxRyLOTLncd6fZbI2fAoNTSB69cE
JxKtnQHdic7f9PmvwKzFTjToSk+JeYtxp3EOKg2cHhxYM8CP3GJkNCf11i5GLnGG
b0sePrBPeo9wDoKEKJpDUIR6WR/b6cEbWES0VWXN2qL8Ik0+qulvfaRnjheAFVFA
tZGrYrJBpBfqqVIYlqj1PB8dcQ91jAkg8XVm3smZn+zKj50qhKjmrfso9vn2gzxI
+88x+04YbXto0pO8Q4SDDUWPsydszbtws68vIp6l7lBtbOfmeev6EXJw8Pi5ZVzt
P0qL2ryzR1rRMpSf7x9CF/iQMjTM06j6i8ZTYmT2gri3CuEFuGtZDBeSeXwGXi6I
cwQTm7Q6KRcPYpPCmgz4aJmeFUc8XuBOxwVQBlxi/tiVRhkEIoLZyQxmHnEQqVkq
VgEfmgIqD+vppOljC2FZiPXDKOuYvb0LQ2ZsIoRyvUKCr7LDuQhDD6ixeSNkEBim
/1+k9x7KsTvT8mzFF+xz
=x9Vp
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
