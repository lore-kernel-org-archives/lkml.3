Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3CAHlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:41:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59028 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884Ab3CAHlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:41:44 -0500
Date: Fri, 1 Mar 2013 15:41:00 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Sangbeom Kim <sbkim73@samsung.com>, kernel-janitors@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/regulator/s5m8767.c: adjust duplicate test
Message-ID: <20130301074046.GJ25302@opensource.wolfsonmicro.com>
References: <1361706934-15434-1-git-send-email-Julia.Lawall@lip6.fr>
 <1361706934-15434-3-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bWEb1MG/o7IKOlQF"
Content-Disposition: inline
In-Reply-To: <1361706934-15434-3-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bWEb1MG/o7IKOlQF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 24, 2013 at 12:55:34PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Delete successive tests to the same location.

Applied, thanks.  If you're sending a bunch of patches intended to be
applied separately it's probably not worth numbering them, it avoids
confusion (like waiting for 1/2).

--bWEb1MG/o7IKOlQF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMFt3AAoJELSic+t+oim9ndgQAIuF3mouafjd/WRfQC6SdbdU
dk6I4lanHgrW0kek/pPLGrGmagc4Ob6+37OVfH4BZcRbx5veEUdWZaErRkCiIBZR
qGz6snMApQDA6z5eym+0TPHYSm+RqNLZQELzWitkV8Xty5+EBow3wUt3sI9GnZCt
YParw1RObycD4fGvHxQg3YO1rYk2k8I24SzKzdVX/alLBrDSF6F1uh8kkzCR9T1V
JjLvmGb5q/8cAX4TjyysqYabEsWbiw8iNJWXzOWknub0u7fBUVpsXc3Cv/hX/VWS
r7NiaJwuoO50cWsGHl2gmV+8zFjcnEvNLU9qaF1WmJF8pREq3GANiNY3D+ryelcR
Qw+kaX6RZaHdj+3cXiRRJjjtYs+w6xGOpmLOuJlqdEuiyzD4D7JsBKe83YKLW8gT
NvbsM4c3GGkvK7c2C7hFM/acrFQkXNJqz/Gm0ZxLOwy78BAeljuKnAGlrSdnR/l4
12mU7G/Aq9B9qyAZwF7YYuLkc+yQn8Ufr90pZm2VccfeVA4OLyzFzKru52RiyTtV
IBmyJtFxXipTaL5fviDNnFIVt+qfzFvAeJ7fb4hPAYvUaFrOoPZD6SB3pWiKBJu3
RwZDNbXAPj5lgXIUC6Aqm6BSKVSJ7/GSh0TxSrvzlOZNN2yFqXfI7o+NDJBeRvH7
KXkzwXqthpris6pE+htI
=F4UR
-----END PGP SIGNATURE-----

--bWEb1MG/o7IKOlQF--
