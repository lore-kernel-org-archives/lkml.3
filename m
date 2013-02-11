Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab3BKIJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:09:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52983 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab3BKIJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:09:02 -0500
Date: Mon, 11 Feb 2013 10:08:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linville@tuxdriver.com>, <sfr@canb.auug.org.au>, <joe@perches.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] wlcore: remove newly introduced alloc/OOM messages
Message-ID: <20130211080845.GB25438@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360569218.12803.50.camel@cumari.coelho.fi>
 <1360569749-28372-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <1360569749-28372-1-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 11, 2013 at 10:02:29AM +0200, Luciano Coelho wrote:
> In commit 0d2e7a5c (wireless: Remove unnecessary alloc/OOM messages,
> alloc cleanups) OOM messages after alloc were removed from the wlcore
> modules.
>=20
> Commit afb43e6d (wlcore: remove if_ops from platform_data)
> reintroduced a couple of those.  This patch removes them.
>=20
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>=20
> John,
>=20
> Can you apply this directly on wireless-next after you process my latest =
pull-request?

please don't... patch isn't really what commit log says :-)

--=20
balbi

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRGKcNAAoJEIaOsuA1yqREAOsQAJJNeVOLFAc5GrPVl+1X7zpK
Rj2rXhyfb7FcSWfCCHNnwGVkqq0aiCePkXewjmTMYYUz/yPSj9TO8aci0G53LyY7
PIEX+xF4Ws4OFG3nGpl2m+j1ETDhzHtMWag2M70Uid1NZapb66VvlqXpEJPtYGdi
1t3LEALJCFmBjzzxWpooOHh6h2pWQxu/5lEv8NfHVSlo2Pm2o7vlabdwGNfulpGv
VjfudefeWoUIgYC1wwm1BgSDQ1oUwd1vKEbyQqXzQ2iKHQ+fEHK/8jIJStJqyfDD
f/376aGFjOBVebhLdtidENhPGNBPVH68REv0uqgaVYT0Msuzh5p5fyEKwGYLz8ZY
7wRdSJvCmvME/wr2zyn+GgLR6XHSysCRNs836dNS/e+lUFc1z6EWn8zI2bwH92Nd
z0EynLfG5Ecw5AmHANDl26vWOQPC/mJPMb1O1NPBk4nEmN9Y5rLXG1DkR+FeFkK2
cYVeVuwBABrvYinY21SAr+OXWKfdlv3k8ORr/H91Cu5WciiV3PeWPlsvYnhLJL92
g8RRxVM91TBJXmfbznuekI+5LrbFKlrzHinqZdBSGjL61JPFEud3fwlMdc84aeBJ
byRN2E+1Ilvsh0X5CgkoRd8F4V6kr8FoZZYi07HeffnVZHGEDw8vHU4hGex++hP0
kvhGhDBn+fzHabIoJ7WW
=y+w4
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
