Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaI0Qqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 12:46:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55827 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbaI0Qqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 12:46:44 -0400
Date: Sat, 27 Sep 2014 11:46:21 -0500
From: Felipe Balbi <balbi@ti.com>
To: Behan Webster <behanw@converseincode.com>
CC: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>, <daniel.vetter@ffwll.ch>,
        <geert@linux-m68k.org>, <laurent.pinchart@ideasonboard.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <robdclark@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] arm, fbdev, omap2, LLVMLinux: Remove nested function
 from omap2 dss
Message-ID: <20140927164554.GA7076@saruman>
Reply-To: <balbi@ti.com>
References: <1411780253-4492-1-git-send-email-behanw@converseincode.com>
 <1411780253-4492-2-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <1411780253-4492-2-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2014 at 06:10:52PM -0700, Behan Webster wrote:
> Replace the use of nested functions where a normal function will suffice.
>=20
> Nested functions are not liked by upstream kernel developers in general. =
Their
> use breaks the use of clang as a compiler, and doesn't make the code any
> better.
>=20
> This code now works for both gcc and clang.
>=20
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Arnd Bergmann <arnd@arndb.de>

another one that make sense :-) And probably also deserves
checkpatch/coccinelle/sparse.

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJundAAoJEIaOsuA1yqREUkkP/i7tBWnOQu7nUvgsJOIBPe8Y
Nh/Zh0I3ivxVtMVFEXDo6GIYSlENb0duDYHXHBkbSr2X67g8rEab1ROrEFepmghc
JIdbWDxrBa+QfB9rG+xM2Uq2sVKc1o+0QZi92va9fsdmolMUWXwshbefhYzp0+yT
03WAWVfn2JykPzO9cvH9Ux41LSpFDNOq0q2U9S8Td3O6dLLN5plDcgB4zHwy/Oal
doHPdKx6VaPG5h/9R88KjiDsrivUEAg2PEy4nN+wKIOfk4Shb8cI+jiKLZAkFP/2
8wBTnFySnl1D6iHiNUY5TflmxOF76eiZVoXOuG9qf2ALAjdeC2KV4mAOY/mIprdc
+JKXCMvr9mlDDG5/8Ap9e0pdheW8j4nEvQv0hDIeP4TCBvvHIFWEJRViLxQyBQav
+AgCBI3+h1XPkFhAjNygV9NWgOxzWyzEpFnp/8vxO0V0+6UMUpa3IA1yGJicPGiM
XBDo54ED5+958dvgs+sbjl4NbqCxRoE/BGsN1JuzIrxne9/9AWhWOORyxc7M81+s
XUGX5rgkYQFDfuzlXI6PdDU+ZpEshFqqTEjcgo1x3VVLQl0bWwo9ka70f++4uUHn
EB+8V9Kj9tcMKnPPSEtfzdEosS42PrIbnbPz11oWgAMrWhNFmv6SckHj1aoxAd6W
CCzYb7XhvOHi7Kig/r5v
=vNsF
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
