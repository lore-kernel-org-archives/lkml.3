Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3HEKrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:47:12 -0400
Received: from sauhun.de ([89.238.76.85]:60487 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3HEKrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:47:10 -0400
Date: Mon, 5 Aug 2013 12:47:07 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: add sanity check to i2c_put_adapter
Message-ID: <20130805104706.GC9694@katana>
References: <1375359046-17472-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130805090030.GC2980@katana>
 <51FF70FE.1090804@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <51FF70FE.1090804@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 05, 2013 at 11:31:42AM +0200, Sebastian Hesselbarth wrote:
> On 08/05/13 11:00, Wolfram Sang wrote:
> >On Thu, Aug 01, 2013 at 02:10:46PM +0200, Sebastian Hesselbarth wrote:
> >>i2c_put_adapter dereferences i2c_adapter pointer passed without check
> >>for NULL. This adds a check for non-NULL pointer to allow i2c_put_adapt=
er
> >>called with NULL and behave the same way i2c_release_client does alread=
y.
> >
> >What about using WARN for the NULL case to point out the ref-counting
> >imbalance?
>=20
> Wolfram,
>=20
> I was just adding this to (a) make it consistent with i2c_release_client
> and (b) it allows to simplify drivers where you need to release the
> adapter during probe failures. But that patch is so small, feel free to
> squash in anything you like.

I am not forcing you to do this, I am calling for opinions here.


--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR/4KqAAoJEBQN5MwUoCm2iHYP/2anAH0lmkpm2ZA30yuvDRNn
QbVT8Zr5CLgDn6rsnA5PIWnFf0iqintQxfAtuZzoli9dWQ3sgow8jbaYTgABjFT5
6jhXrd2ol72uL0BcvLZ3WVFTJ5Rnm/i8NnWttJF8jenQBaKtAWrGEst7m0P0d7Yp
sjgH9AFmf3tt9i+puG5gVxSbZ8C2Fu2JHG/apl01e8gCxQEjHGZ/H7Fh+kFRqXsG
DL2qk1oEg+7IZbkge6yfWsbz/CYYIDs1l14OLuoa5kcmv/Z1MJkwrrFiXtYuYhUT
SU7AJZKBsdQAh9XFo4g+2OdQOs2jksNc1ukNXjHaMbnLGMYmPvkmr5HSLVHD5dLu
7EuICjRwlWpjVk9UomDqm5GVbQ6qoYQpd8nzEFCOphcWnZYRDznQBGbXxZg6Io3n
yKHMRTsl+Ktsuja629azwACtCdR4mxrbWY55hRYp2ZnatlnfuOJMYZEfAGy9F1J0
p756B2jwN2KUrVl5J5jI1QTir/suxnWMi4jOPtv+XBHhm+WqLI0HdFQJUdmnJ8pJ
yEj0dW7o9zO/wfKvq+8Kb1UIL8o4LDRPWCoZUJmoANTBG008JDuue4NH6ARAq7RH
sLhK/W4qVKrokMKrGYSSZedagTYdVjKvZpvIBDcmsI8/zua8lFoYYjBoJIJboTCp
IiR2SFYWbRs+/Hd1Nyio
=iPbR
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
