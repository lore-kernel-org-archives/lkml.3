Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3EFKaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:30:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46651 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620Ab3EFKaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:30:00 -0400
Date: Mon, 6 May 2013 11:29:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [RFT][PATCH 1/2] clk: wm831x: Fix update wrong register for
 enable/disable FLL
Message-ID: <20130506102957.GA13472@opensource.wolfsonmicro.com>
References: <1367422261.8160.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1367422261.8160.1.camel@phoenix>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 01, 2013 at 11:31:01PM +0800, Axel Lin wrote:
> According to the datasheet, FLL Enable is controlled by
> R16530 (4092h) FLL Control1

Both

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRh4YeAAoJELSic+t+oim9luMP/Rymu9iqgrWu3vIX7UcEYjkq
+6P7y34FboumqcWhIQYIf0a1LyxwHBocQDj9DQiuhvodzYARWqgX6zHOo/8uWuds
UA/ZaIyrIzkhQHZ9QYD1hV7HA/MQS+ppLvwWdfL1aB3J55ARfvSCP57bQbJbViz+
UOfaKcIwoH+9JXQ7sKtRXmb61evloJKL5kmrWDcnivYwlhEWwR2UPaQA3/3YjDHP
MQ5QHhzCWjLOkUb9PZFQLl3bWW1ZdRrUkB77QW3ns5XCwBOmIfsfAORZ8cosyQ4x
JJ5jcjPppBIegr+SJWuuG2vfqW3NegXpZ9d0a88VrZlokP3F81NSOi+qtzDS09FI
6efQeRPyL6mHO3Dh14WoSmmbH1W9q2UWJNvGriX7/LH+7noHYdsSnQNXcKuxH0hT
BNWdUPvQB5gojDMWg6OrEh83zYt0rrKsE/V7izy77DM2U5dTK0BQXhmRy5dnVsBL
3DSF5ewoEcn21zVjuQmcKL2Nv4DS+eNIIvampTtf6YTtZ39UlfZkOTVe3u/+ttf2
k+Z58oJT8DyNuWKGN26IZTVGg+R0fjvSsT+iVXehmzTeQwXgt1KR1TfpW+YugmC9
RvJr7hCl05fkda+ObxVSS5RET8/qIwvdnP0/wTnyBkiX1+SAxKopiOKiUrF/lKIL
4jmda90USpr2dQh6BWoH
=M4hw
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
