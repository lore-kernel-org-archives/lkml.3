Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaAOUuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:50:35 -0500
Received: from ozlabs.org ([203.10.76.45]:37010 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaAOUud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:50:33 -0500
Date: Thu, 16 Jan 2014 07:50:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Weinberger <richard@nod.at>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: Tree for Jan 15 (um, rcu)
Message-Id: <20140116075025.7b7ec09805b5f90c75a36dd2@canb.auug.org.au>
In-Reply-To: <2114717.uibXxy8kL0@sandpuppy>
References: <20140115185545.497c14923814b6ecaa540d9f@canb.auug.org.au>
	<52D6B591.3070707@infradead.org>
	<2114717.uibXxy8kL0@sandpuppy>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Jan_2014_07_50_25_+1100_buA4VgT.pFvwGlg1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Jan_2014_07_50_25_+1100_buA4VgT.pFvwGlg1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Wed, 15 Jan 2014 20:39:03 +0100 Richard Weinberger <richard@nod.at> wrot=
e:
>
> Stephen, can you please add my UML tree to -next?
> It contains already the fix.
> git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git next

Sure, added from today.  As long as it only contains stuff for v3.14 ...

> Please note there is a trivial merge conflict in arch/um/include/asm/Kbui=
ld.

Yeah, what Geert said.  If you can fix this, then fine, but a single
conflict is not so bad.

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

--Signature=_Thu__16_Jan_2014_07_50_25_+1100_buA4VgT.pFvwGlg1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1vSXAAoJEMDTa8Ir7ZwViB8QAIWP/XeQ2WaHt5M1yruvzxqT
AhEAirFadQ1rWGnc8VPkgDh0zd+bU2WKNiUI9Jg1ZOBOmy5OV5YrZiD3/G2bIzky
oGSlYtWWKslYbr/1hQYc+m/YJB+e8sOi/aGRyJguKeh6D5Tt+x6sw51pEllCrs6q
V4LNBuIK3gprLEWWBeDu+GnlQEfMJ/QURxytGyvfTS8XCmbn+HsoDYSUzRNJBO8N
5xq3mnk6+5m8q1XKsnmUa77uVExGsWV2uc3npRgoqSD/kP+ksf8Wo6HEO8Ex5xF4
JMvuzkempqwmTippSghfDsacBIHsHixg/wCPnMv91kfbzdGu1qgnV/EKC1PnFbp3
5rN/845i3MButhL0BWRfK80tnNyYnWjuMpE9IVrK2uvhV3o/akLT4bspskCGvFp1
NqPCiYbJuk+raJqxUUuWo/CxZXXGsY+xXDfQt1rBclQ8YNh9BKijDktF9sco6kRn
LrczXLDXHr7IaDbvBsEziZ3IxtrQGb9LqNxSyj/8WIOJj4snsz2AHKyGyb2zDjv9
qk/cw7I4iD+l1EfGdJ3XD5qyH0TOJMQynr/SD3dK44QFvLE7nfSSLMu9H3GhPy+p
k0RP8HLVqc43XZ1NnL6msdroGQlRYub5zXuauUr+q3H3RPS0lx5JRGgo0XcsFWTr
pOfSaLXY6o8V/TC3mf7X
=hoyx
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jan_2014_07_50_25_+1100_buA4VgT.pFvwGlg1--
