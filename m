Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3GBVbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:31:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38089 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab3GBVbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:31:04 -0400
Date: Wed, 3 Jul 2013 00:30:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Luciano Coelho <coelho@ti.com>, <linux-wireless@vger.kernel.org>,
        <tony@atomide.com>, <nsekhar@ti.com>, <mturquette@linaro.org>,
        <mark.rutland@arm.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 7/9] wlcore: sdio: add wilink clock providers
Message-ID: <20130702213030.GB10388@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
 <1372776948-24840-8-git-send-email-coelho@ti.com>
 <20130702153423.GH7013@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <20130702153423.GH7013@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 02, 2013 at 06:34:23PM +0300, Felipe Balbi wrote:
> On Tue, Jul 02, 2013 at 05:55:46PM +0300, Luciano Coelho wrote:
> > Add refclock and tcxoclock as clock providers in WiLink.  These clocks
> > are not accesible outside the WiLink module, but they are registered
> > in the clock framework anyway.  Only the WiLink chip consumes these
> > clocks.
> >=20
> > In theory, the WiLink chip could be connected to external clocks
> > instead of using these internal clocks, so make the clock consumer
> > code generic enough.  If external clocks are used, then the internal
> > clock device tree nodes are not necessary, but the external ones must
> > be specified.
> >=20
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
>=20
> Acked-by: Felipe Balbi <balbi@ti.com>

I guess this should've been

Reviewed-by: Felipe Balbi <balbi@ti.com>

instead

--=20
balbi

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR00Z2AAoJEIaOsuA1yqREEt8P/1njtIAvN5wlNlH6uuTde3Ul
LVDwR8xpbaLKByJVAHcaGGA0ZWZ7SfTUVxBFoTM/ttRnYz9qXhimoRNuUKIgQDqI
Kq45Va+AcKdOsDNpQl8lnfurXky8iwKCYCFCnfpe0lviYoTwK4Ri7I2B/R6nym1M
w0Ehvc5XL3eBqNzdjtXTDPD9klCAVM7She/jWBQsvTCn1B/XxwO9I9WMwWFUeodA
+EdpCGyFO2UZJQH7XGQvYpeMgraFqC4iW7CNaF3A1cMgcx0qIo3q3X77+XM1Ar0O
hLG+W2c4flz2Gt3ox/c2aRKEXnkhlmn2M9G/L7eeM+3g8Z6NZBHmNxue8OpXYrDn
p2NmusEOEiha5EwkbiylhCOPEMdMPfQCF4gfUit76JXMnOOC7bDReKd2neKaqv//
D96KeatpMYFcSVlrYjMwnLL8q4+R6m4b8wL7C1tzr/3ulChTntdWE888OcWqFoF7
ITzjzGHJy7JNNVW/opLw3wv5JU6HLxe/+qfXGo02jlAwQc25lCR7Cz55Wqr11MDr
AAR7D7p+wXxvZm06nWhNXNeoHYBKDfZlp5+O3B3Z3wtBFrDCijexAXKWQIfuI5nE
2MIngJQz0VUz1Kc3j0WkZJRdT5haoWx4yWDKb6E1Mxzgqf430Lfezur+JdE1J/hD
Pf/D9UwgGU+gKReHlJ5R
=TM3w
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
