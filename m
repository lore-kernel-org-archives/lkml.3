Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3A1Kfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:35:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49967 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3A1Kfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:35:43 -0500
Date: Mon, 28 Jan 2013 21:35:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: linux-next: manual merge of the usb tree with the driver-core tree
Message-Id: <20130128213535.15bb937175de3ec3b4a09daa@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Jan_2013_21_35_35_+1100_n=F=3=Um+vwV6ciP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jan_2013_21_35_35_+1100_n=F=3=Um+vwV6ciP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/phy/omap-usb2.c between commit 148e11349b0c ("usb: Convert to
devm_ioremap_resource()") from the  tree and commit ca784be36cc7 ("usb:
start using the control module driver") from the usb tree.

I fixed it up (I wasn't sure how, so I effectively dropped the former
change) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__28_Jan_2013_21_35_35_+1100_n=F=3=Um+vwV6ciP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRBlR3AAoJEECxmPOUX5FEvqMP/3DI618Lxhin4Uu84HB0lfso
0xwyESwmfWMjE2kcnhejpnbKn/68cjXP+phycrItKxNHOZDlg0IfPvdpsML0yqKP
hJ8guD3KIKVmqBnNg3A1kqGK3TSrHQRkSEEBja5u0Dq3a9ZX5aplb12FOBqxaqfq
mDLOGDY8IT828B3MrsYedRf3pLUeDI1yHjjEtayvno89w34vCxrsAX7JnrbjA1uz
brdQjH+rIeWDO7SwZA6PKdx3LnLCO/Jw4DcS7yIEw2nXYCToZH7IqDdHrYUgLqRB
b++1+yUR++raPB0KWq7laAJkJHQttjmnZFy9/b8qIo4K/vfW4wzJwB89HLLudk+I
3VZJqrne0w1WcVstjQbx080cPpLHOk2KJx4HltCcB/ZNCj4xEtYzcCVCC7QFmiNG
37XUJ+f93HdE1wCNJURUBgHt2ySWLB9XrvuR84MDkDoUyvolGtYHirQdgZUQjD2O
FmkYzQDkgeiegsLPt23QIs5+dyzjygwecmdDFPraXzeNNtAUmYScdMQJiaZyzIsb
gzkMS224mjvQ2clg2sVmFzAJf6H9IridxVr/Jnk2jirt9aOKPvYjAz/i8mLu3U7d
WhaWcqf/IQ0bEFYFq62wEEtHUqS/Da5tPB0sUjCCYotY2OkItVqAJUwTAr04O2+V
USLouuGNqotO5KZAqWB+
=rgeS
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jan_2013_21_35_35_+1100_n=F=3=Um+vwV6ciP--
