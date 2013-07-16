Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843Ab3GPXXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:23:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36062 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472Ab3GPXXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:23:52 -0400
Date: Wed, 17 Jul 2013 09:23:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-aio@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: aio-next
Message-Id: <20130717092340.0ec193caf96e74a1c33f60b5@canb.auug.org.au>
In-Reply-To: <20130716134028.GE5403@kvack.org>
References: <20130716134028.GE5403@kvack.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__17_Jul_2013_09_23_40_+1000_8p2jrMM0kK/.nUn0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Jul_2013_09_23_40_+1000_8p2jrMM0kK/.nUn0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Tue, 16 Jul 2013 09:40:28 -0400 Benjamin LaHaise <bcrl@kvack.org> wrote:
>
> Hell Stephen,

Its not that bad :-)

> There are shaping up to be a bunch of aio changes for the 3.12 tree, so=20
> I think it's time to start staging them in a git tree.  Would you be will=
ing=20
> to add my aio-next tree to linux-next so these patches can get a bit more=
=20
> exposure?  The tree is at git://git.kvack.org/~bcrl/aio-next.git .  Regar=
ds,

Added from today with just you as the contact in case of conflicts, build
problems etc.

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

--Signature=_Wed__17_Jul_2013_09_23_40_+1000_8p2jrMM0kK/.nUn0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR5dYCAAoJEECxmPOUX5FE5TcQAJ2iEQlAavbUZHXhrO7jhzhv
2derdq5QRRXWiYFdClY/d8v4NeJwbadg8rR2Oei/LmKuq4DNvk8Ux7VBHKROq0fK
G42wbA1+H5CoHGG8BOS2+0a5pGJ+pATk6c0ehvl52VM6wA4B2WYW/fiCcfER0F6l
TY6nTBuRp+LeMR8Ss0M+1dGrdQ4t4HHCp3tsC9P8VGVva62z9YDvZM/5vPaMB/nC
1+//syEfsKB5d0hq1nMdSiw9cKlpIj9QxwlCk9/QnbBziyafOHH2yK5e/eVEA9dV
AfYIt+N0IHKE3QnjOiXf1MaloIimFwlRgtJS7DOK16doAcwUFLN3eZ4lp9UabKQQ
FM3bTsXxQR8WE+2ITj2NsrYddSrXLJ5qYNcHdIpOVEyCnKskx3Ii32yx8DZy4S+b
VPrI1PvMYat28kk3C6nqOktoAvcm8f3mw/tiEYmZHeuV7T8CLKYWNO+QgeE20Yj9
H21qr4WiOLjtF9Y2nZ+dcy6vsRJR0ZoUPUzbWKbv5yTL5Jp+BBadY3SnKiA1Kro9
RV1KwhWgG7QoeawWbbPIFgLoSnERHzZvYs3bNeesjzm9r1Io62+HT4lqXNP6IM1G
kdMRWOQ6a69BwqE8kBBAbG5mEElQMF5EHzZLZcLUqO4gQ9VO9Dsbk83bGZlVIGPM
bIABbVYzKoZ4zjXf74l5
=T+b0
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Jul_2013_09_23_40_+1000_8p2jrMM0kK/.nUn0--
