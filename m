Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab3GWNGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:06:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53528 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab3GWNGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:06:48 -0400
Date: Tue, 23 Jul 2013 14:06:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Message-ID: <20130723130622.GB9858@sirena.org.uk>
References: <20130723102320.56bc4555@armhf>
 <20130723084347.GP24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vMk55pD2JuhdWiRw"
Content-Disposition: inline
In-Reply-To: <20130723084347.GP24642@n2100.arm.linux.org.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ARM: kirkwood: enable S/PDIF
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vMk55pD2JuhdWiRw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 09:43:47AM +0100, Russell King - ARM Linux wrote:
> On Tue, Jul 23, 2013 at 10:23:20AM +0200, Jean-Francois Moine wrote:
> > This patch enables S/PDIF.

> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

> I'm not submitting my patch to do this because:

> (a) we don't know what effect this has on other hardware.

This patch will do absolutely nothing unless it's used in a machine
driver which connects a S/PDIF CODEC to it.  I see no reason not to
apply it, someone with hardware with more complex needs can always build
on it later.

--vMk55pD2JuhdWiRw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7n/LAAoJELSic+t+oim9PzsP/jbV3YimL/rOUX/iyP019vZz
oH0D60cGVHpPCQtt0BLcsiL3BJynSc4klMnJgvd5dMeCd/nALwIiBULP4EX8k3yd
JIClfVKikWOzf+MndetEoEIxfl+YbbYGO0uNrYExWOSNM4zu7EEsYe1ClVS3dMXA
yh+cAAZKTlashlfGTnoaqVX30B5ZeqX9hi/wAXzPCpcKt3gsBUQLsRZIlI1BQZrl
2n5s9/fIffvwbfafM/ObmNkUY/qa7+tCHMecuGTRT+vMaUJi4yl0ZaXNP48+gzUy
2DkwaT60QJIyywzoHC5f8tvVHsl2dURWSZ+jKD1KuKYsPNvScWiDqNs5gH5yYnbo
op9jRO5MJ2kRaQ7LSPSp14yo7bDWDmvCcPCuLjTkwUdlSPZXO4tF8EsOtLUgqQZ7
eNJ/oaEsmUR9ohmjT4dPKfwMAQIs2Yf50yHpJ2RTltz0RJRSJugKd+RawEXA/LVU
CbbWtVj01sfEcQwhEOGuM/jPqRekPWWlbvrg+t04KV+cfQC+/leFMFbFWpWLKopC
i4nEy91DRSJ/rYU9b92d3BoDb7MtVyCXqFd76zQDSUKJWMJgoYjvf35CDnlpPW22
Pk451LRo8XhQZ5WudAiNr1pY4NV+z0105E90cRGVkpTwxGTELsMPZJG5rlBuhrTR
2GwvtBwWBRYtG2+RkdAW
=cK4x
-----END PGP SIGNATURE-----

--vMk55pD2JuhdWiRw--
