Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3H0Blq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:41:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45039 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3H0Blo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:41:44 -0400
Date: Tue, 27 Aug 2013 11:41:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the f2fs tree
Message-Id: <20130827114109.89e5a99f6dd954d44d73bbf0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_11_41_09_+1000_NYo6_7ZvNJYqICPK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_11_41_09_+1000_NYo6_7ZvNJYqICPK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jaegeuk,

After merging the f2fs tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/f2fs/namei.c: In function 'f2fs_rename':
fs/f2fs/namei.c:450:31: error: expected ';' before ':' token
   update_inode_page(old_inode):
                               ^

Caused by commit 2e569fefc95a ("f2fs: fix omitting to update inode page").

Not even build tested :-(

I have used the f2fs tree from next-20130822 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Aug_2013_11_41_09_+1000_NYo6_7ZvNJYqICPK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHAPSAAoJEECxmPOUX5FE6tgQAJ4PYJI/M/YJb/an4twIWJk1
xCZVyjjOJrxuWbVnOqsC+GmwgkZDz3fuqeke65nsapgm5maDkz0BmBU2EBCtWhIm
QdFXQIQUqbf3MOs7bbwillYqaIKrVS4jMdvP3WbMhZw+BVbs+Ox+sBbyivzzOQ6a
kY2KKd31B9dSezGt+qk2BTCxY9wn4/iQg523jKz9vWekLGpoWIcpbb62mzQCkD/s
UqY85k5bZ0zd5z6sY5s0n39IMHmrIR75zE2dAKvk27wxhijIy9ai+RQYD5Ao5hfI
hXgBrt31YsnECh3Rppfbzo/KWo3Wvb/MV9BZ/li3EWoJk9y9O6/dSmziVsIB1Hl1
oxE9cRIJ9ZvNQwk11oD0lUpqc0vqbzlhmfYB/OzHmcZp6Qyg4G5i9IXgRNKF3mz0
Alf62EzIsW1OOMHD6LldNtXk2XC/14TF0aQp9lZ4mV9Opk14yBB9xV+eammwvZ4v
9s3c+T54h496+nr2UzWfu6uoqE3NKnMI8Yoc+G86FFShazi1KgK6qHE+IfqSP/b9
ffV54HOwie7CPD/YWlKxF6m9YpCFbsFxlePPtwp4/3EVquKV0oVJZouzdCj8pGhQ
/nb6s/v4SNdtskpM+cO1RgBH56/yxCZM+ZwJqxx17tRZ6BJqChWGrjS682QtNbE5
4BY53cWwoyLQiSQ7v/NU
=bXSA
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_11_41_09_+1000_NYo6_7ZvNJYqICPK--
