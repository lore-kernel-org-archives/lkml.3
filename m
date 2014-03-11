Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaCKIzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:55:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54088 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753347AbaCKIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:55:05 -0400
Date: Tue, 11 Mar 2014 09:50:22 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com
Subject: Re: [PATCH v4 6/7] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
Message-ID: <20140311085022.GK2815@lukather>
References: <1394462512-11620-1-git-send-email-maxime.ripard@free-electrons.com>
 <2475487.axlvKsBQ0c@wuerfel>
 <20140310165156.GI2815@lukather>
 <5055473.2ZTHMWo41J@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fLj60tP2PZ34xyqD"
Content-Disposition: inline
In-Reply-To: <5055473.2ZTHMWo41J@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fLj60tP2PZ34xyqD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2014 at 06:57:00PM +0100, Arnd Bergmann wrote:
> On Monday 10 March 2014 17:51:56 Maxime Ripard wrote:
> > >=20
> > > Neither "pll6" nor "ahb1_mux" are listed in the DT binding. Also, why
> > > is it the driver's business to set the parent?
> >=20
> > Those are global clocks, so it's not really part pof the driver
> > binding itself. But I can add them.
>=20
> No better don't then. Can you change the clk_get() call to pass
> NULL as the device pointer to clarify this in the source though?

Ok.
=20
> > About the reparenting itself, other devices are actually fine having
> > any parent they want, only the DMA is picky about it (at least, from
> > what we know), so it made sense to me to put it into the driver
> > itself. Where would you put it?
>=20
> Maybe Mike Turquette has an idea. We have in the past discussed
> about cases where you want the default clock setting to be part
> of the clock provider in some property. Could that work here?

You mean in the DT? I guess it would yes.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--fLj60tP2PZ34xyqD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTHs5OAAoJEBx+YmzsjxAg6VYQAKwo41Su0L2wZ2fntncxtncY
wao5lq320EO0W6G2Aep9vheuFF2wQfbHDxHVxH2XO+UTIjktzillZruYl8y89ZWr
Myh9HZqHfpvvsP2Ip+pcU3UzGrKQRQHhiOFKDjKOWey2BXAoZNIUdHWsRPJNnMo5
Rq6b1qCgFrLkzR/QFj9XooAzusPkjFFG+7WiBb7Zb5OvsQNuRJxxPQlmv5BiCwfg
31W96Jvdbhy7ZB2zEWAgb7ksyKzPy/KBb5iuCHtkhnMqJa5AUkGAOHld1dSKDq2P
UJG0bjFraHpYCBl9qoK2OW8Hraygjf/WD4EofBHalhyEjEoK2hCH4/I7IBwBSMzp
9QRmh4e1GLKMWTNOhEcCGXV2W+9A8g3OwGdGw/Mu5+tGldBy/B1bLkwB/iDlH0IV
B6GnzH0BDRqFniL/gkFNbjgM1xxKEBhsqu4gI4GBmmcK2Jvhag4jePf8MdLBRN/4
F+wpHpM/QQyMX4D21bc4C3aF8dWNbqWfmVVXYKWIfE06deow7dVdou0yRZ68+Orm
KP/Pv0gWF0FapnjhJCgpCpVPQibX32FyHFVyIyb6oBNmSFkR2/r7DALoayHyUfYz
8kWtzq6OVIlxa9ZDHlykbiylh87Iue63vHuyHdFzI14HIs/x6sYsrUg+7uccBhqp
4bdu/FauiZn0Qx8VPIDk
=lro8
-----END PGP SIGNATURE-----

--fLj60tP2PZ34xyqD--
