Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaBSNHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:07:21 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43169 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaBSNHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:07:19 -0500
Date: Wed, 19 Feb 2014 22:07:07 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219130707.GT2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wOOEd1gxhwV8K3c+"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-2-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 02/15] regulator: ti-abb: Do not hardcode return value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wOOEd1gxhwV8K3c+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:10:58PM +0530, Sachin Kamat wrote:
> Propagate the error value returned by the function instead.

Applied, thanks.

--wOOEd1gxhwV8K3c+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBKx4AAoJELSic+t+oim9xSYP/jo5bwEccTvYVfnaE+ximJu2
2TR5hdRCSwmAtRP1PmD/rb6fOTGvCpHj8tZCLdF/0rc/SrrQYJHcOu4/AraikR4E
N53BRrCVwXSDL92ffhcv83/YVyYpKGjZpn1wQ/o0w8jxtgRfLKD/u7WvOB9i6J9r
eZLpygV55Va8UPWmeywTMjCcBhvSnDVXluFF/IW6FmjJnUZbW7JAs8xWL+JEmLoA
oCa8G7D9g0BPpc1phjZ6Cb9EcRuZhqmVaosn1RxkJUI7iiHobXLi4rRGisS+RpHJ
2SvJmCDQpjJ5FOWnzYrU3xGHAwfVmcyeTpVvp9WCC2CE6AvKn0PYIWkDzcOyPmf9
eUPwxg5ZuUzwTj89uCaODSAjSalpddK941KiUcta3HdPRWGuuLuFht1O9ohO9cVO
y/ozBkeJ4jskXGzknQvlDT6MpOpyAxsU4I9s0EF6vr1HWyV3RlDyHoKEDe3H+7cs
5jH72mhChOoLzN37A+nqgQ8VVp3HRcPEWAVh6ViVcbVT5hNn5tuCo6d4vq3AF8Ww
2DG6LN3+a8CbIOh1ptc0eodmErVRQgVkIsikaZrgKkpjQMhBDUsURrHOaxWNBiQQ
liRRTsBfE3ldupC1V9hD3/CnDqejXtYs/zmJCnQHRkjjyXX2fWCW6A1siV4tDtpg
gL4LWBg62se9TUTbO8Cw
=GFA/
-----END PGP SIGNATURE-----

--wOOEd1gxhwV8K3c+--
