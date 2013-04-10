Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936636Ab3DJIHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:07:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50573 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab3DJIH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:07:26 -0400
Message-ID: <51651DB6.2050504@ti.com>
Date: Wed, 10 Apr 2013 11:07:18 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Archit Taneja <archit@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAPDSS: nec-nl8048 panel: Use dev_pm_ops
References: <1365326053-16248-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1365326053-16248-1-git-send-email-lars@metafoo.de>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig3FCD09A59EE8B38FF4AF6CA8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig3FCD09A59EE8B38FF4AF6CA8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-04-07 12:14, Lars-Peter Clausen wrote:
> Use dev_pm_ops instead of the deprecated legacy suspend/resume callback=
s.
>=20
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  .../video/omap2/displays/panel-nec-nl8048hl11-01b.c  | 20 ++++++++++++=
++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)

Thanks, looks good to me. I'll add to fbdev misc patches.

 Tomi



--------------enig3FCD09A59EE8B38FF4AF6CA8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRZR22AAoJEPo9qoy8lh71uFQQAJmWtDVTVXn0ape+VYW20Oon
Ga8y5D/q8gZFwHGB0UVjLsEiGY9wIbNh86IqZ36A7Y21m5mVlhOpa2RAKYzQEupy
AkKKZ8BUa4CIMfdCUZNUZ29S5f94pDZZevoJImPujmnRcJVJgOZhDYN5OlHKPFKR
jyhnEDWbl2lFuUB5tncg1KOttCT3jf0AZ9c0tb2MgpIjZN8RvJJuZ0QQCc8olm1s
96j+uDDXvYg5p8SCWh1EfHMMTJo5rtXadxskxknxEd8FFPeFE/u9XE9NmfSg0xxK
omlQmSlMfc+ebtcHujR33gijjkTde3NxdRdVoyNpaxzCAZKMAjM6jRuc7/gJnLsT
+xP9NZ1r2JyOUkoR9KhmZ5skIFUObtBnxR5pGK+Yxk4UmEU/oEIJ6UeSCj2KAuqM
/7NKx5qohaePrtIaZ2/odI/R1+Px9O4FcqzwdXVVcmpRa5AMcbL/4xuIlOgq8q01
R0ml9A+4+zoFgJThI9H/araXSvsVe3mrH3onpV0kE5oyLfsevEbEHf9Y3xnSusQx
hE06ch61YofRnRDFY9lzZxw8IbOHxsyc/0bsA+p3+VklNLsqpWrPSH/yeXNYudn1
EjcjZEWoaFHPmba+TlVPJcMUYMY/hUnfGywXzPzblxOerfLyitnOOG42c8BGa3pj
u//K5Tn5m4J3du8ZlLX5
=j0rv
-----END PGP SIGNATURE-----

--------------enig3FCD09A59EE8B38FF4AF6CA8--
