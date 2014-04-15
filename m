Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaDORZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:25:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55147 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbaDORZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:25:34 -0400
Date: Tue, 15 Apr 2014 12:23:10 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Weinberger <richard@nod.at>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: mv_u3d: Remove usb phy driver for mv_u3d
Message-ID: <20140415172310.GD16002@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397561783.1985.55.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M38YqGLZlgb6RLPS"
Content-Disposition: inline
In-Reply-To: <1397561783.1985.55.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 15, 2014 at 01:36:23PM +0200, Paul Bolle wrote:
> The usb phy driver for mv_u3d got added in v3.7 through commit
> a67e76ac904c ("usb: phy: mv_u3d: Add usb phy driver for mv_u3d"). It
> then depended on USB_MV_U3D. And that symbol depended
> on CPU_MMP3 at that time. But CPU_MMP3 has never been part of the tree.
> This means that this drive was unbuildable when it was added.
>=20
> In commit 60630c2eabd4 ("usb: gadget: mv_u3d: drop ARCH dependency")
> MV_U3D_PHY was made depended directly on CPU_MMP3. That kept it
> unbuildable, of course.
>=20
> Remove this driver. It can be re-added once its dependencies are part of
> the tree.
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested with git grep.
>=20
> This was triggered by Richard's "[PATCH 01/28] Remove CPU_MMP3" of two
> months ago, which I acked to eagerly. See
> https://lkml.org/lkml/2014/2/11/714 for the details.

so this means that drivers/usb/gadget/mv_u3d_core.c isn't used either ?
Instead of deleting this and introducing a new driver, why don't you
just help fix what's already in-tree ?

--=20
balbi

--M38YqGLZlgb6RLPS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTWr+AAoJEIaOsuA1yqRE/WwP/2u20E+79bULtjuN3x0PbKDU
wfCtDO3Rt/cuuz+h/JcjuIba6cEe4TGuYQxcH0H85AVrB9VvNjdJrJsZWbESuuIM
vAjxcBEWACG1F/aHWuU5ai/4kx4DyDyfHuPOT6TRJxzh42UVpLwuPMAzapbaHL/O
Iqd26XLfOWim0bvCRKWorK/szR/1+IErDFJCo86xpqQBlJY2Ud0Iod4hExZEpdL/
woM90b7fyY1R2hRuHj8jSTjDjzhKOtNR1VkilI3xlwhpLByrBM+9ofnHCsYonnGt
lsZ1s/ygO2/FJqvVN97YmFdlO+qafTIH2mSBV2SMxokv0948rPiz7dJi+g6V+SdM
HTchboNkkzw2HU3ljZCcDd4CSIUEMOelzTtODNd33XqZoUjNTSSK/xFS//I8CUfe
5UIAxE2c6EUk5k8VVjRQeFHUcnyTvw3fRiVT03SEag8xjGrzDxdoDZL6/8czaHFO
p332NW69hyvY1pOrYcptrFy6mHlZfRW4/KG/3NLbOYo7GKtv9ZqXKzcx/E9WqckQ
Zvh/ueY6QrgPy25qrSIszgMXjKzLf2QOUVkLWVrc76neCpC1dneVsB5Upp+Rw7V6
NLPMaZHpYGpC5XcNh7vc5174Tm1mc4YtDmZ6/Irq+vUIOUyoHxPPkrwt26iCX5J3
b/VFX8tu2ESTkJnI5gs8
=iOHv
-----END PGP SIGNATURE-----

--M38YqGLZlgb6RLPS--
