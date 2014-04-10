Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030339AbaDJWhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:37:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48163 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaDJWg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:36:57 -0400
Date: Thu, 10 Apr 2014 23:36:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org, rob@landley.net,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        shawn.guo@linaro.org
Message-ID: <20140410223631.GG6518@sirena.org.uk>
References: <1397143575-10426-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jk/5KjyVsvxWSMIA"
Content-Disposition: inline
In-Reply-To: <1397143575-10426-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6] ASoC: fsl_sai: Add clock controls for SAI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jk/5KjyVsvxWSMIA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 10, 2014 at 11:26:15PM +0800, Nicolin Chen wrote:
> The SAI mainly has the following clocks:
>   bus clock
>     control and configure registers and to generate synchronous
>     interrupts and DMA requests.

Applied, thanks.

--jk/5KjyVsvxWSMIA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTRxzsAAoJELSic+t+oim9+5cP/R5cdpTumXrEfPAIM2WIo0sQ
gi/Fs1bR4L9HiEXNVOh7kueN4AzxE2Kn9ijRXX6J1R7VrD/vOMNzdai4AyYjJL0C
LEU5SW2ehlC8/u1s4HP/6/XGmU9AyJDJjsuq4MPj9AeXsqNHXFmvfST6arZO1q/Q
v18z7Tp+XKmR7/8to4+72AlctPXyKDTh0cZXkcayV7JUgbIsMNjn746Oo08umf2/
ahF3L/nNnf5+sYg7j0ZHl7tjkgHSpq8ZPcj+NA5HktwAMJX1kEGcxIDPa7gKP/n6
bSGGwmvEGlkeEWkb1ee4xsw46LQ++M+RtkDBc79FikTi/b8I+hw07yG4gtg8GYGS
4NNRu1/IzoEWwzggdOjzqqA4vHcfbrO8i62X+kLx72CMVnHBYXR+2gMlOAo1OCla
fJL6heywU3mqWXy6KLCBZ4Eb379GN3VXURamYc0FiYvlwFIz8554LAiT1SO4IFoa
vwKi05GMLAZpEtDNxTrD6N6sZv2hCIsv7xAO/gxBiQJMZU+Lni4wOHWAkpu1OvhL
bJsal3eH76R7JZ5F8e6/w3rabqHVSGaYjjERJIQGA7uMjoZkReHGDwStbmTUU4Yi
fgkRcq4XEovtZ8LuYz+WI8vpe99F/5ipXpilJpmJTpIsRNBZYLxubBHvPztp6v12
N//79nPMbYMsR+9Yiylm
=7bWg
-----END PGP SIGNATURE-----

--jk/5KjyVsvxWSMIA--
