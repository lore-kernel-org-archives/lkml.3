Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbaEMDQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:16:26 -0400
Received: from ozlabs.org ([103.22.144.67]:33688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbaEMDQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:16:25 -0400
Date: Tue, 13 May 2014 13:16:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>, Steve French <smfrench@gmail.com>,
        <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@poochiereds.net>
Subject: linux-next: manual merge of the vfs tree with the cifs tree
Message-ID: <20140513131616.59f41b7a@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7jgW=iFLg/NxUdPohlpKI0m"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7jgW=iFLg/NxUdPohlpKI0m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/cifs/cifsfs.c between commit 485c4e72d0f1 ("cifs: revalidate mapping
prior to satisfying aio_read request") from the cifs tree and commits
aad4f8bb42af ("switch simple generic_file_aio_read() users to
->read_iter()") and 3dae8750c368 ("cifs: switch to ->write_iter()")
from the vfs tree.

I fixed it up (I dropped the cifs commit, so this will need a better
fix ...) and can carry the fix as necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/7jgW=iFLg/NxUdPohlpKI0m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcY6FAAoJEMDTa8Ir7ZwVInoP+wSZYnMqydKFp8qkDgQBml5m
oOvDeIkPJF/adf2dsDEt2YM1oBh7l5rLNQrFg2mWWXvAO2TW9RkyP0LC3hRR8c+0
gl7DVCpf+ZYj0dkjbXROxGqd+b7QUyxe/bZfWsN8kshEeqnFzx3uasUUEDC8KoSy
xGTXbWk7A/y4vH6UQo1IZnzl0Ki8WyYcf4QgkGHpmy4tbVPFmDBu4QDfhfdrOGRG
h7aglb5SPwwCgFVDmZMR0D4sSwbFprt6WsrrgjrxlVxbs8Mz6ImL95dertOC+f5o
MB0LyQHygELz8WWKWbdUdPZ1U3nzC0pWEVIN09HqKZV24x+HowCRZaEDyLBevMu+
FzalKvJMnoIBoBP1jJTcNWEHoRkVN+m7PkzB6IyS2wzsDgXrXpG8QXg7wjTTlvm8
WhtKlqSxvqQ8ZONHlHqjtoB0qq7zyMPbDwf5886nyoS3zdxN+xgIBDEMQMKiAxrn
+m/wHZDSaksPdFrbYgpx5a61ksZEh5f3jEnUh4GaNMn8ODTfRACY52r0695bV2lM
4Zftu+c9MV/0iP/xpoTz8iFWiG6ZoePif3j0GN/BTuJoyp2zD2NTIWtdqUhAUaU9
EUa6qbu5Noucu3KBH20/cQpx8EWNy/NzAhgkFG+lAe4YbIlUM7BIljjpM9iojlzm
CoRiCd7CLb54ZWUNup99
=jrm1
-----END PGP SIGNATURE-----

--Sig_/7jgW=iFLg/NxUdPohlpKI0m--
