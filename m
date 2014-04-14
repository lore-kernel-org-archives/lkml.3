Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaDNIGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:06:50 -0400
Received: from ozlabs.org ([103.22.144.67]:49115 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbaDNIGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:06:48 -0400
Date: Mon, 14 Apr 2014 18:06:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linus-next stats (Re: Linux 3.15-rc1 out, merge window closed)
Message-Id: <20140414180629.198f98cadef124a99439b0b1@canb.auug.org.au>
In-Reply-To: <CA+55aFykrvKAe29pTUqq8Oc2FKtnFWwU7vxbTQXa7ysZ6xxMXw@mail.gmail.com>
References: <CA+55aFykrvKAe29pTUqq8Oc2FKtnFWwU7vxbTQXa7ysZ6xxMXw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_Apr_2014_18_06_29_+1000_54Xu_0Yg3vfEzOAE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Apr_2014_18_06_29_+1000_54Xu_0Yg3vfEzOAE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

As usual, the executive friendly graph is at
http://neuling.org/linux-next-size.html :-)

(No merge commits counted, next-20140331 was the last linux-next before
v3.14.  I neglected to publish the stats for v3.14-rc1, but they are
mentioned below.)

Commits in v3.15-rc1 (relative to v3.14): 12034		(v3.14-rc1:	10622)
Commits in next-20140331:		  11411		(next-20140121:	 9792)
Commits with the same SHA1:		  10432		(		 8810)
Commits with the same patch_id:		    581	(1)	(		  709)
Commits with the same subject line:	     74	(1)	(		   48)

(1) not counting those in the lines above.

So commits in -rc1 that were in next-20140331:	11087	92.1%	(9567	90.1%)

Some breakdown of the list of extra commits (relative to next-20140331)
in -rc1:

Top ten first word of commit summary:

    103 drm
     41 net
     39 libceph
     33 ceph
     30 media
     25 arm
     24 btrfs
     23 powerpc
     20 alsa
     19 target

Top ten authors:

     61 viro@zeniv.linux.org.uk
     47 ilya.dryomov@inktank.com
     24 zheng.z.yan@intel.com
     19 thellstrom@vmware.com
     16 tglx@linutronix.de
     16 dborkman@redhat.com
     15 a.hajda@samsung.com
     13 matthew.d.roper@intel.com
     12 mszeredi@suse.cz
     12 dan.carpenter@oracle.com

Top nine commiters:

     90 davem@davemloft.net
     63 viro@zeniv.linux.org.uk
     57 torvalds@linux-foundation.org
     56 sage@inktank.com
     31 m.chehab@samsung.com
     27 matthew.garrett@nebula.com
     26 jeffrey.t.kirsher@intel.com
     26 benh@kernel.crashing.org
     24 daniel.vetter@ffwll.ch

There are also 325 commits in next-20140331 that didn't make it into
v3.15-rc1.

Top nine first word of commit summary:

     73 arm
     34 mm
     25 drm
     23 asoc
     21 bluetooth
      8 zram
      8 kdb
      8 dm
      6 ocfs2

Top nine authors:

     41 akpm@linux-foundation.org
     24 arnd@arndb.de
     16 n-horiguchi@ah.jp.nec.com
     15 johan.hedberg@intel.com
     14 fabio.estevam@freescale.com
     12 heiko@sntech.de
     11 bradley.d.volkin@intel.com
      9 mpatocka@redhat.com
      8 oder_chiou@realtek.com

Some of Andrew's patches are fixes for other patches in his tree (and
have been merged into those).

Top nine commiters:

    120 sfr@canb.auug.org.au
     24 daniel.vetter@ffwll.ch
     24 arnd@arndb.de
     23 broonie@linaro.org
     21 marcel@holtmann.org
     19 shawn.guo@freescale.com
     17 shawn.guo@linaro.org
     12 kgene.kim@samsung.com
     10 jason.wessel@windriver.com

Those commits by me are from the quilt series (mainly Andrew's mmotm
tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_Apr_2014_18_06_29_+1000_54Xu_0Yg3vfEzOAE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTS5cRAAoJEMDTa8Ir7ZwVhlAP/jsbILAwge/F0Lh+MNATSrtL
PS3ljTimfw/NqeiEGl1bAdQW6lDoDXihNwU+0M3bPSfyjQ6kzXB7giywmvohNhvC
tE+UNscGKRnSJuHFc6jKq1t1xUYvCKrOjpewPX+NPg5d5rvHvWp+oZscYsrc9sAe
uQf362NIecXzVO+gi1zpajjwdxw8fGlTHXgTY1MXAXUZlB1lElCrbgyjwFjqoZJ1
xGwMYZR9M9OOhmO+BHLuCRjNYikJNbjRR0hTBxprHMIikkKyrerkvHb7sng9vCB/
mbpFs489Rm+7pnSEepiBbhDAzFvL0yHznug0B3B2R9I+jjJlPgvetCvfiAlJltwf
g1MR7Bu1OkgrD1+51UGUJ/kToujy6SLX/auH/xRqTUp/H9WPY36xZ9Enx9cCknCf
Gn95mtzSIc8ODbb8ciJOuhVWxwZt0CKW+sOhzTBHCJMFWMW8fXS6QOEWTwvquPdc
efFwf7H5UrUOsky4RgiEePWeMSkxpabWE1ModSX/KczHB+u4mOkZaQXN22puXtor
x8Lulv++FPSSrh40bqPi6bB8GJHOdRjSuV264eHxS0VFiN7F/q0xYd8rHJPKLuah
zrJD2JgEYXH0UL4obQ+WXQB2Tl7BHzojzw3dDBOpOa7Jne4LwgNVq2fS+ae9uns9
NNcEFKg+w+s0RPB89DRs
=DyS+
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Apr_2014_18_06_29_+1000_54Xu_0Yg3vfEzOAE--
