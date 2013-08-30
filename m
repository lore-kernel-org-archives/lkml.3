Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3H3HwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:52:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52552 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753835Ab3H3HwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:52:08 -0400
Date: Fri, 30 Aug 2013 09:52:05 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: sunxi: drop lock on error path
Message-ID: <20130830075205.GH4341@lukather>
References: <1377796784-31147-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3VRmKSg17yJg2MZg"
Content-Disposition: inline
In-Reply-To: <1377796784-31147-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3VRmKSg17yJg2MZg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, Aug 29, 2013 at 07:19:44PM +0200, Linus Walleij wrote:
> I forgot to drop the lock for the return inside the loop
> protected by the spinlock in the pin config routine when
> merging in -rc7 in commit 6ad30ce046aefbdc3848232c665a728860d7bb68
>=20
> Reported-by: Sherman Yin <syin@broadcom.com>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--3VRmKSg17yJg2MZg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSIE8lAAoJEBx+YmzsjxAgNlQP/AoxAGf5H5S3KoPL0F/I18Dn
Ratsf+qN1/ULIZTY4Sd0nVKwgprWWnEETpsbCgfHAdhC3aP69Z/bVUWCeTEwMnfI
yxWnSWnvpsAnduDlgoODb6WYHo0rKiB+aAWLorR09BV3mC1kaDD2L8zegPG9R2eO
hf+JZOAwt3/pQ1zkGOEYcHuyx8UZJYuyOrppF7KXGolbji+ZBm6VLvaGRCIMmMSw
CGXcotm7UTuGJnaW9/bcir4RKXJFjLOF2ZyXoYxAhkRjNxlnsanyQUfGG1DpCQKn
zZ8viHLLiI0y95II1UvWcBf0wdSizRGRiz8Q595jAj9Ghucwg5hnJMRm5bjgtVQ4
FVJ1YB0+7z+8o3ZvL6nXx8rU01m2mW1GjuMm6Ty16k2Jq279WOiOQefNP3ruoFyy
8GGaNmGUdChaqal0XLM6iIX1DDRlDbvbVpHPt56KEyUoC2VJgvHTVOTrRp1Xg3Dw
0os7j/vHK4F05Qrv0h50AN5l0An1/MvGKkvQY8CTuf+ppkIR7BLhwPc3HPaL0x8q
z4bv+Z2Uduk3bdfoMQG2AmFPuaj6CbubnvbQnCdep0aCKj4YzIZd2hz7XN0bhren
tL/MsG5EbfmvrGfcOsZ9LO6fj7H+4Umiy3n3T6LEXCcc2QkR0/Qww0Qi2Fq4+x8D
IFS5HpC07swQHdBmjFUv
=WN+i
-----END PGP SIGNATURE-----

--3VRmKSg17yJg2MZg--
