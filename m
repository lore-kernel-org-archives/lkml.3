Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaEZX7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 19:59:52 -0400
Received: from ozlabs.org ([103.22.144.67]:38412 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbaEZX7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 19:59:50 -0400
Date: Tue, 27 May 2014 09:59:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincenzo Aliberti <vincenzo.aliberti@gmail.com>
Subject: Re: linux-next: build failure after merge of the l2-mtd tree
Message-ID: <20140527095942.0a071e63@canb.auug.org.au>
In-Reply-To: <20140526174225.GC5241@norris-Latitude-E6410>
References: <20140522153047.62c1721c@canb.auug.org.au>
	<20140526174225.GC5241@norris-Latitude-E6410>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/3l56u0pJ/9PL17Jk2svQqCA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3l56u0pJ/9PL17Jk2svQqCA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Brian,

On Mon, 26 May 2014 10:42:25 -0700 Brian Norris <computersforpeace@gmail.co=
m> wrote:
>
> On Thu, May 22, 2014 at 03:30:47PM +1000, Stephen Rothwell wrote:
> > Hi Artem,
>=20
> FYI, I'm managing this tree now, not Artem.

OK, noted.  Is there a different URL for the tree as well?  Currently
it is git://git.infradead.org/users/dedekind/l2-mtd-2.6.git#master .

Here is the legalese:

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

--Sig_/3l56u0pJ/9PL17Jk2svQqCA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTg9VzAAoJEMDTa8Ir7ZwVGOsP/2EPdtsinDw98F2BV1cIg+Ip
xSrYQ+B3lU4NloNUcDPAnK4CTrbIlcvT3+mg0MT0oWJEfKp3wabFPfRS6nuhQ8Cc
U2V+vWg1FfHubu6XPjSA4Wq43BC3iUJgN1ZtYEi8RnIAXo5JBSZDQi/RLh/YPKTg
oCGJbkYyaBkwAQ+P4a1njmNE3RVsfNKKhy+mDRVfqYP0QueoLD7R1XBXPWt1LdBH
P48PbI8ha6x7HXtb9QnEsmzAC8gmSVgDxlJtIA07+O1m1Sn09eGQpSjQjEBJWtPa
QuWfrBBCVsDUyp6DxqtnaYYgPHt5yjt20uHTtQ/maKJfhNloxoD8+Gylwlj5E5ja
Ya3Eh2RjAIyXnBio4AcCL62gu0O85PrJVuH9gG+WTcY4KxyQfy3/KQ8O+K7BxoJY
7YLzc1iGuCWtgOM0WnFq+jFuMfMvI014H691UP0dfLBkAyf3UbmCklE4ryVfYahv
OJUVTXVGK1a046h1QPPQvlOsDMIKwbAiDZtw98NDOEv/DlTkk9vVz7GGYVaeIwYk
nI+txVqAQom+mnAcua2/Zzkb/ANJVRqSkUG7UDqQ447EDSWP37mL270Q+3dTYgoD
KUclDKaUmZYUooXUhKIkhhDoibvTjtR1wViFc2DvAKXRnT7hhR86+0BmVsmk/AmS
O9ogMjQjo1vbhewBAdiC
=t0dn
-----END PGP SIGNATURE-----

--Sig_/3l56u0pJ/9PL17Jk2svQqCA--
