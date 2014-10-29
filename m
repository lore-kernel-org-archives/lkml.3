Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbaJ2WY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:24:56 -0400
Received: from ozlabs.org ([103.22.144.67]:55432 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291AbaJ2WYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:24:54 -0400
Date: Thu, 30 Oct 2014 09:24:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: unnecessary merges in the v4l-dvb tree
Message-ID: <20141030092445.519a86ba@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/f9bX2SmEm1e.SVTQn4CG.Ke"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/f9bX2SmEm1e.SVTQn4CG.Ke
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

I noticed that you have two unnecessary merges in the v4l-dvb tree
(git://linuxtv.org/mchehab/media-next.git#master).  This is not
entirely your fault.  Unfortunately, when you do

git merge <signed tag>

git will produce a merge commit even if it could have fast
forwarded :-(.  Consequently, you have commits 1ef24960ab78 ("Merge tag
'v3.18-rc1' into patchwork") and d6d41ba1cb38 ("Merge remote-tracking
branch 'linus/master' into patchwork") even though the patchwork branch
in each case is included in the tag being merged.

The only ways I know around this is to either merge the commit
associated with the tag or do a (hard) reset to the tag.

Linus, any thoughts?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/f9bX2SmEm1e.SVTQn4CG.Ke
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUUWkzAAoJEMDTa8Ir7ZwVhFQP/jzdyCkxPaWBOmV0YO9vxeke
Mk+Di7YvfQcG+DZdrW8a/7cxneO9+TXGw+FhI1f82v4EQSsL/cDfpuCZ8mAxxx/x
Ka68gZlcFyI5Hrl7CyRJCKcU0dj4gP3zPLJZyH7WvAapXf/TEzZWdL8mxyle4EIn
wM4MNn2bmfv4SqgMuS6cdHLXXH1qO4jnmLj7lBc6ljwrS4hGSL1W+BbBYY3RP4Mc
lX3mGuANeNXUFG8tNuP20sxXzwHwWMf+Owp6QylUf/fCz13ESD1w6G6/rt2W8lpi
zW0deIeeiF75fqjgONpMVffFYw7KEgrN6nA4XwU5CUFJjtKaW0WDhtW0AYZep7lW
2J9aLaVo01JGjfcW4+TQMcYLZdrOt1ubqJwPgTs4iUVr4zMPpcst1lRuTDJwTbVg
iyN0r7WVph+y4pGB/qOVmmzT1AJtbrxw9iUayBLzD6kXn94PUNFqkZv9GxFWcqZp
Ewuhsb4Xw4H9qV6W22awNwMRZls8I+EaNoxQa3lalGvsZVQQnszWUu7oLC5/dree
7CmF1rWph7leR6y0qyZIsT+dFxd/snvuJr1obwVDnTdm+3++7xNagTjgBdfLu2Ql
izLNUSFIkujrVHHTm8dyK4NnouMFJ34RGNM8iaqBXp3Wq81hf7tcQ5uk0WUYppSt
3wBNqs89LRp7aRsyRhde
=sOCI
-----END PGP SIGNATURE-----

--Sig_/f9bX2SmEm1e.SVTQn4CG.Ke--
