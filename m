Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966Ab3GaW7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:59:21 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54642 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab3GaW7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:59:20 -0400
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Stupid linux-next git question...
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1375311493_1587P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 31 Jul 2013 18:58:13 -0400
Message-ID: <24590.1375311493@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1375311493_1587P
Content-Type: text/plain; charset=us-ascii

OK... So I have (as usual) found some issues in linux-next, so I'm looking at 3
bisects.  I already know that bisecting between (say) next-20130715 and
next-20130730 won't work, but bisecting between the 3.11-rc1 base of
next-20130715 and next-20130730 *will* work.

Question 1:

Does bisecting between "the HEAD of Linus's tree when a given next- is built"
and "some later next-" work? (basically, I know that anything in Linus's tree
as of -0715 is 'Good', so I'd rather start from there than from 3.11-rc1 to
save several bisects).

Question 2:

If that works, how do I determine the commit ID to feed to 'git bisect good'?
I *hope* this in Next/merge.log is the magic I'm looking for:

$ git reset --hard stable
HEAD is now at 6c504ec Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
Merging origin/master (5ae90d8 Linux 3.11-rc3)


--==_Exmh_1375311493_1587P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUfmWhQdmEQWDXROgAQIjLhAAkd+6oDf/k8i09DrNdn1AKUSoYcPovl3Q
sR3BPpTh5GtAHjO7SlClDk0l/gIb/e6f5UqYX2PdmAoIzS5YtjHnUpOT4gUYQk97
S48Qc5P2RQ/THI36O1m2Cd0KEcNfPszXlCgpmtpqQmoxESe2jcON0Ru2rYJMhOsx
BzioolDbEEPZK1p66Xo8ZqjSsM3eNqiCuD8dQbM7k3BUdCg/nnbU409WSfMHvQCx
6+WqL2CQIih+8r+ACPxER+Gb5mbVTzrz07YcQQmeBJIIdzUMfAjJDngcZwgi+Ajo
CksgT4CYOUWXCT9V8m4AaN78H9Zh56jViyglUTfz8Hy7zrSy1lNnpoey0gl1naEb
qijGG+VAm4SN4EHn4s52cbAKNYsQwxj0+X28C+dw+VqQqdVtuL2Y4Jy49kVsqbEO
pZCogUe7es6UERb7iOnuAhr+s2UVaLRjkZ630jAxT9aN9nu63wzQN2TNgu/BwaYy
EwpKey2CrLw0hZ32LGt4yQdFLhu+BSGGIau36puA1RpE3HHRj4QPs4tbDtWeMbof
9pKDUPj6Kj4d6VHl818IQhTKkNo18cE0KUqT6N98mYqNTgGuyyyz7BtD2bFH7u/p
KJWwQPRCdnYn1zOcR2xyXwKTip/yPSDh75eCgJRQVHuijHZTN9FweSPGHNgqoSvM
3lByL3d6VG4=
=zFar
-----END PGP SIGNATURE-----

--==_Exmh_1375311493_1587P--
