Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaHDAIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:08:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54282 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbaHDAII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:08:08 -0400
Message-ID: <1407110877.8341.10.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.8 107/116] hugetlb: fix copy_hugetlb_page_range() to
 handle migration/hwpoisoned entry
From: Ben Hutchings <ben@decadent.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Kamal Mostafa <kamal@canonical.com>, Jiri Slaby <jslaby@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 04 Aug 2014 01:07:57 +0100
In-Reply-To: <alpine.LSU.2.11.1407231659330.2093@eggly.anvils>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
	 <1406067727-19683-108-git-send-email-kamal@canonical.com>
	 <alpine.LSU.2.11.1407221608040.3128@eggly.anvils>
	 <1406149325.3612.33.camel@fourier>
	 <alpine.LSU.2.11.1407231659330.2093@eggly.anvils>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WBJRxAInj2M7yQS+2ezO"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WBJRxAInj2M7yQS+2ezO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-07-23 at 17:07 -0700, Hugh Dickins wrote:
> On Wed, 23 Jul 2014, Kamal Mostafa wrote:
> > On Tue, 2014-07-22 at 16:08 -0700, Hugh Dickins wrote:
> > > On Tue, 22 Jul 2014, Kamal Mostafa wrote:
> > >=20
> > > > 3.8.13.27 -stable review patch.  If anyone has any objections, plea=
se let me know.
> > > >=20
> > > > ------------------
> > > >=20
> > > > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > > >=20
> > > > commit 4a705fef986231a3e7a6b1a6d3c37025f021f49f upstream.
> > > >=20
> > > > There's a race between fork() and hugepage migration, as a result w=
e try
> > > > [...]
> > >=20
> > > Please drop this one for now: other -stables have carried it, but it
> > > was found last week to contain a bug of its own, arguably worse than
> > > what it's fixing.  Naoya-san has done the fix for that, it's in mmotm
> > > and should make its way to Linus probably this week: so please hold
> > > this back until that can join it - thanks.
> > >=20
> > > Hugh
> >=20
> > OK, I've dropped it from the 3.8-stable queue, and will watch for the
> > fix to land.  Thanks very much, Hugh!
>=20
> commit 0253d634e0803a8376a0d88efee0bf523d8673f9
> Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date:   Wed Jul 23 14:00:19 2014 -0700
> mm: hugetlb: fix copy_hugetlb_page_range()
>=20
> is now in Linus's tree: so the original patch is good to go into
> your -stables, so long as you add 0253d634e080 on top.

I've now queued up "mm: hugetlb: fix copy_hugetlb_page_range()" for 3.2.

Ben.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-WBJRxAInj2M7yQS+2ezO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU97O3ue/yOyVhhEJAQqE3Q/7BJqCyKkwE6S93/UQfdzMOO9N50Mhp+nU
c5c5xpLbk9Rin2fljAV21/6Y2bHQzphwCOmfoShweOyDXZoIn22/xyQnvpzOAOwP
t5L8USAPm5pWgtZClIU1QX5OfupHo+QlnMetQlDaBFXZsbRWbNIpAoSLrK8rir9x
W50AXN+sp7xme0ARJ91T88gvE6DK8RAlvSBp2p2Jpav7rLMto2dstcoTZ9j6laR4
ySqG1bNK/vDCzxmXQ+LeSlZB6Vok8fFVZiyiFrswaRoWHaMDQWACgqV3c8fUNZF+
dLhPLX4+hkiQsnqoWNLpCiHzPMOOnhfPOga/bImrQg4hOY13hSx/GVv/9DOJwawa
b+JucqAYU/MK9sQp9CFJSGO6qcLlVZERJmJNWQeTJmhhsgMJG0j8cLzHNmftd+Le
04hKiBkESCvSJWUz9YrW4Dl8Pp+x0kKw1EeFXs1Rs7RIW/XulO2enhe2sKKuqJH+
omXApkp4QEzx/rS6tvWgbz0745EG03nPyPjtij6TLk4JbRjFVTWTDOYFMl2EVLDQ
SP/neUKUL3KZq/Hc1wm1WJPoks+tO8YB4vJ+ocAFWcfQ+kc1HpKJnFFEMzlXcfOh
CZo+TRD8ATIRm05B1ln+lwClP6bwlbMa10kc+Hmwou3gs4t3nBc/dltWPc+RoIhL
EJX8YEgCrfE=
=57/3
-----END PGP SIGNATURE-----

--=-WBJRxAInj2M7yQS+2ezO--
