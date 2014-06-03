Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934346AbaFCXIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:08:55 -0400
Received: from ozlabs.org ([103.22.144.67]:52642 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934243AbaFCXIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:08:54 -0400
Date: Wed, 4 Jun 2014 09:08:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failed to fetch the aio tree
Message-ID: <20140604090846.3b4fd54c@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/se58d1+qYFmoUH/0.h+.pMw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/se58d1+qYFmoUH/0.h+.pMw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Benjamin,

Fetching the aio tree (git://git.kvack.org/~bcrl/aio-next.git#master)
for the past 3 days has produced this error:

fatal: unable to connect to git.kvack.org:
git.kvack.org[0: 205.233.56.16]: errno=3DConnection refused

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/se58d1+qYFmoUH/0.h+.pMw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjlWDAAoJEMDTa8Ir7ZwVklwP/RqRlgEs/NGx7W26jv5mKY+G
59xqJfi8mqdU1Uxb+b3SdJz8Ka8+d3P3mbCH5iPX0rlvqm8dZCUov1XC3icra/I6
9aHQxgxqACDYCFjja28R4C3AI/KKVB3tJAbQm6UCqp1WcHfH+IjfB9SQjE4fflCX
Yu0U1U6hNEQQQgSQpIn1EJapdNEjTekCrFpwumZyKldojoQttrbB+SFAb9sq41Vo
35QnaJPdKrP7ZX3cPieHg63EwztpSzcBagnmKYgmaP2IUTR87WeKIdzGhQHQ3LVe
9UV7zq1jd41gwSTCfDAYn7751vi2K2vuC5HO36uaOm39zEzOwc5xcPtZv86ljmWr
pHIBoeXxEeYZ7hxmJ5n4FipDbTScIksaBGCv+C9BwQaXtWxU9YVIxBrp8VaIawzS
57XqRSBbjAdnfSC01vV0sC+x5UZYd66VjJyzbeTKiVcmM7gY+I/3bttdBbGsZlyu
szVPqgLeQUCpLwVMmFyTu4VE9iwOlyklMdaUQEIKZcTtKZe8Z6FGcrYuuGLXSo78
RaHmAS24vJu1XWp5YgYgA7OiiDruK4NOJCGRLJryBLBgt4XVzBaKySnc60Hz232/
FBDlN9ZX0wJ/9aCZMDh34NZkqQb7ZOK3UWDoAC3njl6Jzr3kbpHati9m+rcBmzfB
9OhHhjovjPrgOd5dUG6+
=e89n
-----END PGP SIGNATURE-----

--Sig_/se58d1+qYFmoUH/0.h+.pMw--
