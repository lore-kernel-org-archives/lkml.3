Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750946AbaAOFbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:31:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbaAOFbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:31:08 -0500
Date: Wed, 15 Jan 2014 16:30:55 +1100
From: NeilBrown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: Re: linux-next: manual merge of the md tree with the block tree
Message-ID: <20140115163055.24e2bae2@notabene.brown>
In-Reply-To: <20140115150743.ff3de076048b32e82fa5ba27@canb.auug.org.au>
References: <20140115150743.ff3de076048b32e82fa5ba27@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/e.LDbpvrug70YpxkPZMxikS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/e.LDbpvrug70YpxkPZMxikS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Jan 2014 15:07:43 +1100 Stephen Rothwell <sfr@canb.auug.org.au>
wrote:

> Hi Neil,
>=20
> Today's linux-next merge of the md tree got a conflict in
> drivers/md/raid10.c between commit 4f024f3797c4 ("block: Abstract out
> bvec iterator") from the block tree and commit b50c259e25d9 ("md/raid10:
> fix two bugs in handling of known-bad-blocks") from the md tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20

Thanks Stephen.
Those md fixes are now on their way to Linus (I'm hoping for 3.13 inclusion,
I might be lucky).  Good they they are easy to resolve!

Thanks,
NeilBrown

--Sig_/e.LDbpvrug70YpxkPZMxikS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtYdDznsnt1WYoG5AQJ4RhAApQC/r3v4Ze23mlnYCs5V9GEQO4AZ9sz4
m3XzgAzG2spw6Z8nLNWtIdgQ1r0NOUG+YQWv7P4Zft3IqNWin9jWBxUFhBMi4rPJ
zVKdYUmStnbFB4EvLWdODioSUVu5y5BEisErVfhjgm5K4xukjw3cFKgW8eRX/7u0
asv/NwPjsL0+le1VA1JnF9jZxlzEg1JI+g5l6sz9cTNImAAfrFZZucExkmlu1SkP
ti3lsOzk2KgoXsHZAwcHPEhVJyWEDMdoxXAsTfkn9wQeYXgHjHh6o7j3cNwmpwdZ
ME6bmpuJ1mA4WdlIRDlencmoY+Xk3NS+Os5qY4z60y53MlbQJ21+K0vmgAdV4Zfj
cj8U52oqXTMSF6piaVyaXkW0XElygaLbGzBn0TFeHW8V7oYDqXnMlKiNkUmKVwPI
zda8UjTOhdlQ4dubdsxR/ZIjMvcDqXpxfQ2XOF79B1IvaZ0JLOvgsjGlKn4n1cRQ
PKKP9aCyFNNLjHuAfQsd+hTWrL7QWNYYhqVe14hVl2f7KrzxWOkLHqPqEnhn/Jzp
yao1X2wCGvnQj1N+ThtfyVGxn1qf4HNG00+8OzHaDf/oScsfckSPdzZN7miNATdY
V6/+a/2VhK2vNIW9sdAwt8/pQiRAjR5XorXSP9HCif8JJ0Ro4CLgywj6+t+gq6BZ
A702HF9LDz4=
=NFMA
-----END PGP SIGNATURE-----

--Sig_/e.LDbpvrug70YpxkPZMxikS--
