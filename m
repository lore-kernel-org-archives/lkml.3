Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaDROMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:12:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37850 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDROM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:12:27 -0400
Date: Fri, 18 Apr 2014 15:12:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140418141214.GM12304@sirena.org.uk>
References: <1397760924-7423-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mNe6SYwlAlLDuqTf"
Content-Disposition: inline
In-Reply-To: <1397760924-7423-1-git-send-email-tim.kryger@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Return error in get optional stub
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mNe6SYwlAlLDuqTf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 17, 2014 at 11:55:24AM -0700, Tim Kryger wrote:
> Drivers that call regulator_get_optional are tolerant to the absence of
> that regulator.  By modifying the value returned from the stub function
> to match that seen when a regulator isn't present, callers can wrap the
> regulator logic with an IS_ERR based conditional even if they happen to
> call regulator_is_supported_voltage.  This improves efficiency as well
> as eliminates the possibility for a very subtle bug.

Applied, thanks.

--mNe6SYwlAlLDuqTf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUTK7AAoJELSic+t+oim9gsUP/iyYyBtR8K+gLdIzpcrx5i+k
YCc/7IqUYuDA99hUyRwSglDaCIbV9Ofef1BDg8TBPeIdGp45Qp1OGAj9lC6lhcyS
dJgcRmosA5Pedr/n1/qSEJajQRUdz/Mrvh3v+azGiz9/yVrxNs+azfI3vbQKc5od
IwB9d3FKWm86bLLRxVaO/lH+2ae+9VsykJTwIVrtPJUCo9qgge53h4i1Cj96N0ob
0+xxiUa085HOMhiwK4ghkxUYb0bg6NSyZRkQQW3Bu/3mvYyB+kXrnrWoCbYyAekJ
PKwUtI8kM0VAxjNGe72PfJyC0ahxMeH02smSF+OBc4GB9Kl4EVzcdf+Wvzpibrk/
drqrPt1cZ3gXGv71BWeYjx9yyWhz4VAIr1C57HILWEyUZsLlBydWWsZ2ylhDdx9B
rn/YDXv7p1xxLd+UK4FvIMzZxgbmXicNp1FKamKFdsQmAcRCbeABkOFN78t/1i80
3lVr2aL4XQ6sV5PGlyKaUig6w2sLw0FoR86KSx5slOrBTLqnq6wraR7KIlXWNN1f
qn8oh+sfBAGJ6BSaOaRJQJzLyP4JwIYMveM+GlZF2rYSpTZ6XWwcVdweMRCe7/xR
sF/5uhkUT29MyWixm2ULgSs5/OZNBuyJmKVz9uDtqIo15J7cXHMbdDd1ffyYc8lU
MxG2fZijrJQq2B7ofsYj
=eDQN
-----END PGP SIGNATURE-----

--mNe6SYwlAlLDuqTf--
