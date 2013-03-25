Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3CYKO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:14:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33261 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580Ab3CYKOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:14:52 -0400
Date: Mon, 25 Mar 2013 10:14:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, "'Magnus Damm'" <magnus.damm@gmail.com>,
        "'Simon Horman'" <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>, linux-fbdev@vger.kernel.org,
        "'Guennadi Liakhovetski'" <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v3 3/3] backlight: as3711: add OF support
Message-ID: <20130325101442.GJ18316@opensource.wolfsonmicro.com>
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
 <1363968949-12151-4-git-send-email-g.liakhovetski@gmx.de>
 <00da01ce2917$54856ce0$fd9046a0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ONvqYzh+7ST5RsLk"
Content-Disposition: inline
In-Reply-To: <00da01ce2917$54856ce0$fd9046a0$%han@samsung.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ONvqYzh+7ST5RsLk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 25, 2013 at 02:12:21PM +0900, Jingoo Han wrote:
> On Saturday, March 23, 2013 1:16 AM, Guennadi Liakhovetski wrote:

> But, there is a typo in comment.
> > +		 * At least one su2-auto-curr* must be specified iff
> s/iff/if

Are you sure that's a typo?  "Iff" is a bit of mathematical jargon
which means "if and only if" that's fairly often used in a computing
context.

--ONvqYzh+7ST5RsLk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUCOLAAoJELSic+t+oim9JXgP/i3LNEfswgZh0nLszgq7Q/mJ
7NwsVM+fA11r4hAnbxktm/IKHRlNqCT2QIuZz0AztICLn+o8fE4SKARnYtMskRkg
6UjZmF2O/Sean6EkRgvsBl4h+2Nndw96qpS7c89rFxQ+RtrP/Wuiy5ILiJ88+835
UTXkFSn+WCtg6VKWRNEshBLee5Hd8f9mLJgrUThHLBy+g4HaA5YsXMsvA17Fc5/o
LVhSSagX224LcJCtN2umZfu5LSPfwYlfQgzP8NM1p09By2/nMk5VwV/CSlwcI5kE
3QD+IJIWEePXnipns3wjcwfMO5p2LccYMegaJU4SB8i6SzVxDMVAuGF92zdOcRxz
7Wh5TFby1bIhPLVl0+KWqKpuvFHqkBVpjymoMOvbS9VqH4b2GuaaZ4MGHQSCl20e
IFxwVm9gj6++SWlBfS9zvieDwhruWHBiMWItdVhH0MDwdXAyZR+TsNxJf4gY3Isn
GJQAwABPEbO3oVm9WUTPpOrNwvNsGZB6RaUHeZWwq3i9y6E5AiknKvkkMDMl0dvX
pO+qNTU92DIdhe9FYnxOF8V2X8tTx2qeV0Nd6UxnOq+jgXIT3o0TP8aausRg1hFp
Z4kUt5crA0kxjBsCSYNXPaiPFnWhfc6Y3YIvpfvNR/RbCQNseeSVyngf2swpoi7s
Gl11AOHXrKyKJ+g7/5cC
=XMYt
-----END PGP SIGNATURE-----

--ONvqYzh+7ST5RsLk--
