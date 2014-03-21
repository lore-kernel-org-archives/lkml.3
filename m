Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaCUSKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 14:10:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47678 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaCUSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 14:10:16 -0400
Date: Fri, 21 Mar 2014 18:10:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Matt Porter <mporter@linaro.org>, Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140321181004.GL552@sirena.org.uk>
References: <1394762274.8460.1.camel@phoenix>
 <1394762347.8460.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ai3I8gwHc37+ASRI"
Content-Disposition: inline
In-Reply-To: <1394762347.8460.3.camel@phoenix>
X-Cookie: Contents may settle during shipment.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: bcm590xx: Remove **rdev from struct
 bcm590xx_reg
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ai3I8gwHc37+ASRI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 14, 2014 at 09:59:07AM +0800, Axel Lin wrote:
> The **rdev of 'struct bcm590xx_reg' isn't used anywhere in the driver so
> remove it.

Applied, thanks.

--ai3I8gwHc37+ASRI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTLIB5AAoJELSic+t+oim9gWIP/1T/2lgW025hkFyqXzB8gnGb
6TG1OYS0iYtb3vziFkJPh0xF4LvfzKGevntlpi+KnYuNXzg7uUMMCSRxbwWyrEAR
Zx5f1PB7oP0/5RcuOokDUBH91LybIShFnP8K4RZYsI5A8lwjJS2P3e3G5N/ZA987
tUa5fUz7GSGVIMqb80PDW9nBkbMcpH99VNH1UpbsTU0G1pFk1vCRSdpkvBND0cyz
DM4ej1U/Rp2sa5FpPFlLsbbtllcTSM8KQBBEhgJ+rtxRo7S9/EyETUnOOYDhTQvX
qn64m7PNc58/8sA9yzEynDaprYACD+kbj2Dbnqh2MiWwWDX1BTHp3qIDunIgTNei
6KOb2WxNT9rUD1c9kK1/Cho7H+mKKh4G52FLoF3E6RVqDoTog9/K8A9PuRvaCFma
46q5tob6lcqCFLUbXbPj4qP8AlIXHNyZqO3ggu8z9PnGXWu3kfLOGiQf7DjAdS6g
jybvHrN4FacLNVn/wufJBUluVy37vCMwMa/RDGJJMCMomlmC0gjsoTlVmxN1umBm
nEgEYOkVLyWKv5NkO3q0mrrGg6iJ4Rd6dCqEoAt4h8kZua7c+Uv2odAhbySoPxCB
ZNuJ3BeYsLQR8ZKyMCP+V/S0jo4Z6awRw2xxspPli+1HEAV/inDOeayaOwRll6NA
L3w176EPHpoS1o86Rkub
=25YR
-----END PGP SIGNATURE-----

--ai3I8gwHc37+ASRI--
