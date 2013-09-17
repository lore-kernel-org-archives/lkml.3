Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab3IQFvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:51:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42437 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3IQFvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:51:11 -0400
Date: Tue, 17 Sep 2013 15:50:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next stats (Was: Linux 3.12-rc1)
Message-Id: <20130917155057.2125aa5f69fb9cf9bbe01166@canb.auug.org.au>
In-Reply-To: <CA+55aFxg-WropC74v5ir5r9kBJKEd93fgye4oTBhw5T8e8sb+g@mail.gmail.com>
References: <CA+55aFxg-WropC74v5ir5r9kBJKEd93fgye4oTBhw5T8e8sb+g@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Sep_2013_15_50_57_+1000_8B+PyPziB/msXo3."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Sep_2013_15_50_57_+1000_8B+PyPziB/msXo3.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Sep 2013 18:08:11 -0400 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> So it's been two weeks, and the merge window for 3.12 is now closed.

As usual, the executive friendly graph is at
http://neuling.org/linux-next-size.html :-)

(No merge commits counted, next-20130903 was the linux-next based on v3.11)

Commits in v3.12-rc1 (relative to v3.11): 9474		(v3.11-rc11:	9494)
Commits in next-20130903:		  8891		(next-20130701:	8929)
Commits with the same SHA1:		  7991		(		7670)
Commits with the same patch_id:		   472	(1)	(		 759)
Commits with the same subject line:	    70	(1)	(		  55)

(1) not counting those in the lines above.

So commits in -rc1 that were "in" next-20130903:	8533	90.1%	(8484	89.4%)
Commits in -rc1 that were not in next-20120722:		 941	 9.9%	(1010	10.6%

So better than last time, but it would be still nice to figure out where
the last lot came from.  I have the "git log --oneline --no-walk" list if
someone wants them.

Some breakdown of that list:

Top ten first word of commit summary:

     57 net
     53 mips
     49 drm
     47 [scsi]
     23 perf
     23 nfs
     20 cifs
     19 nvme
     18 vfs
     17 arm

Top ten authors:

     33 Al Viro <viro@zeniv.linux.org.uk>
     21 Sachin Kamat <sachin.kamat@linaro.org>
     20 Linus Torvalds <torvalds@linux-foundation.org>
     18 James Smart <james.smart@emulex.com>
     17 Jon Mason <jon.mason@intel.com>
     17 Chuck Lever <chuck.lever@oracle.com>
     16 Tomasz Figa <t.figa@samsung.com>
     16 Jingoo Han <jg1.han@samsung.com>
     15 Daniel Borkmann <dborkman@redhat.com>
     14 Trond Myklebust <Trond.Myklebust@netapp.com>

Top ten commiters:

    162 David S. Miller <davem@davemloft.net>
     64 Linus Torvalds <torvalds@linux-foundation.org>
     53 Ralf Baechle <ralf@linux-mips.org>
     53 Al Viro <viro@zeniv.linux.org.uk>
     52 Trond Myklebust <Trond.Myklebust@netapp.com>
     47 James Bottomley <JBottomley@Parallels.com>
     22 Steve French <smfrench@gmail.com>
     21 Inki Dae <inki.dae@samsung.com>
     21 Arnaldo Carvalho de Melo <acme@redhat.com>
     19 Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Quite a few of these could be bug fixes (especially DaveM's).

There are also 358 commits in next-20130701 that didn't make it into v3.11-=
rc1.

Top ten first word of commit summary:

     56 arm
     34 drm
     23 selinux
     15 drivers
     13 ocfs2
      9 iov_iter
      9 bluetooth
      7 kdb
      6 pci
      5 watchdog

Top ten authors:

    31 Andrew Morton <akpm@linux-foundation.org>
     22 Dave Kleikamp <dave.kleikamp@oracle.com>
     15 Jani Nikula <jani.nikula@intel.com>
     13 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
     12 Eric Paris <eparis@redhat.com>
     10 Joern Engel <joern@logfs.org>
      9 Zach Brown <zab@zabbo.net>
      9 Paul Moore <pmoore@redhat.com>
      9 Marcel Holtmann <marcel@holtmann.org>
      8 Guenter Roeck <linux@roeck-us.net>

Some of Andrew's patches are fixes for other patches in his tree (and
have been merged into those).

Top ten commiters:

    116 Stephen Rothwell <sfr@canb.auug.org.au>
     33 Dave Kleikamp <dave.kleikamp@oracle.com>
     31 Daniel Vetter <daniel.vetter@ffwll.ch>
     28 Benoit Cousson <bcousson@baylibre.com>
     26 Eric Paris <eparis@redhat.com>
     22 Jason Cooper <jason@lakedaemon.net>
     14 Joern Engel <joern@logfs.org>
     11 Shawn Guo <shawn.guo@linaro.org>
     10 Jason Wessel <jason.wessel@windriver.com>
      9 Gustavo Padovan <gustavo.padovan@collabora.co.uk>

Well, that's embarrassing again :-)  Those commits by me are from the
quilt series (mainly Andrew's mmotm tree).

Some of the above will have been merged into other patches or replaced, I
guess.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Sep_2013_15_50_57_+1000_8B+PyPziB/msXo3.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSN+3HAAoJEECxmPOUX5FEvZMP/1XqZnGsfQGCqpdh1HDETkkp
fZDoaDdzXwcyGYWQwFOWouD0wBYI5seKeuLqik2I7IgL+HG2bX2c0ozFH5pByJEl
Ii173aiomkroAg9aUzxuflR+tlfFZeO0FkzzvJrW0Q9+I4nCn1BFbpRagTbYvfqL
/1wTvQwNUyc3vHYJ3/GHPyVvKWVg548EX0xC1dzNZ8xPJJxgTvh4YOnFLhEpfHYg
V+dIAE0jLoOAkv+NqBPboC81xTNl4kYu0PFTJwBCs83Ljt+YF03HKVXMroUYR5+d
lFhac8PXQ5plLOYEYmRwnH2T7kK673hCl36PU3Vh9AEEOgGKh6Dfr7oB8QlfFT2f
CNGsx/ROYGZZIqUpIvpwUWC4GzGYw4sVgPHpU1Miw0l2MS/+Gf2kCrIO5/FiADCS
qHW0QoGw32YFWpCtKXAsB0TFSH+TEPImAEdL1fH/RdOTIuGFsMMslaM99ybA4f6C
r7Pcgswxpzaal2ke5JWobxHoVpFms8PMfiCCr0K8hMwUtEvkFaycVRGeYme7or0E
O1hG2YgPSxTRZ60WPJIU21dIGE+pJFqliEWyPhv2f1oIYpZA9LrkIUyKyLIYBKme
DNOdOSJx8wOWoghQKyeLywqx1EBjcJQPVhyRg9edRLbo/fmCaqCZSaB4w35T5oE8
I99JnZpdQyQphq4/9r2R
=MgCZ
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Sep_2013_15_50_57_+1000_8B+PyPziB/msXo3.--
