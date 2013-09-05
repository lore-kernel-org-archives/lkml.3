Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763180Ab3IEHce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:32:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53083 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab3IEHcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:32:32 -0400
Date: Thu, 5 Sep 2013 17:32:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: bad commits in the drivers-x86 tree
Message-Id: <20130905173222.946719639b05b3b4b3f9b8fd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Sep_2013_17_32_22_+1000_.9fwO6jY.PErX+Ng"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Sep_2013_17_32_22_+1000_.9fwO6jY.PErX+Ng
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

Unfortunately, it looks like you cherry-picked (or somehow) managed to
get copies of quite a few commits from Linus' tree into your tree.  Maybe
a failed rebase?  This has been causing conflicts in linux-next for the
past couple of days and I am sure that Linus will not want to pull your
tree in its current state.

I suggest that you reset it to the state it was in the day before
yesterday (commit 41c8bd1c75ef8e85) and try again.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Sep_2013_17_32_22_+1000_.9fwO6jY.PErX+Ng
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSKDOKAAoJEECxmPOUX5FEwcwP/0BnVGb0GybMD+46MA4ucepe
Ahl2RWTPY94myU6is/8IXCgQpAKgwU3V9wPAUUh4QXwEdnT+/PB5wAQIgATXDgYN
Vu8SB/4HO0uLYw3idgg8q27TXwpjKo2b7dUvbKIDdlnVlknWjQbnzcTXrYE+4tQG
0IUF/Ymc8yOJmjijWVIuNpV074KOwPOZViGLKcjXYaio5jjZp1ENENFYVOpC9fic
2DlZVpAVq1I+7HD/L0KxwVZIVcY3ObH63l9Db+pyiF0TPLKqQ7rNn6+SWiDeizfC
yovsqzsI/vWPvxnVPZbkKrQZM9LkiS9FxcFmgqrNIBKocadjp7UtVZOQprnIPjdF
f4PsQjn078GZW8nTBjbKJySof5G7VHR0lCBONJzby/4KTRu+CjUvnB31efP88IJa
vgg5hgM20fWCGUh0ZUJ7ugodY5h14ttoGgua8cNuSy8PTvUvT2Y2XGOkU/lhQNPS
ekKX7tVXTK51dSj5+lqK2vUmOdN7Iw1SZ8J5l4/oPl2Yg6ulcv4ZAynUBtJ5Ih8S
NFj8pAoghgdFbvGSp5dtVV7yInvnpJ5sBp25nW9fUXZ4vkXzYf6u8qrJFXv3fc8d
kJcjPbJBaf3QduftIDOsC1eM3hQfRO6T6gNmkWfmKz56fxYH84ZdGWO9Zb17PCCe
7gF0DX2v9oZQXWGgMrDO
=vbNz
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Sep_2013_17_32_22_+1000_.9fwO6jY.PErX+Ng--
