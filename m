Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbaE2NeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:34:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:47904 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576AbaE2NeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:34:07 -0400
Date: Thu, 29 May 2014 15:33:57 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/4] tsc2005 DT binding
Message-ID: <20140529133356.GA4716@earth.universe>
References: <1400693774-21306-1-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <1400693774-21306-1-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2014 at 07:36:10PM +0200, Sebastian Reichel wrote:
> This adds device tree support for the tsc2005 touchscreen
> controller, which is currently only used by the Nokia N900
> board.
>=20
> The patch does not update the reset pin handling for platform
> data based probe to avoid merge conflicts. The n900 platform
> code will be removed in the near future (3.17?) and the driver
> can be simplified once that has happened.
>=20
> Changes since v3 [0]:
>  * Move common touchscreen DT handling code into its own file
>  * Add regulator support to tsc2005 driver
>  * Added N900 DTS patch for completeness. It should go via
>    Tony's Tree of course.

ping! It would be nice to have this in 3.16, since it makes
the N900 usable with the mainline kernel when booted in DT
mode. The DT bindings haven't changed for more than 3 weeks,
so we don't need to wait longer for feedback from the DT
maintainers AFAIK.

-- Sebastian

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJThzdEAAoJENju1/PIO/qaZXoQAJ9ifTNGksfdMZ7yWbgM9NKL
6MUMajU8zESTicwRp2woT/cCfRuTUFtgdm+j4nc/yRAqikeUPMwBnOgY+IKOlb/W
bxTdBwVeWm7OuM8jJvXwktj1Y/Mr3yo1Wr4/vHGZoK8P7EalB1m9GqAnx6fVhuMz
iPS0dF1TvgDXa7xOQl/riFPB+bVd7v8hZhqNYjLHUvxgRf3yN2KADdohMRPyxHWl
hZSc6Z/mnCXCk+7ompwpTzgk6IAe+Mxbmogp07AwnQbYiykZKD4sBkqt45Dih9P+
zBGnO2iI0o986U0UC3aBlx2Vf9fi/yZO2ZK6nJS8xcz/YIagDcyjyRBAnLdrz50w
nPEkw3WNyS+1NVXO3rUTveAZYGLUaGK1hYl9ZTrh+rsaw3Blc/YpD/Ik4Qhqy1tu
0QUcKRSeXDnbdVqxGksG5PF6y7gSwq8Bp2+o06ICyClNax1OECQDpsZZa9U3M2AF
X3TxtHgUlza12aOVn7G1maZY67fKHzZIlEcwTl7GDeAZWNr1zgac1MJI7VmXJ+tZ
eShfiLG1M8kWnEdOM19XIQAq9A0EX7YmKjCEOMESx18+erQ9L9XprIUfIIrKIiIL
dKGeIni9cllVOuEUFJP5+DwsAVbFdo1K/4cC8MckKj+1oKd3PW5XrMTOc5OYQdRX
Dy4JB3wJ7GnBQqThOxXZ
=Ib1e
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
