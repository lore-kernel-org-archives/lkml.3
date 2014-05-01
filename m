Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaEASld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:41:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54193 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaEASl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:41:29 -0400
Date: Thu, 1 May 2014 10:53:44 -0700
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20140501175344.GE3245@sirena.org.uk>
References: <1398847242-9394-1-git-send-email-k.kozlowski@samsung.com>
 <1398847242-9394-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AKuaMbydVAlrc5ow"
Content-Disposition: inline
In-Reply-To: <1398847242-9394-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: s2mps11: Allow GPIO 0 to be used as
 external control on S2MPS14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AKuaMbydVAlrc5ow
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2014 at 10:40:42AM +0200, Krzysztof Kozlowski wrote:
> GPIO 0 is a valid GPIO so allow using it as external control for
> S2MPS14 regulators.

Applied, thanks.

--AKuaMbydVAlrc5ow
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYoolAAoJELSic+t+oim9AiwQAI6wOnQUJfKmo5zsnDsh88BL
XwP30lWyN2tYJZzxFygdnkmEhJcV0fbA8zez2oVS5xO4Ct2kZIs+9cWoAVxryR8T
KJVAgmQSqyV3ccQbE8ji8GnkCuYC3mgkdjz9Pp7LaLUPKMOGW9qwalvuNYpL2J+u
neJlBznifpOJUQ8AhyhDoDMknppoMlCfT1WeYP4a6EFYgUxevWbtI40vsYD7gL+a
pSf4ZjbyUNVPk3JpkR2Tq5OS0WiuZ78AsLOdli54GOXri4wWHLVUpd9F1F/IwLrd
tOgIR4DDzidEMmF2XyJzDsEzCXQYTDhm2ZBOAjePBS5gPZXD6A2pR3iTUyBJbi+A
/bApN/yo6YDAkn4sNdfJZJ3XChyh7TfubgJf65gyMVr0uG6qHnX/jYBDN/Ch497/
tIA3OOGEDjUqA9IwV5mAWxrIwuBGEH+ibm3SvErup+8gmIhgChvxmTxDY+StJass
B0O5XSP1DsYKjZ+hnCdXfKTDew0ps7UckEjU8lggOHIchRgZIE3PAIeKsJT35KdK
igtK0oNESIWoYBeVIYCLgW8x6hBwQPScT5p64o25T430EPPSDECTR94iYtMH08gQ
3w+0kYsoCBCSDbrnq7IXnRHbQRo1oG+E+CrHxZuIIcKqMK/YehbFzPmbpJi/9woO
8Q/MiY4uYaTrNBaAMdG7
=/sXc
-----END PGP SIGNATURE-----

--AKuaMbydVAlrc5ow--
