Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3IWUAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:00:22 -0400
Received: from ring0.de ([91.143.88.219]:40779 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab3IWUAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:00:19 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Mon, 23 Sep 2013 22:00:09 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
Subject: Re: [PATCH 4/4] RX-51: Add platform function and data for bq24150a
 charger
Message-ID: <20130923200008.GA21808@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201309202122.06327@pali>
 <20130923180259.GJ2684@atomide.com>
 <201309232116.19161@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <201309232116.19161@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2013 at 09:16:18PM +0200, Pali Roh=E1r wrote:
> It is not as simple as it looks. This is reason why I submited=20
> this patch long time after I submited bq2415x driver.
>=20
> Problem is that for rx51 is needed specific function which connect=20
> to two drivers (bq2415x and isp1704) plus it call specific rx51=20
> board functions.
>=20
> Something which cannot be in DT (unless DT support C/ASM code).

mh could isp1704 driver expose the data via the regulator framework?
Then the bq2415x chip can just use the regulator framework. This
should make converting to DT easy (by giving the bq2415x chip the
isp1704 as regulator) and uses existing standard interfaces.

> Patches for modem support are being prepared for upstreaming :-)=20
> so after that it is up to you to create "call" script as you want

I'm on it. RFC round will be sent out this week. It seems
hwmod data is already finished, since i didn't get feedback for
that patch :)

-- Sebastian

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSQJ3IAAoJENju1/PIO/qaM0QP/RLNy0kh5FMKMfwSmgZK2aZi
W5p1U0uxYkj7+1GqbGdMmVkllhfc0DZ/qepriPKz7sdK3dwcOfZj7GjU2s+eBbgp
7doPknxPVLYRUvRBIoUcDQxaSOkaG5ertnenr1ACqoN2NvGgP67CnFvm5Q0OxbpA
/SntclhvWOxaEY9SG1gpUN8sTnDX4XQZTNZntknaWQx41lmVLsCHNi1uTICQkHej
81shKJ3ewHkC4d0INocnJPJmB/vk+j7P/pNiVoih6OHtbMR5/O+3U7tF24DPimsV
dEUHYSWZoTz0GkEuTN2lzxZYCka28lE9gwk+hfb6onxyxZVOz0hzjkjQzthdsAdS
Xa9lJB76Ot65m/+m7M7cX+t7nBTA130VcnKqq3Sf+yCbtAK8OMuQW7DomftOnWmW
XPsmeDTFyTtUiMsC+4JHOLo4HYSNdtpPU/1p6DyorgyxFXXZWrJ4reyPMNOrtNG0
ccRs3B0wCEvC2xFuyxZjbFDTrryK3L5z+f17v5m4J8Mw2wFT+Hpb/3mj09Z/q2F3
ZqL224XJpAXKjiVP61q4UXPI8LlukIgpjWVK1bBgFPalqnASjCAHd9ZTeTeDfRIe
/KUZvdqwnyEhLB85cWQjRP1jr4D+0NaYnbt64I7i5Fi0rxIbmp7+WoaAZZnrBFmt
Lr/zUiOuvGFKR2LvqqAT
=dWkq
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
