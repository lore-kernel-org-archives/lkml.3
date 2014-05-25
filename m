Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaEYTmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:42:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33515 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751647AbaEYTmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:42:38 -0400
Date: Sun, 25 May 2014 20:48:08 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 03/22] clk: sunxi: add "pll6" to sun6i protected clock
 list
Message-ID: <20140525184808.GP10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-4-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LW0Rr0Uq98qh6Rv"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-4-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LW0Rr0Uq98qh6Rv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:06PM +0800, Chen-Yu Tsai wrote:
> PLL6 is used by some important but undocumented module, most likely
> memory related, such as mbus or the actual memory controller. As we
> do not have a driver for that, add pll6 to the list of protected
> clocks, so that it won't be disabled and leave us with a non-responsive
> system.

What issue have you seen?

The system actually works pretty great on the A31.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--1LW0Rr0Uq98qh6Rv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgjroAAoJEBx+YmzsjxAgKwEQALNAU8JHnvZys1+eK7PK58Xl
C3U1cEp16rinFV87yxQV/U6vA9v8h+pEP6lDaGKPlIFp2Kk4/kXs0v7VKtCM1Q/+
F1zSD3uuL0oI5uQleSXbgZ6++VC/3Oa08IvJ7KYOv3MCtYc44QlswOu5N2pErw9q
yrZ2eBMjzc02QxvvBdzL+ZdzPBJPfK7V7b96B61PxMbdtPEUQL0OPywLgg/N+CZt
4s1g3/esZDqAOgJ0Lc7hKSpP76iae8fv7jMYUr63+uWaZwXUvLLRQPRP1/ClaTAR
wjP6eoZVFxPoOVph6Dq0ndZwvkGCbY13PzdvIjg2J9HU8uMIiXFrrE6vvzzfgwx/
N9KXDkVfuJP5wkD4P+KfZL9JCmkPO+npB6WQw04LuLZIgkCOMErRey3pHNBbMJVj
g2AhyKnodoey/uOiMDMfxf+N5mFNUvY3Ryd9A3B/CYLvT8KLGUGH44lbgGZxCj4W
3+xqZLaR1Pj6PnIGWkUJVDAWesq/XcPbNujPhgVySbD89ADMI9AArajF2HtZOFHt
DdskeTmEE7aH+zFvqioKUtmgec34uGZhE+b2MoyO4WasJYBnVtmKegPheNveww0Y
Cbj1vsprNkw7mJlk7CEjNkvAedQaFeiodlRRenL21vxb7slHrKRqFI2vxNJavuwj
vIUcDCf+m2tDa7y2KDsz
=dqUG
-----END PGP SIGNATURE-----

--1LW0Rr0Uq98qh6Rv--
