Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3LIR01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:26:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52312 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3LIR0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:26:24 -0500
Date: Mon, 9 Dec 2013 17:26:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Message-ID: <20131209172620.GB29268@sirena.org.uk>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
 <000f01cef252$8dbe1d90$a93a58b0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2y/feSa6JmJqKeZ6"
Content-Disposition: inline
In-Reply-To: <000f01cef252$8dbe1d90$a93a58b0$%han@samsung.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/6] regulator: stw481x-vmmc: use
 devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2y/feSa6JmJqKeZ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 04:12:41PM +0900, Jingoo Han wrote:
> Use devm_regulator_register() to make cleanup paths simpler,
> and remove unnecessary remove().

Applied, thanks.

--2y/feSa6JmJqKeZ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpf05AAoJELSic+t+oim9nLEP/2bk9+/8GWNU6JaFXmcGjaPc
Wa3fgq26+AQ9ON0fUQnv6YJwdz1jJT4Cg74GCaM7EicJfdbYmo6YpcrsUkV1VIS+
Qvx/Wq8eJQ3QT6NxcikGpH6KGBHK+op8gxDhLFP4aNkuV2eNNQPojCA/zqcMVPp+
kIboQyBzcMPhHAKFs+OrLMCg076kqzfZpsbB32/GeXvFjKyuIfGs7Y7B/PY/sWRC
h3vuJXeS9PldxJAA6ODu46OewdD2XplQm9P+kSPGRRobodGsVxohASBfy1Zt5i5N
/xlgJ/j2lx7uXVeIZDl8xIYzp5s6tMDY5Gp/4sX4l7+yR/pTBNX+5wpAqzHEF3X1
tZv7bA2iFXcWfqW6JS5DzmE3+uXLNeJAN4WfAqRZrrwGbTzPULO8siiNuE37PtZb
gijScwvj+r30vvD3a6E/LQjdCfdtr9pYN4hQYhgTrEvv4bAmAp/JxHYKvWHZMJHA
CeT0EdhvXn9MNmdlMgHOdoqYWt21SgpDuiUa8YBxVYlkNuCfEshKDaalZiCfKGhZ
vk2aHySk2wZFF6pLB5ikdjF1h3bO+kZbXtqJORoOWKZLNzKATAM00cWNvz9HGCtf
bRk4VvWmy2Eor5L0ZNp4vQn+3no8FMnd+AoBr4JCX10xDSH8Hb9JVN9nFsgjvdfn
MyQRy2Z6PwtZ1veAVUjT
=k+w9
-----END PGP SIGNATURE-----

--2y/feSa6JmJqKeZ6--
