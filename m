Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaA0Tl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:41:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60177 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbaA0Tl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:41:27 -0500
Date: Mon, 27 Jan 2014 19:41:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, timur@tabi.org, Guangyu.Chen@freescale.com,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140127194114.GS11841@sirena.org.uk>
References: <1390463283-7545-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOmQO3H5Qmmwdmk8"
Content-Disposition: inline
In-Reply-To: <1390463283-7545-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl-sai: convert to use regmap API for Freeacale
 SAI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOmQO3H5Qmmwdmk8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 03:48:03PM +0800, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Nicolin Chen <Guangyu.Chen@freescale.com>
> ---
>  sound/soc/fsl/fsl_sai.c | 243 +++++++++++++++++++++++++-----------------------
>  sound/soc/fsl/fsl_sai.h |  47 +++++-----

This is fine but it doesn't seem to apply against sound-3.14-rc1 - can
you please check what's going on here?

--hOmQO3H5Qmmwdmk8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5rZXAAoJELSic+t+oim9L0YP/3W5A58eW3dtQ/m4yI5GBC8/
xLBc+4jXa+lYdH5VN/ouA/AkRli273ZicUzy9GJ1fF3NTEscj8rkmkq9xObEpgQS
9ijdnJYPgAFPItRVbLJODOnCU/J36wNdnbp8vo9ofCFSfLLZe4C3IxWOaqPoF+so
5b4Xby0CYOA5/xDvN++F6T0IJ2GbUtrZhSQiz02x3XN3YCJlVaG+WLQBSiz3EksT
ZA0bq40Miu9/cz5ityFx3Gfpfg/BpSje0Wk00mxAh/9qN3yccWnI2TTdKTw620Fu
9CqyPF1rHC127ESR+5lQ2DnzobWZy33n3pgE9amjfa6VWHsog2Af7+V3OxuyghqG
99ynL0NA3CB2hlA1tjJ5Cencdv5ilLVzlAeE0RupZwK7RnyZmePNR7CGHv3EeMTZ
s6bq4lejpfmOsXjSgo+k+M8ZIN2jg/aZa5VVu9PG5JO2ikAKYaCGFisdSa20bEbX
8wy+tBi//Yd9lruVwL/uNpusd6RHMqL7bNy45ocVc9IXDhxHU7kuHbt1Fx9L3zk9
mdc/Ys7NNPhmY/REFXYIxtHymTnJNQw0c2/yUPRFoSpRu8DX7Xfa3ud2Vbejx8hE
17HFqxPc98ZSSJFyV7WshwfbOBJzbb/Fm54MZjfdSF3RkkXBFHliTqL5bzin+08U
90EL6qihy2090iw6mD3o
=0sEL
-----END PGP SIGNATURE-----

--hOmQO3H5Qmmwdmk8--
