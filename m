Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab3H2MkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:40:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56144 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab3H2MkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:40:16 -0400
Date: Thu, 29 Aug 2013 13:39:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130829123953.GE10783@sirena.org.uk>
References: <1377364396-27861-1-git-send-email-Julia.Lawall@lip6.fr>
 <1377364396-27861-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qPhbOctOI3h5o759"
Content-Disposition: inline
In-Reply-To: <1377364396-27861-2-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: simplify devm_request_mem_region/devm_ioremap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qPhbOctOI3h5o759
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 24, 2013 at 07:13:15PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Convert the composition of devm_request_mem_region and devm_ioremap to a
> single call to devm_ioremap_resource.  The associated call to
> platform_get_resource is also simplified and moved next to the new call to
> devm_ioremap_resource.

Applied, thanks.

--qPhbOctOI3h5o759
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSH0EWAAoJELSic+t+oim9N+4P/AvISWoVBHzyE8GAotu14Omi
Bg0OQdQyL6LVw/CMImx84+Dw2JRiAaLKj0fTAqwonHlV/gaXjwMVmLXYSdxwV7T+
2Lmj6OQS9DVRXHLcwhmAW7sT0vxfZMgikuGxuRsBw8J5+/CGveuCtqeNC5010lkY
kNYFag6yGsWB/AIhrdU+hsh2maX/IC5b6HfMe8pIzVcizFNbWYe12FfIv5/kwT7y
qeMjW6kopw1XblR/U+Fj+iLLSoCFBvMPdawiIynBobRWadwCFWOiuphtBCUsmM5l
Wlw5XxOfhm167cQnMz4/7SypXVyhifamq3t3gEqzJT8bhwlVnEM3M2Gx8hmOb+Fk
r0g8rEZwrEVE60rcAUapgt8/d5uSSygBBfc9Au+Ep1wDDhaFgdaWSBSCxouPTJ7p
qAg4KC7cMuDMFzBt0Q5KSGI4XHr2VXxlM9HMuVtW1Yo1IdjD5Q1oStlIwWcH5b0a
OJapBkMtEdxl6lYfornl+ia7ENshw9e3IvvrB4u6h7vWD9MOJDiDVLKU5ODtubjw
4Ho043YLYUUEqBL2SaRrxWoSsAjT8DiET0l7EkcoVVVUAL7DRe2gMGnQ32KOR3F4
1A9eu0pcuKNkVeffCas7weaHjGZDIypCIH7cwvy4YJIMYGT11dl29sbInJOKG4U5
stPvttqnpnz1Go+bYZ61
=b6ou
-----END PGP SIGNATURE-----

--qPhbOctOI3h5o759--
