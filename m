Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab3GXP4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:56:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49911 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3GXP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:56:08 -0400
Date: Wed, 24 Jul 2013 16:55:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130724155545.GN9858@sirena.org.uk>
References: <1374654402-4647-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vL7xWxsqy+bNTFJd"
Content-Disposition: inline
In-Reply-To: <1374654402-4647-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: irq: make flags bool and put them in a bitfield
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vL7xWxsqy+bNTFJd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 24, 2013 at 10:26:42AM +0200, Philipp Zabel wrote:
> This patch makes mask/wake_invert bool and puts all flags into a bitfield
> for consistency and to save some space.

Applied, thanks.

--vL7xWxsqy+bNTFJd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7/j+AAoJELSic+t+oim9H10P/0ourN64eg11264Z3deagJ8G
NWDGs1KQQlzqtZdgGmlII604XppspDVsckR6NXUDtB//1BLkLIGcV99VO2NV4oUt
xjm5Zc6VzuNsFMWKP5WSO89++5jCKdbnSU6v76IrHbgSzQ5cSp6p8oTU9MDGjG8l
WAACouoh6XNyEeTCvgc+SqSmXBh6o6T//4QuRlADN3PjFcookfPkXP86ob7noYH4
9kiyTJRL4NvsgTzY72E208yjy26kCu/GRnAkq0jS3f5e8IazyP4S9VHe1RFSpxQx
19y+c54gTXQY6WTSAO80uR1dDspvlFKe6NjHF1ZK1loggApAjU45aGPmWNx7GJta
u2rzwijce1TE3wf8lW1kwdlFWKKOnUDbP3tp6Db7z+zvTsrLXpEetMvH65KdU4P3
FVqZZwCsNiJd+b3dk6K3z6cDlY728KLUe/j/1zwIsaFt+Hrw9Nchi3wXl+YiEr05
vJMpU5djbGikcZCebsLulzjzPsbvLXtiWhs2Ksmf8k2IS2qM0ymb4lW4DqHg9NAe
s1M4mDV1RgBCW8zJ0zkb/beMIgPxF+DU3qXMiSJAOVqrhSDOHTW0j8fU14t3Kf8H
HvNnw/rM25hzpsU0YwRjmTqBtcSFAslDQc2GDGC+B2Fptq1vwE1YkeMG9ADZT4gO
iXeMKSwahswMFxMJwY68
=oV9r
-----END PGP SIGNATURE-----

--vL7xWxsqy+bNTFJd--
