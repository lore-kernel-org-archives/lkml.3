Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbbAHS3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:29:07 -0500
Received: from sauhun.de ([89.238.76.85]:45885 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbbAHS3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:29:00 -0500
Date: Thu, 8 Jan 2015 19:28:48 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, Anders Berg <anders.berg@avagotech.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [wsa:i2c/quirks 7/11] drivers/i2c/busses/i2c-axxia.c:452:27:
 sparse: symbol 'axxia_i2c_quirks' was not declared. Should it be static?
Message-ID: <20150108182847.GA29629@katana>
References: <201501090118.jHaamxHl%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <201501090118.jHaamxHl%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 01:57:37AM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux i2c/quirks
> head:   b1d39af8ae21f4930854b0656aa83a83fd38049e
> commit: 70181ecd2990326a91edb3dac1db4cce21e561f7 [7/11] i2c: axxia: make =
use of the new infrastructure for quirks
> reproduce:
>   # apt-get install sparse
>   git checkout 70181ecd2990326a91edb3dac1db4cce21e561f7
>   make ARCH=3Dx86_64 allmodconfig
>   make C=3D1 CF=3D-D__CHECK_ENDIAN__
>=20
>=20
> sparse warnings: (new ones prefixed by >>)
>=20
> >> drivers/i2c/busses/i2c-axxia.c:452:27: sparse: symbol 'axxia_i2c_quirk=
s' was not declared. Should it be static?
>=20
> Please review and possibly fold the followup patch.

Yes, it should be static.

However, this is a development branch and in this case it would be
enough if the test results would be directed to me only.

Is there a way to achieve this? I know that adding "experimental" to the
branch name will skip the testing. Is there another pattern to prevent
sending mails to everyone?

Thanks,

   Wolfram


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrsxfAAoJEBQN5MwUoCm249kP/3ORDgY5yWWghs0rBbhkeV5D
QY3yVuC2ODgrXfVlPqnsj176RG1kWqrYSRDzko2x2tLAi+hOk7r9QQOCXX7Tfqx8
VvM8S9eOj7Rrtl0EiUZGvCuhAlSSflqbsic729TpBQoTs4w6nAnxb/9IfWcPz/cb
4xKZF3OIJzXWb2rtOrIIjP/B//jEMHF60dsReGaV2trR88YFte4WjDqx/HsFuNUm
zu3iXG6H4ZVt4+/tUvqOJQsHH7vWWFjeXOhqyzQXVUvKrICwlQA9EOTUygyV8APG
ZEAJ5bE6Yxv9kQ15i9q0rDQnEgFERSzlUzPQ1inVymbHD2BIGOFvymts0fi+KBrK
cgqFL4F0FlPePY2q2UnSONeEXKdA3urOsjJr40rx8P6XCx2zWZ5C8l0ds2bzoXuV
Ea5WwtWGDESnWjKbqt0YDZSzhSBu/mnQHUoORvXKh5vvTiKlO5ivPw4ZmdVzd+Yx
MV/ANQDkLgTlcFCssqxu37bHJpV46NRtBB4yALydXnkwi9Y98IJzxcldJBJsr0Lw
aQcZS8tO3sPZ98phKt8yAo50nagLi4owdQlUq6EVh72zMU88gvykZvC+EUSROKCg
my7B6HEI57DK8tyl6EJxFa0RM27AJaallp2hdWkG1eqPS7ff5Kxn0TXNaup0zrh9
vH088MoLN0DWDshOKKYw
=rIr7
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
