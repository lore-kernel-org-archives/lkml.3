Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030653Ab3HIOWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:22:05 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40718 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030311Ab3HIOWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:22:03 -0400
Date: Fri, 9 Aug 2013 17:21:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <george.cherian@ti.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 5/5] usb/musb dma: add cppi41 dma driver
Message-ID: <20130809142143.GN12041@radagast>
Reply-To: <balbi@ti.com>
References: <1375471450-31154-1-git-send-email-bigeasy@linutronix.de>
 <1375471450-31154-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IoFIGPN1N3g1Ryqz"
Content-Disposition: inline
In-Reply-To: <1375471450-31154-6-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IoFIGPN1N3g1Ryqz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 02, 2013 at 09:24:10PM +0200, Sebastian Andrzej Siewior wrote:
> This driver is currently used by musb' cppi41 couter part. I may merge
> both dma engine user of musb at some point but not just yet.
>=20
> The driver seems to work in RX/TX mode in host mode, tested on mass
> storage. I increaed the size of the TX / RX transfers and waited for the
> core code to cancel a transfers and it seems to recover.
>=20
> v2..3:
> - use mall transfers on RX side and check data toggle.
> - use rndis mode on tx side so we haveon interrupt for 4096 transfers.
> - remove custom "transferred" hack and use dmaengine_tx_status() to
>   compute the total amount of data that has been transferred.
> - cancel transfers and reclaim descriptors
>=20
> v1..v2:
> - RX path added
> - dma mode 0 & 1 is working
> - device tree nodes re-created.
>=20
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Vinod, do you mind if I take this through my tree ? It's tightly related
with the rest of the series.

--=20
balbi

--IoFIGPN1N3g1Ryqz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSBPr2AAoJEIaOsuA1yqRErDEP/1P1n4kp8MUiK2wKZEfZ0pd1
aVgvd4obBYIGZwmL7ssgeWEvQALRuc+lm21vreCDoAwHd3GlfdAMWIZHgvoztRRO
Ws3n/7E3/aNnRwu0jq9EwOs2A2gBXUQj5018frL/s2kq4Y5qUMcLSPhQx0vWpWKI
nhP+FJYIsi+9hNH1M4xqlpy1kT0I+s4/VfFCKcnk00M3DZFosG9zUI426W4ZZVq8
dmyxMdM60iSQc4edSAh3KK1y+pZgurOC1qUlwzODert3mGRkHeIIcc5J3/15c3HG
+CZnl3H2/8etK5lhxcLrZmmPJ93U/6AnkvjuGURlhK34VQdYRx4NlxtJeMKzrOEM
R5adZBBaRhDYdigUxA3ResIvgIchYoKx1Xvcs3SCFk+2W3QUdiKoIu4HiFE83ZgX
z/EdY/7XRjFo5vh1if6GxXDMcIaphnQTfNSmw56pd4RKa2sg4iQlyJEdBDpFBe/0
uR68TS9ddh4K0yQFjmy1lruSbwwaVh8V9WDjSzZPNCW0rxvovlajkcBRavD+illC
yb96g+frZbKypRIpgyxjJ1YVahLg3iAReUE+EiFrB0oZN5rRy335BojCN1pFnD6B
wosaUYS8jkV7kvOeDh149CW24JrQT167UeXVNo3hGCLCvtoDvexFEXabrRLmbOQF
q1lMmpz6445YGR9E/ggw
=cnbN
-----END PGP SIGNATURE-----

--IoFIGPN1N3g1Ryqz--
