Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab3DANvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:51:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50991 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757595Ab3DANvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:51:06 -0400
Date: Mon, 1 Apr 2013 14:51:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        richard.genoud@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 08/14] spi/spi-atmel: fix spi-atmel driver to adapt to
 slave_config changes
Message-ID: <20130401135104.GZ18636@opensource.wolfsonmicro.com>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
 <1363679236-3973-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7fVM7fn5T1d7Fqim"
Content-Disposition: inline
In-Reply-To: <1363679236-3973-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7fVM7fn5T1d7Fqim
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2013 at 03:47:16PM +0800, Wenyou Yang wrote:
> From: Richard Genoud <richard.genoud@gmail.com>
>=20
> This is the following of the patch e2b35f3dbfc080f15b72834d08f04f0269dbe9=
be

What is this patch actually doing, shouldn't it be part of the previous
commit?  The changelog really ought to have a plain text version of the
commit description too.

--7fVM7fn5T1d7Fqim
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWZDCAAoJELSic+t+oim9KzcP/2qoMf1QCjPNieTa9ndxU3R/
JwPnBunEvlH96YJ9DPKaopkcqhxd+makc0bPC5EDv9ZfAL4k+s5Q2kyJQS9qGO+B
qLigmh9RWnOR2bxU+dyaTjAoB+2oV4WosTp5VeLBrZveq5wmiEvUeR4f3J4HsctE
pWtlLwe4fbnTvH8DLXXeZ0qrTHNwjWFtIi45Hf1S3QzTnxHfnTJyV/txAs1Dlnga
1UqSFc1jKntyMDZJgkpqoHTaVmFZGDJ7xVV3YqczmGj1lRxxRp0UtcOTIMZD0qlL
2c9tAOJQKACyL3Jz+rbhHZ5mFcWpTko6c6fxZeBkMpswoAPy2q6Tym169LTqajYj
wckK7FKF7/chUQXJi96ILG3gjQVaL48fIfKbKFx1StVtBPY47tJqb/IpMV8MkXXN
m1UCybnlab+5kQjtPZVMczTU5CElBkJP0ocBKz/fgLCNtqbYvFXtaYLXeJXELUnb
wol3pR+armZUpfm4TT7XGjYI7YqnFcQHf53INBE7adGL41S3exymsftM8fpfeply
3qUMdFOqUBaEn1GGj8oAl2we52H4qxUETvta22WQu9WPLlGFxJ88GQpsgkdhqCTK
1vuDWjhaTZmXXv4nbWgkGRHruSOnQ7TiFOQt5lXQwODa6vzIwOmTAKI7EmrbcZGd
s/RT4QMEGa42/uhJ6b1e
=5RWY
-----END PGP SIGNATURE-----

--7fVM7fn5T1d7Fqim--
