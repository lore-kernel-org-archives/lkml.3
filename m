Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaEAUac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:30:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54506 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaEAUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:30:29 -0400
Date: Thu, 1 May 2014 13:30:14 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140501203014.GD3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-10-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gxnQqCMJOKyxv5fW"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-10-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 09/15] ASoC: Migo-R sound needs I2C
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gxnQqCMJOKyxv5fW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 07:18:30PM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The WM8978 driver needs I2C to be enabled, so the
> SND_SIU_MIGOR option also requires this.

Applied, thanks.

--gxnQqCMJOKyxv5fW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYq7TAAoJELSic+t+oim9hNUP/23IEu5K8SDbRguO6a6Ra3jf
BZyHw0vZEHP2Kfqxw2n8K99spShArGD6kP+W8tJ9tKyFMRBQEf+euirgUfpggC3Z
VFYMBIrGwg3vZhbEfG+dZ1ZgbwxosJwQIrdW3ORD8qWi7gwaoGHKHBiIjJpKbsM6
vGMJgOqtTeU2IZHFk8LN2oPNuvLWTtbSYPQZn+4JFlviQDUsPrAoguy5rEwW/vk4
UsmeBWZD52VL7n0eRcurE65jhZHKvr0xaaQIHyME9OySxWbBN0nwUeMAYVNQs81k
1uUBKs+NS+t88R2pAlaJwBfYf/mtdFqx9EPdK9O5gpMe8KxAVGBeY3f495t1cmEG
Kdll0mnk33jhNJgSoHsnFZOf/eqzQhhjRtxZK1tzF70Ku1y/NUi0Touvm4e5qqLr
BRVaPB9fxfbIS9Zn8wpD3pZ15bT4RgnlFWWM3f9oEXbOoeGuPKAyWUwoLjEQmV5v
EmATdF+NWJrLtun2btp9kTZ7bc1ZHvA6H2HFZrRQ/p/D2LlUqikP3TgAPGfVQhfV
fNzuXZkmSMJHl7n6tyxLRJmOPwVtIH08O6GFOuJexGmd/XeUZ25Mv5kNZzPaLTGE
vlTpXOO5QGc1d/sXlPJ5KYaO+Gdn7LyAaOw3yV3JL81ICGv8TACdPUcalkLvgHbl
P+9XSf/NYKPWQs3nO4Sa
=pj/o
-----END PGP SIGNATURE-----

--gxnQqCMJOKyxv5fW--
