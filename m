Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3KSSvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:51:12 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53093 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3KSSvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:51:08 -0500
Date: Tue, 19 Nov 2013 18:51:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20131119185106.GI2674@sirena.org.uk>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
 <1384859269-19801-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1IYcr18XUmgwOrO2"
Content-Disposition: inline
In-Reply-To: <1384859269-19801-8-git-send-email-lee.jones@linaro.org>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/10] ASoC: ux500: Store DMA data in the DAI differently
 in the pdata and DT case
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1IYcr18XUmgwOrO2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 19, 2013 at 11:07:46AM +0000, Lee Jones wrote:
> In this patch we do two things. Firstly, instead of open coding the
> store of DMA data in to the DAI for later use, we use the API provided.
> Secondly we create and store similar DMA data for the DT case, only
> this time we use 'struct snd_dmaengine_dai_dma_data' which is provided
> by the core for this very reason.

Applied, thanks.

--1IYcr18XUmgwOrO2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSi7MWAAoJELSic+t+oim97TIP/RYJrwHpHTHs47UaBuycd/Bx
iYV2kAxg+T5HB4QhJ/A0O9KNPoCzSQqWFtFR2htNoCD3wqYx/78igxuCF2XBtqVE
r9hXdjazV+D1hBNVzUaFfINYenCGdBxBIP/TCA10JxIoPqLweVci+fum31h1qUiJ
63gdIDixIhYE/0k/+PNj67cKjiJx2lgtHcCsF7Cup11TcOxRZy/doJ50frJf7Lw2
E0xiPbuNEzhi1zFyyekjS8SWYZwkAtrfj6IIDP5yZ9Hrqe/T/riVZKLCA/RpkhV3
ad1QVZ/A/ywE4QE9010k6eYsXIMrBF7jwzwXczNTgpkjanpzZK2LS6y4u54wOndO
WgppGO0Lyz0n9BMjnLSVBsjMRZgdEK5BS7Yx39R8rQO8jwnkbVLlYkYhy2ML3gf3
1xIkGiPkPpoKlgJBc7WdH27OWCn4BpyZ7Hg8ogq6r9+l3/+VB1Zpv7bYpKRxJ3Bl
ZN4nF4a7dRLAxiuZzrB2EzTkm5wQPdvjGvsv1T7bj3qRa7A1UjGueooFiKUoiF0h
DXaIIyxfFUMHzzvVb6KAF4NL0f0HeO7rk0oI52tv4LatTBKs6UEUh/91FbW1AJgY
sA64DVXlyz6LgXX3rajEvamXIfXtt1hGQW/NpILvba7droMwzhEOSnM81mA3ZLwO
SlsMyH1gGw9XoDwVkKOc
=Ht2p
-----END PGP SIGNATURE-----

--1IYcr18XUmgwOrO2--
