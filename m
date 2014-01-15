Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaAOLuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:50:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54636 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaAOLuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:50:14 -0500
Date: Wed, 15 Jan 2014 11:50:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Message-ID: <20140115115006.GJ15567@sirena.org.uk>
References: <cover.1389738151.git.joshc@codeaurora.org>
 <39f0fd65345f4c2b75b036234514ca02279fc21f.1389738151.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v4FgCkd4vT7RadTR"
Content-Disposition: inline
In-Reply-To: <39f0fd65345f4c2b75b036234514ca02279fc21f.1389738151.git.joshc@codeaurora.org>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 6/6] regmap: spmi: support base and extended register
 spaces
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v4FgCkd4vT7RadTR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2014 at 12:41:40PM -0600, Josh Cartwright wrote:
> SPMI states that a slave may contain two register spaces, the Base
> register space is a 5-bit byte-addressable space accessed via the
> Register Read/Write and Register Zero Write command sequences, and the

Acked-by: Mark Brown <broonie@linaro.org>

--v4FgCkd4vT7RadTR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1nXrAAoJELSic+t+oim9COoP+wdqWASjkGSYT5XnEvlL8NYp
QSx5MgRvqr9kzhSC8TF5Cb0wUr5/N+V3xlMdGJmO3CD1DTriRq8bvF9uHPGGgQpW
QfR8VrK4ybSDHf8BBAhMtCOnImLNABqLHTaQf4zssfXMIh0Kf0pzk7gvXeJ0zHA3
JB+YqVfkv3Xx+1/L9TNeY1tHF2qrwDwttb05zRR5M3Teo+jG+KXZRvRCedmo7PDH
4K720UGIekrDyU4z9yj61UvbBUTAcPdFT6A+53HOmWavsTyTGg0C1gfaVu0K+HQY
0VbzfHKrwumMnJDzsV1plxwOwMpkV8D+rhmAAynlns1ehkoJIaM4U85eoDQThyxY
UW4pSjgSLhD4xsCz4ZBw6O1BGJiv/kfxUuTc8yBrJRUWl4AZ7i4hhl6vG2iIeJvG
o+RH5L7lSPXiz+uIkCr/63A42CJbhsCAUG/uv7RppX+DF3vp7FZ7NfDM8OU2R1i6
/rdHSMyPGsz23JVJtqcncBztTTnJyEk2ZUHz7ksKPwY+3qzObJT5nzzfR/TC/+S4
AuEH0hlq9s8ecelOO7IDI1lcrCo4qLLFbwN/Vht4+StcbjiDoSQf8mG17myRj9LP
uxbS1qrgnXxusEGe77c9Jdr0zGnnZJ/GehUFs7pzyJsrMfw1m9v3QKoE5cjBACym
qzMFNJGPx/7RKGhOkEYD
=rY1v
-----END PGP SIGNATURE-----

--v4FgCkd4vT7RadTR--
