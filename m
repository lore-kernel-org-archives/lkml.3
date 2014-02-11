Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaBKLU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:20:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40333 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKLU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:20:28 -0500
Date: Tue, 11 Feb 2014 11:20:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, Guangyu.Chen@freescale.com, shawn.guo@linaro.org,
        perex@perex.cz, tiwai@suse.de, fabio.estevam@freescale.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140211112006.GG13533@sirena.org.uk>
References: <1392086825-15737-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L+ofChggJdETEG3Y"
Content-Disposition: inline
In-Reply-To: <1392086825-15737-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: fsl: make sure the regmap-mmio is actually
 enabled
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L+ofChggJdETEG3Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 11, 2014 at 10:47:04AM +0800, Xiubo Li wrote:
> Since the Freescale SAI, ESAI and SPDIF are using the regmap-mmio,
> there needs a select of REGMAP_MMIO in the Kconfig to ensure that
> regmap-mmio is actually enabled.

Applied, thanks.

--L+ofChggJdETEG3Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+gdjAAoJELSic+t+oim9iUwP/jGGtP2w4LlVJ8DorbcEhcVI
7vxRC8Vst3LRJW3UFeO1nCg9ekDVWMjU9MPuAzeGPNoq9mEgTvZkSJRHfr27it+N
Fu2sR3UQw3LBS5EipbXfiJnmHZXwJUWz6zrAgoVYkOIeTOGdTAc+2t4MHKZTqQLK
z/BbxOmd4ms9nLFJ4bn7wU0Ovs2g+quzJlq75VyXBsUMhaWb7eXcVA7q76bJU5Kb
x3OFL38ikB51Ku5GzXKpG1YCeAEHRwyxpvJ8o1stBKPF0h7g93mlWk7KYXw+44Mj
49LODdgrqHApipou8CpkQvZ0PTIRsXPs+5DZZylt0PNioM8PK/QwrRA7+BTKlvy0
UxjI82aadFZK4uDGD2GxmjF13nwVSMJgBshXU3/+/JT2JK6cxoltQhZLPE9Ivl4F
h3O9Wq6mPr6NRjUhaF9vyN1wpWcpyYH7jUpNvqRTdLf37l1x7o8uG6EFl23PKUoQ
1roewZUI5uPZ1LU7r+1NuDuNCJySe7Nj7aoFIWj0GVSoJnRKo9J97WL907gSYv6u
KlsBQpG2V5ve8gZ+5M9kRn7jp0o2Na+AysGxDnGBLmd0YLl1od7TNWUXupPK4ZQ/
aGf+Jl1E9HgDQY4jgnpTUoZJmm563obk9WCtjaTcJ5KuQrG+Dw0wo7uklrTzNqt9
hzHQ0e3Pf/rY+cBvysJP
=hhrR
-----END PGP SIGNATURE-----

--L+ofChggJdETEG3Y--
