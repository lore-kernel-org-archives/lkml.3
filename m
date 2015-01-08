Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbbAHURB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 15:17:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45086 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbbAHUQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 15:16:59 -0500
Date: Thu, 8 Jan 2015 20:16:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20150108201636.GE2634@sirena.org.uk>
References: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JLqpAN9gGHZowk+m"
Content-Disposition: inline
In-Reply-To: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 0/5] regulator: Allow parsing custom DT properties
 with simplified DT parse
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JLqpAN9gGHZowk+m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2015 at 12:48:40PM +0100, Krzysztof Kozlowski wrote:
> Hi,
>=20
>=20
> The patchset adds:
> 1. a way of parsing custom DT properties by the driver when simplified
>    DT parsing method is used,
> 2. GPIO enable control to the max77686 driver.

Applied 1-4, thanks.

--JLqpAN9gGHZowk+m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUruWjAAoJECTWi3JdVIfQd/IH/RuLGU10FeNFRf6CWJoXQ5go
BjTGJl4L5OnKyWv0WSpO8UmBl22y1Q11SoTBLGzxKpkDEZXtRiA9kZLEVugTjHXW
AJauBic/edRCVOZX5PbrUBkS416zcgGBxALk2TthUVydXcKhCwUJTLrKgxDQZlsk
+fNG8/5UpuwHyR2dhOrCdpPVTXG8An6KofE6c0X6l591vwzR2oVZ/ntVQw2xqP3q
T0tmzfTjdmc1vlhZbenSsWWmCxbm3fBCavofeYr5LVm3/EPC4qHmbrMnzw1NElnr
8jT6PDvIGEh07b6LCb4EVN7Ens6jNT2FoH0HzDKOYIJZDju/ToA9/kRWJf/Ppm4=
=K8HL
-----END PGP SIGNATURE-----

--JLqpAN9gGHZowk+m--
