Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934932Ab3DJANb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:13:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42392 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765437Ab3DJAN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:13:29 -0400
Date: Wed, 10 Apr 2013 10:13:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with Linus' tree
Message-Id: <20130410101317.0fa466659e2376aada964540@canb.auug.org.au>
In-Reply-To: <5163E925.4060601@ti.com>
References: <20130408143623.bbf18647b96df42b8b8ec6a0@canb.auug.org.au>
	<5163E925.4060601@ti.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_10_13_17_+1000_ARzuh/zW.KXa9/Lc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_10_13_17_+1000_ARzuh/zW.KXa9/Lc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

On Tue, 9 Apr 2013 13:10:45 +0300 Tomi Valkeinen <tomi.valkeinen@ti.com> wr=
ote:
>
> I wonder what I should do about this conflict. Both the fix in Linus'
> tree and the new code come from fbdev tree (I'm currently handling fbdev
> patches), and it feels a bit silly to have conflicts between the fixes
> and new commits from the same subsystem tree.

Since you really should have that fix in your -next branch as well (for
testing), I would merge the same branch that Linus merged i.e. I would
merge commit 090da752cdd6 ("video:uvesafb: Fix dereference NULL pointer
code path") since that is already in your tree (presumably as a separate
branch or tag).  I would also put a comment in the merge commit itself
explaining why you did it.

> I could just leave the conflict be, or I could merge the fix into the
> fbdev-next branch. Do you know if there's a rule of thumb I should
> follow here?

The normal rule is to leave it to me and Linus, but since both sides of
the conflict came your own tree, I think the above makes more sense.

[cc'd Linus for any conflicting opinion]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Apr_2013_10_13_17_+1000_ARzuh/zW.KXa9/Lc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZK6dAAoJEECxmPOUX5FE6wEP/2C/VmKDvw+h7Gv3QF2q655N
SbkOfZ02ETdHlYygQyvmOmt2BrIZ3bNH5zFnMnZiG0hE2pv9YXIEn04kFiZFpem6
nkrSICwbrjm2KjOXpKQAKU4eoYqotKBwOxvknIR9vKEFu4MW8PhmOV/GfLKsgMlH
ojx54/E177ubwlbxANZBE1v423GyBNl8q7fpx+TOQERChBqZ4slRvIBsI/Pf+cBC
01v4CfZNNZzK10gXsjVnJRoGoSwowG/u1NP5u3Jm0tH08+Gq4nRMapqB/gW289Zq
paCrkwidilCZG2p5utgaUd7ioEUat9guHqiBTwgoFN26KlNHk6Q8L+w/n9mAOOGW
7OzA22IPH+b1ABxNPu0NC8bKQtitWx32NMpSl1rAnbO1OQ5hvQcQB6MNo1QS3fke
oVWeAAjqeIczCNc8GQPl7nKgGUJDH46NXjow8kfPGwktA0UipahtS+aBuCyfIDix
fdI4ECrBSLDoeyEENiEYuHOJdebd4McsWFcz45V66MOyduFrk+Ksd+Qcp1AakKmc
1t2P8fQLlp+/cDCiuP1lybnZNZoBpK+56ococ+BhA89P1HvMax2tt8p3fdMyv7v5
wN+p3dawI+PXBggm5AUbzbxflJE/0oqcpv8HhfBna/7eWv5vgBI+gBeH03zCuRR6
dDfiTkAlpAxHLspHqZYC
=9kgd
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_10_13_17_+1000_ARzuh/zW.KXa9/Lc--
