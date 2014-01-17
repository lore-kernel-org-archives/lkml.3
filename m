Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaAQXCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 18:02:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34699 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAQXCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 18:02:31 -0500
Date: Fri, 17 Jan 2014 15:02:24 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: xen-devel@lists.xen.org
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: MAINTAINERS tree branches [xen tip as an example]
Message-ID: <20140117230219.GA28413@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

As per linux-next Next/Trees [0], and a recent January MAINTAINERS patch [1]
=66rom David one of the xen development kernel git trees to track is
xen/git.git [2], this tree however gives has undefined references when doin=
g a
fresh clone [shown below], but as expected does work well when only cloning
the linux-next branch [also below]. While I'm sure this is fine for
folks who can do the guess work do we really want to live with trees like
these on MAINTAINERS ? The MAINTAINERS file doesn't let us specify branches
required, so perhaps it should -- if we want to live with these ? Curious, =
how
many other git are there with a similar situation ?

The xen project web site actually lists [3] Konrad's xen git tree [4] for
development as the primary development tree, that probably should be
updated now, and likely with instructions to clone only the linux-next
branch ?

[0] https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/N=
ext/Trees#n176
[1] http://lists.xen.org/archives/html/xen-devel/2014-01/msg01504.html
[2] git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git
[3] http://wiki.xenproject.org/wiki/Xen_Repositories#Primary_Xen_Repository
[4] git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git

mcgrof@bubbles ~ $ git clone
git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git --reference linux=
/.git
Cloning into 'tip'...
remote: Counting objects: 2806, done.
remote: Compressing objects: 100% (334/334), done.
remote: Total 1797 (delta 1511), reused 1646 (delta 1462)
Receiving objects: 100% (1797/1797), 711.01 KiB | 640.00 KiB/s, done.
Resolving deltas: 100% (1511/1511), completed with 306 local objects.
Checking connectivity... done.
warning: remote HEAD refers to nonexistent ref, unable to checkout.

mcgrof@work ~ $ git clone
git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git -b linux-next --r=
eference linux/.git
Cloning into 'tip'...
remote: Counting objects: 2806, done.
remote: Compressing objects: 100% (377/377), done.
remote: Total 1797 (delta 1545), reused 1607 (delta 1419)
Receiving objects: 100% (1797/1797), 485.23 KiB | 0 bytes/s, done.
Resolving deltas: 100% (1545/1545), completed with 327 local objects.
Checking connectivity... done.
Checking out files: 100% (44979/44979), done.

  Luis

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS2bZ7AAoJEHoaE3+fqtqo2PUP/3XmVtQoDTfWm4dvKq5Sb0UO
t7sJR6CXny8MOFHXPpBiuucqjuXv6EPcOKu++04M4dC3bb9NMoaF07X1K5nBTtYF
ho/BxDzJIcRVwB0FzSUSLfbPHCNurTqo+vXZrSIJGuJcIwmenChPCq8eHs1LpKU6
5fZO8t4W480nkuLY7C7w1Y2YEDBXFC+DYa/x/U8KcKqdmzJOexR0Wo68B9a9PdLJ
HcUljCcj9mrLLQBNY4sEG0trwOBJtb/ph+FgfL7aJ3kgRsKcAT0jB5/MEnld/t/6
Y5uxl/06T7i04hri3YARFAEZZZy0LCats8N2X91TrkIhJ00HWxj3qcrfWixabdxk
77LupBfVLxkQ0hoS3yxOgvj08jBJYxftBPiBYlm+tGG/GYcRcLMLc8tZ/ExUyYax
7i3bg53q84oq+bombYRVCqV/PtYr585V/xi1cF4Bgs+BU14+jbaeoxxNWYNdADl+
GrR2u6r03i+m/m2Lx4+pGzsm6J2G3FQTU92Tbhd6m4RSLbDJRYTNDIB24iIADgQR
Hj/LyMiTTMIpuP4oyALv2OKIfIMLlRSLpUQFRvZWCimAp7rOO6O6Q9QxJP8HoS36
RvEua1584Mg460U3p+PrrEt4aJd17GD6Lr1MZxw148xUlNB2Dt1LW6Bsjbm8dQ/9
n0OafA1t6B50U2r9ktah
=13gW
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
