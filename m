Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934898Ab3BOChY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 21:37:24 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36052 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3BOChX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 21:37:23 -0500
Date: Fri, 15 Feb 2013 13:37:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the drm-intel tree
Message-Id: <20130215133714.6f55139ad1a037b7b9fa1b70@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Feb_2013_13_37_14_+1100_sUgGnzut2AhupKjY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2013_13_37_14_+1100_sUgGnzut2AhupKjY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the drm-intel tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "pm_vt_switch_unregister" [drivers/video/fb.ko] undefined!

I have dropped the tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Feb_2013_13_37_14_+1100_sUgGnzut2AhupKjY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHZ9aAAoJEECxmPOUX5FEHA8P/Rd1F9rpn4Ub6Yq6Q/Mt+XAm
i/Uevjdd4qTwgfAY23Exw3iIeuZpdb4U2dCxHrJXKVutIjf0uNlAmmNyCRVE6A2y
hGN+e2zZSdBdx3QHzOE1viLkrXYq2t01d9meEOaYjk7vfhUO5QHj5tzDSedx2xDL
0pkk6s/Elf+rJDCnzR4ybN5zXsqpISaauhvlpeFF7ha4lKKKY77/wtv92IvFe7Vw
QcX3aKkSnnOfhPMQcDP5DBpNEO/TKfjdqnnCvA6NxBZlgTdb3zxF4AIN8cHdGIdv
XKZOQaqgGR4bIZ9TMV5CzkHKm9dx6xo5sv58Xkuviu3R+hhioFNerN6jWCwZt0mX
4oi32P9jSuMIX6xz1GsnLVsjecqD6jLXV8wIte6GhclM9nmb6yfJMrmAGeQdrv/F
7bZtsfcEvYWIA3Bm8CZUcvwikMrexD/srplvI1Zn3nvoHm3LsdSf60GD8Aw+1QNC
wBG8TwKPEslPC6Y8zhiEFRARme9AWGiaIHVfVD7QCde4zVoYv5ZuN2mQ/Xm9TJO5
BKo6CUzZ0kQDsm7Xl9ft77+nU9ZDg6ET0Aw1x4xUvJiqkusxTcMPdwQfsIAZISPB
82nhUjJN7n/drrwRgNznn6uQF7o/Vzpzdq4eS6NwD5bGUDL8++uOEX+98uDVDfOz
xCl7bJEQW2+gyiPlxzBz
=1EaY
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2013_13_37_14_+1100_sUgGnzut2AhupKjY--
