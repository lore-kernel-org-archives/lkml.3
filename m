Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3E0ALB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 20:11:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42463 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab3E0ALA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 20:11:00 -0400
Date: Mon, 27 May 2013 10:10:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Adding fscache branch to linux-next
Message-Id: <20130527101053.6e9daa850882f7c1ec6af230@canb.auug.org.au>
In-Reply-To: <6967.1369322428@warthog.procyon.org.uk>
References: <6967.1369322428@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_May_2013_10_10_53_+1000_1JYMCOZgNyLD7JaI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_May_2013_10_10_53_+1000_1JYMCOZgNyLD7JaI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, 23 May 2013 16:20:28 +0100 David Howells <dhowells@redhat.com> wrot=
e:
>
> Can you add:
>=20
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=
=3Dfscache

Please use git URL's when talking about git trees.

> To linux-next please?

Added

git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git#fscache

from today.

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

--Signature=_Mon__27_May_2013_10_10_53_+1000_1JYMCOZgNyLD7JaI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRoqSNAAoJEECxmPOUX5FErq4P/inZpQ9gtQAmMiwCO4qvG5JH
NkcFG1/r90Zspy/9ozUZVvtDH6HgWaTZh5zBxb3TO1aYNhTyIah8vSRdMLDkdzyT
5VPyZhr8BcvI/0xGSed7py0fQ6P19nh/1uR1QpwiQLXt97SfKY216Hb/uTNmIPjP
wXdByBGpW44xS4Db0nD5+Qa45y+8bJHCP9D/3hR9XgtDyrSseezdtu8Jnh3eiwqI
izsBOJkPZYU1qz4LNymtRmcBppDbd68wM4eSpscMCWg6fbFbNW3OP3gDQLjq+kJv
YAgg562lcsJEUcjBXweFgYpNUluMNmM10s4Q6oaLN0MuBGTq0MvmIWYP4yPQiYX8
mBHu38O6cdW7kaYA+k1iSfpLmiyYL94nm0icthh3KyWUoX7cux8rf0TZisgW25LB
2SAR/EAUHj+/GQOUqjCH11jd5tbva2wEy6epaHyfZ+D0mEwKcJpCo79ApHa2Bm/M
0PutcTONBpaaZUwIc85oowypvJyo2iNFuo3y53+FJX7dZ4//4Su9NBl1esum1NOi
T1dl6mPxquqFZF5PHQzP4hhtOQwpXOkJUTAwT23VCAJB6XV9DHI7IZuM93ns3GGa
niYWGG8/fxd4m8L5CTgF08UWGOTP8zfBxz/vlgDx7AIBrfJYXyTqvX6vLLCW88kQ
qUReXxPXdgjphKDVPBax
=bsk8
-----END PGP SIGNATURE-----

--Signature=_Mon__27_May_2013_10_10_53_+1000_1JYMCOZgNyLD7JaI--
