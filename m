Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3ILLRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:17:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56905 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3ILLRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:17:38 -0400
Date: Thu, 12 Sep 2013 12:17:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Message-ID: <20130912111708.GJ29403@sirena.org.uk>
References: <1378741920-11085-1-git-send-email-g.liakhovetski@gmx.de>
 <1378741920-11085-3-git-send-email-g.liakhovetski@gmx.de>
 <20130909160406.GS29403@sirena.org.uk>
 <Pine.LNX.4.64.1309121254330.4632@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LkPui+4YGLu0bCC3"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1309121254330.4632@axis700.grange>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: da9210: add Device Tree binding documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LkPui+4YGLu0bCC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2013 at 12:57:20PM +0200, Guennadi Liakhovetski wrote:

> Is a separate patch like this one ok or you'd prefer me to re-post the=20
> original series and merge this with the DT implementation?

Please repost, the bindings and the code really ought to be reviewed
together.

--LkPui+4YGLu0bCC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMaKxAAoJELSic+t+oim9hgoQAJFYvwFsKugB2z02tJRlorAX
PK0aKgiUcNfgce0jQq93rVfTICRnHWLweMpXP2bkxTujhFu6nH1zUuG3va4Gs/a7
i32kZQx9DQ4lbE9kcDQZfTic4g/0knGNChXEMKDiTbqVke9G+JWiilsW6by/jCpa
/fM/UucnYIa5Mixtrs5Gv4J00NBQRDXnxdXdLFcxVrBdsDo2EsV9gCB8DOYZDZ+J
Kpj+YxjyoK9L+lmHoGrrLp6IJsQmw5GghjbTQgyoiZoE5/Si8+6psNqmlQQDuDq3
aaOlJhzGHyxsWIXzF58N6itWapV/9WYClzYvMnxlO2hbmnpi0EHMvXA/uC6fYN+t
KfUCMzxoYvpyV784wOzD91r6tNqsJKmwuS8Lrva4vqo4uhcA5qdUOrCWttZGn8Rg
TNl48UyiRHTLi2D2c2ltRZMfvdieO64QAVmNWpcvtHk7kHDr2RmR4t/gYOeg0wkh
+1/M+wSkAD3L220LDLbFFyjOcoi4mZVHSUyiLffj1rZNzqrSLKqGaXJdiQ/jjdA5
zSZ4hE0eRurHE1fIXMkxqxBwEd3lMzxUe2aDQ7BY+kjKOlzcHdgTWtDmtQQQJl5y
6a2ZFKUxHzzq8OahJUqPGDl5TVzotrAwk8v1DCkdQJGVQc/AAiJVtRKsKUaCRCxK
pCR9763oT1rwzTEDKsBn
=Es+0
-----END PGP SIGNATURE-----

--LkPui+4YGLu0bCC3--
