Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071Ab3LITcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:32:25 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40370 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab3LITcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:32:23 -0500
Date: Mon, 9 Dec 2013 13:31:16 -0600
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH] gadget: make USB_CONFIGFS_MASS_STORAGE depend on BLOCK
Message-ID: <20131209193116.GB28441@saruman.home>
Reply-To: <balbi@ti.com>
References: <52A61781.6070708@infradead.org>
 <20131209192157.GA28441@saruman.home>
 <52A619A3.7020705@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <52A619A3.7020705@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2013 at 11:27:31AM -0800, Randy Dunlap wrote:
> On 12/09/13 11:21, Felipe Balbi wrote:
> > On Mon, Dec 09, 2013 at 11:18:25AM -0800, Randy Dunlap wrote:
> >> From: Randy Dunlap <rdunlap@infradead.org>
> >>
> >> Make USB_CONFIGFS_MASS_STORAGE depend on BLOCK just like the other
> >> gadget MASS_STORAGE options do.  This fixes the following build errors
> >> that occur when BLOCK is not enabled:
> >>
> >> drivers/usb/gadget/storage_common.c: In function 'fsg_lun_open':
> >> drivers/usb/gadget/storage_common.c:241:3: error: implicit declaration=
 of function 'bdev_logical_block_size' [-Werror=3Dimplicit-function-declara=
tion]
> >> drivers/usb/gadget/storage_common.c:242:3: error: implicit declaration=
 of function 'blksize_bits' [-Werror=3Dimplicit-function-declaration]
> >>
> >> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> >> Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> >> Cc: Felipe Balbi <balbi@ti.com>
> >=20
> > Already have a patch for that
>=20
> Thanks.
>=20
> It wouldn't hurt to fix mainline so that it builds without this error, eh?

I'm not the one who merges patches in Linus' tree, that's only up to
Linus eh ?

That patch is already in Greg's branch and he has already sent a pull
request to Linus.

If you're concerned it takes too long to fix build errors, you can ping
Linus to see if he'll merge Greg's pull request sooner. There's nothing
I can do.

--=20
balbi

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSphqEAAoJEIaOsuA1yqRE7GUP/0walCgU8HnhXwTnKf4gw+1X
KNF8vRzHw1iwI3ClMGR9RNr9E+LTlDAHJk/KdZhx5IsuvbEwEbGcVCKHVOVKTpkm
13/7q/QRsBGILJ/vWnVVRefqd/hOuUp1BqEtEvFRPgXQJDgGMkhTgiAoE9VuxMAG
cEAhvFQMyE7OkTLF1QOVfoQGPFzaowOoE5lkN8FKXTeTLzNSTgtDp34zqNoqiPKD
APKSBrWCrAnMcumfMcZEgDXdAUCKTL7KrGtJYfl+BQvuR9PLPqElFJ7y+Cgl332J
QL/rIqg3EfBuIvPPeqJDlUlc3Ks+YW9YHwmh2hPGtg5/OaoZySywMq2bFkkUz1gw
f4Bc4Q3+MYWBB04I7ftpRfIvj59YJrKxWAMibeyfLBIxEjylDTzfDVlprEmeuPAs
abcnCPGSJqjDjyh9q0DYshdcgWnDNnTX+YJrEVQS34BY+FRhhv9daAar9Ixkrapp
eVGtXuDJvXU/nGAP0iGBmxJV/dWSss0gj9A+32gJc0+Y54L0VPzcVpfP2ho3PtVF
ct4x1bh8zNihVebHtXNjn0eT16UXvTHLDI/fb86zlfGNYGWdqQd3Q8vqh+pwEUA/
r3IYuGBq8jBKlRF5xLcu9CE6/9ab0x9urxDOE85pkRhUCYm8xw/g9vLnELW/hfrp
X4iFN1InYX24JUV3j1OF
=Jluw
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
