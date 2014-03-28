Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaC1LND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:13:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36526 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaC1LNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:13:01 -0400
Date: Fri, 28 Mar 2014 11:12:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20140328111245.GX30768@sirena.org.uk>
References: <1395983576-4258-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8MA55IEjTDEadc2f"
Content-Disposition: inline
In-Reply-To: <1395983576-4258-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: mmio: Add regmap_mmio_regbits_check.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8MA55IEjTDEadc2f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 28, 2014 at 01:12:56PM +0800, Xiubo Li wrote:
> Fix the support for 1/2/8 bytes wide register address checking.

Applied, thanks.

--8MA55IEjTDEadc2f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTNVkqAAoJELSic+t+oim93z0P/1lep+L2BPn4CnlM42l8LdPL
3ksa68NHHDX9f8d7y9a7o+R+5MaHqn1AeMJf9vU1BjJEAT4vLM8IkMKQ15kv4yjr
HJNpP6kvbsy7UWXQRte4oLdnMW/9U033gfUpUKgWpk+Si/L8MCsed9v5DnZY/RBC
qngSpIU7Vj0Y6JjiYCqa81p2GGNto6aINvJqVabUIr6l5M8FFR+1IU2k/VMStDXo
pdKrjcKBOsZbTNJHlfgQwsAVokaK3CSPD4G4+JM6oVUpdnLc+VOD5M8Zw9T/oPUu
kP8FqOOzSwppTs3wBhak4V880R9oun3WF0zc2TawpWocv8ZprfHEnkhLTYXEG8H6
wgVkP+kjwkjSyJLEDIp/01cCQ8DQS/HnA43EkvYXoZjiUzL8VvsUgnkLrkOtBMJD
jebBze5d88m2tm9cJQaQUOu/5C+KTf1aNcsaxPPBX6jSyHsCyg7nHUn0aXRl/dkR
Z2F5CY6P9OX2oxy1+/lBFhfNqZVB1HUnm+ztXdVVnlkx1r0KrNBPjF0rXgQPZpvQ
hea1cE5ns5BP7PzCU7tWUFnxTcNcU8bYTTqig8WNtgHdLX5hfIvg5T4lbv1HYxkL
tKjS+YjFJ8J9NEe0dtLv32QtfXyFMHaSShBoRGc2dyq/YloHL0HDbkQS7X1KtfWE
9ne1kSEklp002oyygdaF
=XKlz
-----END PGP SIGNATURE-----

--8MA55IEjTDEadc2f--
