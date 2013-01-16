Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab3APR05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:26:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54798 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab3APR04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:26:56 -0500
Date: Wed, 16 Jan 2013 19:26:42 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <balbi@ti.com>, Alan Cox <alan@linux.intel.com>, <arve@android.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <mikechan@google.com>
Subject: Re: [PATCH 06/10] goldfish: emulated MMC device
Message-ID: <20130116172641.GA15718@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130116165552.15183.92942.stgit@bob.linux.org.uk>
 <20130116165937.15183.76416.stgit@bob.linux.org.uk>
 <20130116171839.GD6377@arwen.pp.htv.fi>
 <20130116172701.62c5355b@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20130116172701.62c5355b@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2013 at 05:27:01PM +0000, Alan Cox wrote:
> On Wed, 16 Jan 2013 19:18:39 +0200
> Felipe Balbi <balbi@ti.com> wrote:
>=20
> > Hi,
> >=20
> > On Wed, Jan 16, 2013 at 04:59:38PM +0000, Alan Cox wrote:
> > > +#define OMAP_MMC_CMDTYPE_BC	0
> > > +#define OMAP_MMC_CMDTYPE_BCR	1
> > > +#define OMAP_MMC_CMDTYPE_AC	2
> > > +#define OMAP_MMC_CMDTYPE_ADTC	3
> >=20
> > OMAP ?? :-) If you guys are emulating an OMAP mmc controller, why don't
> > you just re-use the omap mmc driver instead of duplicating the code ?
>=20
> It's not an OMAP controller, it just has some similar behaviours. I guess
> that's because the original Google emulation target was entirely ARM
> based.

fair enough, cheers

--=20
balbi

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9uLRAAoJEIaOsuA1yqREW1oP/0NJ3P+q/zQGEGfzx6JEH17M
o0mwl5Y2k52vxPNbP8MPdSdNjTWXsGzmiIVRvfAE/i570l6Dw6Hp+/fKAGnzMdAE
sujXi0XjZIT35xuoFXXq1YzdHxcsrnZn3XotR/O0lf5Zcn8/18RUpiW6ybFl6h6j
+1Mk72tGIS+FyxFkFEFTwKT3tWg/6sVScP7HYw3QK+QVMVkgatwfVA7gEWEEQmP8
wb76EUBQVjDcjGKwsjofI0KnE9VAOtHeJzmxyj6buBM1qLM2TvZ9/kWfkgRIaKLX
TULmV03RILfjiXFW0nvISKLdBCGXML8OcSy9ID4n20gFmbiH1Ufl6NTSC7I4q6F2
dvNg7GW1eSRqZNWFQFALi90my8OWs393StPpYZANEhNjA7ZdSvNJX7xdARJJgdZZ
8OGbHNN8O4vj/p+uKVW0o1aZGq1g6o+cgCLSC93KqWcxl3MKKyHZXXiCYCwavPqn
tPKt9/5mRVdN59t4A+lDadP3SwSozCWl0aKVzadTVG9RwXV0VHw4JuiX/dlo9SrX
cuZWchmWWtb7XGL1Xl+naGLSNvU+0Y9WjKfs0H8hhdwxlhJioPR4QdoZMyQYdyyl
5vWANjErCrMymVH0IBBNpLasLJa8TmoKtL4l53su1CPjOgAJ0UEaGHDp//Kugzao
C/oCU2jYAhZukIyKYUot
=nypp
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
