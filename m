Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaIJXfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:35:25 -0400
Received: from ozlabs.org ([103.22.144.67]:35426 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbaIJXfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:35:22 -0400
Date: Thu, 11 Sep 2014 09:35:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Corey Minyard <cminyard@mvista.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please add an IPMI tree to linux-next
Message-ID: <20140911093514.5b40f0ec@canb.auug.org.au>
In-Reply-To: <541051A5.1040801@mvista.com>
References: <541051A5.1040801@mvista.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/U0.mjuP.QIl38.Hu8M1fhqX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/U0.mjuP.QIl38.Hu8M1fhqX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Corey,

On Wed, 10 Sep 2014 08:27:01 -0500 Corey Minyard <cminyard@mvista.com> wrot=
e:
>
> Could you add:
>=20
>    git://git.code.sf.net/p/openipmi/linux-ipmi for-next
>=20
> to the linux-next tree?  This is bug fixes and minor enhancements for the
> IPMI driver.

Added from today with just you listed as the contact.

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

--Sig_/U0.mjuP.QIl38.Hu8M1fhqX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUEOA3AAoJEMDTa8Ir7ZwVQJcP/jaKigAhzeGCJDL7lgTreNH5
fyX3mgkAVomz7O63iNCDO/a+5vs3dy7MRP/W57TK2lms03jp7F+2zyUPch9AofzO
v2ZmFWch2hV7Pk8xEGlkeMCAh/Gr73/sEZXXWuQUeLzgxywyYVdZLd353BM1s0AW
DTsLU9RTPog1UGHPWBklmDJhEqLJprTryPQ1rKrbfHBhh2NOCRkyR4XvdoIgyM4n
mlBqzKkvIkbD24sZ2Cw2G0v9c6fSS/kx286UuSyClm7x2qw+Czmuv0IQFK7EHLWl
I7qVvtu6kQa+7oINS+WyJ/HeV6cWTsjZK3JlLksWy8d3bkbFrQ+z+EivRV+kf7LE
9jcdZ5agZPX+0kXydL90gtfAcHVBk90UAOAm6G5pWbVbHBLGG8B6Ecq+8fq++CN0
E99B5wat9d5EC4PA5tS8bX3Dur7BXmuYplWCwh6a5P+PKwyvAJY5HppQaPAI+F3S
huoMBklBGmflI0mW51nhLf8KqTv4g4MrOdWcKr14YbJvET+isGbW6FBwL534y6Qt
KUOzr66mQKBcRBfr3eNzlvr9mGsK3KhU1R9SwgIIcxTyOBHIYD1fo/raFcckOES8
XSQ9uMNzzgAfL7sVuXJUCPw/Fwtgsdxz8Ep88LB8+i+2n38h5qg3drm1Ma9Y+iLP
I+C+IkwXSJ51q2k8Xwjr
=qkxU
-----END PGP SIGNATURE-----

--Sig_/U0.mjuP.QIl38.Hu8M1fhqX--
