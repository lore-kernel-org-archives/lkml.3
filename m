Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbaGPAYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:24:25 -0400
Received: from ozlabs.org ([103.22.144.67]:47599 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933513AbaGPAYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:24:21 -0400
Date: Wed, 16 Jul 2014 10:24:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 3.15 14/84] serial: imx: Fix build breakage
Message-ID: <20140716102414.337e58ce@canb.auug.org.au>
In-Reply-To: <20140715231713.621762682@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
	<20140715231713.621762682@linuxfoundation.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6td9aHF6MDioJ97cE+p4+hZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6td9aHF6MDioJ97cE+p4+hZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 15 Jul 2014 16:17:11 -0700 Greg Kroah-Hartman <gregkh@linuxfoundati=
on.org> wrote:
>
> 3.15-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Peter Hurley <peter@hurleysoftware.com>
>=20
> commit 8bec751bd63847b4044aab8b215db52aa6abde61 upstream.
>=20
> Fix breakage introduced by
> commit c557d392fbf5badd693ea1946a4317c87a26a716,
> 'serial: Test for no tx data on tx restart'.

That commit only entered Linus' tree at v3.16-rc5, so this fix
shouldn't need to go into 3.15-stable (unless the original patch was
backported as well - in which case maybe the backport commit id should
be mentioned as well).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/6td9aHF6MDioJ97cE+p4+hZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxcYyAAoJEMDTa8Ir7ZwVx0gP/R2oWgygFOkNWn127m/snVn9
O5/32fPiwHJdlRQOZifx6vGNGRKzWkhz02bZoHb3g3rM0zdqnsKAs+2qd0OQJEXK
Nc4dY9hx8hT4n2uGoy79GiNU4exJpJGEWjnh7eRvx8suglFGFcAEsosbisReGGHp
8K1O7ZB2GfPnBCiR31d7zYqjDZzZ855kPlGqolaQCt3cKmzbzEwPJ7x9v1dPrVi4
7u0KmK54VVI5CohDbfqjehM8EsRtF6psh9KRUrG7Bcsf0W1fUfVbvSxlz2DS67zE
FAP9ylNnClPz4ZA5Xj0qPxlWQNmV+wjPPAOxaUafPPQI5BJ0eaBfxD5geQTfLuG3
qO56EtuLDL58k96yziKd3zkYLhJx8BMzKyx33/xaAf+xCiDKbKa7GeCz2kDVPJLr
h181kThJCgL/yk1LE+FDgmdImbdGYtOcDc/NH7sb9gGvBk+9US7h0Su4/3KyLgPk
y+FJN+a+mSfr85gdFAFQVq8ZNHgWV8acVudOQMlEfE69Gn74fKd3iOtO5x1BuVf9
OrgNQNx/TMswFfbCwqMqdvwRdN0yyD/msRFgx1DAm//mO1cq7at8Llj0pUcHrLjt
qFXq/qbnziSu9wuoKQucW+Ja3g+w163JqYD1icaBwdq+LTcGXUlbP1ivcHiGp/MH
mrQTkG3A6vQsSibm5hnt
=vcgn
-----END PGP SIGNATURE-----

--Sig_/6td9aHF6MDioJ97cE+p4+hZ--
