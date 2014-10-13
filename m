Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaJMKjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:39:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50168 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaJMKjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:39:42 -0400
Date: Mon, 13 Oct 2014 12:39:21 +0200
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-kernel@vger.kernel.org, dp@opensource.wolfsonmicro.com
Message-ID: <20141013103921.GL27755@sirena.org.uk>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
 <1412845377-17134-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdqEfx9vLKjgI91r"
Content-Disposition: inline
In-Reply-To: <1412845377-17134-2-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/6] regmap: cache: Sort include headers alphabetically
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdqEfx9vLKjgI91r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2014 at 05:02:52PM +0800, Xiubo Li wrote:
> If the inlcude headers aren't sorted alphabetically, then the
> logical choice is to append new ones, however that creates a
> lot of potential for conflicts or duplicates because every change
> will then add new includes in the same location.

Applied, thanks.

--sdqEfx9vLKjgI91r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO6vYAAoJECTWi3JdVIfQA5UH/RwAS2tlDHOEeOi82mtxJnI8
ILZaFzkDWChxyqWLDUmnOpRmw6cnBZyohFc59SZAtQyhlEt242GpbUBWZJIH/iMy
XHtFL6oY/CTllXyxR7943pgn0KzDw12tVCr/zjw/MS68zGEDqvaBLQ7BLq+picXS
VStqXfWIjmH1oY3n4nvtFSg+eNWKgpftoDFqVogcqFMnLLrmgKQZYSeAwXz9+CZq
UU/oQxsv8fytKjNtWsJmIFcFwsNwzIeMaNR+WJoazFJniQS3xcvWsPSelc2jjaQ5
6JMcUTA4GsaOminEY/ZIIZfgpcVK3mqoNd4G23F+DxgyxtY0EQCcbA2uqTQtqXo=
=wcQi
-----END PGP SIGNATURE-----

--sdqEfx9vLKjgI91r--
