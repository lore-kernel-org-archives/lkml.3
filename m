Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934773Ab3E1Q2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:28:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54305 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934576Ab3E1Q2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:28:36 -0400
Date: Tue, 28 May 2013 19:27:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
Message-ID: <20130528162715.GB28253@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-21-git-send-email-lee.jones@linaro.org>
 <CACRpkdYjjDp+7hzGtAchyy3+5Vxc8jK5THGCETkAO_V9Hj9Ssw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <CACRpkdYjjDp+7hzGtAchyy3+5Vxc8jK5THGCETkAO_V9Hj9Ssw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 15, 2013 at 07:18:01PM +0200, Linus Walleij wrote:
> On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
>=20
> > For all ux500 based platforms the maximum number of end-points are used.
> > Move this knowledge into the driver so we can relinquish the burden from
> > platform data. This also removes quite a bit of complexity from the dri=
ver
> > and will aid us when we come to enable the driver for Device Tree.
> >
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: linux-usb@vger.kernel.org
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>=20
> I guess this stuff is dependent on the stuff Fabio has recently sent to
> Felipe for the ux500 musb DMA so these musb patches should
> primarily go through his tree.
>=20
> It seems like the later changes to the platform code
> (arch/arm/mach-ux500) may be sufficiently orthogonal
> so it can be done out-of-order?
>=20
> I can't merge any of this without Felipes ACKs in any
> case.

Do you want to take this yourself ? I haven't fully read the series yet,
but seems like this depends on the rest of the series. If you want to
take it, let me know I can ack the patches as soon as I'm done
reviewing.

--=20
balbi

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRpNrjAAoJEIaOsuA1yqREOPIP+wTdGoX6sKB7isxYa7pMn/R5
BGZ80lNHGrWNG52gMVjSXaYUyvgUBQb+n6e/KQom5+2dcE/Ym09tX5f70gpSbv+d
acJSlli0AAS3EgEET5VUQDQQBxoYCs+pkriplRlXRqLNY9HwMFNZfZAGCkdhXoUI
xg/Cz40CN3WrJiKmNXvA/R2fCfAGoQqd7Tc1uYl+f6oja4fuKxK0d6+SQD+riHtJ
n/JBkJ8kiKy6e1+cexcrL08LjaMOXzjAqoFHw97Ks9G9q8eUf24JbtHiLQVbV62R
ECnv8a45vNzrht7NqWhbD4ED/NMWhyQd1iA00FAPswccVVcLA+u7CY6uJ9xbU34p
qxRW3qqR87M1Fc2HribBLeNs76C2l4V3bGJes8wXx+6+K3gJ6NAZ6xRaISbhoSJl
R55mI7RDUJsyw8u3TzZ7OLaxjRQ0n0KWilgOPrxOetfAde5h6Yqdt1mgKGXvPPRU
hQr0sjve8XCmdS0h1tAwIqV97WSunCGBkVtwKvcmkPxu/BEDFSCcvxJUJcUSGnEP
3jqYT9/L1ZveCKiwSQXmuehhRkFJAzrt0MB1nzn9AmD3e99STNhyn9iNkcE9SbHG
Iq3q1pSYCzOcbg1utj9W2bS4QEHGum+4/b5MunRYqynPrNfxS+r/hPkG9FCcPN+L
+8oj2x+GnOAiMqWA6mjf
=1ZV0
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
