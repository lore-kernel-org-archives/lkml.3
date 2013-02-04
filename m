Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3BDFpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 00:45:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37057 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3BDFpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 00:45:15 -0500
Date: Mon, 4 Feb 2013 16:45:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the pinctrl tree with the battery tree
Message-Id: <20130204164506.b1bdf19083adab5e94b0534c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Feb_2013_16_45_06_+1100_p5=lUNntm1_IRH6e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Feb_2013_16_45_06_+1100_p5=lUNntm1_IRH6e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
include/linux/mfd/abx500/ab8500.h between commit 0ed5107fa860
("ab8500-charger: Do not touch VBUSOVV bits") from the battery tree and
commit 56813f798e8c ("mfd: ab8500: update header file and version
detection") from the pinctrl tree.

I fixed it up (the former is a subset of the latter) and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Feb_2013_16_45_06_+1100_p5=lUNntm1_IRH6e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRD0riAAoJEECxmPOUX5FEqlcP/10IYTaXeAGVQCTXfPGfMLmZ
9/KLi4hSYbsN9oUiY+ue3TAi2H4xZP+HoVvljc9nJ+VY0bTE8t83tX1x59MPwClH
UI6nRDGiYl+P0O6DMQGzgHq6SKf6sAe9KXZn/2vLfsZ1BLOGB/vDGAHXuPujZbva
BjAvbCuqDW9fIVPhLUad5oisiYSZg1DZPlVNsCV3berC4OWq++c55b67zaw257Ft
R+WVX/g7J7l0apbZHEU873hiDmQxlhxw9SlQ+4ljLQiDeAZb3jYpv/I0jCD4HCFw
CXSNt0eL3J38EC9f/FSrEpNtudy1KWsxXF/OQUESaoMwy0cw1As7/QE5dBqVvzWe
ab7+6A0bL+lE1qWfTWt9LzJ2dmAKEtMKbSP36p1WZbzZXEi9DUryMDZqG5wl3J7c
JqhxPj5L+DGHlA35iEm1Glq5ydYTwyDplHXUOBwjNywrPBMAjgso7ze8UpcXRtsw
BKChJA6gX5HigKS8gjIQK7VUOYOl1bCR8Bte6ZrlRAu9xwmxccysnfx/L7p2MAnB
nPmD4FkS18fxBTQ/B5EtotH6WEZL7It3S41XXrvXYWOoOgFHLzk6uurw27cNxmGn
splye8/MuNJipLtYLdTMQBNZzULyk1THMhhHicQwpcrd5PXYSwmniAR94V5dHi+i
q9c+d/IloK0SAoezrbRR
=YFet
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Feb_2013_16_45_06_+1100_p5=lUNntm1_IRH6e--
