Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3IAPJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 11:09:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54089 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3IAPJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 11:09:04 -0400
Date: Sun, 1 Sep 2013 16:08:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        alsa-devel@alsa-project.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130901150853.GG3084@sirena.org.uk>
References: <20130831130741.GG18608@sirena.org.uk>
 <20130901144847.GM20329@zurbaran>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6lXr1rPCNTf1w0X8"
Content-Disposition: inline
In-Reply-To: <20130901144847.GM20329@zurbaran>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/5] Remove ASoC-level I/O functions from cq93vc
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6lXr1rPCNTf1w0X8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 01, 2013 at 04:48:47PM +0200, Samuel Ortiz wrote:

> As I'd prefer to carry the MFD ones (Including the twl6040 one) through
> mfd-next, I can build a branch for you to pull from. Would that be fine
> with you ?

That's fine by me, I just want the patches in ASoC - obviously the
branch couldn't be rebased though.

--6lXr1rPCNTf1w0X8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSI1iCAAoJELSic+t+oim9+b4P/i1410dDEXX6TJacGtOVBIsk
oUB0WdYEJgyxoiAyolJhkDRzbjrYxIH8HomfjjCb8pTHVUkEmM7a4cX58PDmuXMR
BFAq9Ov0nrLAzBeq99mPYrWLRkSCBac5hAMjliCHRKNwJEqLimV3338LD8MdwuzQ
790r1iyONKkCr1Vub0EdwdTt1zthP1hdF+wNvv8LmTU9jnKfULlOaTTK6+YXfGun
vZQ2/ljPkBQNyeV85IdGwn6zmwTLcgX0v5tHykzOs6G95m1rQ20IBkf8LwkIuGE+
ODsVtwhESStuws6osMIjsciiJJXVDaJW9mnc1YZPk1q4NEkGlCO72cKLHwGxvXH6
uvIRxOtJeCPl9xIUweRBaIMtrdRoVhZEJOSXNXKHBWlIJTn8OU8I7SPlT/kzC54e
VIfD3WOSGz6KRUErefKaCSWJA1aCQdIZjwJDfonaVvGFtORYMlPrR/Fec/A2vDIo
QXxqNuu5YxpfCFwmE/8AYVzo6J5V4lzx6MRfElt0lWafY/hnXONI0Ql4OAHJrfe6
qo5XLkR9ZqcvWPr7KFLY6qgdlQxQqLLpbhyvGuNAI9M0ktdXSdv6RQjNGLcdMhLG
15EDmGBb2y6hkU6a+NVaUF185AlTVuRuaVEBhwuUwb1B4FcdOQji6wOPRtXdaMNE
PD3u2ZVN+Iv9RBBBdbe1
=zyny
-----END PGP SIGNATURE-----

--6lXr1rPCNTf1w0X8--
