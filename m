Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaDOOpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:45:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41131 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751029AbaDOOpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:45:05 -0400
Date: Tue, 15 Apr 2014 16:44:16 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-gpio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 6/7] net: rfkill: gpio: add clock-frequency device tree
 property
Message-ID: <20140415144416.GH3207@lukather>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
 <1397544101-18135-7-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LFBTxd4L5NLO6ly"
Content-Disposition: inline
In-Reply-To: <1397544101-18135-7-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4LFBTxd4L5NLO6ly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 15, 2014 at 02:41:40PM +0800, Chen-Yu Tsai wrote:
> Some devices, such as Broadcom Bluetooth devices, require a specific
> clock rate for the clock tied to the rfkill device. Add a clock-frequency
> property so we can specify this from the device tree.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

I think such a property belongs to the device that requires it, and
not to the rfkill that controls it.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--4LFBTxd4L5NLO6ly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTTUXAAAoJEBx+YmzsjxAgsCUP/iA4SYjm+jYyJMCgApwwXNKw
w/VFkZpJUOm3raQQ/L+Xi2KSm4+xkXr7G3MbsIX1hkst2uuuOFUjSTsejkFrHbj2
hhH5cgZyag3qYI5ZYFxqF9kKpe0x7TdyWWGM9MMH3Gi2DgkwtnoA537XxSK8DRK7
mfczf7sIuimy/sqZugnYFntFw+r61jBz0NyG6C34tXYkyUHQwqVVKkCP+ev7d5j+
vgNXAgMNutArLpTVJtQcTDrRXgAmjx2jCVekk2+N4Xiv1Whil9uIZ93i99cMBJSR
72sDpenoaXYsBH5MZAusnxHwft/TFq/xlEVXvIwKHb3pn9JinbRNkMrN0rAFOCVM
MOIau7s1R2DrEjMEQGxrxQayjXbZWDsZu5Xv/OkRCSNK69dpL9Wpz/WHvwIhsvSy
EhW7DAztAiUMeYuc137Re68gU4VLCNrtRTe4UuZKwkW25ps9DJtrz4b6bqA/Ct/X
I4Fnuk/v0uY6VYW03gmJTF8Oa0bztz4tRcgirfZVzFvYjUBc0VQp9l6DcuBohi7k
DXZyQmCHq0x0AcVvxuiDi7GJ+sIJHbq8TBiaK2NbpzTJADlG0XN2vojfb0Jyr6jk
zv1qLqTCv40qt8xqiOoSolLcsYQZTjpd4t9y4oIyjKU8g874WpSDHlb7EXT01UYS
iA+4sA6cuZ/t/O3VwhpC
=ksvN
-----END PGP SIGNATURE-----

--4LFBTxd4L5NLO6ly--
