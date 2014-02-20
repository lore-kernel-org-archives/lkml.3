Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaBTLws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:52:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47292 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaBTLwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:52:47 -0500
Date: Thu, 20 Feb 2014 20:52:33 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140220115233.GH2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-14-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A8E9YQbHeV6BjaSn"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-14-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 14/23] regulator: tps6507x: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A8E9YQbHeV6BjaSn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:14PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--A8E9YQbHeV6BjaSn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBex+AAoJELSic+t+oim9u4IP/iU1ei5Ot38fa2PmT4b9Br0M
BTN1IDgMx8IqaZLZOtbwhDJixbqWKbNASDfZyR278V2hhFDpUlwemkbJwSsLWqqs
ET8guWqHOvudqXqK2Ht6JsUQZhICQqSNi4432Mqe4l132wm2d9Z1N2bhXnorKdAY
ewO3Si675qszlyLYlprVeMb+dPOqkU0u7TAwYUBI2mjnNHqP9TMNAOpLnzdHjmKL
J5QmKSLWnOhbJ1tywWMN7OnxnhZMiS0tKMdqNl10LiJ7u60kD+HR8tk5F9wtfIUt
/aWFTUC42P45+TbKNFQP913WJBI3y45EoWr74LzrQvnFiOySUbaOzLqkKFHoyLMP
qDewnQQSgoK36eJA5D0JWaFYTXStOyWJ6d41ZbU9etvD4XsC3RRgmefL8AxV9olc
iQY5AuRceUAo6rspLhEplbP8hTeLPXSp6133KEk7SHNEw5g6zUTelg6LDKtboSR5
oCbD3AhVLGMSkCHR1Ps4BLtUNyrydfm8eaDGRXA+/A9qbu/lkAD9IsGWlOTNfGIC
L7oCN1X5tcNKKHXugi/ZaPmSyDOkYfXWnbuiegDHyBRi4hkmd17ros0yjbwsV4My
wr7Sp2Vsa17u+d1Oe9+TxlmqHBGF6L2HoEGMswUtItetwDL7lnlaqG8NR8Iqdlfh
tZNIn0bIftRYVN+8RQRh
=5+zp
-----END PGP SIGNATURE-----

--A8E9YQbHeV6BjaSn--
