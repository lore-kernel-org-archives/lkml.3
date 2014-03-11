Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaCKTFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:05:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33820 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbaCKTFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:05:40 -0400
Date: Tue, 11 Mar 2014 19:05:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Colin King <colin.king@canonical.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140311190529.GY28112@sirena.org.uk>
References: <1394537109-25162-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctckVVKmWMvUcUMp"
Content-Disposition: inline
In-Reply-To: <1394537109-25162-1-git-send-email-colin.king@canonical.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: da9063: fix assignment of da9063_reg_matches
 to NULL
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ctckVVKmWMvUcUMp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2014 at 11:25:09AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> cppcheck detected an incorrect assignment:

Applied, thanks.

--ctckVVKmWMvUcUMp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH152AAoJELSic+t+oim9CV0P/3+p81PvFABF7HZYwuL5SFaC
K010722DvqnMmzwx+gpSX0zBq2lokivSp5j/DcNCkJKMZ8bxhcqq48xR4+/lKYBZ
gZ8UNKhOazSh2IWQWE6OEx0UG2BfDT869/xTWD/ARF3+NiYwp/5gtBxZmv53rbJz
JHhQpvYRtNx8DouMW3Z1BW/rCiPB4HjCmG+LbBBg3dmfXsRl0STk+AKEqACXMsql
36OtkleOH0DCKGuk/WL5/TPDfIocEYyUm1qTdAPGoUGDYFQonKfvasPQoeWESWL4
C0jShDzdHsbz0mFK+4FovJrwpe1RiNT7IdOhaCDtZX5wlJ/ci8RQ+FmHyOvu57Gd
SJuY928w+iEJmulcMrG/Vn++AQyFuC6L3YMgGbMtzh3jdNxfwedtzG774zum7+1x
vzdB6L8NGcTZv9ty2KqyVAtt6BydNyeuTfm9ot8T9GKaiVBRtNU2rRb08cRQ7kcq
89Q/MoJP3Bg3xfYzgGRQp7oSJLMwKy3bnIb58gpE7ucamYYIooSYOHPa3ZO8exre
zWbdlKjEkNM8JCIf5FtL/jtzlHUurrsgHf4xYMk7a1fNgN+FA986OxPRHDJFz0Ts
aGsGOncWbuZEECzukgvGw611KieaymJWXhiZc1gSSk1/b3SoYUvWtXrV871wGRz3
hNHKIfp2Qy3tAXXphvWe
=ZFTl
-----END PGP SIGNATURE-----

--ctckVVKmWMvUcUMp--
