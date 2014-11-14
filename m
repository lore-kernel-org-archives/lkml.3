Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161738AbaKNR4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:56:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38601 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161640AbaKNR4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:56:32 -0500
Date: Fri, 14 Nov 2014 17:55:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sameo@linux.intel.com, lee.jone@linaro.org,
        lgirdwood@gmail.com, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com
Message-ID: <20141114175502.GL3815@sirena.org.uk>
References: <1415794082-30277-1-git-send-email-beomho.seo@samsung.com>
 <1415794082-30277-3-git-send-email-beomho.seo@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+msPJjaBje60IBrx"
Content-Disposition: inline
In-Reply-To: <1415794082-30277-3-git-send-email-beomho.seo@samsung.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/5] regulator: rt5033: Add RT5033 Regulator device
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+msPJjaBje60IBrx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 09:07:59PM +0900, Beomho Seo wrote:
> This patch add device driver of Richtek RT5033 PMIC.
> The driver support multiple regulator like LDO and synchronous Buck.

Applied, thanks.

--+msPJjaBje60IBrx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUZkH1AAoJECTWi3JdVIfQpMsH/RCG1UZh7KNXgIB5zwmI08E7
zw+CEGw98x1TL/N1ANdUiVq0SpjF7LV8/kfIQKIsiUP6xsQEKrxiRtpefMEFUnPQ
ONkL4k++SB2BMQBDhacKYdQxq1p7YrkKqrAwOUru7MRgk2n4pJ3LsZwDIH68iylU
uqeI7YMzUP7o6MAc+yZQF/BorjyJ9FUEj59QEcc0/5HHmKCrDIZQsnQdWV57DVt5
H271/qDkLpwrJvQKBTWtZsTWvXmMFMcWI/DZ7wcfBL6ejdReHRqu2TOmxUKnRGvS
59Dpgbuvj7Qv0l72yJzfyRW0eIPLNTziqd7t+FzeQ8TK5djoDYyC51kEy1qhdx4=
=pfhN
-----END PGP SIGNATURE-----

--+msPJjaBje60IBrx--
