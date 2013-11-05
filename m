Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3KEWwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:52:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46743 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab3KEWwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:52:16 -0500
Date: Wed, 6 Nov 2013 09:52:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: rbriggs@redhat.com, aviro@redhat.com, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: audit in linux-next
Message-Id: <20131106095209.715a7bc82f3722982e1687d7@canb.auug.org.au>
In-Reply-To: <1383669356.28218.61.camel@flatline.rdu.redhat.com>
References: <1383669356.28218.61.camel@flatline.rdu.redhat.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Nov_2013_09_52_09_+1100_c5d3=OarG.H0Lspq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Nov_2013_09_52_09_+1100_c5d3=OarG.H0Lspq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Tue, 05 Nov 2013 11:35:56 -0500 Eric Paris <eparis@redhat.com> wrote:
>
> Weeee audit in linux-next again.  I seem to fail a lot.

:-)

> Al, can you please tell Stephen you hate audit, you will never update
> your trees and you are washing your hands of it completely?  Your trees
> are dead and should be dropped.

I have dropped them.

> Stephen can you pull into linux next the master branch from
> git://git.infradead.org/users/eparis/audit.git

Added from today.  (and more widely advertised)

> I'd like you to pull now, even though the window is open.  I plan to ask
> Linus to pull for this window.  I obviously should have been getting
> into your tree for the whole cycle, but at least a week or so is better
> than nothing.  Thinking about a pull request is what made me realize we
> never actually got that done last window...  Or the window before.  Or
> the one before that...

Well, yes ... ;-)

> In another cycle or two I might ask to have trees changed again to one
> rbriggs owns, but for now, I think I'll still sit in the middle, even if
> I suck as a maintainer.

No worries.

> You will have a merge conflict in fs/exec.c   It is pretty simple.  My
> example merge commit is below.  Instructions to solve the conflict:

Thanks for the heads up.

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

--Signature=_Wed__6_Nov_2013_09_52_09_+1100_c5d3=OarG.H0Lspq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeXaeAAoJEMDTa8Ir7ZwV3XEP/3bxQj2AKGOOPvrwYVKXwyk+
Ss1w7hq+yRjJXNWYjarmLJvAjXMSTAq8DINJOk2eWbsYsgalEl3CL/WmYR4a6JTS
6B9TfsWWPgRz2yYZ+4Co/jcPWlljlMHd+5s9LqWjTUDwZb0lbeil33UhuC6Wgs9x
2SlLRilVpygdZJVwjm4rStYFe2P8itsaLXOClhyVsEJb57eTTipfpMazSeUwJHeM
xpeyGL2YtpeE6ThXzG4qXN5mR/CXZ7F4XNJrx4zXNsvc35toZ8tM+utxUYolN7Xx
359NhPbcMUj9AamcHXGRQ+RGpxhUjIyfbMN/QrMCM6ANQWAvCldDMWQosxeSL2lC
GSlgegzK8BCNL04KBP2H4Q5pt+XmvowTCtcJvbPrv8+sJDLoy065XCtKZ35MVKIn
HlpPX1myP8NpUmqFusI0FMTtlCMCHLerwY8r1rUIuTOWb4Wcqd/ahgTLhk2oQYa6
s5ziEVRQ7bh8Vm7aPtnaoriCqM36uLqkDZzxyNVdGB/OwWK0e/fRxM7a9m15tz09
aUQGiVWllzA2D4Iy1yXjG+qUzRsNCQI0uOY+zREJ6H4xZlJ85REzbDSnO/Q/z+Lb
wrtjYoiU4Qg2vf0XDJUeo3MaCYGyx4TsoD2zOKFipFUXCx2V3GHdQ1iahSQbXYQo
amaCgfH3RaXVGbI3FZav
=Bf8A
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Nov_2013_09_52_09_+1100_c5d3=OarG.H0Lspq--
