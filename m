Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab3K1KgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:36:22 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51652 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3K1KgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:36:20 -0500
Date: Thu, 28 Nov 2013 10:35:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20131128103556.GJ14725@sirena.org.uk>
References: <1385556677-5244-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iIdb9Iy5ocJYgXq2"
Content-Disposition: inline
In-Reply-To: <1385556677-5244-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: wm5110: Give new AIF2 registers defaults and mark
 as readable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iIdb9Iy5ocJYgXq2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 27, 2013 at 12:51:17PM +0000, Charles Keepax wrote:
> The registers associated with the new channels on AIF2 were accidentally
> missing defaults and not marked as readable this patch fixes this.

Applied, thanks.

--iIdb9Iy5ocJYgXq2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlxyJAAoJELSic+t+oim9vLgQAJZNDlE0G0Gc+D7KQgMw7Abp
zYOqrkWuxLKEumFatVcSeGVfaEbWcuHZJU3lHGF8QYEuL++xVCWgm6NCZYoeqj/5
n9zmz7IbyWQgS2TdDpoech2ORyeCOu3YjggXvKqoIXAmVGskeaDhmfrkNasDsFoR
Jy0+wJ4Aemwm3EPVoFeSsD4FitpDbf/73saffHmcUv5bgt1KQwjnHmh2NG7EnfTZ
ZqxO45cB6rIbsX+fPb94Sw5bB8Nz9bq0yNTyIZSv4HhYDPUuqiWC4vrDKzWHpumk
F4MGJjWHAV2s30Lrc10e3EMUn1kbiEbjoOT+o5mj12flO2Lqc9HdJoWBhtSKEuio
T+PJhJ/0V/S3HasGYgY4C+KenuTV4Mhhm1k0/NMJk3VXQOWmTdExRRsqu++nWtdC
zuUYj0Zk3AenscAsotwbtlrjnrbRjfestNMmfqDwP3vbx05lf4K7UfaDGd1b14WW
96DhjF4kDEh7KxuO4QN+Vf2sbVEMLaZpEX8l2d+vMg4UwEVKl3Z2dboX7As4nZxM
tJMRQMtSKd1f33yRaPCxlWzkj7X0UadWxrPPyOjlAoJ2sCk87snQLNFwKFTNSZcf
DxeLXcUtZHH2GIwPj39DLNYO4p+3LeYZDyEUDaTW+sH+ro4rnecxu3d9ITe812vm
mQ62kzqw4ekXjUXuvk2z
=vAGX
-----END PGP SIGNATURE-----

--iIdb9Iy5ocJYgXq2--
