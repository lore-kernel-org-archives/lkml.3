Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbaDXMst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:48:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43865 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbaDXMs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:48:27 -0400
Date: Thu, 24 Apr 2014 13:48:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Anton Vorontsov <anton@enomsg.org>
Message-ID: <20140424124803.GW12304@sirena.org.uk>
References: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
 <1398264640-12122-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BWRtCqNGKifRcW6m"
Content-Disposition: inline
In-Reply-To: <1398264640-12122-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH part2 2/6] regulator/mfd: max14577: Export symbols for
 calculating charger current
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BWRtCqNGKifRcW6m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 04:50:36PM +0200, Krzysztof Kozlowski wrote:
> This patch prepares for changing the max14577 charger driver to allow
> configuring battery-dependent settings from DTS.

Acked-by: Mark Brown <broonie@linaro.org>

--BWRtCqNGKifRcW6m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWQgAAAoJELSic+t+oim9Nf8P/03cQSnYiQCnK2neDp46eN3D
9TUydYILnUTskue/9mZuyAM9hhhoe9zkTBsYLLMDs42+ECNUkqTqCXJUdd6Gz5b3
EbYTHTt/OCrkjHH0hUSlKawVXw2w0dgEkCYnpiCU9v3bcZKPiwAZ7NvK/AOv6+T2
odTGpOh4GmVLBwHVYxVPXwzRpNe20PWrZ6QI0ofaMKDDOXkuiyW4/sskPoklcRmt
E6Ew7oVGVjs+1djyJPUdi8qwHf9E/xU8yDImzkcWms+xexvsIIFVhW5rb2kNbddR
wVGWBnGzoqMYZ16FgaO6usvCYUhMswdjYSwuEDCk/P5bYE+ntYAxIR/oAysDlf1n
jyPqAN5ND6CmymyGuHNzXxExFagJjtQC6W7BujQ11DJUAdrh7R6wbU3f4sH4p3Uz
X2DTqc/HHMZzBPSF5t7GuewKYJYlwSbNTp19aHrHyPsmpGtN5JfDZkFY+I0SXDAk
jQKubjF3Me1rX//R2e367eImDdHrS3aOrJ98gVz4XKhUg0vYAN+EBkrFee0RP/1s
WHSyfvzsAUxpXVqh8qclEhwk/CqyUYNUi4kRVf95qaZKoDwJ1+XjEe1Bn/+YZ04e
MsqHM6FYM2g4dV5q2bGL/SbOWzm6bgMrIYpEkr6AIvtBq63rtRCcIgb2J4qw5xbY
Ktmfci8zUhTTDUpqHtR2
=2Lcs
-----END PGP SIGNATURE-----

--BWRtCqNGKifRcW6m--
