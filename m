Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaLVQMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:12:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50490 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbaLVQMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:12:38 -0500
Date: Mon, 22 Dec 2014 10:12:18 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: sundeep subbaraya <sundeep.lkml@gmail.com>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: query on DWC3
Message-ID: <20141222161218.GF12815@saruman>
Reply-To: <balbi@ti.com>
References: <CALHRZuotPpSoX9bnQin=93k0Hr7tEp_HZDaaBvfKaPfmoi_EBQ@mail.gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E03048450126C@US01WEMBX2.internal.synopsys.com>
 <CALHRZupFbTxTn9KiUCmvcmgYxUUcNfvAoMqOq=Drq0gZ+H246w@mail.gmail.com>
 <20141222161123.GE12815@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Content-Disposition: inline
In-Reply-To: <20141222161123.GE12815@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Mon, Dec 22, 2014 at 10:11:23AM -0600, Felipe Balbi wrote:
> (please don't top-post)
>=20
> On Sun, Dec 14, 2014 at 08:39:18AM +0530, sundeep subbaraya wrote:
> > Hi Paul,
> >=20
> > As per my understanding, for BULK OUT we do queue a request with 512
> > bytes length since we do not
>=20
> sometimes we _do_ know the size. In case of Mass Storage, we _know_ that
> the first bulk out transfer will be 31-bytes (CBW), if we were to start
> a 31-byte transfer, we would't receive anything.
>=20
> > know the length of the transfer Host is going to send. For Control OUT
> > we know the length in wLength of
> > Setup packet, hence I assumed there is no difference in programming
> > model of Control IN and OUT.
>=20
> there is _no_ difference. It's just that it was agreed that for anything
> other than control ep, the function drivers would take care of it. See
> the uses of quirk_ep_out_aligned_size.

btw, why are you reimplementing the driver when there's a perfectly good
driver to use in mainline kernel ?

--=20
balbi

--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmELiAAoJEIaOsuA1yqRE3BMQAJIQ312rXGDmKtAw0u1t2g3S
D+50Vm9XvL6wDrfRe0UdFmqQ9XBQrYhEjYYu5Ct/VyK2NhMvCFOJM6CJ9F4xmuvA
C3UrXam1jUnC8zBAlc2Ec7J4ZX5azeSFGyG59/GxDpUt0gYYwtHWyBulA1rPjCWl
VEl4DCup86Co7VrX8LkhGSlWL07v565vUSVIJFTjAmjECciisDmPTV59yHVJMM5n
xtQ68vXbDNBzQQbsfyB8k92BUdz6mbtJt4S/d8fSTHxUzAtjrDhtQi/Rs8qyDdtd
u/3DQahcaxTvOZTdP3as7UpqgbHMw3pEz6bQGo6ARC+6BpKpOY2zwZwTMAhM2t4k
qBT6qaM92X0uUP2DxbCiB1tiy0TNn/yws933Mk4TF8LYqd3C7fQWCeIs00VqLW6F
+3/7SU1TV8Ha+n8tNxYG9k1WECRIjpCWFBH4MVRjE8YjE07BwrIHIXx0SYJ1d2kS
qapJgcYBpku6ThqQtvfA6j+4q5Kg5VvHCsI1Rarbbp8IcbdVo3RC/Ss7lcwyh8jm
73CLMHRf2Ee4Ct6NVMUwMqUsJAssH56RkFpTMDGLXMIKyoT+NK72WqXrg6DeHkjm
4TzREUQHvr1KSfSOJ5y5kzsIpWcKgMML2DpXUQoqqFtjitQ1eFXctZ5rkNWcXPQ2
aIP94xgFK6TmLkV23oFB
=GHVV
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--
