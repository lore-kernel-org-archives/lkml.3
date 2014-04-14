Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaDNUwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:52:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33020 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaDNUwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:52:22 -0400
Date: Mon, 14 Apr 2014 21:51:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Jane Wan <Jane.Wan@gainspeed.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        Emilian.Medve@Freescale.com, kenth.eriksson@transmode.com,
        thomas.de.schampheleire@gmail.com, b48286@Freescale.com,
        jg1.han@samsung.com, sr@denx.de, insop.song@gainspeed.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Message-ID: <20140414205151.GH25182@sirena.org.uk>
References: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tH81YkO9bF1TqYxP"
Content-Disposition: inline
In-Reply-To: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
X-Cookie: Are we THERE yet?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Configure FSL eSPI CSBEF, CSAFT, and whether to send all
 received data to user
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tH81YkO9bF1TqYxP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 12, 2014 at 11:48:35AM -0700, Jane Wan wrote:
> Make FSL eSPI properties configurable through device tree.  The
> configurable parameters include CSnBEF and CSnAFT in ESPI_SPMODEn
> registers (n=0,1,2,3), and whether to send all received data to user.

Don't send cover letters for individual patches, include anything that's
needed in the patch changelog or after the ---.

> Test done:
> - Kernel version 3.8.13

We're developing v3.15 now, you need to submit against current code.

Please also be sure to CC the mailing list on patches, the sourceforge
list has been unused for quite some time now.

--tH81YkO9bF1TqYxP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTEpkAAoJELSic+t+oim9BSkP/0wR7irKM2xzBSjJUVT0f8eh
ly664YKstoy0H5g4Asy7+hjDGq8M0LCrqYdheDJTDgDX9f4qcp3ktcTa6ooeeao1
fcz5RXkXFSDLMv/tkN8T8zO86AfSG72sTVSC4MA4BXC8aD5zSmZAQduY2d0y2p50
UA2VkbBhXud1TawyKzv9VGEzbeuLXgktK5D53j5+NTKCepv017jFh5OlXmV47Pvx
1wMVJaaNZ4L/QY4LtK0OEHzrejJGd8gxpNei2RR3QHLfkYHSrViTrGdHZ5g4pmTy
O9lBOzZp0yz95kwBdN62cHF2j7hpHD/o6mN8V5mF0DEAiJ64NcGxhx4U/B19VwDd
G+Yj33YDgKAK9hN8qwxfhE0wSKEFtNxWYsz5jEdGXaytoS2qrn5nKQHgh8oIuLbE
rr485jpUTi9qkRbFe8Egu5oaB1u0XfOnCZVS/eM347/Em/IY9MiN7c9YUaf1bNWl
Awsw+cDfKXU8tD4TDGFmE1LgVuC3YNA6z8icfZHK9YchlhHPwii1o/rVjERPEyJ0
aYg/ijWMjn9rSdKGY/OcgyGuiDE7MGhD/CEjy7iTmzXXnFqEgVdDWWjkDd6cnhHT
lrfkZ80xeSf2iCG5xn0r+NUWc9s5HzQjfL30EKwp9p5ofyunXMoC4NoQ2kpgvQu6
XV/phnnh3amxxeqSpSt5
=cZdl
-----END PGP SIGNATURE-----

--tH81YkO9bF1TqYxP--
