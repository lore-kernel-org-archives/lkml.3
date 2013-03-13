Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139Ab3CMTIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:08:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54372 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933024Ab3CMTI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:08:29 -0400
Date: Wed, 13 Mar 2013 19:08:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] regmap: Fix regcache-rbtree sync
Message-ID: <20130313190824.GB2912@opensource.wolfsonmicro.com>
References: <1363189113-9757-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
In-Reply-To: <1363189113-9757-1-git-send-email-lars@metafoo.de>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 13, 2013 at 04:38:33PM +0100, Lars-Peter Clausen wrote:
> The last register block, which falls into the specified range, is not handled
> correctly. The formula which calculates the number of register which should be

Applied, thanks.

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQM6XAAoJELSic+t+oim9JC0P/j49JEAsSoYfkpfHjAhIornr
/oCLaI4ECZtdTQ4g93h7RABk7NOxe7601KB4510SZja9Y5w4ODOlz30mfz6ur6OE
8hbCI8WX/0RU44YZUAFx+bx8MB9N2IiF7y7vb9qwQeCndPoH+KK8vf3/3pcfv5lU
otjTQZ9jNCHSSCm+BRA3/cpYY/u9KG8Qc+wNUF3xEiS/0uEGcWFE/RHK1nyIzdbu
KKlatMg5mMt24862L/KtBTh0PGZQ0ykd+/iY6u6L4H8qdM9EKCEh65ISsjWqR1Xf
GrE+kEQ/PJqKa0c+Km/PT2xJrIhSkrDPfzVwKypcQy7H9yXia1M2uXf73t0vjS2q
oxrzJlh2hKwxzeSR/xWTqWP3/gtx7YC563eP0QT68+Xw6OW4XWic9ASA/kEKMKBp
uc6fHbRkpmccW3ARo7+9Q9rTXUSc6tXHuAef61sCquLKKNbqGANm01sakpaDDlzD
MxwWYKuhy8BvxufFtKG2HXtPQTpzZDBQTiqL9+gf082AfdrxtkYhnulx5xo6YrFD
AmMkOkyFNOUorPsmh24rM7SFa1iWzM/Q7sVo63ulpdy1yEAgoq0z8Kszcqqz4CQz
5F94qICEmxPPQRJgJxglOiB+OaGMLE+VUpEZgQxkGzuYglNElcpH1If6aCIacDER
zV8sYopx2Xydg2GHE+p1
=OrlW
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
