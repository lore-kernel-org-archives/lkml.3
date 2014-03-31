Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaCaHBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:01:41 -0400
Received: from ozlabs.org ([203.10.76.45]:54299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbaCaHBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:01:39 -0400
Date: Mon, 31 Mar 2014 18:01:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next Documentation merge request
Message-Id: <20140331180132.f89b7d7665f1223f2255f46b@canb.auug.org.au>
In-Reply-To: <5338DDC5.70506@infradead.org>
References: <5338DDC5.70506@infradead.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__31_Mar_2014_18_01_32_+1100_/F.bvpviRjlIKE/J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Mar_2014_18_01_32_+1100_/F.bvpviRjlIKE/J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Sun, 30 Mar 2014 20:15:17 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> Please include http://www.infradead.org/~rdunlap/Doc/patches/ in linux-ne=
xt.
> This is a quilt patch series (initially empty).

Added from today.  Called rd-docs.

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

--Signature=_Mon__31_Mar_2014_18_01_32_+1100_/F.bvpviRjlIKE/J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTORLQAAoJEMDTa8Ir7ZwV+d0P/3hLhchjRrgRo6d09wvv0NgX
aU9kuqwtPqYEm+gfUBMPsnp725iL9rs8LO2PA5gADyvDhfA3dO3MlysqilKDBNHb
JLCetTKr0CMXgRGx2lWcO7GJEHKke0iJrJIZZQ/HmU5skHUk896zQyM+WL2KXdH0
lwZMpM0J2dutx8yfzl3MJMt6bTYrWtrxkxsyhasiH0lYNDJErg6Ufz/K8UhHn3vY
TLs/lCS9x69BiEyq7bOQ64Mx8y3xkkE2We6nLx9HTbiEtStsLgtCZqLxhxHJFosQ
6OaMv5jjS96i+T2++J0yBi2l4vjtv/isOokPNTspV/RkVuexq4wgXjZ5PmBsQOFz
OFItfbIuFo7EBKhBO1FDbEQ8FKVBTfjyfjlDZJyNN/7SzfSIBin/e9/3z4PDi/Y4
a52HsCdYRUh76AgOX+EaN4BOBYlB/pHLJ8nVxlH1adzGdHM+NO9Nmm8zIetsKpPs
CPvJdyBsOgzjiaJ2b9ssFpEYESAvANNQO6GwP/dh5QwzkvGyt7bDi75oWOCraNUG
lZmoFOSQqXPDEJWKukqfQWJOurLinohWKtA0RcyLSwpX5VY0JVUt2dRwYsPxcdBF
c9zL+deaejS9ezsXEQ2MZzxAomECl9ZZaF/v3KlilytqGZgCxWrAgQ/RJV+uXVqB
0N39xv2dPEycJYruOmfy
=EgUC
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Mar_2014_18_01_32_+1100_/F.bvpviRjlIKE/J--
