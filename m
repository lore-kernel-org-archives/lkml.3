Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaAGPj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:39:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48366 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaAGPib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:38:31 -0500
Date: Tue, 7 Jan 2014 15:38:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20140107153826.GO31886@sirena.org.uk>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
 <1387468508-12286-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dEd1YYlYcNcvthRg"
Content-Disposition: inline
In-Reply-To: <1387468508-12286-7-git-send-email-lee.jones@linaro.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 06/11] ASoC: ux500_pcm: Expect different saved DMA data
 when obtaining from DAI store
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dEd1YYlYcNcvthRg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2013 at 03:55:03PM +0000, Lee Jones wrote:
> In preparation for full Device Tree enablement we must differentiate
> between the two varying ways DMA data can be held in the DAI store. If
> we're booting with Device Tree the provided 'snd_dmaengine_dai_dma_data'
> data structure shall be used, whereas in order to avoid breaking legacy
> platform data we also need to be able to translate DMA data stored using
> the UX500 specific 'ux500_msp_dma_params' method.

Applied, thanks.

--dEd1YYlYcNcvthRg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzB9vAAoJELSic+t+oim9GfcQAJI6HRJUAlo+eG4+rXGrChF1
zyyfjpql4uF8eqFOYEljMY1pIBkRXO6EjYnMtjx5lGryA/bgCBKmsD1jpgJ1UfIl
3oz99pRr3k+I0N7VvG/WMnfxe9m3dzWhC96/wgXoz87OJ6XF7jzG2txDXbXMjd+h
CXRvnu8+wFfcJH64vKEc7kCRsxlGGP6hkrgSHXuUmaPiM0ZB2i6tPpd3GQhFM+u9
XM+UKzRhbJaNGPseJAYehXHy+Y7sXSW4mJfUampqaLVb8DHRhyc4V1yAB9etsanP
B8A5ud9KIdQC45Q8u8DnbvVIF0alsjRI4aV2jrmuiT/Trq80Jlr5tutWD6meqYrE
LgD/1Mzkb0fjNg0foyn+LMtebWwrVQBN7Bu/oDgK68FoXMly/8LCj5ZzwfJC4BBO
GKeHzf+k5CtkkFY7hm6LelapO5HIe6YuSiykyVf+aa4JcSbxD51L2WTKssj5HHoJ
IkvIVut9rnHp1Y8GcGuVhcvnDrX9EBeGTWafbuYh2BTrxKDwIz+2kSlvYZiQrg7B
WMPfkhsVTa1CT4OvMmXn9MCrQfTumF67fobuMavIBewqDVUUIjsUc5s1miJiDKzS
8iId5xmh9L+GgFuAM4K/3B63T/xF0fRdXnIPnR6SwFam14yU57rCChPOR+xtBeNB
OE5dD1I5R5ttBABH2eGy
=rE0F
-----END PGP SIGNATURE-----

--dEd1YYlYcNcvthRg--
