Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaANShI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:37:08 -0500
Received: from sauhun.de ([89.238.76.85]:48340 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbaANShE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:37:04 -0500
Date: Tue, 14 Jan 2014 19:37:02 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i2c: i2c-core: fix coding style issues in i2c-core.c
Message-ID: <20140114183702.GC10340@katana>
References: <525C0C5B.6040703@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
Content-Disposition: inline
In-Reply-To: <525C0C5B.6040703@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2013 at 08:53:07PM +0530, RAGHAVENDRA GANIGA wrote:
> From b21e6a52aa9c36e8c01173cff13bbfd2a380d0bd Mon Sep 17 00:00:00 2001
> From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
> Date: Mon, 14 Oct 2013 00:29:08 +0530
> Subject: [PATCH 2/3] i2c: i2c-core: fix coding style issues in i2c-core.c
>=20
> This is a patch to the i2c-core.c file that fixes up warnings and
> the code indent error reported by the checkpatch.pl tool

Please describe which warnings.

> @@ -1737,9 +1735,10 @@ int i2c_transfer(struct i2c_adapter *adap, struct =
i2c_msg *msgs, int num)
>  	if (adap->algo->master_xfer) {
>  #ifdef DEBUG
>  		for (ret =3D 0; ret < num; ret++) {
> -			dev_dbg(&adap->dev, "master_xfer[%d] %c, addr=3D0x%02x, "
> -				"len=3D%d%s\n", ret, (msgs[ret].flags & I2C_M_RD)
> -				? 'R' : 'W', msgs[ret].addr, msgs[ret].len,
> +			dev_dbg(&adap->dev, "master_xfer[%d] %c, addr=3D0x%02x, len=3D%d%s\n",
> +				ret,
> +				((msgs[ret].flags & I2C_M_RD) ? 'R' : 'W'),
> +				msgs[ret].addr, msgs[ret].len,
>  				(msgs[ret].flags & I2C_M_RECV_LEN) ? "+" : "");

You added some extra paranthesis here? No need to. Also ret doesn't need
to be in a seperate line.

>  		}
>  #endif
> @@ -1905,8 +1904,9 @@ static int i2c_detect_address(struct i2c_client *te=
mp_client,
> =20
>  	/* Consistency check */
>  	if (info.type[0] =3D=3D '\0') {
> -		dev_err(&adapter->dev, "%s detection function provided "
> -			"no name for 0x%x\n", driver->driver.name,
> +		dev_err(&adapter->dev,
> +			"%s detection function provided no name for 0x%x\n",
> +			driver->driver.name,
>  			addr);

'addr' is dangling.

And merge 1/3 into it.


--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS1YPOAAoJEBQN5MwUoCm2XPgP+QEnqHQlOqVRr1NoUR5l7iXr
t+9oPXEBmnxqtcWjzINpK6O6zK8ZITwSiT09TAuPBJgobwHM9MW92nEydkDhPsGr
WRqOv5LbXzKmZrdguvq9nQ8zU8XXQnx0hrtQhsxW0fuqnfQj02XXT4jMmARN/dnb
PpsbVxJlCwCBznYmQUvPWHJTMF2byLxvB+8ks7wL0j0jCOf81LDehGA74eMnZxF6
z7Cz1wqvv12ozC/V1DUGHnjZROMLrWB6V8o6jdQu8tbL5PNPNKCEG3fVsxSAUuj3
Z0UiArlKRuKbHv8knixmsvXu3F6nppc5Sh1K5s9WG4g2wc/4DJ+0icZK+Yf+kRkJ
EtNCaGIrIDQfImmas+6r13ere4zFowN/vbrC2GvQwiMdm8ydV0E6CZKjKj1P5Ds+
7sgONGAD2JMZgVTmP/gOywUZyDZKe4HhdCkR3QbepldIVzvY78MYNbl2/kUDjXC9
kxvhExJ8RTnHnYzAXHUF+HVQ/coW9E+iHnFkc/vjvdcuV4gJzgEguKMXONLwKkho
Nma0OJ0fJ/JHMSO8vIXAW4/rdAPD2CIkI+bqj0YzcLklMTcTt7+kqHRoKJ0dbw97
p9Z+bK5+IIEB5JiSKhPg9nHK2xvS8Wc2QSxF6mx4eovTHciGHN0rzcQKEGrC5ZwO
sO32SbpfjqeMxS2zKu/E
=hBjp
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--
