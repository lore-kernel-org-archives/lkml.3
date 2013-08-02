Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3HBIgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:36:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42456 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3HBIgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:36:00 -0400
Message-ID: <51FB6F51.7090500@ti.com>
Date: Fri, 2 Aug 2013 11:35:29 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <hector.palacios@digi.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCHv3 1/3] video: mxsfb: fix color settings for 18bit data
 bus and 32bpp
References: <1375346437-18991-1-git-send-email-maxime.ripard@free-electrons.com> <1375346437-18991-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1375346437-18991-2-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="0CsePrQKCBTcAcDwKv4Wh7w9tWtDTAJ1E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0CsePrQKCBTcAcDwKv4Wh7w9tWtDTAJ1E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/08/13 11:40, Maxime Ripard wrote:
> From: Hector Palacios <hector.palacios@digi.com>
>=20
> For a combination of 18bit LCD data bus width and a color
> mode of 32bpp, the driver was setting the color mapping to
> rgb666, which is wrong, as the color in memory realy has an
> rgb888 layout.
>=20
> This patch also removes the setting of flag CTRL_DF24 that
> makes the driver dimiss the upper 2 bits when handling 32/24bpp
> colors in a diplay with 18bit data bus width. This flag made
> true color images display wrong in such configurations.
>=20
> Finally, the color mapping rgb666 has also been removed as nobody
> is using it and high level applications like Qt5 cannot work
> with it either.
>=20
> Reference: https://lkml.org/lkml/2013/5/23/220
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> Acked-by: Juergen Beisert <jbe@pengutronix.de>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/video/mxsfb.c | 26 --------------------------
>  1 file changed, 26 deletions(-)

This one is labeled as "fix". Should it got to v3.11?

 Tomi




--0CsePrQKCBTcAcDwKv4Wh7w9tWtDTAJ1E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR+29RAAoJEPo9qoy8lh71DWwP/jSQh8Ttyn5R+BcvrmJtGHXS
i4XRQ3doz2G7vCZrtdo7P+JK+uU2y7NBuhHP5p41PbBISFbRwLXacwgkSQXgdQZ/
j02X8g1JH7+0p9NzmRoIigwjjXmV55ROi+Km/7uHNLshenu4Yofdjtd0CcWZE2VX
IwaXucV0GTImpJ8n6ZCqVZ1nNCL+iJVMf8s4lOrhj1xsV4u831u537+RgaBMPtq8
TYORaJ8T0EkbKh17kg1jJnq7QBD+gHFD7n5+u7vLRLmDb5Z90sfxtCYjEmqjKTx4
1WtVcws+9NCCVSr5KaYpbH/RZW37jhjsSjBEcQn7gXJeNawBFTWyNz6l0yBt8tGd
RGF3NAguaQk3po+B8pfzhUwalfD52ZJwI1uRNL2zlVyON+H/F6emg/88PW5MBlT8
CP/huMXs4MC+dkpLRJo6pzPK7WPsw/Yh8ejJ/bbHrhEdIQpviub1+tR2huQnZfP6
NcMbOTE7XIrLwY5iLQ7Jj/lU5QI5tzrmf+QAM4xgCARGhlI0/SzDKzW8H6JMXQaV
FcJ/DjclL7aX70fKEijR7Pnd29VaYVNY1VqIW6aCOqrp4bAIEfWA5EQoqNboTC8i
MjGyhEaE/h/4h6rqq4Mycb8KOi3+GUSlqFDd6MBAE1Kv9dLXzCIG2yYXnhWalIc1
CXg4UNcHC/BrSxSN0A1R
=Q3AV
-----END PGP SIGNATURE-----

--0CsePrQKCBTcAcDwKv4Wh7w9tWtDTAJ1E--
