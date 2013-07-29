Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3G2FBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:01:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50473 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3G2FBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:01:37 -0400
Date: Mon, 29 Jul 2013 06:01:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, rdunlap@infradead.org
Message-ID: <20130729050112.GK9858@sirena.org.uk>
References: <1375069211-32069-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5XswgcLA9HHGPOFO"
Content-Disposition: inline
In-Reply-To: <1375069211-32069-1-git-send-email-b38343@freescale.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator:pfuze100: add MODULE_LICENSE() in pfuze100
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5XswgcLA9HHGPOFO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 29, 2013 at 11:40:11AM +0800, Robin Gong wrote:
> Fix building error on x86_64 and i386:
> WARNING: modpost: missing MODULE_LICENSE() in
> drivers/regulator/pfuze100-regulator.o

Applied, thanks.

--5XswgcLA9HHGPOFO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9fcVAAoJELSic+t+oim9aigQAILQSe9nNXWQtvCQnse/+wP0
j3Y9p8PWQhvnpQHIy4uETd9lpzcd0MnDyr69IaQ4hjdOEF07ZTAMMhY6Z9f1kxDz
6fQ7Z9aWIPUtEw0+Ewovn5frCSGezc7NwTPJl1aHkwaw3M5uG7jDSTi9OArm41Cg
C43lybpKh8OhXai4Fqd6T5PXqBSYAZxXmTpyhyVOQ+0IodFO937D/C/+Yl1EzhMX
w4y50UMMATWNA4rV/9LC5wyL47R2n80HkIOQc+GzAGnYU/CHq4c07ZYfalt+PIn/
5AyMcGPbHQhmXSW+fq+X0nkoKG5GsqckFv2xm055xr4yvdPOCL/JznHu3VXIyppU
W5x7Uy4iDG/kuHlFuuoAL2UVfACdYKFdwH1m0BkK+7pLjQ0c/ERHNScaSa2GRgXk
5mCWWeOIv4sQcyGxjX1cJyyG2ac7giGCtHVBKPzo5o/aseN91yv7bqM0yHF8eNan
lTBiBsfUH+22amFitCC6Wrt4vJ+4bEFQ1GojVOGmPN0BlSyaS2QjkzxP86T0tsHm
jJj/FekLGFW5UNK8BBz+hlV7NJHzXJ3DwW3qnQ78qFLwi9tm9uDhBY6mAo6nYEj8
AIqCYA0ugQihb1RB1TN2m0uPa7erVwR1Ql/AbqMunAFRajnk93oNGEP8FCohKjvc
gc/w1g8QLVz8F/sc2g13
=lWGQ
-----END PGP SIGNATURE-----

--5XswgcLA9HHGPOFO--
