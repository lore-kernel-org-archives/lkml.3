Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934680AbaFUKNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:13:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51731 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934596AbaFUKNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:13:09 -0400
Date: Sat, 21 Jun 2014 11:13:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Andy Gross <agross@codeaurora.org>
Cc: linux-spi@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Daniel Sneddon <dsneddon@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Message-ID: <20140621101303.GE5099@sirena.org.uk>
References: <1402601652-24641-1-git-send-email-agross@codeaurora.org>
 <1402601652-24641-2-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dMPRVcIY2SVCbCAc"
Content-Disposition: inline
In-Reply-To: <1402601652-24641-2-git-send-email-agross@codeaurora.org>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Patch v2 1/3] spi: qup: Remove chip select function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dMPRVcIY2SVCbCAc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 12, 2014 at 02:34:10PM -0500, Andy Gross wrote:
> This patch removes the chip select function.  Chip select should instead be
> supported using GPIOs, defining the DT entry "cs-gpios", and letting the SPI
> core assert/deassert the chip select as it sees fit.

Why?

--dMPRVcIY2SVCbCAc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpVqrAAoJELSic+t+oim9WH4P/3DIoc4zhoOmkCIcHckB0/GH
wB+wI0Gta/ewzJx5MMuUvJmm75lL1C1ITb3QjP7kljk+kpbLX/7idQtqfzetlPuR
ukFNfNJ3jWzmI3C/DYd21ucWSnT+gDdsGUIMEQFTE+SXexFOUCzBHORs65bFk6yp
9pEMxtJjNLiGRUKgNrv1TrQCTkMSNIg2e/1aTAdB2br3S6a2UpT0PhL3D4nWhuIl
rAWeTFtiisGluhQkvGcu8RUkLYk0d9Pv3EZACDGjzcEvjvxOM+uuXxxHR2ky2zi0
Ay61a9WsSG6fbKlKjH+d3EXqYp+f1sCnQZhTphuMEyhfIcLHnU32fx1YwWqmU2lf
aZrGZjXvbbUvNGIzJc3AayxoD5UTG1jggypPtaZ/SSnKqxoQr9aUJzcVMsEHOumK
ATfZKwiPGW52W73iU2kIl8blXlzhP4NNfTxjpDqxEvxHyVP3SEKCDyvMwTqfd4u0
RKKzvinpce/ae7sjCWvfTDfBONjxLnt3u09gcUryPulDjmcPYKES9psJ18T1u/jf
tN/B2HXiymPMWSR7JgnfA05Avds2C6lKn1uvBiZ9PPC+TjIa+2DngWkV6AWYWB+t
rL/6g2ISqdD0S6CdvkajEunLUp2tPNeJelF/mfzs5JPuTt/cEyRU+cPuC/wGfhBo
/vztYfei1u4IJSYVnBVV
=1CXQ
-----END PGP SIGNATURE-----

--dMPRVcIY2SVCbCAc--
