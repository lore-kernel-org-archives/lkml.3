Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaLOSWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:22:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60725 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaLOSWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:22:18 -0500
Date: Mon, 15 Dec 2014 18:21:49 +0000
From: Mark Brown <broonie@kernel.org>
To: weiyj_lk@163.com
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Vinod Koul <vinod.koul@intel.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Mengdong Lin <mengdong.lin@intel.com>,
        "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141215182149.GM11764@sirena.org.uk>
References: <1418130877-28923-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ma2IebCqBk9lYfxq"
Content-Disposition: inline
In-Reply-To: <1418130877-28923-1-git-send-email-weiyj_lk@163.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] ASoC: Intel: fix return value check in
 sst_acpi_probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ma2IebCqBk9lYfxq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 09, 2014 at 09:14:37PM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> In case of error, the function platform_device_register_data()
> returns ERR_PTR() and never returns NULL. The NULL test in the
> return value check should be replaced with IS_ERR().

Applied, thanks.

--Ma2IebCqBk9lYfxq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUjya8AAoJECTWi3JdVIfQuRoH/iYjyXVJOycs9ImGJwi3WsOb
zBUBRKR6ooXfuWYcHzE8lTKeps3llXaIeUcphhi+WMS4Z88c29BXYy7ivbjedd2Z
i9DIklVwxsfHBjb5CP2SIQS4A027zg55jD34QDsd3g1OI5kv5KRLH/Uyb4OvIQJa
kvrCcIC5pLBqH/DWnEB7x5JVRr4YN8PmOvZsk1a96XFezzwwTyWVa77Wc4w83tvY
y6Y8fyFOPnFFU1k0SW35JJYV3uHMO1HpON1MtF5iwb5OwwYCQFURGwsGFl0iKuuu
G/upaDsH+gmLnSL2POjMl7kwK8YmNifp9swg28BSeZ86Yo3jTbzW+suwLbMYeVQ=
=D8m2
-----END PGP SIGNATURE-----

--Ma2IebCqBk9lYfxq--
