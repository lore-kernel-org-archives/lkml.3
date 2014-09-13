Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaIMCAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 22:00:00 -0400
Received: from ozlabs.org ([103.22.144.67]:49723 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaIMB76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 21:59:58 -0400
Date: Sat, 13 Sep 2014 11:59:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        <helpdesk@kernel.org>
Subject: Re: linux-next: Tree for Sep 12
Message-ID: <20140913115950.0331951e@canb.auug.org.au>
In-Reply-To: <54132FC7.1080004@infradead.org>
References: <20140912173817.3c719e7d@canb.auug.org.au>
	<54132FC7.1080004@infradead.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UyI0KC/UN4Dm+1CM=2NThch"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UyI0KC/UN4Dm+1CM=2NThch
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Fri, 12 Sep 2014 10:39:19 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> On 09/12/14 00:38, Stephen Rothwell wrote:
> >=20
> > Changes since 20140911:
> >=20
> ---------------------------------------------------------------------
> >=20
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > (patches at http://www.kernel.org/pub/linux/kernel/next/ ).
>=20
> No patch tarball?

Hmm, sorry I didn't notice this:

Pushing patch to kernel.org ...
patch-v3.17-rc4-next-20140912 (1/1)
  100 %      2,494.2 KiB / 15.7 MiB =3D 0.155   1.9 MiB/s       0:08       =
     =20
   2554072 [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D]  100%
Compressing: .gz: 100% .xz: 100%
Calculating sha256 for /pub/linux/kernel/next/patch-v3.17-rc4-next-20140912=
.gz ... logged.
Cannot open lock file

Helpdesk folks: is this expected?  This is a put of
patch-v3.17-rc4-next-20140912.xz using kup.

Randy: I will try to reupload the patch

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/UyI0KC/UN4Dm+1CM=2NThch
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUE6UbAAoJEMDTa8Ir7ZwVFkkP/1ccbnvz0yfVCVBV/BbkIYux
NxpCHnsHIQPMUr8H4bTPZ60/2NuZk7RBQNJCtfgQo0hZaw7AaWeIUYrSwo60VOxp
ehrRsVge83cYQbPbnL+8uRduFImwkPYIV6LLozmcNyOp+H6zpyZ3oRT0fEfkTkD3
dyMqZ6j+6DyOLzv6VhQh4/Tp/63O58Ra0zZjZ0CBv1CDlsXpKJ6DgoRu/vPOFGWW
vHA6dHqiaQfnkPtj+yTbGmiwNlE7orQmmQ3BXsmW34Pw4fpLV0UaCfQ++N7dbuAS
RHHskL07GC1ycaKTxnaz5drUW0kXqc7on8FklS2nlUZxyk76XlZkfXLvLfu8JMVX
91lpMUHFJinBNr4q+rV6p/XTecbbKTGb/FjJVLQhhK+6Bhxsn1TCmT8GKVt0+wfa
7jqHHBfSopihI1Vgg9GpPHsc3s0TX9T/dJ9yCFeNXf2a/n4uv8RIkuSJ1okqOhjy
TK+ag7XdV+cU72AUxpi+9g9dERBBUB2z80f+DMz945FZOJQX3SDBC751vBdsB4I4
CK7hMNLLvrzuiMfE+Kv39DEY2rALkltXbKiTPsZUZRmSEW6MvtPiYXTAGdJipuG0
AXI6UJO885QdEFzC91lXSLlZ9UP8R0nzKb8kYrmBhfhnhaNDtkDaGgvRUUYopAh0
qNH1YR9mRiTJ/4fRD4K1
=BO+i
-----END PGP SIGNATURE-----

--Sig_/UyI0KC/UN4Dm+1CM=2NThch--
