Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbbAUHqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:46:23 -0500
Received: from ozlabs.org ([103.22.144.67]:39208 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbbAUHqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:46:13 -0500
Date: Wed, 21 Jan 2015 18:46:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the akpm tree with the block tree
Message-ID: <20150121184606.214150de@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/PlKb8MWTe1BuliYZ4z+McCT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PlKb8MWTe1BuliYZ4z+McCT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/filemap_xip.c between commit de1414a654e6 ("fs: export inode_to_bdi
and use it in favor of mapping->backing_dev_info") from the block tree
and commit cd5ca6e1eb43 ("dax,ext2: replace XIP read and write with DAX
I/O") from the akpm tree.

I fixed it up (the latter removed the code modified by the former) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/PlKb8MWTe1BuliYZ4z+McCT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUv1lDAAoJEMDTa8Ir7ZwVr4sP/1bhsho5BGTc9Xg17kLoBNAp
nJr1A/yusRwZ2wALZ9CgWwO8rP2YgWC2JwUoYs9F9ihM8zsIwfLYxkBMivHeTDA1
bsJFsoZ4h15dcU+5H/QosIrAsU3AhbBa4ETgQU65dSi+EjZdFl48mOg1+Qr0m5EI
5HEVYWc8YcFrdnZzkR/Ga6+5cCUjNuCWCOD9830sXo5tLHN/o2LmreFYCl8GNrKP
4RO+CABotfAFx+UlrKAepztXGMYV1Q3W1DUoQ8fXBZEGdjkqadozLtijgKFskG12
jqO9KljYuCZwv473er991nBxlmN9cJTBMD+quwp1X4w09sa3/r66sKEy7N0UUC/S
dk51HrB2yIWhOtzgHgfLZfrHBz7ZsDqg6AtZKEAf5sP34viaCRgmTlpamIpBXBYk
yJSItoMnfGlgVnxx11bVhhY1ms8vzwh8U4Z3WVyi2oHBYphgOSC9zhn33rUi/nQP
VMm/W3eRx2wCjkwU7dExhpC8FQWEaSIoGLtnOyxm+bxc8sdthPh4mv0W0mKYet1J
wAhSEE7aTLpBjI0iPzfAFe2at7dmgjtdrLnUKfoOpyNGlg0sEI0kJZaB+XQ+FEfH
7catjr3LOhGI7wAffsFFW52wPQF3b+hs0QX7am69qJea9kv2XET/m/ZKnOtkycfy
+l8ShQ2Dyc0DwxA0CQz7
=WmIk
-----END PGP SIGNATURE-----

--Sig_/PlKb8MWTe1BuliYZ4z+McCT--
