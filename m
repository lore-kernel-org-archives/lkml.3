Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaLXL6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 06:58:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47027 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaLXL6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 06:58:50 -0500
Date: Wed, 24 Dec 2014 11:58:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141224115817.GR17800@sirena.org.uk>
References: <1419356493-22539-1-git-send-email-der.herr@hofr.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGw25I70SdcL9+dm"
Content-Disposition: inline
In-Reply-To: <1419356493-22539-1-git-send-email-der.herr@hofr.at>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.173.220.131
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: unnecessary double init_completion removed
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGw25I70SdcL9+dm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 23, 2014 at 06:41:33PM +0100, Nicholas Mc Guire wrote:
> The double call to init_completion(&mpc8xxx_spi->done); is not needed
> presumably this is a editing mistake only.

Applied, thanks.

--ZGw25I70SdcL9+dm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmqpYAAoJECTWi3JdVIfQ4dQH/2COul2XOu553PdjXAOmaDfF
uJC4TtpTBFGQhSGMGxHSARVPr+RG1yi9Pa15EW3wwcICoDUxsIhU69JEXxUpqVco
sTqR56AKkuTKFCmrhx97ZCzY6hvUFzkCpYgxW1zsWHlDWEh24vyAO2dPOa5oDP0E
Enh8VA6LqMEJbNG4+mm0jKgsQsb7fqAH2eiMeV+KFPj2KvSMi5pKQIoDNj57Yqhr
cxvWpi0D4oXPdC+vdnswN6VNlCqHgxSimyWS0Y+rVSDkXRwu3ptj44pR4QNrmuaE
2YgarTORkGGgX5xq9Fp1ZTrg/KPa0mpgJzDaRV2K+BDx2AR/SB4IPh/fl36/p1c=
=fMjG
-----END PGP SIGNATURE-----

--ZGw25I70SdcL9+dm--
