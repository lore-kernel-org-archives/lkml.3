Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaJQMqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:46:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33226 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaJQMp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:45:59 -0400
Date: Fri, 17 Oct 2014 14:44:59 +0200
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141017124459.GN1820@sirena.org.uk>
References: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413478133-2577-4-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sy9WyBOsCRoUO165"
Content-Disposition: inline
In-Reply-To: <1413478133-2577-4-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/7] regulator: max77802: Don't treat OFF as an
 operating mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sy9WyBOsCRoUO165
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 16, 2014 at 06:48:49PM +0200, Javier Martinez Canillas wrote:
> The only operating modes that are supported by the regulators in the
> max77802 PMIC are Output ON (normal) and Output On in Low Power Mode.
> OFF was wrongly counted as an operating mode while is only a regulator
> status. Make clear in the code that OFF is not an operating mode.

Applied, thanks.

--sy9WyBOsCRoUO165
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQQ9LAAoJECTWi3JdVIfQQ+YH/0lPxUlhpiGB4bAmAEYteRKv
eoRD2iBdR5RbWxNGymYUBSiPS+kMFm/1ucQv2GGVcNywjsx6wrlrlfkKVBtYyIob
hNQ/GuEnBnQtw6ZJEpVhIq6tXiWGbcWtQUS7BMkgMe0hmy9gNkOZ2LKzmCUK/gqd
tBKEmzj2lAJyGeePIRFMRpa4mjW61urWWimXcOSEWBkMUIGeeAfsRuTqnfwNDCzb
qdOTgRsrllu34Vnfv2D3o9T7BQZjD3PgwSMhsMaThwEZU7rmyWG64eIX1FLgBcGR
NW5g+gY0GtiJSfKYXcn2itNCaJe7TBeDzy+ojuve9rADCEnCOQ4hpNMBL3rBmko=
=JRuo
-----END PGP SIGNATURE-----

--sy9WyBOsCRoUO165--
