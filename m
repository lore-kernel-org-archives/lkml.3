Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaAGPiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:38:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48371 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaAGPik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:38:40 -0500
Date: Tue, 7 Jan 2014 15:38:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20140107153836.GP31886@sirena.org.uk>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
 <1387468508-12286-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cVuSN1UEk1U5M3GR"
Content-Disposition: inline
In-Reply-To: <1387468508-12286-8-git-send-email-lee.jones@linaro.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/11] ASoC: ux500_pcm: Extend Device Tree support to
 deal with DMA data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cVuSN1UEk1U5M3GR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2013 at 03:55:04PM +0000, Lee Jones wrote:
> Soon we will strip out pdata support from the Ux500 set of ASoC drivers.
> When this happens it will have to supply a DMA slave_config to the
> dmaengine. At the moment a great deal of this comes from pdata via
> AUXDATA. We need to become independent of this soon. This patch starts
> the process by allocating memory for the associated data structures and
> fetches the MSP id used for const struct indexing.

Applied, thanks.

--cVuSN1UEk1U5M3GR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzB95AAoJELSic+t+oim9MXgP/0CH4m4LqjK0dIynkI9PxPzK
lwzXYPsLCAnze2HSeQk0dXJohXESPBdtRi4uYrx3Dt1wrwqx4MFIF/1+g9eAcx3f
d66oLBSHw6peMyLDjvf6OJoLgmwCYcctiZ8j9gNtKO6Ekf/VFoHPhypfRlHZOXfn
ZXQvQL8nQ0An9x/Z6/BdjPgenNVNyDbyT2cAPi3qgo3B23K43mxSoAi2XHAkgXqh
qHO8KXMlxNg9bbVcdv4S85sQAqFPDSOVpmkS+mZaDrw+HOlZA4EzUiO/XqJDCuuA
Vhs0IQNIkNnKh56oT5cfh105Wx2VkgtUE5u4JdEH3gM4soxFWFCeWj21eBV5t1hN
iWwil67LGshnLE4RzzGdV93fCg+lTE+bYEIZv9lYuSnw5l1HSatsUL4fVoZuGExy
4wdFo427cRE3Ua0bg+Ke/tBhMqAbQiQfSHgmLvcLbf47LOFs+ULgR5KLVnybtEke
PRfZ491ptCT6NwUkaWePWQwJc9QnFsmq5IfJCioeqLsJEROnvYBpBSOHZwEXn0Kg
N+wpEtBzCHnKvFuzGpviHVweVT1Ofgyb5Xb/2tjBp4A2U9/c9RrSma+HY5JkZUDi
2qlhsROroS9GDoSiBx7m6/v23e+V12Fwd530LvGTGniklGZS+AzB5xfK2qBmr5z7
H16SwY84Mga6hocrwqAn
=9c+d
-----END PGP SIGNATURE-----

--cVuSN1UEk1U5M3GR--
