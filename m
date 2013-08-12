Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3HLIPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:15:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52417 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751055Ab3HLIPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:15:04 -0400
Date: Mon, 12 Aug 2013 10:15:01 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv3 01/10] irqchip: GIC: Add Cortex-A7 compatible string
Message-ID: <20130812081501.GJ2911@lukather>
References: <1375609657-15434-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375609657-15434-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tTtjoeSQr0V4EVgS"
Content-Disposition: inline
In-Reply-To: <1375609657-15434-2-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tTtjoeSQr0V4EVgS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Sun, Aug 04, 2013 at 11:47:28AM +0200, Maxime Ripard wrote:
> The GIC can also be found on Cortex-A7 based SoCs. Register a new
> compatible string for those cases.

I'd like this set to go in 3.12, could you review/merge this patch?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--tTtjoeSQr0V4EVgS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCJmFAAoJEBx+YmzsjxAgWvMP/2x4qxn43Zi6T4MOnHKiUFck
S1UUr8TTs6zL71O3flxDQ2qmagqdc/osW3T7eRB2kE+Y/FSl+pcC2EkUC+SyRhFf
PhMXlKb9Hx5Vp0RW8bCzbvjc1cGMF+CaDc3k7txev/wy+EI0ttfPu6vi9SGexq10
lISuUq+mpd+fNy41zlpaQBe9LnIbXD3Iko7QVBInVmePMAbgYzirPTsUOYD1Tmax
gzHag/WlK1lDya16ZsgZaNaaRYknIxnBN765QxtkRDt1Gkad/i0k0xyQhIrXS2Xd
gnogMr1/Dwc1ESaq3N8ykb8+jihC3jS6QbSAO2biFAXbTCP0qw3nVa7JqopPavlo
DDW2IZ6lcOrIhHmX8cBRkpKXZgxjZc8vls4snG8YGicgy5XtGwgKpiyi8qj9a3ju
Vj4umIvAV55xaTRaw2RY7lrwNZC45TFCzGm98AV2nZ+/9Zt7JvsCzvHJZynwalU7
Pjk+i23PlY1rHEUoKHuHMG4B+SI1I/JT9tiaQtd0UmTEPBfwnV+9d3MomTsuwb91
Fnp61qwv768DzOoWgulzwCrUMj1jKjlEMWFZSiIGuRhwiwZfyiV0gIfP13QZi3UU
8FxhzmzegL5iRlD8B30PdnoWsjQyyLB3EqPxDTynCv/1MNN2eezJlgD+G1XguPCO
m89cnNNuokkOrOJTILcf
=mI2s
-----END PGP SIGNATURE-----

--tTtjoeSQr0V4EVgS--
