Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaHRGUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:20:20 -0400
Received: from ozlabs.org ([103.22.144.67]:33936 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaHRGUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:20:18 -0400
Date: Mon, 18 Aug 2014 16:20:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: stats (Re: Linux 3.17-rc1)
Message-ID: <20140818162007.621d2ac1@canb.auug.org.au>
In-Reply-To: <CA+55aFy4WSYZ_6p-+E7=XaYn9U0vwid6XAxw_uB21d=KrPW0mA@mail.gmail.com>
References: <CA+55aFy4WSYZ_6p-+E7=XaYn9U0vwid6XAxw_uB21d=KrPW0mA@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/JKhierlm3nWsVzOBig6xX6p"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/JKhierlm3nWsVzOBig6xX6p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

As usual, the executive friendly graph is at
http://neuling.org/linux-next-size.html :-)

(No merge commits counted, next-20140804 was the first linux-next after
the merge window opened.)

Commits in v3.17-rc1 (relative to v3.16): 10872		(v3.16-rc1:	11364)
Commits in next-20140804:		  10268		(next-20140602:	10283)
Commits with the same SHA1:		   9216		(		 9204)
Commits with the same patch_id:		    590	(1)	(		  559)
Commits with the same subject line:	     53	(1)	(		   60)

(1) not counting those in the lines above.

So commits in -rc1 that were in next-20140602:	 9859	90.7%	(9823	86.4%)
That is higher than last but simillar to the merge windown before that.
Last merge window was unusually low.

Some breakdown of the list of extra commits (relative to next-20140804)
in -rc1:

Top ten first word of commit summary:

    262 drm
     62 powerpc
     51 input
     46 mips
     41 net
     28 hwmon
     22 xfs
     22 bcache
     18 arm
     18 alsa

Top eleven authors:

     82 bskeggs@redhat.com
     35 benjamin.tissoires@redhat.com
     25 axel.lin@ingics.com
     25 alexander.deucher@amd.com
     23 himangi774@gmail.com
     21 gwshan@linux.vnet.ibm.com
     19 viro@zeniv.linux.org.uk
     17 paul.burton@imgtec.com
     15 minipli@googlemail.com
     15 christian.koenig@amd.com
     15 acourbot@nvidia.com

Top ten commiters:

    141 davem@davemloft.net
     99 bskeggs@redhat.com
     64 benh@kernel.crashing.org
     57 alexander.deucher@amd.com
     51 dmitry.torokhov@gmail.com
     46 ralf@linux-mips.org
     41 matthew.garrett@nebula.com
     32 torvalds@linux-foundation.org
     31 daeinki@gmail.com
     28 linux@roeck-us.net

There are also 410 commits in next-20140804 that didn't make it into
v3.17-rc1.

Top eight first word of commit summary:

     66 arm
     33 mm
     30 drm
     22 rcu
     15 fs
     11 ocfs2
      9 mips
      9 drivers

Top eleven authors:

     30 akpm@linux-foundation.org
     23 olof@lixom.net
     17 ville.syrjala@linux.intel.com
     17 bobby.prani@gmail.com
     15 fabf@skynet.be
     13 laurent.pinchart+renesas@ideasonboard.com
     12 hannes@cmpxchg.org
     10 paulmck@linux.vnet.ibm.com
     10 joe@perches.com
     10 behanw@converseincode.com
     10 arnd@arndb.de

Some of Andrew's patches are fixes for other patches in his tree (and
have been merged into those).

Top ten commiters:

    154 sfr@canb.auug.org.au
     31 daniel.vetter@ffwll.ch
     29 paulmck@linux.vnet.ibm.com
     25 olof@lixom.net
     14 horms+renesas@verge.net.au
     14 eparis@redhat.com
     13 shawn.guo@freescale.com
     12 zohar@linux.vnet.ibm.com
     10 jason.wessel@windriver.com
     10 behanw@converseincode.com

Those commits by me are from the quilt series (mainly Andrew's mmotm
tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/JKhierlm3nWsVzOBig6xX6p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT8ZseAAoJEMDTa8Ir7ZwV38oP/R0E0dueC4IW2ZxUZkhmDVRm
VjzUOreY0ZY/G9KLLJJqm0db55hbfdL4NSmmdwrVkXFWUOfgYjwTSHIQ1T6R0S0L
3QpGs9cXFr0WddRb6wYqCk0LLWYb0V1Tb/EIU0x/I0qUBH8T2kImg3zr5Pn8Z8X2
6oL3+B3im7EwZSUZgsk/QsBLF0kG0MulNNPko/pER/WZub6jyOOekbOb1CU+x//d
xwuoiIQ4JUAvyrnajCN+UO9Y4nH83XQaLjpwHCE1vm1vcXHP2Lca0wo9tp6Ru6uS
V/X0oB+OrXGv/cU+40VJsakYLK3IF0Hg6YqVB2PEk/oG7l6/aFfs5gtoRyV11UI3
hLE/wAddV+jhXxe/ehMutJcTPebnSdI9bDCeV0E2zgrafEl+1lP0CH+w0ykUM0xQ
IgV963XJtkReby5uGHXy1pbtHgzACgPE+HCAbpgX9l+G+OFZ3p4twtnJEr8eXfp1
h+zZjtgG9sIhYXN1fbtFjz/YHa9SE7Qf6uxzLZNc3SX1o3LQzOZ0+0wBIh3ZIojx
acMFx427gpCuhWWVkwHHOSQJLyabfibuuPQb08fVJHf0X/gCoMFGhoVUglC9a/JX
7clfGZSvfHbG/iOnHDa/6j7/C7EibvgwDQQgZ9bclj6NwwSN5w+T74SdzeyCMwIy
XP4rbtEEGqJz2pyOKRe6
=AO+3
-----END PGP SIGNATURE-----

--Sig_/JKhierlm3nWsVzOBig6xX6p--
