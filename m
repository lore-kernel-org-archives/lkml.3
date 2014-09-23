Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaIWAje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:39:34 -0400
Received: from ozlabs.org ([103.22.144.67]:57231 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbaIWAjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:39:32 -0400
Date: Tue, 23 Sep 2014 10:39:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, mhocko@suse.cz
Subject: Re: mmotm 2014-09-22-16-57 uploaded
Message-ID: <20140923103925.08b35d84@canb.auug.org.au>
In-Reply-To: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
References: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/uxtxwePAT_oDjG/A_xG_gAu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uxtxwePAT_oDjG/A_xG_gAu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 22 Sep 2014 17:02:56 -0700 akpm@linux-foundation.org wrote:
>
> The mm-of-the-moment snapshot 2014-09-22-16-57 has been uploaded to
>=20
>    http://www.ozlabs.org/~akpm/mmotm/
>=20
> mmotm-readme.txt says
>=20
> README for mm-of-the-moment:
>=20
> http://www.ozlabs.org/~akpm/mmotm/
>=20
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
>=20
> You will need quilt to apply these patches to the latest Linus release (3=
.x
> or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> http://ozlabs.org/~akpm/mmotm/series
>=20
> The file broken-out.tar.gz contains two datestamp files: .DATE and
> .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> followed by the base kernel version against which this patch series is to
> be applied.

This tar file is no longer expanded into a broken-out directory?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/uxtxwePAT_oDjG/A_xG_gAu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUIMFCAAoJEMDTa8Ir7ZwVdAYP/RlFhlBUC7oxCcyphZtpA9uY
zT/Rp9zsJMgsqgnqZpBDTfHDuSFqltgWS+N5FTnkA318DcnnBtgbnL/BYeqqTUTp
UOobzQGUS/tiUee2mg1Y3QEBcqruPy1lSYIn1MuXXqYzz7rCpOuwkPtbTLVbRdXY
wpRI6I4Yt3YKr9RKSiKEH8nthwrg3TNgguR1lvxY7ltiBdqWCrMSOQdeF5w8c0F1
Kz3nesRh1bEo+ZtikdZfBq6kolBIRyDL7d6Lb159zany1oP32nhAF01muBRqRNjW
HTrQ+23hySNOaquqlk7hiclWrP/K79BRv+9/0cYdZaCPrD99/oGaaNtwTYeq/LYj
3AFIPVrAdE+Y8tNZNBHM9M+zdq6pBWbeChCVc3XVYOQulpWVMZcO0LijTVaoRSbz
PR5XAa9U1XkK1jBn72GgfAZTuW+l8Qr/nW7uyuK2PBVwDg102/TJg2+JBGTqbvOs
rzwBzCUG7h6vXZDwaL94txogzWh0xrd7tFuKlNGsFPzhgkZcR1vRMXBKsqquvAit
lRbV6QjdRojNUNU559i6oFW/+q8gv4Kw1OiyDl8xGeI5ZTTXwyMBEohUoTfbokpw
bDqyYkf+UdPOjIKThZ2AxIhJaf4a/px64qrvjI6yx82HOZBP6FRILnk9fmCjjIw8
J3alZIcz4u+lUtDI70ue
=pSwo
-----END PGP SIGNATURE-----

--Sig_/uxtxwePAT_oDjG/A_xG_gAu--
