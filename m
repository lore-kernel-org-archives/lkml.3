Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab3IIFWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:22:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35852 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3IIFW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:22:26 -0400
Date: Mon, 9 Sep 2013 15:22:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130909152219.a20db49e7daa53ebb8a21ef2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Sep_2013_15_22_19_+1000_dolFh75s7a_SO4j="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Sep_2013_15_22_19_+1000_dolFh75s7a_SO4j=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/dcache.c
between commit db14fc3abcd5 ("vfs: add d_walk()") from Linus' tree and
commit "shrinker: convert superblock shrinkers to new API" from the akpm
tree.

I fixed it up (I just used the version of shrink_dcache_parent from
Linus' tree) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__9_Sep_2013_15_22_19_+1000_dolFh75s7a_SO4j=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLVsQAAoJEECxmPOUX5FENx8P/0yKRycuYzsGHlFlr3UXWZPf
hdPoev8pb3HooHaDuHA5aIPtpRWKf6URBNqLo7GESEHHiJ3gJDgob83ox6ts89d7
0EdFodfIEIBU0NRUMLbvHcxm1JCXirFDGJj0bgAD3m3pt//x4tkjK0wC+T9ZuAuk
8HFzAAgNq+1wGBH685wkxmC4R+FBP1sZ3cbzc0Y6lNcmDw2EEt0VYcN/NNtgzoNr
tWPIZKXyKsT1JmYP9Ru9rZWNlEmhU3X5+UftiGpyJCdbKaaS/jdWf/T3MGIErFVl
zHY0pqSnOa+jrYSCYbdcO/Epp+jnzbBlX8Y6e87yx0u8DnvJ6tBGAOSUvMbZjh2h
0F4nmVpVQSP4ke6D4EnNRukZVO795feWUWhV/P5Qm0xomXNNg9fVYjhZu20SdJRO
YGZ4Z3G/9fY6DFjdVIoyFCEl3qhtHsXqbr5q3lq9NxWk/NO72xfwnovBAf0e61W1
pdfMRpe3r8eu7mugYGqiDPKrJXISRtgY57RiPpkzTX2HfrsrWD8JgkakMmmOtNeu
HAY49kqn8e5yMh6XgYNwe5KXfmQdTdwPCrRosp86qbEo5kkjm6aQFu41KLxZYrx3
75/ZkWJldpE1fv3dn3xk/levPKL9GAyypU/3TbOoabAgZHc1jKLF8PquSshVi4n2
3dOh7jwuyPGIUK5YdY/N
=gPdw
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Sep_2013_15_22_19_+1000_dolFh75s7a_SO4j=--
