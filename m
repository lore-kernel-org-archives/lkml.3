Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab3ILJng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 05:43:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46689 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3ILJnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 05:43:35 -0400
Date: Thu, 12 Sep 2013 10:43:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        linux list <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org
Message-ID: <20130912094331.GB29403@sirena.org.uk>
References: <1378901968-7368-1-git-send-email-broonie@kernel.org>
 <CACnwZYeNe4T27eqiQ+LW-ot9Hk8Qk0Uzg7b3jH7xF_euHOWYhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SIVARdI9NlIk32Qm"
Content-Disposition: inline
In-Reply-To: <CACnwZYeNe4T27eqiQ+LW-ot9Hk8Qk0Uzg7b3jH7xF_euHOWYhQ@mail.gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Split devres code out into a separate
 file
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SIVARdI9NlIk32Qm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 11, 2013 at 02:15:51PM -0300, Thiago Farina wrote:

> don't you need any forward declaration here nor any include (like for
> list_head and device_attribute)?

Probably, though all the users should have pulled in the regulator API
headers.

--SIVARdI9NlIk32Qm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMYzAAAoJELSic+t+oim9MwsP/2xIKFD/W5Y/YR2a/FUMjcT/
Y7ctEUCS0NeOGew1+bSFfoESAByzfJT6woMjbAiCiHFtT9aJPGHpQpevyjQh0iRV
eIj9zEQ+77gvgdiOo9Ivk0ROXJSZl2ymFa3+HRMrrF1EXxXXySikK0qhNlUy4pPL
9H3+7flBdSBFIPOhkF9r1E4h9kqcMsAjuBSVjebmQSEGLiKNOZKD6ajSovRS9CAT
OJg4Ybiyjvi5Gx9wDfXKHV3mRzYK8ghEZoM5WLIIypapPhCeQMqVxp7oQrf9dUTt
QJE5eu+SnpVIc3KbaDGQNGP1qL6Rem0Xuc4YoD58hcnPF4VMc4LPTFczBVjLQY6v
tfqoUhnWU/R7qogzvJjMcmN3pQkUOcO3JGplsV7WHFO8pFz6V6RhhF0d+UnyWEOH
JVHG31kw4eibNsLG0u8OE2uSQB/hmQHMXxr7U2ttpCXZbJCBtDjt69jjJ1FnnZg+
PcOzIvZEuiGhLiHjEGBT3CGduftPgf4mHvWQEOjx4JVrvDiuUqn+UZIjo6YtqKqA
6R0S1olHmk9xEAKWgc7IgBtAnenzlx7Qgl9SnZmriVCkd/8gJsgUzW21ui+Y4+o4
/65Iss/LuPjvbu3NFXdFBLLz8o8aaGVwqi3TfMTy3+CoyA1B+QQrgrDm58lLglu1
dUR/mdgStC4Q4jVsvJPM
=IEVo
-----END PGP SIGNATURE-----

--SIVARdI9NlIk32Qm--
