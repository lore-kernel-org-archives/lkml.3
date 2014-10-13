Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaJMKWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:22:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbaJMKWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:22:11 -0400
Date: Mon, 13 Oct 2014 21:21:57 +1100
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/2 V3] Allow access to sysfs attributes without mem
 allocations.
Message-ID: <20141013212157.4e68147c@notabene.brown>
In-Reply-To: <20141013083512.GA29706@kroah.com>
References: <20141013053733.19481.43981.stgit@notabene.brown>
	<20141013083512.GA29706@kroah.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/O8tZFzoXByhCUoVKw.OIGeB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/O8tZFzoXByhCUoVKw.OIGeB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Oct 2014 10:35:12 +0200 Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> On Mon, Oct 13, 2014 at 04:41:28PM +1100, NeilBrown wrote:
> > Hi Greg,
> >  please consider these two patches for a future release.
> >  They now have
> >    Reviewed-by: Tejun Heo <tj@kernel.org>
> >  and I've addressed Tejun's final nits.
> >=20
> >  Thanks Tejun for your review and comments.
> >=20
> >  As soon as they appear in an -rc1, I'll submit updates to md to use
> >  the new functionality for the -rc2.
>=20
> It will have to wait until 3.19-rc1, I'll queue it up in my tree after
> 3.18-rc1 is out.  You can merge from my driver-core tree into yours if
> you want to build off of it, as my tree will not be rebased.
>=20

All fine with me - thanks a lot.

NeilBrown

--Sig_/O8tZFzoXByhCUoVKw.OIGeB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDunxTnsnt1WYoG5AQIXWBAApbTktSxfMMxuQeZ6tfnP7IFInbxzlP8l
ulGpQBrlbz/G1p2+62FQ/o4pwBnY96OI5g0KVwrPP6r9l8sgSmYZwatTF8jp5EIp
QdZao7Q2eDRVL2zR9k47yUHUO9qkt9ODHShQWbOwl87jilSOue3/WxC0mYKdHEZ3
zwtSRJm/0Q/0ScqUfZq+i0KLec24kKRgEafXoP6OHsE2TnhrtNaSEDrfAdOzdDt2
Ub2XYPNXUvtTLZSpsONH5IeHADYn6yRl0tkr3wnqz1p+2fuQSYV6wX3POpbfev1i
TegjqUSiIXXeLIAKQ5IdWNm2BTllLWIiSo0TeBmKmYFS0D9NYGnZjCNatJH+VWd4
qDfvC1xNUM7tywRKW7kvm1bb1CR682OE2DXWHmHIxzSLR/nzAaaJT0SJWK6FwKdc
HSZpaZZfgY5USWT02mHKqZ/n20nq9LzieY7cueLmPpSokPrPWryv5PVId6fcu4PQ
xjHRCXbO9kBwF8KtVU3wjzOjOcdvdc81Uk1+8rf7kMcD6Oar7Ck1+DjJ69VhN4P1
RhEYkuZYuS+yd1OXlhO0kNHKTkLZg0xRjgqjt8i8gXqQzbMniJiWZZP5lGwCTZd4
xablo0Tx1mDg9kqIE8ZReNpCjfALYtGzVopagU1zqL/0G8+5ak7h9htIciQ9yI/z
c0RFCahTOQE=
=DU1y
-----END PGP SIGNATURE-----

--Sig_/O8tZFzoXByhCUoVKw.OIGeB--
