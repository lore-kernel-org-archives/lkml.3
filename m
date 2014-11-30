Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaK3Bpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 20:45:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58035 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbaK3Bpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 20:45:39 -0500
Message-ID: <1417311913.7215.111.camel@decadent.org.uk>
Subject: Re: [PATCH] e1000: remove unused variables
From: Ben Hutchings <ben@decadent.org.uk>
To: Hisashi T Fujinaka <htodd@twofifty.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Matthew Vick <matthew.vick@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 30 Nov 2014 01:45:13 +0000
In-Reply-To: <alpine.NEB.2.11.1411262157110.1481@chris.i8u.org>
References: <1417065728-5592-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <alpine.NEB.2.11.1411262157110.1481@chris.i8u.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1PgVn7v+jBrWGgzV56qP"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:1079:d8f7:d09f:54f7
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1PgVn7v+jBrWGgzV56qP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-11-26 at 21:59 -0800, Hisashi T Fujinaka wrote:
> I'm pretty sure those double reads are there for a reason, so most of
> this I'm going to have to check on Monday. We have a long holiday
> weekend here in the US.
[...]

If there were double register reads being replaced with single register
reads, I'd agree this was likely to introduce a regression.  But all I
see is var =3D er32(REG) being changed to er32(REG).

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-1PgVn7v+jBrWGgzV56qP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVHp2sOe/yOyVhhEJAQoGHw//SpO5726CRwxjBRtXTTFYjmOBzm2hki5j
pnkeWfii7bo+kWP4LpeZ3OHmDUW1MiopoUqUGwZDevpWjlN+1M4OC0TKfQnYVi1Y
sD/BFACNiNnynTDW9JiZLabHa0VPcMAHC0SjRenCcTNdlk+EryLTVynPui5/Ue+o
Fi7xaNouGrUozxK+ScKMOtwC1deyoTRRYULmDK+m6f10oJKzVm7JgaxpBkBq4qHg
irIIkHV2hvo52JOiEGJQOwCo241WyDR/7N72HqWR6JNWk/gdPHnQ41SJqZ22ZMar
mhG+O1Kb/hCtkr99s91dQn6f0NbO4z1lzUVuxof3xRyppbyhstkO/lsM+KzLufEk
qiuDcIaD0c0nW8m2GcZmVgqZYeDLT/FOfpbdVwaVwYrBrERtYwolMGS5lkeXYBDY
dFrMwoqulFoMxwDfSg28b2NsqaAVc+jtYMec+G+kgQkKz22zno5sn4fsRWOkwio/
4EkZ5E2zoqAfdEOmIa+jda9uzNbtfbhDhpPcfmBTbIomCGblsLuBowfXvAjw4Z60
ihuQiXBedQ0zpga9xw5ABT9dRQ98rL8pHcj0ORFLhiKWI3t26iiGr90LvEdSdWOZ
ZyIclPRRbDjISe66CaAX5ugKetWqh6NBbM4P3AUS99rSIFb9/7Dfn0yHiDrjj9Ne
R4r2BBJgc1c=
=AvQD
-----END PGP SIGNATURE-----

--=-1PgVn7v+jBrWGgzV56qP--
