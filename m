Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaCBNVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 08:21:32 -0500
Received: from ozlabs.org ([203.10.76.45]:49019 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbaCBNVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 08:21:30 -0500
Date: Mon, 3 Mar 2014 00:11:25 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: xypron.glpk@gmx.de
Cc: grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree-compiler@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Remove dead code in util.c
Message-ID: <20140302131125.GB12916@voom.fritz.box>
References: <CAL_JsqK9Wquv6kgefyPvy0JqXNO7Cx2+iN_ss=CtgXnKEjrF-Q@mail.gmail.com>
 <1393661507-7197-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <1393661507-7197-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 01, 2014 at 09:11:47AM +0100, xypron.glpk@gmx.de wrote:
> From: Heinrich Schuchardt <xypron.glpk@gmx.de>
>=20
> xrealloc never returns null
>=20
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>

Applied, thanks.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTEy39AAoJEGw4ysog2bOS7NQP/01WNPmmsaOS9OCN8P1n9Xvv
4QkAzzsX7kCd6sfJkgDZdhsQN72AFnDb11iCeU10STlZz+PPnJ8LQEfZBSrAH5tL
7Iz3FMwpinQ1NYsuGDVA5gwzMD1wEl/9Qq8Qmt1OmNhE5A4canioSpmn0Qmut2us
oCVLPXct1Ix9VB/t+0aXaq8LYG1SgeFQcLYv8y8ZewcHqVdKwYWx1c8gmL2M5Kup
1zlTOGU7ZYwH3QnvMzbUFZrpBxHFSymwnqU+vrqcNfwT3xAlLzqRQ0ye6bYRxOo2
JjMOzikvfBekt1CT16PP0mpDFtHOVa52qthp6xLNyRXoyG7R2/i/Du/A3y91Tz3H
ycTbhvnPkZgaV686K+IdfbFiln9XGbPKoGR9rgCDUU+Dyvw13lBywXQFtLerIxMa
ajqWzVygPe1GL4/usfzGM6uAly0+krQu5brpyAM+cdo9p0HNknHYUppgtvphXAN5
YbTcQkhwFy+aagjsUsICVwMIjSk96rEV4yBsmqO9Ap2TQjTPU+UU3eI7Aq/vZPti
gKWlXisNhtKPImeNKqt+SxDVjoku6H8rjKNsE3iWF3meTPWQYSKTVCPShJvD1tQk
BQBhqim3kfYqcqaAa3avSf+GSWdwBKy9qTQMzkWOZmfHvsUf23JTktbZdgf4oQ3y
FxY39GpJ+9527QYp2Lup
=OVEe
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
