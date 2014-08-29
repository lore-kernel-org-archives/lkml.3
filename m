Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaH2LIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:08:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39364 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaH2LIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:08:17 -0400
Date: Fri, 29 Aug 2014 12:08:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        "Jeffy.Chen" <jeffy.chen@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, amstan@chromium.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140829110803.GO29327@sirena.org.uk>
References: <1409269428-24680-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMHqbYJb993HXwLR"
Content-Disposition: inline
In-Reply-To: <1409269428-24680-1-git-send-email-dianders@chromium.org>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/rockchip: Avoid accidentally turning off the clock
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XMHqbYJb993HXwLR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 28, 2014 at 04:43:48PM -0700, Doug Anderson wrote:
> If our client is requesting a clock that is above the maximum clock
> then the following division will result in 0:
>   rs->max_freq / rs->speed

Applied, thanks.

--XMHqbYJb993HXwLR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUAF8QAAoJELSic+t+oim99kIP/3uRNvfVY4neyrcFLxk1xnYG
3JU3o5OVMkWVN1ltT7fh18ukOXO9S2MGXzBSHbHuhnt46iqJx1pJll+8eftzrPJZ
zYyoubftXWJJquP1Ih+m4sicqMw9BXkWbfUt/i5pWwGvjGbwAZFPAwe83PXMx8YU
LFApMDg9+GX/QNrkjZfFiJwH9s2bsioupDBMtMeL5rxecGWgE5fSXd5JRyXuVCF7
X5k3qVIr/ulBVv/E7Mpt5IbJjlTAGEfObOuH6t8hu3xs3hP6riG345XTTV2HHSek
b6fuKmgcLOh/pOA1cXoCzqHdAc/X690m8W6y/U30YlOoPa6+wyLmMY1jclr26Kx6
os6poTlUEHPYDXrTzYMlae3TF64lrSMTNHRxHQNoAfA8B17bLOkzqNrrgfH/BTxK
I/3tzvJq/9z1+bjzK4bv06OCkfjwmN7TCehVWeO+A7MBKOm6y3E83c6003fwb2eb
JO6KOt959b8fCoNCXhVBJpu+5dEAFRoo0GziFEJLEM5HttCGhuH6Q5ilJlqakK2W
rwyCoqyunqFxt/CiT58KANfRku0Q2UntXIHj+1M449EE2XEQTHUPaSaN+SXYqho4
n9R5UH3y7QeAMUnczG3iTxJTMVHBsyXjSKi8uPZMagfgbPN3HTC2dqJzb7+vw3of
+ygK23mpVXd2kgAyHLbU
=Rg55
-----END PGP SIGNATURE-----

--XMHqbYJb993HXwLR--
