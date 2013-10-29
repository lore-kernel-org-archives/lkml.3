Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3J2JQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:16:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54542 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3J2JQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:16:30 -0400
Date: Tue, 29 Oct 2013 20:16:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20131029201622.c8cb7bea9b360a98a2c66f74@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_20_16_22_+1100__AXsz9ZMzX/oBmyL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_20_16_22_+1100__AXsz9ZMzX/oBmyL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
failed like this:

drivers/built-in.o: In function `mmc_gpio_request_cd':
clkdev.c:(.text+0x75c3c): undefined reference to `devm_gpio_request_one'

CONFIG_GPIO_DEVRES is not defined for this build.  I am not sure what
made the above error show up, and I have left it broken for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_Oct_2013_20_16_22_+1100__AXsz9ZMzX/oBmyL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSb3zrAAoJEMDTa8Ir7ZwVTtYP/RNVc7Usvfv0PaiNtC25e9Gf
adwK2FUODYX4TUOw+ttxmJGlLIzPqIctiVRbzuDuVItyotaVyZEduCYbdNUWDX0W
39YrPptVkfi7iwtAZZ++dKAtmoyrIWE3ar5yk5JbC9Ha+HBz9tDVzmL5ilR0RbWg
MQMusGGXjKmdits+Zz2CGLQpOOxd1soL7wYkRNwB6a1/HMPQfEXHbcPdTlOBt+/2
5ytWijEGerghZ+KAZARDawcSqEU65TWYSet6qZrZSm1AVhsr4tGKOgxFfSLm69ZB
0nhumeEOpc9wJv+JSx2tlwmnZ6Kd3FZ5sGZ8el+K4xew1sN2hySsDcoe6aw2f3oq
Nigado/y52NwKPzYn9tklgAg5gRAS6JtP1kI+47eoVmpZ2q29bOYzez/dqi2LVV2
v/YEg836yc66PLfEHVeKtSQfTvMfxWHCFCdynQv6C9f2ElnAYdebcjOcF3Bno5Y9
cX08Q+BnXVN6NrrdRMGR3GWp+RadmB+BeMdsr3aGB/HmctP1yRwqp+aKkEshMZQw
C8JzDKhIkGJ+kWNxSYvnBbtf330vkrnDEx7a4ubYMd8ITTOPhgBsw51Gz47QceHg
hDNN5WUABotl58CPQXhSTp4AvQOWfxrtCCJBCQOWqjFE77Jgyvqf4PR6FD+8/WOb
3AazwOkK3LOUz3C+uvTi
=PCH9
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_20_16_22_+1100__AXsz9ZMzX/oBmyL--
