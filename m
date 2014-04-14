Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaDNVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:16:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33063 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbaDNVKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:10:02 -0400
Date: Mon, 14 Apr 2014 22:09:48 +0100
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140414210948.GB12304@sirena.org.uk>
References: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
 <1396433349-31470-3-git-send-email-Li.Xiubo@freescale.com>
 <20140402194812.GK14763@sirena.org.uk>
 <bebf1cf679014e62b1f4ad3fa970b52f@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Content-Disposition: inline
In-Reply-To: <bebf1cf679014e62b1f4ad3fa970b52f@BY2PR03MB505.namprd03.prod.outlook.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 2/3] regmap: Add the DT binding documentation for
 endianness
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2014 at 07:04:00AM +0000, Li.Xiubo@freescale.com wrote:

> > Generally just not
> > mentioning regmap is better for a binding definition, the binding should
> > be usable by all OSs and not just Linux.

> How about move the endianness OF parsing to the driver/of/ ?
> Is this will be better ?

Where the code is is sensible enough, it's an issue about how the
binding documentation was written rather than about the code.

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTE6ZAAoJELSic+t+oim9L+8QAIKStf0lXEA2VmjNUXdv/tM3
DyUHkmq47k4EUlYHT4hMeZFUkXtpZaYMm0ftYGfTcDk8fA/H/l79oBUUX0m2/s8o
R5DdNUdhnCjqDu9BkEQJdFpKmB2YzHfyQRYLAZA1tD0f4dLM+69EeJfpFUDL0TPx
rz2KeG5vUP+6IvCE5Jmn0NbmyNKhhppgTQD1dwndKm5tSh2RzbRCwEGH5fUbPx1S
MZBbrlbzvP2TslhNjlj+wRyOP56VHITEHyUapJPf1b6iSHp+bLLkhX3G6JDl2O2V
rL3SwPg+jxx9ZiuVvBEvUGUNtA5zS86yJzHIOeiJHiyN6bTA1ugMmbKPHOCkMU4n
MalMtvaDwZXOi2f51RZNPjBfPUk+MVaMdgk902z1RepLRkGsv/QgrNQ1wpkthaOu
F70wtX/1e3Dm+0KhuPY32r/IJV6zQDjFJktkwCpIk1lnN5EgQBFfqQooci6kfGay
vtJ0iLEO2m6c54gZNgH1mV4NGFgOaG29UxT2aU/ZRXErb5u8KfpFe5q9YX0y/5Uh
HBYaVNTfD+VkrCNzA235w4vXqsTKrJtMBSXKqQyn+NO9maKnSdPJPbzwfSz5AI9Q
DVKmUlUmdDQpiuIVWhVb5E2sfSSSuXpemhsycwKs1Be+Uj2sYXTwH5W4d45DJV9H
M6QLMt+vU8jE5B8uRwFD
=bYcK
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--
