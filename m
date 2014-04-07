Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaDGXF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 19:05:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60120 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbaDGXFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 19:05:24 -0400
Date: Mon, 7 Apr 2014 18:02:18 -0500
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: Apelete Seketeli <apelete@seketeli.net>, <linux-doc@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        David Fries <David@Fries.net>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Ben Hutchings <ben@decadent.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>
Subject: Re: [RESEND PATCH v2] documentation: docbook: document process of
 writing an musb glue layer
Message-ID: <20140407230218.GA28921@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140405183636.GO22445@amegan>
 <20140405184205.GP22445@amegan>
 <534322B9.30605@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <534322B9.30605@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 07, 2014 at 03:12:09PM -0700, Randy Dunlap wrote:
> On 04/05/2014 11:42 AM, Apelete Seketeli wrote:
> > Document the process of writing an musb glue layer by taking the
> > Ingenic JZ4740 glue layer as an example, as it seems more simple than
> > most glue layers due to the basic feature set of the JZ4740 USB device
> > controller.
> >=20
> > Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
>=20
> Hi,
>=20
> You should be cc-ing the musb maintainer and the USB mailing list (so now=
 done).
>=20
> Felipe should probably be the person to merge this unless he wants me
> to do it...

I'll merge it, just resend once -rc1 is out. Thanks

--=20
balbi

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTQy56AAoJEIaOsuA1yqREf/IP/i0SKBtUeJznzQRZi+vx0NDW
ADubTV5aP99z6rJzUyqGAJsKbUfkMKLH/EqwbTlSXXAQKsIPKGZzyHrmsspwpbdt
Pm9YMgVhDtgiWvmq7LvjT/1eGsfdzgsSEMOTtC1gn7FZhNCrW/BIz49Qpg6bGltu
bGqvW6UV8o7qIRaNe3TAWABFLvB0INIHrlZkfKU7EoEjFk0Xe8tgZ7E+VIFoHeqt
xye4g7NHwFyJpMFGJFObM4VpA/gKhuippmcQVAMFy8UgNUP64bM7BbqiCY65bdlP
99sWI2Dxqid7DX/XKqaT4B2nv8P2tP/7MAVzw2pZybedOne2CMMSc0U0J6+i2FU7
CsXKz4WDsm/ZM+ZmkOOp2yT+XqfcmbkS3vto8aGOW5jynoVQiNN+vW1WZ/jE+rNw
+hveGKNcaxEqQCIF1am2oFF+y3p9APwgnoeIIFqffuwrocR8Fhpx/H90PnJHUtJf
xHuEgAQFGpeH4R3M1n0RLDj9E/iQ+/ftb9daIrpIHtRQlfwznMAGxie6jNonC0Ml
AfG1Jw60nTZNolO/x7YL9UrTwjt+urYOaowIR631xXZNs46o0b8dBTlkygxD28JT
rv8FeJEwz78OTzyRqued2JP6LuDxIcxIm/cC+aN7LLzWyHl0egcdJdIhFk2BlupA
Ekf8NsLxbkBpPmSNIUrY
=/+l/
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
