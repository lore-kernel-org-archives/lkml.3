Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaENOx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:53:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:50087 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaENOxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:53:55 -0400
Date: Wed, 14 May 2014 16:53:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tim.c.chen@linux.intel.com,
        peter@hurleysoftware.com, jason.low2@hp.com, riel@redhat.com,
        alex.shi@linaro.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:locking/core] rwsem: Add comments to explain the meaning of
 the rwsem's count field
Message-ID: <20140514145345.GN30445@twins.programming.kicks-ass.net>
References: <1399060437.2970.146.camel@schen9-DESK>
 <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
 <1400077624.9356.6.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jNp2UUAAd0DeWbgM"
Content-Disposition: inline
In-Reply-To: <1400077624.9356.6.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jNp2UUAAd0DeWbgM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 07:27:04AM -0700, Davidlohr Bueso wrote:
> On Mon, 2014-05-05 at 01:46 -0700, tip-bot for Tim Chen wrote:
> > Commit-ID:  3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> > Gitweb:     http://git.kernel.org/tip/3cf2f34e1a3d4d5ff209d087925cf950e=
52f4805
> > Author:     Tim Chen <tim.c.chen@linux.intel.com>
> > AuthorDate: Fri, 2 May 2014 12:53:57 -0700
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Sun, 4 May 2014 20:34:26 +0200
> >=20
> > rwsem: Add comments to explain the meaning of the rwsem's count field
> >=20
> > It took me quite a while to understand how rwsem's count field
> > mainifested itself in different scenarios.
> >=20
> > Add comments to provide a quick reference to the the rwsem's count
> > field for each scenario where readers and writers are contending
> > for the lock.
> >=20
> > Hopefully it will be useful for future maintenance of the code and
> > for people to get up to speed on how the logic in the code works.
>=20
> sigh, after this commit, the opt spin patch no longer applies, I'm
> rebasing and send out v5.

No worries, fixed it already.

--jNp2UUAAd0DeWbgM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc4N5AAoJEHZH4aRLwOS6QF0P/iuP0jnsPvbMHRjdS6XWJM2F
iB+/fTFZVTPOI/B5NUO1CwOJGcmLKGZ5a9CvbozGdnmtQW3SPPHLAcbYVrBPSoRT
ov0bCh+HvPl/vN5/c8RnDX4drwoIojuvjt+OmaMvy0vZy9ZCJC3tNtNnx7jUg7cq
aGemHWePXzZKnuA2ge74yjUGTiPgXXANGl3TnV85sJoPB6dzLjt2wx0PFbS+icvz
iPJTRKnTu+ys5c4BCAp111aRt32FtAKT/AuqcaiOjufijgb55e4ato2qkHCeVE9q
irKHcbrGSehy7DKToOxzQcbdDZgZURYJlFt9lrKLUO+3zGhCv+sjJxv1M4IcnODH
75mYV8+J9jPiQhW+eZVOu9uI9GTIx8mSaBSd06MBndzBk3LOFvRJlWRyAujm3Bp3
MKqVQlyLmjhilBncnxM1kWL0rQefy6hVbHB/5OCP6Ma33dnsiYFkMQSEJVMte1vY
O3HcLtsfYzySUZwm2MNKblsynubhgQI8WEMB3qAJrkx1/Bwzy6vw0Q8rnRr3Z4Xm
3ChL1/VDyyA8/daJoj9LQiRLPt/OMUwgJIIYwVkYQvC5EWO4XLJ5+ggclPPE9wqw
pK6vSzvcjBgfPMfJbzEXqIImdxNvRvHmEX832klDPeYP1TMFYyajbPbfBupMyU4q
b3QDKWxklz3E3R4Kt/Dt
=9/dP
-----END PGP SIGNATURE-----

--jNp2UUAAd0DeWbgM--
