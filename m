Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3GOHik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:38:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49383 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3GOHii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:38:38 -0400
Date: Mon, 15 Jul 2013 17:38:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, "lkml" <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: Please add PTR_RET tree.
Message-Id: <20130715173826.f698f36373c6f701126b42d3@canb.auug.org.au>
In-Reply-To: <8738rg30cw.fsf@rustcorp.com.au>
References: <8738rg30cw.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__15_Jul_2013_17_38_26_+1000_7GdJXLmPstzo332l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Jul_2013_17_38_26_+1000_7GdJXLmPstzo332l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Mon, 15 Jul 2013 14:07:03 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Temporary branch for PTR_RET -> PTR_ERR_OR_ZERO and associated cleanups.
>=20
>         git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git PTR=
_RET
>=20
> Log appended.  Contributors and people who didn't already ack CC'd.

Added from tomorrow.

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

--Signature=_Mon__15_Jul_2013_17_38_26_+1000_7GdJXLmPstzo332l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR46b2AAoJEECxmPOUX5FELgoP/jtpLANItThwcEXEAwfmnMD/
agFcV2eMi5MIa4YUlmydTbF5gl4WDNVILm9kAAIWbxPyr7ur9dZ7HfagDJ55yMK1
vrfbvSJBwqFxCiuEps8w24BJCf0E4Q0ss7mAe1YGMxoQQnXHgW20l5lKzF1hgSNf
F9laXQdj46Lax1lyVZB6IlrVNSbnqSbR9GGEl1Sl2gjgdAY6lYkOSP4E/DocurjS
9JypQyR+wFs8dR3m3bvYmO2cGVYcEhtHkVbesNiG5uGlo+vR1eIhKxQO2JTyMIgD
W+DGqCKvwNVuRP6lMQXzApYcSu4WbX+DTZAgfqyGC0ma/UswHYRzHQewyVxU19sD
rglmyNbP2pMg40jJFPXQLhUPrTSEHKC4h4KCZqImU4EV2q0V1nD6iJolxX7gas4M
tnGcFt0A4EK+6uhhwdqn7Y6qatv4aeDXFLDiW2pw4GJ6JkT1HIxoxyRr3NUPfhK2
+OLuFR3gRn9W5rOdMMGIqEAsW7yTpiiP9/Pp7U5kAk0cN8Hmo62Sk+cD1owO2y1n
AfaSepKBJbYrjeTQuOkgiClzJZKYIdwnXf/k8jUsT085J3o+d9NwqwyohZAhhMUF
ED4BrDSb6n/MSeto+RXsOiYf5M/LhWp+ScVliZiV/+KvNm3laesttUS/TGPkqFom
OzKWD/rIurjUY0anoG31
=58aX
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Jul_2013_17_38_26_+1000_7GdJXLmPstzo332l--
