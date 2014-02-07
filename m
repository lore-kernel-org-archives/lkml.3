Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaBGRSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:18:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38375 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaBGRSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:18:41 -0500
Date: Fri, 7 Feb 2014 17:18:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Message-ID: <20140207171834.GF1757@sirena.org.uk>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
 <20140207073952.GA2610@qualcomm.com>
 <20140207165127.GV20228@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/aVve/J9H4Wl5yVO"
Content-Disposition: inline
In-Reply-To: <20140207165127.GV20228@joshc.qualcomm.com>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/aVve/J9H4Wl5yVO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 07, 2014 at 10:51:27AM -0600, Josh Cartwright wrote:

> 	config SPI_QUP
> 		tristate "Qualcomm SPI Support with QUP interface"
> 		depends on OF
> 		depends on ARM

Does this really depend on ARM?  If so why?

> 		depends on ARCH_MSM_DT || COMPILE_TEST

> With Kumar's pending the ARCH_MSM_DT -> ARCH_QCOM rename, we'll
> introduce a arm-soc/spi tree dependency here that we'll need to keep
> track of.

It seems simpler to just depend on MSM_DT || ARCH_QCOM or whatever.

--/aVve/J9H4Wl5yVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS9RVmAAoJELSic+t+oim9rNMP/R9suSA2XsORTOdBvvhp3HoM
f/bPIoB6+kfOgnx0Rt2+PPDIP6/uyUURjCf37g/FnPAs6Wlp9wnR17DqgyIq7oyn
qS3S668rYQTHXMfoj5wobkOqHUHuZyGd3qVc421nA3N7b22LR2ib0O6kUeEQR/Qg
jWSTYxhbHuGSQEhprpGjiPaCkyZ+tGorLQ1DP3HjcupQe+FsYXkYFXbwd4oLeqwz
3WyrER1UQsMgoTDl7MDW71El/nOmB6YCUWYeQGcFdOl608utnxsq7RI4U9h7zh+o
21OLwhr0+0Icf1g4Qtvo2y3/cC5fiqjYiKui4I3ppYAiSMHtoagmdIrIj09n+CjH
ql6LB+w8gCVvVjmqHWBya6O0q8ryutFgxh/DgH3Lw42lqu3+qlYHjdi3VKRJSyuW
i/qhT5Gi0K2O6zkwtAkL4lVWm+SXungFxBdK3M8DXt0wnDjeK1ZfRCNAncLEAECZ
qeU7YdWluPJ7efqYRck2PZLAecNdrRujNOFtLBqPSQlrMKtHwi+eWG3fAy3itJW9
QeBGKTOyH9PduZ6wlS6mzDtLuBO+rxzbLnScPEALd9/F08ejrFHOOy3ab1X5Pr0Q
dnXRqueg7UNJviRye/BIZOBh2ogK5I13+gssp4C6AMJH4I3cnpXPnbpcN+xj8f16
yPlCv+guFbOuoFEC0gmX
=iHN6
-----END PGP SIGNATURE-----

--/aVve/J9H4Wl5yVO--
