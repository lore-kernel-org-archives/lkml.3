Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3HZT4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:56:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38465 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3HZT4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:56:44 -0400
Date: Mon, 26 Aug 2013 20:56:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20130826195632.GG10783@sirena.org.uk>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
 <5209BB6F.2000208@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aYDVKSzuImP48n7V"
Content-Disposition: inline
In-Reply-To: <5209BB6F.2000208@codeaurora.org>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 78.32.9.209
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [ARM ATTEND] catching up on exploit mitigations
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aYDVKSzuImP48n7V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2013 at 09:51:59PM -0700, Laura Abbott wrote:
> On 7/30/2013 12:05 PM, Kees Cook wrote:

> >- RO and W^X kernel page table protections (similar to x86's
> >DEBUG_RODATA and DEBUG_SET_MODULE_RONX; it's not clear to me how much
> >LPAE and PXN is already handling this, if at all)

> We've had support for RO/NX on our tree for a while. I'm interested
> in attending the summit to share what we've done and to see how much
> of it could be mainlined.

Is that related to the code that Google have in their tree?

--aYDVKSzuImP48n7V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSG7LtAAoJELSic+t+oim9JHUQAJYA4eB6b+V4bEPr3VuD0Bon
dOyEkcMO1TtgK3DgLfqbMbMXuoNqRKiGjbWEHv5MKNPYNFt+7OwKXibVUzvw3wbk
Skgc/BqVx2O+Y6nwsOn3s6w2arQLs76P30QRMIx1b0bsqzaHqgsmlaCdS+spCOn+
JVHWlf2kbmRlLlQg5fRZPmvvzzywqlnQJ7M5Iy+I1sHy7PwIC2PUUe5GykWpY0ig
lJtsHu7+Y0roGn6WoW7r8+WgOjigxf1xwzaWGrvYmIiRbEtk1RTb35ki8cQeUOJa
bwkb5YVRy4DZISJNFqZ7sFsmk9qjzIveB8H0+qP9ztediuPEaT5+S7XA0ZVs5kva
d7VO7p2FJy+BKuS7F9ni701QTsbx3ZwungxXsnCot/cbFLHt9jyba6ZtH6yf1agX
lgqB52cv1CCZhjGyRSDbz97bFPWlqvm+yDw+3VpOQycfveguplfGJVEsqLVPznUn
PmfSZ2ju2BqT0IKXXGys+H6WGo6UFld2D7Dx+HD2ac3o1xlC1owX1Ttb83wLSA3F
HmX8wv5bwCiv/MlKIQfHiwe65c4z7jgJm80+giQstpnQv981evu1QINhVWFtkKfw
VeyfEbNsh0rvafSbU4TnSy4EOY0meYoTyen4oOBM+mTkQvUVW1C7GhCrfFH5vTLK
EFxipo2bfh17bnnjh2mL
=EMoJ
-----END PGP SIGNATURE-----

--aYDVKSzuImP48n7V--
