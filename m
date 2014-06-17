Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbaFQDs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:48:27 -0400
Received: from ozlabs.org ([103.22.144.67]:60115 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbaFQDsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:48:25 -0400
Date: Tue, 17 Jun 2014 13:48:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>
Subject: linux-next: stats (Re: Linux 3.16-rc1 - merge window closed)
Message-ID: <20140617134818.16e116eb@canb.auug.org.au>
In-Reply-To: <CA+55aFzNDTm_O8rGYdNw1S99P06u6EeSdttXBvtURJocQT2O0g@mail.gmail.com>
References: <CA+55aFzNDTm_O8rGYdNw1S99P06u6EeSdttXBvtURJocQT2O0g@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Fx6N2uABQYJOafJO5_DbR38"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Fx6N2uABQYJOafJO5_DbR38
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

As usual, the executive friendly graph is at
http://neuling.org/linux-next-size.html :-)

(No merge commits counted, next-20140602 was the first linux-next after
the merge window opened.)

Commits in v3.16-rc1 (relative to v3.15): 11364		(v3.15-rc1:	12034)
Commits in next-20140602:		  10283		(next-20140331:	11411)
Commits with the same SHA1:		   9204		(		10432)
Commits with the same patch_id:		    559	(1)	(		  581)
Commits with the same subject line:	     60	(1)	(		   74)

(1) not counting those in the lines above.

So commits in -rc1 that were in next-20140602:	 9823	86.4%	(11087	92.1%)
That is a big drop - presumably caused by the suprise opening of the
merge window a week early.

Some breakdown of the list of extra commits (relative to next-20140602)
in -rc1:

Top eleven first word of commit summary:

    243 drm
     91 btrfs
     87 net
     59 mmc
     57 i40e
     46 perf
     45 powerpc
     34 mips
     32 reiserfs
     24 xfs
     24 alsa

Top eleven authors:

     48 bskeggs@redhat.com
     41 rmk+kernel@arm.linux.org.uk
     32 jeffm@suse.com
     28 namhyung@kernel.org
     26 fabf@skynet.be
     25 fdmanana@gmail.com
     23 james.hogan@imgtec.com
     21 treding@nvidia.com
     21 geert+renesas@glider.be
     21 dchinner@redhat.com
     21 chuck.lever@oracle.com

Top ten commiters:

    218 davem@davemloft.net
     93 clm@fb.com
     76 jeffrey.t.kirsher@intel.com
     72 torvalds@linux-foundation.org
     68 bskeggs@redhat.com
     62 daeinki@gmail.com
     52 chris@printf.net
     50 benh@kernel.crashing.org
     44 alexander.deucher@amd.com
     39 hch@lst.de

There are also 460 commits in next-20140602 that didn't make it into
v3.16-rc1.

Top ten first word of commit summary:

     43 arm
     39 sparc32
     22 drm
     21 sparc64
     21 mm
     18 arch
     15 vfs
     12 drivers
     12 arm-soc
     10 sparc

Top nine authors:

     67 sam@ravnborg.org
     49 akpm@linux-foundation.org
     23 shawn.guo@freescale.com
     18 n-horiguchi@ah.jp.nec.com
     17 gang.chen.5i5j@gmail.com
     13 ebiederm@xmission.com
     12 olof@lixom.net
      9 mhocko@suse.cz
      9 eparis@redhat.com

Some of Andrew's patches are fixes for other patches in his tree (and
have been merged into those).

Top ten commiters:

    166 sfr@canb.auug.org.au
     70 davem@davemloft.net
     34 shawn.guo@freescale.com
     28 matthew.garrett@nebula.com
     21 daniel.vetter@ffwll.ch
     19 gxt@mprc.pku.edu.cn
     16 ebiederm@xmission.com
     14 eparis@redhat.com
     12 olof@lixom.net
     10 jason.wessel@windriver.com

Those commits by me are from the quilt series (mainly Andrew's mmotm
tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Fx6N2uABQYJOafJO5_DbR38
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTn7qHAAoJEMDTa8Ir7ZwV/rsP/2bZa/oH/iOeX984oTK3RyIs
aXZowkI010cn7aIwDeHCC431eG7SmFBJFJG3XEzHC9mf06QKhb8y1xGz5g2gsfHe
KO0HhjBqrfW/x8ozb0cFZa6gMzSlAws0AGv5a5nHLwMyakLZ5Vue6Fu6VsCr2E2I
fCnBD5YvOSl0OTy7RW4uEgbQ2Vmfp5NwDgLDcGxy5b78EgPC9hK7s25U0asKEmqR
L/7ABdE9bsMYzp66ARuxDd4mVI368ScNZmz88TC6fl5ruPARGFwrFAijOfO4XnyM
c26bKeMGJ20BALPxY1FWwTviS/Px5vS0awZswfswZWf3T7BS0FeJMtLRnyPFgLXP
Rt1PRuKmfbPAXe0vh4YK/N9gbLSxIIp8Jvw46MqCzaDkBQ8XJ2ZxJ9eakQUmhqk8
V+BHRgxvlq6PdR9Py/dcArDcNBYpca3bKgpPASqi8nX6zYrembl76ZvoRjICA5KH
rwUzV0tSxLO02+sJKuS7gcpE4CbNAdzkPH8TvT8JtbmlMa9peWljDrz1pkKUc9Yv
XOxKPhBO0VHOWOoZs/6/ieQ3Dtc/BoFoQdQ+uuXy+2qdpjpcK3y7BWKITB00Tsay
4/+6O10Zh2a75BSNxAE2ITEn6vg1nezd3LWzNL06q/9CUBvKKcTqdKkH6Je3BOUQ
OPfpT4sCmeMGHJPoEPii
=HfXs
-----END PGP SIGNATURE-----

--Sig_/Fx6N2uABQYJOafJO5_DbR38--
