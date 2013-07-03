Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3GCFWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 01:22:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44158 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3GCFWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 01:22:48 -0400
Date: Wed, 3 Jul 2013 15:22:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>, David Sterba <dsterba@suse.cz>,
        Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>
Subject: linux-next: manual merge of the trivial tree with the btrfs tree
Message-Id: <20130703152241.d9f23c7709f13a40493656f7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Jul_2013_15_22_41_+1000_=pcOMf_/QdbFHNBL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jul_2013_15_22_41_+1000_=pcOMf_/QdbFHNBL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
fs/btrfs/free-space-cache.c between commit 905d0f564e9c ("btrfs: add
prefix to sanity tests messages") from the btrfs tree and commit
8b513d0cf603 ("treewide: Fix typo in printk") from the trivial tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/btrfs/free-space-cache.c
index 7517285,2750b50..0000000
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@@ -3202,7 -3200,7 +3202,7 @@@ static int test_extents(struct btrfs_bl
 =20
  	ret =3D btrfs_remove_free_space(cache, 2 * 1024 * 1024, 4096);
  	if (ret) {
- 		test_msg("Error removing middle peice %d\n", ret);
 -		printk(KERN_ERR "Error removing middle piece %d\n", ret);
++		test_msg("Error removing middle piece %d\n", ret);
  		return ret;
  	}
 =20

--Signature=_Wed__3_Jul_2013_15_22_41_+1000_=pcOMf_/QdbFHNBL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR07UlAAoJEECxmPOUX5FEi50QAJTqp5o36dxEblrAbw+4K9XM
PGekDyfeLVwDfiVitG7+3Sg6naUrUmmh/7oEEmD+pDZ8Sz5797OD9c5OMvcXr8by
gQc3phahswqA6zDeZloBJGjyPYDmkYLvZ666ua9gi6Jp+0hFh/oHpB+vTA5APT7U
hoqw2agoMdbVi2i3tzyWFQNPDpEWgsAGheIq0IFlffz/J9gab7NMzCss+JEorFyW
hkouop64iDZxpDyd0Au15JozY5eBIoSUSich0H1lzSYD2bdgEkZ/x0zrwetNrdL6
A4weAQsRpLWBTvirsPkl2gOMwZBYmeK1XlQbu3aXvYaFwPo2axbNdt05IHsuwSDV
eqUNArzO4+yBUCAXfrt7rvYlMzyVxc5qrYhFSGsmLrJJ3gRtzWLIBYo5na4J9Mba
5ZRJZoCt5xwjPpCjfbm3bvWUcAmKuukuebg0/ugWapJfHfq2yc8jsIdANcwoTTfe
6DLFRbt+8CfmETaxqgU9QZlRpvJaOcatfrD5HLPc/IWku2f9RHY1WzKIdBqicEMi
A1rQaBqIDyRRWAp1Gfj5hrDBPTmcGJYk/PiMcn57WZzo4IMxR6aJqP/oNMYNHX9T
QGi4i9Qs9q4jO0CgFYPRv/vqkmJ4rCF7fA8sDXbSCU7N2diDihFVcyEP2KL54mtK
ZPqWHdVvFmKEDK7rAuPS
=4ioF
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jul_2013_15_22_41_+1000_=pcOMf_/QdbFHNBL--
