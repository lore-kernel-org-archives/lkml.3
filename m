Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3JJV1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:27:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57056 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab3JJV1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:27:19 -0400
Date: Thu, 10 Oct 2013 16:26:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree
Message-ID: <20131010212659.GA22835@radagast>
Reply-To: <balbi@ti.com>
References: <20131010212030.GV21581@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20131010212030.GV21581@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 10, 2013 at 10:20:30PM +0100, Mark Brown wrote:
> Today's linux-next merge of the usb-gadget tree got conflicts in
> drivers/usb/musb/davinci.c caused by an add in ea78201e2 (usb: musb:
> davinci: fix resources passed to MUSB driver for DM6467) adjacent to
> the modification of the device registration in 4c9ad1059 (DMA-API: usb:
> musb: use platform_device_register_full() to avoid directly messing with
> dma masks) from the ARM tree.
>=20
> I've fixed trivially and can carry as required.

Thank you.

--=20
balbi

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVxujAAoJEIaOsuA1yqREX7cQALABxxACszITjehrJziE1gOP
4r0rxzeWOAXtxAlag4SJXOWjD7XBItWTrZBXTB+uhxhJnh93bzYqjG/FQn2iMVL+
FuxmfGuA1xUPEC+RAS4hSxyFILtuSptLFXllGNeVn7P3fAGqQie9EcGv0Owafd/t
1oFLe9Dj8h1gIo0BxjS524MFxIxZVGRB/8+EPrBo+1baUDxd7/hXoaRlrP2JQ/nz
6FafI/nxFYofvnyukH0kdaYtWca3MfdD4OJ2OrDY2C3eYF+QkN3FF6QBYTYvsqfX
d1+qYVInAZmPnzkh9+/DWQVHpHWKl6+U7SJ2qevTNRNnW9k2PefKsGkS+EGHV3MJ
HnKGhDlH70vqW8B9/vVa8WPlBK0QmZVksU9guuFs8CFyw93YjyjmKMgiI1kEKyt/
fr40qk4cEqS8jcY+js6uWW1y4jlXfDjRn5Fox5iHz/QQgX99CckmZlfMInRRRGDM
Tp70j5pKNJcVLGCdWhy0ks/oEhz4AYqa2cpVKmvajoeFkVAT4KVYJuuiRz7icMLD
DMec7uIPwqjhKLPtWNu66lKlWUEdDBQpXSlEdOjtSiGioFQ2pFBkxEOQZ22NJTp5
woZ30c5Z74URfWp33YHmjCOnjHeKpZYQgtGHnt9ykuRTgRViBB6WVhvfkMPHmttb
YJ0mD8iMP+Iz6MuOOXi5
=yk9v
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
