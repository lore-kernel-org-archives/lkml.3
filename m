Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbbA0D6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:58:39 -0500
Received: from ozlabs.org ([103.22.144.67]:40707 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbbA0D6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:58:36 -0500
Date: Tue, 27 Jan 2015 14:57:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: linux-next: manual merge of the block tree with the vfs tree
Message-ID: <20150127145754.03e711a3@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Vici=vM5IJs9rA7WaqkLRGA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Vici=vM5IJs9rA7WaqkLRGA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/block/loop.c between commit c2ca80413553 ("loop: convert to
vfs_iter_read/write") from the vfs tree and commit b5dd2f6047ca
("block: loop: improve performance via blk-mq") and several others from
the block tree.

I have no idea how fixed it up so I just used the version of the file
from the block tree (its been there a while).  Please have a chat and
figure out how to combine these two large changes.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Vici=vM5IJs9rA7WaqkLRGA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUxwzqAAoJEMDTa8Ir7ZwVsP0P/i4DXvQ8tFdxL32FPlVIfeEh
N4Yf4KB8ErP4UExmea6LCh1gymnLP8TV+fsUZK7fLHkP/eY/lYyALjX0RHeFImPE
aUVRTF1aEZxU322PhXKBSUQkQZ2DLMeWUmPfe/E53W4pNjfUG3TqwEmbbosXCBhP
G2PcS/IOx4DoTvGcX/DJsR55i0OvwTtZJ3qesF3kmUeWDFZLBwzSHtsf2EAVe9m3
Uy+jfDX26vuNdPuOyQIBq/7d9R2RmNo58J0QTjisC+vj8+XkgibyFdFnoVKThbp0
tvaatkYt/JItr5jnA5YQOdIAvmLZtE9we2OQ7ZZj/13rRhv+7Y3Rlpt/uvuhjSwo
LeADvICFkMgCeKcArtlpDJGeapXLAwteAj5ZfwtcJf6FhdXzdcDMn6NHYJaT0zoq
/eGWqXzoBKNwNBTElblHq3kAbz4224Wpzs6XFdIdVupiOyxPj/eUvEhEcho4gjkE
eloJAWgdzAv0vGMXnwzn+wCf8HXb2tYnelGRcc60vlV2VfQGxmigVZAdWUfTtYRF
6FeKn37mOlKDtTH0MrgvJaYno8JAs4E4UiVUcempxUp/xKZAzcmSLy7NjNvh69mp
xqtJzWP3cHefM86lCSAqaxzWHVaOZw0axH9dNlEo+ZSsyr6BRtJif9EMh1fYY+mc
IH+WXgqazIXHt5BaO9nf
=jiDM
-----END PGP SIGNATURE-----

--Sig_/Vici=vM5IJs9rA7WaqkLRGA--
