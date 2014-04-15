Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaDOMYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:24:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33916 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbaDOMYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:24:44 -0400
Date: Tue, 15 Apr 2014 13:24:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140415122421.GB12304@sirena.org.uk>
References: <1396733753-9820-1-git-send-email-sre@kernel.org>
 <1396733753-9820-6-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C311HLcnHV2CzHlo"
Content-Disposition: inline
In-Reply-To: <1396733753-9820-6-git-send-email-sre@kernel.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] ASoC: tlv320aic3x: fix shared reset pin for DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C311HLcnHV2CzHlo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 05, 2014 at 11:35:53PM +0200, Sebastian Reichel wrote:
> Currently the second tlv320aic3x instance fails to
> be probed from DT if the reset pin is shared with
> the first one.

Applied, thanks.

--C311HLcnHV2CzHlo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTSTyAAoJELSic+t+oim9ctwP/iaNSc+Slsx0w9DO6bRLGVw5
GpCzrlMLNtkvQuvCwHm3HWcZ4yyx1M2a+vONmanBZtKPlKS19DwNvE9J73uqroIR
WMbeZsIc+WQQd6kdsLtaz92ZGcQkfELfqgQfnt7ZCnhGUZZltKzgptsWoqH1hLw2
vo233s83cOqup7N3x6ETkpWkbn3uIKBIn8jklRZbpwLP3wUev/u8civCkbVukJUB
QO04tXX0/ekqWSp2+FCP+kCntZVxmV20CMwSLs39EKWhAzeP9jI9XuiJvvRj6UuF
0o+zWIA08ILPm3zgqRMm7I/jL2jwcmMjntO/C5zuDNb2pQ+flqE1mzcM3A0g5BSS
Loyfq8PznwPfmTJ9/g1/S8SxQUJdHEHMfCmjSB/oRqSg46VuzxSYkTDIc4nQUOAB
dKRaIQ2RkfpZbyi+setkEJYVruLchqeEGSXCpCc8r1WR/KgDIVTgLIUBy7tWq+i7
u6Rp8D0yOwE75HtN502tmEnWwsrFEJEv3Ud7pH9pkMXDWbJ4Q2TCYJKEfcsXY7ks
cm0pui4TScyjakqtKDNWbVnug91cvtRMT36yPepZT4ou+YLyqrVRp50019g+QX1H
skawOXWrZ0CZ0r0t7aAHAHU/9o0DrweacWgH+wshAvLyOyFf+jzJZziJd9lewDat
CBU5OTvUHcHUTssNRkae
=8mmd
-----END PGP SIGNATURE-----

--C311HLcnHV2CzHlo--
