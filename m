Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3A2Uvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:51:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47644 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3A2Uvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:51:50 -0500
Date: Wed, 30 Jan 2013 07:51:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>, Arnd <arnd@arndb.de>
Subject: Re: linux-next: new arch/metag tree
Message-Id: <20130130075148.2f34a4d16fdd4a62625260d2@canb.auug.org.au>
In-Reply-To: <5107DD1C.2080008@imgtec.com>
References: <5107DD1C.2080008@imgtec.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Jan_2013_07_51_48_+1100_3u2qu.3INsTe=wrc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Jan_2013_07_51_48_+1100_3u2qu.3INsTe=wrc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Tue, 29 Jan 2013 14:30:52 +0000 James Hogan <james.hogan@imgtec.com> wro=
te:
>
> Please can you add the following branch to linux-next for Meta
> architecture support:
>=20
> git://github.com/jahogan/metag-linux.git for-next

Added from today (though there may not be a linux-next release today).

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Wed__30_Jan_2013_07_51_48_+1100_3u2qu.3INsTe=wrc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRCDZkAAoJEECxmPOUX5FE2zMP/iA+FtttgY6II+g2FMykl2rl
4haNjdHSegihW5Gl5f0wy4tqDfm6wEhaqYWF1+46qApicwRuSQz04iAuSZTBR+Dt
6UnIHpJcusMASSucw0GJfnNT1XIjr3Z7ckLBuL0g9pjYHhm96QBfO0CS17QqlYjT
Pcs8whiYJRPJED61yW6j15+nWdVa5xcgKQltR93ttLgi7XHelhujtZnyIsE6IYa6
N4OT/CPnMhyTy8E48h/Ai0XxEeKO1BbKOV7fcLMR6jUT2o7lA0n4Krugm5/DRy9b
VHW2dEqpIcovbyHUcJoGUYuD/8jceRlUV531KHmwwSMB8Btuz6DN/Ai0XwiePPkP
XvwNiXpDoVfsIyD6x3Y2wBJE1hnv99l4ZHopQA5BUIUJKHf927woViQBesxUEbgd
QKWRzFS57vCgSLqTkayzH9rG/VPA7UD9tjFPxko+Djtv1rYmvZLkfJxoceg4Ktzc
OxwKm+cayf/muirWO2kxzI7/O66ZGSjD4Ay7wOHrFqcoAaM1ASwCKI0+++yfNxdI
tHS/S0IX180m8fmGtvb8mW64LUVDXhEBb05mrK+SUxutInl/6a3bLOJ6NUkWmmFS
TT07YZQxdt8ldnHFiFmpUXCYDslbFkFaA4dATyY32ebhuvuT5/Cq8R7IQJCgx+WV
PGSLgQM9sb4DWpWuVai1
=mmsc
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Jan_2013_07_51_48_+1100_3u2qu.3INsTe=wrc--
