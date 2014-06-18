Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965797AbaFRKUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:20:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52329 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965039AbaFRKUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:20:39 -0400
Date: Wed, 18 Jun 2014 12:17:34 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH v2 13/20] clk: sunxi: Add A23 specific compatible to
 sun6i-a31-apb0-gates-clk
Message-ID: <20140618101734.GP19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-14-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WOTjKnJ88wpJKlWH"
Content-Disposition: inline
In-Reply-To: <1403016777-15121-14-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WOTjKnJ88wpJKlWH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 10:52:50PM +0800, Chen-Yu Tsai wrote:
> The sun6i-a31-apb0-gates-clk driver is generic in that it supports
> the "clock-indicies" DT property with "clock-output-names" to list
> the valid clock gate bits.
>=20
> However this might lead one to assume that the clock in the A23 is
> the same as the A31. To make it clear, we add a new compatible for
> the A23, "allwinner,sun8i-a23-apb0-gates-clk".
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--WOTjKnJ88wpJKlWH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToWc9AAoJEBx+YmzsjxAg4qoP/0LXx/5xHrGu58BuZOO6+WEE
WQoJSNad4abLWVgDv8aKSfln6FdW2l6gMQjPg6MVKMJQN12qTTizs2Vg2q3KQkCE
S0GM9YFDBruW0t9r1LFazxeSCpEyh7DHLRsOCr64+ggIImTCAML1n5FNZMx2PCi1
5pHisu0IFfUNyY0TXULMmlzPqU+/nURdQkTZPlhg3E8orC+TjhTpB3IPoF7PYqo1
BJ663fCv5OzoFFH0uBxQee6euWWGMtCDQ31E+muLjnH4xYOsTM9QwXP7rZF7RRSd
hz8TXUpoWgzJ2olAFWcNBa6pmV+feQuna+hKGdtx1PTl+ogHvTtYVcLLIoiRiQeZ
h1CBeAE3eNQpg3f1+Hp2l0eJeZ9BGdXHwiSrVin6X/6zWSX7te2a0BfDGBOjSY9W
3pX/Wa95ULJsaE99ap5c67n86O1GTdI/zwT508QOZyF3U2cfBFeiIzcdF4I5Vs9Y
FAnP/UGc1Cb7HUGuXhJVSMZ3P4Hh3s5J0sq3MndaD2a0g2aAa+piFRsYydxcfLW5
OkM0y6Ip/8Tv2UaYiMwlOY1Eauv2I0ZQii+A5UhDs8o/wf6kqw816fvBi5PrNFJM
Jit/kiSVURr9m0ZNkmLJjemPq7BmENLAygXFLcQ3xbZe4WdcCSWAoKQPL31falfh
6twjHi4whER3ESLOmmj7
=Rzly
-----END PGP SIGNATURE-----

--WOTjKnJ88wpJKlWH--
