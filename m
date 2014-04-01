Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaDAXTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:19:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbaDAXPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:15:48 -0400
Message-ID: <1396394127.5088.0.camel@menhir>
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Date: Wed, 02 Apr 2014 00:15:27 +0100
Organization: Red Hat UK Ltd
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-nEfaWSnCtKqeTgjXGG62"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nEfaWSnCtKqeTgjXGG62
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Hi,

Please consider pulling the following changes,

Steve.

---------------------------------------------------------------------------=
---
The following changes since commit 1b2ad41214c9bf6e8befa000f0522629194bf540=
:

  GFS2: Fix address space from page function (2014-03-31 17:48:27 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git tags=
/gfs2-merge-window

for you to fetch changes up to 1b2ad41214c9bf6e8befa000f0522629194bf540:

  GFS2: Fix address space from page function (2014-03-31 17:48:27 +0100)

----------------------------------------------------------------
One of the main highlights this time, is not the patches themselves
but instead the widening contributor base. It is good to see that
interest is increasing in GFS2, and I'd like to thank all the
contributors to this patch set.

In addition to the usual set of bug fixes and clean ups, there are
patches to improve inode creation performance when xattrs are
required and some improvements to the transaction code which is
intended to help improve scalability after further changes in due
course.

Journal extent mapping is also updated to make it more efficient
and again, this is a foundation for future work in this area.

The maximum number of ACLs has been increased to 300 (for a 4k
block size) which means that even with a few additional xattrs
from selinux, everything should fit within a single fs block.

There is also a patch to bring GFS2's own copy of the writepages
code up to the same level as the core VFS. Eventually we may be
able to merge some of this code, since it is fairly similar.

The other major change this time, is bringing consistency to
the printing of messages via fs_<level>, pr_<level> macros.

----------------------------------------------------------------



--=-nEfaWSnCtKqeTgjXGG62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTO0iYAAoJEMrg3m4a/8jSM1EP/RRjcf84RxBO/Yx/um4n3wG0
gfp9d3YfDoUY1jcp3xzxmgzhunEnDm2wPbZtWtBdGqaAJejxoK8xC1E9rA2mwLjR
H46U0+B6yHS2lNA6Uu7c8ff0SMfBUSw0+nJTfRfboRpNr7sdJodMn1vEs1m8poxN
eTzrSMcgQf2oUnDrDDu6FjINSzRKxzyIrL9XTnfCNYvtcvKB2cZlv9boe9ihtMcq
I2jktN2WzHxOWlcWCLeCvc0It5CtZ8Cni9f8/MWFWkvFKNKxfggsczm3UFh4PIa9
hjO3F9oUL6mrT/1lxyIRrOohpWmFgeRGOB3JxPxtM0yD5umH05KdxC9aGfem+uh8
9Q0bB1AdmjyUJ0pyd+mZsXGHrJmJr8olzYkEyYURWeoUEvEm0qR1bjXrUgjwU2Qj
iQP/II9t2ilEHwXlc4BrG7Lr+tLr3CiFUAWxHx1vqu53qLNDGsdWhYI5BE2adede
cKqIVQyuh31CE2OwtMzSQ5lpqNanZbdUbbTN0IQspR7SUzqBBct5Ad2MBkOF8kb1
7xWDR+axM9jXiWb/18xOQEX0NKFv8xJnD4UryHqs+CQtH1gMXPxhFJ57O11H06Q1
xnNw4bGBTEIeFTHGj6NqJcosCTaiQyIj4ELJvc77jCsN7sXFVNLjBDKpXOXLZqQc
+G+9B1j0dPoBqek1gs8r
=OuCA
-----END PGP SIGNATURE-----

--=-nEfaWSnCtKqeTgjXGG62--

