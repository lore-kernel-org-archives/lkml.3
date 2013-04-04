Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553Ab3DDGMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:12:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58216 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab3DDGMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:12:14 -0400
Date: Thu, 4 Apr 2013 17:12:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20130404171211.3d359e39ca54e074f122d541@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_17_12_11_+1100_lm2EqbNn1KmxB7VV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_17_12_11_+1100_lm2EqbNn1KmxB7VV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in mm/filemap.c,
fs/xfs/xfs_file.c, fs/splice.c, fs/ocfs2/file.c, fs/ntfs/file.c,
fs/fuse/file.c, fs/cifs/file.c and fs/btrfs/file.c between commit
36bd5dc0c4e2 ("lift sb_start_write/sb_end_write out of ->aio_write()")
from the vfs tree and commit "fs: return EAGAIN when O_NONBLOCK write
should block on frozen fs" from the akpm tree.

The former was removing the code modified by the letter, so I just
dropped the akpm tree patch and the following "ocfs2: add freeze
protection to ocfs2_file_splice_write()".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_17_12_11_+1100_lm2EqbNn1KmxB7VV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXRm7AAoJEECxmPOUX5FExDEP/2OSVv/twwkkewBAuBkAG51I
a60ZaF9WPDWB4WFj8gy5Dj8snwIrS1jbq0SEh4dxF0gQqaZhskQvZv1V4XTlRzD9
shGq+6cTJOyhj8h28m3GYJ6/cE+2lD6tNLwm5Pi4K75gvmm9UL/R1tN7ybwvV4IN
4kzxPloqmRHgtG+buxpd47bGocJzDuZyJfVUra4mgwiDj9Yf794HVVD5X+9NwBzp
ZU3qc7z+rBUphcNztFv40IE2YjC7u4h0xdFdcw2isp44VitlpXUfwQYuILy1Omvs
dMk9UsOHnB1LWzt+FUuCb4ENHeoXCMiz0xcVqhuCTQFxg4IQS97v5wbrrM5RGYYD
WoRfPQnmL6aT0GqnF2ZaGkmLiAgYHrLJ8f/WD8DW6uAZuXd6BcQSDNz9zGo3KPX7
pyq9cGyGwUeE/WLVO+/+5HKCQzV+HpBIjw56SMsRgaFRsHlCOYH6qFPjD1qrvdYU
e4DKb6XvyV+Vb8taKkFe8tSMS7o3QAN6DL7opB79TYFIF0uMP0D8b2mD+2bS41tR
B1eHGe8OpduG9xSBJ4thsoYHfgkX1PhRAyTSPzQxeZpZXQlduApqt6akTklF9pld
ZIJ9w2vawlWC0VaPU3AKzRR3v/A8yNdEtczJ/CsMWqZQq4UYMC9vMwdXdFwH9Dbq
aQT4jHq49JLmjD584n9L
=shJe
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_17_12_11_+1100_lm2EqbNn1KmxB7VV--
