Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab3E0Xrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 19:47:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41946 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782Ab3E0Xrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 19:47:47 -0400
Date: Tue, 28 May 2013 09:47:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@linux.ie>
Subject: Re: NVIDIA Tegra DRM tree
Message-Id: <20130528094737.0bd6d41092c6e3aa7db9fd89@canb.auug.org.au>
In-Reply-To: <20130527161402.GA9676@mithrandir>
References: <20130527161402.GA9676@mithrandir>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__28_May_2013_09_47_37_+1000_bYUtuY1Gxr4zJQok"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_May_2013_09_47_37_+1000_bYUtuY1Gxr4zJQok
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

On Mon, 27 May 2013 18:14:03 +0200 Thierry Reding <thierry.reding@gmail.com=
> wrote:
>
> In response to some fallout during the last merge window I've setup a
> tree for the Tegra DRM driver to be included in linux-next in the hope
> that it will help avoid more fallout in the future.
>=20
> The repository can be found here:
>=20
>   git://anongit.freedesktop.org/tegra/linux.git
>=20
> With the branch for linux-next being: drm/for-next

I assume that this will be merged via Dave Airlie's drm tree.

I have added this from today.

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

--Signature=_Tue__28_May_2013_09_47_37_+1000_bYUtuY1Gxr4zJQok
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRo/CdAAoJEECxmPOUX5FE9wUP/jMYiKpjOc/NBshnhOnv3W9C
Nsx4LYDGVkvaUKr0n0MGjYt2KtCYqkZNvEZz9N/kaIjgXaBXNksO1kWQdIzvqPuC
aEZDL1lRHaZMdgmPpB3EgMaSO9jfb+wtpYHgozr2lX0CSUjHbCVVi+5Tun7/22z5
habyIk7+Ujigch56CS9sD2yQeiz64hg1Z7pBUhrVyFkqBNyxcRbLVPsyqQjvHm+A
An0Ua3MkTgogWyO882g6Du3z5tXkRdVF8WhvHmVUfjulQUFIWdinb5CMVoNY7Chk
g4bdtliqLWYhtjDg0l+RPStOM8mbKGhyjw8/WgyEo8xLfY3gNVNAwfAhYjT7kb0G
/P47b7mM+89mU2I4Vm3Ic1cP6b9sSjsTaGiuVq2Go+kg/tHn07zoIQlidwfkzUfW
07V184ftfAmOLhpr4gFWjyVJmOJ64QoCWCTm4++s97EkiZOo2pwZkNLzIbWPqHPj
oAX9CAzTdKJeV2xNOTHShUK/TQeovnNO0xYB4o7wasewLwr4RE6yY9WEeV7M+/Lp
7kAcwY8BQUgXXWa5kwYC3GaXzVvbACRhr/mV9+1Ykt8qbPJ+2lUMEzo22wDmcbsc
NufJJLcpIjExCTZBQikzawPmQe9f7qBycAR+psZPfigqliZ8QH7bvRiIU8iuo/Cl
D8AUewug7A9ZUDTYu34A
=nLhv
-----END PGP SIGNATURE-----

--Signature=_Tue__28_May_2013_09_47_37_+1000_bYUtuY1Gxr4zJQok--
