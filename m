Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaCCQtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:49:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38878 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaCCQtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:49:41 -0500
Date: Mon, 3 Mar 2014 10:47:29 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH] usb: gadget: atmel_usba: fix crash when no endpoint are
 specified
Message-ID: <20140303164729.GE10987@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393515733-15764-1-git-send-email-alexandre.belloni@free-electrons.com>
 <53109EBE.4020900@atmel.com>
 <20140303164633.GB3155@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="maH1Gajj2nflutpK"
Content-Disposition: inline
In-Reply-To: <20140303164633.GB3155@piout.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--maH1Gajj2nflutpK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2014 at 05:46:34PM +0100, Alexandre Belloni wrote:
> Hi Felipe,
>=20
> On 28/02/2014 at 15:35:42 +0100, Nicolas Ferre wrote :
> > On 27/02/2014 16:42, Alexandre Belloni :
> > > If no endpoints are present in the device tree, the kernel will cras =
hwith the
> >=20
> > s/cras hwith/crash with/
> >=20
>=20
> Do you want me to send a v2 with that typo corrected or could you
> correct it when applying ?

I'll fix it up, don't worry.

--=20
balbi

--maH1Gajj2nflutpK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTFLIhAAoJEIaOsuA1yqREhU0P/RgITj/LrTiRS/WLQkqMyz+e
42rYQF2HA4tOj22msfWepWdCNC9LvP3vLcYyp2wPWsjjJaa54Dg+t9ZcRczQ/BKC
cMlNIGhtZDWenyZuOmuuungt7SXsgpMU8XUK/flRO6iYqYph56LRbIXQwL+G55p5
y3sk3oW4wKH9bUKLPhuBI6UJDqwDVX4oRWEnKT/FDgm47gulifuURbn4K2ybnTsh
4a/svJ8vNOwkHLepDtJtznuMbYF2O2kAFgYi07sDB2t7XGLnUhEmxKS4/VJRwv4o
UFatsAHMjrNuY8msDqeMmkS09zPffbdHx1vDVJu6IzQ3XhVf0BIyxY2fncEoNp8w
8BqcJqAggxTf5j7Afsn9eoEYmVN1di5I1DU6Ff4sGjCm4FSBX788mlD+M7ptCfCu
86kbdpOzW8zh7/NVf7/7rvD5K7abGewtOrViyChMpZ+wbhclHPrDB4K2TeWRfBrE
lCMxhmlcJjFnbOq+wYXcXsfs+Cx0l+9k7QYf8Ey2aJ7/yB+P9UTnkT2c+0i6QtsW
C5EbO7uAxpQSaWt7tf+f4x4hRmcyClVOappMRZTRGeb3pJXrcUS2sTT93Ls6uYnD
JEZqqvS+VcsBukt2D9+quNnuG+e3IWtBWtx8F4aWyNcVHOcMevparrrY83I4EA4o
aX+xdC1AptcaaxxLF09D
=bKHe
-----END PGP SIGNATURE-----

--maH1Gajj2nflutpK--
