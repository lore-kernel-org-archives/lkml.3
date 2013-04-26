Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3DZF1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 01:27:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35814 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3DZF1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 01:27:22 -0400
Date: Fri, 26 Apr 2013 15:27:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the trivial tree with the arm tree
Message-Id: <20130426152711.75809ed49e490843db673840@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Apr_2013_15_27_11_+1000_xX+1luxybWckPHmW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Apr_2013_15_27_11_+1000_xX+1luxybWckPHmW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/arm/kvm/arm.c between commit 3414bbfff98b ("ARM: KVM: move exit
handler selection to a separate file") from the arm tree and commit
b23f7a09f935 ("treewide: Fix typo in printk and comments") from the
trivial tree.

The former removed the code that the latter fixed, so I did that and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Apr_2013_15_27_11_+1000_xX+1luxybWckPHmW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRehAvAAoJEECxmPOUX5FEwtAP/j3XyYep7o04sbl2o9THRMb1
jsOTC9rx5PN6PlC/FFQAiuc9CBeng/gy2F/xWO5JK77K85MRvDV04rQUkaLxfKmY
kxdxN1nwAYc6zV801Mn1nHjWHyl6ACAUD1NitLJFkcATPYx9t+N/x3rj/u58/uYk
JKKGL03ZAkTyVGmAGuroeU7oJxFkh/tsz7vitKvyDar0w7TMtaeTdwjBpQbdO2uk
U1mlrlR4H4xRtFP9vULY9sVH7VgLpi+gJLW9S8wHychd4D6qviDbvZix3T4Gfyzp
W9O7TWewswb/RLhgokCIdiK03j0GTzXKO9nrKlVoYNlasGccATKBplVzNoIPyird
BnE2nRQTgwMpu79uBqFUO2vHWwu5QszVcGBjKIqSqqXrDpVPNfzOwIvkmtDYnLTN
OKAF9jGL4yv20zj1Li2XUnNkSe0FHhC1u4q5+sp3CRErJ5hVqsesUd/U4LuzI9aS
Pjs1lJaUvPY+0GfavxmexRrRTG6RZjot3fQzIl/QQMavdAZWeAls7HuAUvX1GvMe
HrgiE97q4i7VRnep13O7Cg+aKkZgoRju1KI4BnuDV/pr8NGF+mr9Zph9mLZwoyHw
2G9nPvZ9eJhr3KdtfmBTMWJH+DQeQ736lSkKgtJgBq3Xkix9VVsLYgg6TsLiBNeh
gQWqMf46bZU4WD4Blhob
=nmV8
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Apr_2013_15_27_11_+1000_xX+1luxybWckPHmW--
