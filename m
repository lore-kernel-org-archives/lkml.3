Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab3FZPXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:23:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35535 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3FZPXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:23:38 -0400
Date: Wed, 26 Jun 2013 16:23:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Message-ID: <20130626152331.GS27646@sirena.org.uk>
References: <1372221817-4382-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yOCDj6dCdxu1mn4c"
Content-Disposition: inline
In-Reply-To: <1372221817-4382-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: ab8500-ext: Staticize local symbols
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yOCDj6dCdxu1mn4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 26, 2013 at 10:13:37AM +0530, Sachin Kamat wrote:
> Local symbols used only in this file are made static.

Applied, thanks.

--yOCDj6dCdxu1mn4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRywdwAAoJELSic+t+oim9VJcQAIJyBHhVT2/Y0ZHaX6xEG0dm
avYQqYtrB3HS4N7KYQBopzX3BIMtITLYsCr4bpwi0JwNR4EryG2eQYGxxDubGnqi
uxm85Zl69mBKUTiKPNOpURkJsdFzhPqrgaMbjmH3GkJvOsyPlU1sNFxUysZHgIIw
Md+0SeUXc0my9ViluR0mmbFcRtuWWqt1WeBeMwlwej0C0gCL9tkAlLVs0Z+VCSSO
iT6YFQ+m9EQkJfLf3ojtUXfbKljVOD8XZs3hmOWvfRdmH/0lGiuR0/4C17k9SXiG
+YN5b5cf6UeQrgWoCQ2/h34kNZC5rSNQnY2PUXuau45VaGpixTT90+rfcLxFRGOj
QTZAWwMh5QhJ+tQz4AUkmw7xF1ZOIMujlityye3R6sMwoo5qe3A4AYVam8VxRkEb
WUlzqMSI0qrYO48G9CjujoHQTh/l47iYqyWouCt4A/wp3Pgb2QDBPfH7F2Vsmsbk
a5aCrNOrzTpFviNk82106dfjynMh4s35R2ggX2A1ZRNSmlhYnXHHTmg2HEf6pKQT
Vu5w99yw1tJxCl5VAyZQ63doU73THvzBE5uOTpsleIDPE9BlZkmOxWgRY2mI/sA/
o2QpxjkNh9rjNqnn6pLXmP89336PiVuCTd+lEVuqThuypOABWciNN1CQYxURjg2t
vTLShtkzV6LRovFa7qoa
=8KtU
-----END PGP SIGNATURE-----

--yOCDj6dCdxu1mn4c--
