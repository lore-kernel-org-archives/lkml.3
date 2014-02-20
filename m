Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbaBTMEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:04:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47340 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaBTMED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:04:03 -0500
Date: Thu, 20 Feb 2014 21:03:55 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140220120355.GO2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-21-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UyRhYLlBUOwBnHrp"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-21-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 21/23] regulator: wm831x-isink: Remove redundant error
 message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UyRhYLlBUOwBnHrp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:21PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--UyRhYLlBUOwBnHrp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBe8oAAoJELSic+t+oim9egQP/148WgljqpgZZJfiX0zTxnNg
/MthjrgGWe+DPgPj+Wsgm8Rj1dZgcDcAGSCUX4kCnpwt3GYp9xNivpnzCboRGPrC
3lXOsU2EW6gbznmvXQQ44RnT5WGaTxXGXdE5FaUkdtdDrU8rpU5uSbWRFkMPvTXT
6HPHoKehc+jTir588KQPqVhBkIZlH2zkDkp6jJ02dCQkL1auNsuQ5f4YED1+LKsb
ABKAxjnTJzQGTO1pBQV7fQUwah+F7/0j9avBjKaiqjDWa7bbS7dpreFXU5L3FYiS
5K9EqOzGVYsUCSe8YCWk//NzBhTJ/WRF1X42simMwb9Zs4+RfJ/JZu1CGoFK7nLA
qXBlycR70s8onqw918mkPz8j7aGpYMmVjzXjHl2kMIjA3a3KxsVdo73hoqdJw6qf
Kw/KOyIs8KYTd3mZKS4hD5Eb+xyDWZtmILOhbSuuXksiC16NQdXZhrXyGTaP1TjU
CTVgSkO9mRs6+mt4zculScn5oTpZRQzM+4N1ONoMxyge0PWkc39h0YKa/i/GSmZt
fgbxXXrt13+IDHYdhQxlYgcr+wy5PzJbkYEzpbZDFju5kNAoU36DigSt4dwZn1z9
JRJwISeTnW2uwEjDiUu/Crv4BUsobTG9y+vyVLu0ZZnQExCuaU+B97gUTST+lHBJ
goy8Hdd22fo/+GKSTwKq
=KS7W
-----END PGP SIGNATURE-----

--UyRhYLlBUOwBnHrp--
