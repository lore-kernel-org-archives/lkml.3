Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaGGFxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:53:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39005 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaGGFxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:53:41 -0400
Date: Mon, 7 Jul 2014 07:53:38 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Pawel Lebioda <pawel.lebioda89@gmail.com>
Cc: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: nvec: remove unneccessary 'out of memory'
 message
Message-ID: <20140707055338.GC15216@ulmo>
References: <cover.1404586529.git.pawel.lebioda89@gmail.com>
 <df2e426106dbb1040fded1f2ae69cb88e6c8c5cc.1404586529.git.pawel.lebioda89@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Content-Disposition: inline
In-Reply-To: <df2e426106dbb1040fded1f2ae69cb88e6c8c5cc.1404586529.git.pawel.lebioda89@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 05, 2014 at 10:30:56PM +0200, Pawel Lebioda wrote:
> Fix the following warning reported by checkpatch.pl:
>=20
> WARNING: Possible unnecessary 'out of memory' message
> 811: FILE: drivers/staging/nvec/nvec.c:811
>=20
> Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
> ---
>  drivers/staging/nvec/nvec.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Thierry Reding <treding@nvidia.com>

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTujXiAAoJEN0jrNd/PrOhJPcP/ArfSEezmG1FHAUE0dWebO5p
tB1bP9tnrE4FWWJgEfwJqgA4t6ZK30F3+kKO5FH7aqG9e9muOzYiXdxpUm/JU4ZA
vz+zT22NkgVLuAFg6OUJA4jSUOjVRmNSQp9GzhFkZSGhoi9/Rd5THJG9lTDN99KT
/CBkLnyz7W9AGTcnZ/1Xrp3vtjavW+JPAHEjrXMOr1c19Qz47eKXJ5C6hd6iqLpI
ldw9jFqlDjkIwQ7m7WlFHbG2MAodpYKrdwRlqfk+dwYxrl7dqubhfEcQR7cRpCaJ
s5fxz6PLD08DZa+lNciyPmJwM9UyGC/kBwk6VgZfElM/PPnyprg1b9GiUh1czV+7
a8zRgusywJFT83nf7ey2EZfHQ7Zkrmq3qCX+K/zwh+5ilgGYRKtk+oLpqmtC86lO
wEVV7zdQBQLKv/F5FE/K+JKe7FJqOzR2hzpkC4GGhjeWXcIFf8e7lT9Sp/p5AqUq
iBOhOvjQTlMlNp7DW6PHS7DgD06mxqpcSA0DFT2cwxRmij7W6CZTt5HOWOOHhSYj
lFEnBSL00B0FYIF9sD9UW+TdP2JrGpQmu2QTO3PsAOFIuGT6yPD6dgdP0W5L+vcc
GaDAIhYH4o7KuDHTHqbwC8Ko+ObByw9fQoy9zRVeuYFCJ3D5iOB2zIiP4gOOMTrR
o0mpkdf48mH5zqp2vKjX
=eoEl
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
