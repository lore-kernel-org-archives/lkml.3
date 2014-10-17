Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaJQMkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:40:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33194 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaJQMkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:40:31 -0400
Date: Fri, 17 Oct 2014 14:39:29 +0200
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141017123929.GL1820@sirena.org.uk>
References: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413478133-2577-2-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FnOKg9Ah4tDwTfQS"
Content-Disposition: inline
In-Reply-To: <1413478133-2577-2-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/7] regulator: max77802: Add .{get,set}_mode callbacks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FnOKg9Ah4tDwTfQS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 16, 2014 at 06:48:47PM +0200, Javier Martinez Canillas wrote:
> Some max77802 LDOs (1, 3, 20 and 21) support to be configured in Low
> Power Mode during system normal operation. Add function handlers for
> the .get_mode and .set_mode operations to set the mode on these LDOs.

Applied, thanks.

--FnOKg9Ah4tDwTfQS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQQ4AAAoJECTWi3JdVIfQGrIH/RiF4jE8zUV2hIgXufYSx3VC
8fBSk3qRk3BeYd7pPcHycpqCSr4uTE59wwq/fokBT0CqYrqpXiOFCacTfCylsvwV
Gqju2FhsBIzgalI9Uq2j7KdjZuYTKlGI4QRmSHz3pfWbRqis/I9nqPnVh5wXqMMe
kAKPNWxNJW2+VU87fqHlpoi+461tcLWgdah3ptqX7c9d12J1HJc4c3l2x7uFydCS
GrIk3pqefWh9WpfxKrGPJ32xuyP2bN6ardiZ3A+LCcsjPUM/lsuOSdcKngDHsfMl
bF9V+mTb2SglP43qdgwhWECMgxwQw7lzkobrm3oc/gaBjpJ3ekQaIwJCMY1qoAA=
=1yfx
-----END PGP SIGNATURE-----

--FnOKg9Ah4tDwTfQS--
