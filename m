Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaEIEqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 00:46:35 -0400
Received: from ozlabs.org ([103.22.144.67]:47814 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaEIEqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 00:46:34 -0400
Date: Fri, 9 May 2014 14:46:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tip tree with the block tree
Message-ID: <20140509144625.67839275@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qej2u6=KKbwgETbPXJCg0Tv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qej2u6=KKbwgETbPXJCg0Tv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/block/mtip32xx/mtip32xx.c between commit b10fd728b985
("mtip32xx: convert to use blk-mq") from the block tree and commit
4e857c58efeb ("arch: Mass conversion of smp_mb__*()") from the tip tree.

I fixed it up (I used the block tree version which removed the code
being updated by the tip tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/qej2u6=KKbwgETbPXJCg0Tv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTbF2nAAoJEMDTa8Ir7ZwVZU0P/0uEvyZ/bw8Hqi957qcpGOGI
427skh+t1pqyjf0sA2/3L0DENDW4eSQ7XeVNWDbt5pCdhUXuzIAfcbABDUAd73G3
6Ikyv0EZNeqNmN69GGU2QhGZEsVeM8ke9jBOqdGLxkldOissgIM5MzD/y4WaBnIk
WBy5bnk6Yeium/Y3oAZzEiap2vsEm7PGyrNlTFATdTbiMpUUDmne1kiz4bh3Ky0P
IIxCNSSU4nET4fPBKDI+PGUgRlQ0fHs6azpbVBPcSAFa33w2Vuz4u5emBZY0dzQu
XV1lOWPiB/Nsf2dm8G1b2Yat3K+IWbndWBYJTl+875PRwHLV9yym2+gKJ0fBXo9+
pETnhkTCoafz9ruIjsDdfTnyeQyrF3AGZWY00ApGIjtKhmtH7Y8Iz0zDFZRP7SCv
0kPow8q/Zshx+KhY+toVUdIMJNRPpS9JooCcm89ar+oXC9Wq1XtApvl5LLbcfvd6
2XC250IB6GjYrZCqL4xmuzso1es9MOVnUGGI3ue9ZSEz3hI1+SuIY3QfdgXeIoX4
aRVnmM6shdR1G59aXCdjC+ThdBuAn7eC7L9mm9MB0mNeKkLQV0i2IOW0VsKKmUw7
9qqQ724H628zfnsx/NYG1U2Kg5u3tV0YazsqJuCBV7bbWKo4MtmD9obWThM9MWbS
f6WZZQExgJ72ZSNN4NFY
=9nKK
-----END PGP SIGNATURE-----

--Sig_/qej2u6=KKbwgETbPXJCg0Tv--
