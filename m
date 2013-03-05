Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab3CESit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:38:49 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:59402 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab3CESis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:38:48 -0500
Message-ID: <51363BAF.3010305@kernel.org>
Date: Tue, 05 Mar 2013 13:38:39 -0500
From: Konstantin Ryabitsev <mricon@kernel.org>
Organization: Linux Foundation/Kernel.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: webmaster@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [www.k.o] Let tar.xz be the default tarball on the main-page?
References: <CA+icZUVhrWQn+mW8_HgApMgLBYvUD96XafMznP909tVJZS5TRg@mail.gmail.com>
In-Reply-To: <CA+icZUVhrWQn+mW8_HgApMgLBYvUD96XafMznP909tVJZS5TRg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2JLAMROWEDWTFWHUCHMCF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2JLAMROWEDWTFWHUCHMCF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/03/13 07:58 AM, Sedat Dilek wrote:
> Hi,
>=20
> it is still tar.bz2 the default tarball for downloading.
> As modern Linux-kernel versions exists also as tar.xz which is smaller
> and causes less Internet traffic.
> Save the planet :-)!

I think I'll go ahead and do that, if only because some time down the
line I'd like to stop making everything available as [.gz|.bz2|.xz] and
eliminate bz2 altogether. Switching main page links to .xz will help me
accomplish this goal in some distant future.


Best,
--=20
Konstantin Ryabitsev
Systems Administrator
Linux Foundation, kernel.org
Montr=C3=A9al, Qu=C3=A9bec


------enig2JLAMROWEDWTFWHUCHMCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQGcBAEBAgAGBQJRNjuvAAoJEI6WedmufElewIYMAIpwifgoUbRgXH1trEVe6To0
ZgmxHJF9ALny0Z6ehkukNYq6RmdA4da2Ui64gk4ll1G/dAyu0Cfz+VtLDVah6R/2
XBtWBnflXFMhYgP9u9smorBU9TPJWilsGXPNHNCTWJXISqqeiWREO0zsjkMVeYZa
5Y2OVIQfRokJJtTJac2BdFewardeemz4jptFk/Cdc9hJelnSGi2yIWjRhvwI6fBe
wTwXX85qwbKQD+69gsJkPYpu4eUFOqKKl1GTMWZ4AhPwPZ/o7hrY8B/SSCwz1FAH
+50r76erVN2EKs7TNfM0Pi3S/QbcOE4rzGJwHxzFcg+oaz7jj0tmwDuF7DqwV3cD
f5Ex+6RWGjamzkU7q6dD6szrKA4DFhaZr1QLxVYndLFbCi+aumw4ppuDtaU+yG4t
Abl5eE4h0yuR5R4wQpiYMtcv/eubzwOT1w1sae/aXVOODWPf9ONvM5UAPfoEkFjf
JvJR3sDqUq09cCgqZXQWvTFoRCyW6xmhgf6TGNZ88g==
=D+qt
-----END PGP SIGNATURE-----

------enig2JLAMROWEDWTFWHUCHMCF--
