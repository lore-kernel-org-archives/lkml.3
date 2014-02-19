Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaBSHv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:51:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60891 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaBSHvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:51:24 -0500
Date: Wed, 19 Feb 2014 13:46:05 +0900
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140219044605.GB2669@sirena.org.uk>
References: <1392765432-9111-1-git-send-email-mporter@linaro.org>
 <1392765432-9111-3-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lKKnPHJE/sHLsAX+"
Content-Disposition: inline
In-Reply-To: <1392765432-9111-3-git-send-email-mporter@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.145.86
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/5] mfd: add bcm590xx pmu driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lKKnPHJE/sHLsAX+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 06:17:09PM -0500, Matt Porter wrote:

> +config MFD_BCM590XX
> +	bool "Broadcom BCM590xx PMUs"
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	depends on I2C=y
> +	help
> +	  Support for the BCM590xx PMUs from Broadcom
> +

Why does this need to be built in?

--lKKnPHJE/sHLsAX+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBDcKAAoJELSic+t+oim9IokP/1zCBpRFHVKLvcArQOpmLhfb
N4hgfcv9ID7mrrb8JuKSmdFfw8GH70Q32CbscyQLnxINEC+ui3dVsF1PI0EWTMzQ
NSXR3h3BvgLau1CTBE/xs/n0nEmBJF9G61raMt25je/T1UjH4cgG/ykIWYKTjqDT
4BCrV6gM9X9ogREtb/2CLctlXDI0OwMeLc5MKiQ3DlJXSczhmVuSuDKxJcYMwven
k8g0YmvEc9si3QH9TNvsSQ0LfQgq0xmOEpvQD3jRHIrZKfOPY37pjrcbs53bKcVE
OKFMkwktMdC/AgpX+mY6KEPF8jpLc+lDopNvGlJXhc3ZmQSXpJO7qXGHBtE52Thl
IK9oAdW4ALYjA8Vb6Fov0AGG2uJUmIzrRWqGOJK8v/a8V5svXHUI2xxsTzSg++Mc
sget9vZ59r79hhEhO69oAOuB8qDQtzX9TJx0ZkuPe6wmFrmkvUzN/pi69lCwRK12
gEOabSFSKtQ3ZcCD+riBixZTo1SC/u6XQrgJyCJQCqND1V1B9OuChWYjG7+1jTRI
zVxhnI6akBDf/1SQ95/xTatLfOThuvYaZlzhhDyiJUaqlbRVKfT727MDVDUdOr2/
pMxy0pJFDmQik+oZnH04nUdLh0efizqEwR2WqNsiMPHZajpfVEm29PRW/mQR3Rmb
5U8PBca2Zo4FDIf7VBlB
=5bwz
-----END PGP SIGNATURE-----

--lKKnPHJE/sHLsAX+--
