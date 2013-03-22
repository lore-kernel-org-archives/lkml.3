Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab3CVLE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:04:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42424 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525Ab3CVLEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:04:25 -0400
Date: Fri, 22 Mar 2013 12:04:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 06/46] regulator: ab8500: Separate regulator and MFD
 platform data
Message-ID: <20130322110421.GH22890@opensource.wolfsonmicro.com>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
 <1363881583-15234-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ik0NlRzMGhMnxrMX"
Content-Disposition: inline
In-Reply-To: <1363881583-15234-7-git-send-email-lee.jones@linaro.org>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ik0NlRzMGhMnxrMX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2013 at 03:59:03PM +0000, Lee Jones wrote:
> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
>=20
> The ab8500 MFD should not have knowledge about regulator-
> specific platform data like number of regulators and
> regulator registers. As the regulator platform data is
> about to grow with external regulators, this information
> is moved to a new structure provided by the regulator
> driver.

Applied everything up to here, thanks - I'll carry on reviewing the rest
later, not actually looked at them yet.

--ik0NlRzMGhMnxrMX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRTDqrAAoJELSic+t+oim9KacP/3IewdZuS+rre57gcgwjom+L
96q/I2rRnUhpkgA6SOYoH8JDFpe07G1qElJ0l2JHpp9uDMm7mWl1yo8RpNvBBb3c
/wMMbW04blrJVvlNaEZWErkKtRdHBZDqEYrMMcOmkeBT8InQeb3Zxr27Y63uD+mN
kbbv69TPDyMJMqYZ2SWb1ETS1MSDJ6HVgp8zqRmxrurAXabSy27nRh+L4lhOJ9tN
lCLAoekPCsSED7LZEYOOFcKkN3TTTvAjuKNc1GPDg2SeHslX2O1zjmpkHE45LoiY
C21TZK8Fki9S7GH/sdSIDbMWiQ5hn9cdvIYH4z09zvOtY9mR29NSM5WF3xIIxSRZ
5JicZoujx7YyxHtKk/m119Pp4NA3vhReSdY2iay5sCOO38bTtyzY/PuQRR3x63CU
SKVw1l58XqkYPmRJ98tE0qRU6vzEPuEqHuo9d+W8QjoOpkkQwyiZKNq8unm0mIoy
ak/LZIBorhAA5t+gOXEK7WqkYnh8zUXjLIZKfjlBPVY0ynchNnnFMFYtaxmja3Jp
dQ1eRx4FzApJLfElBA4yVG89W8ykDmkllayGZTXdjEEmRmiGQU8mkZiPOHdB4Yi1
HjMS3dfJQ5y7wcqXJ1jHaIy5Wm7DA8TqBCowJ1KmrdGRqjb4SRvplDqqMdpssEqS
//JLtP+rGq+EELp6PY9U
=T9DT
-----END PGP SIGNATURE-----

--ik0NlRzMGhMnxrMX--
