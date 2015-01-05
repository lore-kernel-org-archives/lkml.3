Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbbAEXD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:03:58 -0500
Received: from ozlabs.org ([103.22.144.67]:33815 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbbAEXD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:03:56 -0500
Date: Tue, 6 Jan 2015 10:03:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error fetching the microblaze tree
Message-ID: <20150106100346.6dbab82c@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/nQ8BG+CCOldFQarC4Mn0Syk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nQ8BG+CCOldFQarC4Mn0Syk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Attempting to fetch the microblaze tree, today (and yesterday) produced
this error:

fatal: unable to connect to git.monstr.eu:
git.monstr.eu[0: 89.31.40.14]: errno=3DConnection timed out

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/nQ8BG+CCOldFQarC4Mn0Syk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUqxhaAAoJEMDTa8Ir7ZwVvC8P/1Br3LcIxvx4zMOGvhjJXiUO
D1DEoO0EkXt7yP6KaxNBj1IUh3EuVuZgFjmwSMnTMLSKEzlflKbC9l74JRTdjbDW
mauCWyseYWXPh3r0HJt3N1Kw+dR2Q0CvRrhT7NcuCnPTIuNgeJOAjFDFLSs3H8TY
BeuRZqoft11cxAlavD31MDzZjC0xC6xFxeiXvwsS4uk6y2PK43NO3rvcEMmGK/tz
c1SUOHZb/ZbXyjs1g10H5RAXMzUbv/K0qDRQswK2Mtz2XSutq9OJbBeGL9YOAufg
wHnTSDCv3Bbo5u7ndPX87oazL8JVSO0JGp9qW+B7o3b2ihELZZkWoxsgoDdm0vM3
AGI2W8w70xW5RC6p6qEiZZ2XZHK7Mdlh/tR3sIvwyq7zm483layWqrX/sNyOWzGI
EiteoJlk+h9smsiueFp+RVk+Fxg4hj5tIKXV0MtEb6Crw0GhpOXtyX54vpdQbTx6
FXLwT50jnvD/sCnPWxT/+jHy6uLPlgX5i4guSeCpgd7ZBMY46dhD3DZVdM0MLAw8
vizgh5MpqWtC9W5Xm/61w5bUiPOlJwNaZM4rKjbJYzOqzSDSrWRhJykYzru1UdTU
9aDQzWl/IlJfIwdfVF1ImFP7h+ho1RGpgSWsz94dtPmtLJEei/Ip9l1mzHz+Vvct
E7NgVSod4+SUj9kd5D3i
=cFyM
-----END PGP SIGNATURE-----

--Sig_/nQ8BG+CCOldFQarC4Mn0Syk--
