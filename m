Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbaIQQv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:51:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48227 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbaIQQv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:51:26 -0400
Date: Wed, 17 Sep 2014 09:51:09 -0700
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, heiko@sntech.de, huangtao@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140917165109.GM7960@sirena.org.uk>
References: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
 <1410959280-29662-2-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3pZv5aVBMTAsT+kh"
Content-Disposition: inline
In-Reply-To: <1410959280-29662-2-git-send-email-zyw@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: st-pwm: get voltage and duty table from
 dts
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3pZv5aVBMTAsT+kh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2014 at 09:07:59PM +0800, Chris Zhong wrote:
> Get voltage & duty table from device tree might be better, other platform=
s can also use this
> driver without any modify.
>=20
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> ---
>=20
>  drivers/regulator/Kconfig  |    1 -
>  drivers/regulator/st-pwm.c |   80 +++++++++++++++++++++++---------------=
------

You need to update the binding document if you're updating the DT
bindings.

--3pZv5aVBMTAsT+kh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGbv8AAoJECTWi3JdVIfQon8H/ibLrB2NbQGigA5OXM6pKyVH
aHXB11xmG0EMqAKNClZpIeProDkHYYey3lpTsvJQK6kD36hJUtUuyXAK6gE25Qr+
HEoRzzMUBC7KtbFatO+9jKoEjtOQryfHj9mLHMT2mAm0SC5Cs3YO2yLY0wFr8Cdb
4hRx2hDh8tGPZldBCdtbg0uea+d0n15sy15knj7WqaIAUJD9xpwy9oeU3Ha88g+p
NoQNJJ9eUkhwSlMmukGtfiLg/+kybvEek6Ee6VUj7uPe/AS2IFk8PXuqLrNQTE56
FW3l2Mxk81B8MrxkYDoUsk1J4OzofUUh01DizxUILb4WCPzF2A5/1KV6fyYDUwA=
=kbQB
-----END PGP SIGNATURE-----

--3pZv5aVBMTAsT+kh--
