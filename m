Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaG2S0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:26:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33361 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaG2S0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:26:13 -0400
Date: Tue, 29 Jul 2014 19:26:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140729182601.GA17528@sirena.org.uk>
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
 <1406651339-28901-2-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A5jN/zRxu3Z2JiN/"
Content-Disposition: inline
In-Reply-To: <1406651339-28901-2-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 1/5] regulator: core: Get voltage from parent if not
 available
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A5jN/zRxu3Z2JiN/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 29, 2014 at 06:28:55PM +0200, Javier Martinez Canillas wrote:
> Load switches are modeled as regulators but they just provide
> the voltage of their parent input supply. So the drivers for

Applied, thanks.  The term "load switch" is a bit unusual - they're
usually just called switches (or sometimes FETs since that tends to be
the implementation).

--A5jN/zRxu3Z2JiN/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1+c2AAoJELSic+t+oim9ok4P/0NGywZ+ZbhbapJG8/wVSlWl
XpLwUxLXuGLvJDIhfco84MlnwKwHTaxIt+W2ef50LiKYlnXw8Ni/YDPNyqd/tZxL
tDGuo3liZ9yaMRoc8OfPrPdST9Icy8kkirSNJf+WCtRTZ+FDsGsxRR3R3pqtD+yM
MVs36Lv/WcmwVocD1eGgFkCj+8Qlve+yvYdPyY4TooHp9VJbX/kB0Ts1cjzVtnkW
XHQnMWeR8uJZn2j2P9uv2Bmj4O7agDqeuek7oPJA+nh0Fw7IWwBNCSHDDk+MHU8F
Mx1pdiK8D7+GbbtEb4JWfGJWRRcjzKoIKyz5J89uGt1hA5kbQdn8OmE42y/aLDUQ
EnurNiDGhrW3sKdiggZ7RS/fzG6bCUuPpXGZ6EEmFIf6wXCPIEYM9M07YpYNJ6mU
wyHPnQuld1nuosZcMpNkB8vvyYF/mUTn3wcUaDHOvXBuGHj6U763i0j9JK7Maxp2
GnFpvdc85AU/UMZE5A6aPy04xgsaznN8tc9qABXqXXeDu5EUkw/enHEJCG7l55EA
3uj9Cgac2ptlKExAo55Ppkw9SVgekfVb3bZj4sS3vU28N2NrOu9dZQctIOkUxgT/
I+lC/YxXLZL8Sjtfv3mgCeVFOK2ueTjs5eTpCR+iiLb+Czq4lFW9TKJ+HbEhszBR
nhRv8bnj7ioW2TQxmmwp
=kh5M
-----END PGP SIGNATURE-----

--A5jN/zRxu3Z2JiN/--
