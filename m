Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaKQIn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:43:28 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:50776 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaKQIn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:43:26 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Date: Mon, 17 Nov 2014 09:43:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: sre@debian.org, sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sakari.ailus@iki.fi, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20141116075928.GA9763@amd>
In-Reply-To: <20141116075928.GA9763@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1847905.6cyh1QvJQ8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411170943.20810@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1847905.6cyh1QvJQ8
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 16 November 2014 08:59:28 Pavel Machek wrote:
> For device tree people: Yes, I know I'll have to create file
> in documentation, but does the binding below look acceptable?
>=20
> I'll clean up driver code a bit more, remove the printks.
> Anything else obviously wrong?
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> Thanks,
> 								Pavel
>=20
>=20

Hello,

I think that this patch is probably not good and specially not=20
for n900. adp1653 should be registered throw omap3 isp camera=20
subsystem which does not have DT support yet.

See n900 legacy board camera code in file board-rx51-camera.c.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1847905.6cyh1QvJQ8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRptSgACgkQi/DJPQPkQ1Jp/gCcDXvCk21znfd1oIRrJyc1nuQm
Aq0Ani3PDwgQk4b7tvcNNpAAy7HkvB6o
=b1Is
-----END PGP SIGNATURE-----

--nextPart1847905.6cyh1QvJQ8--
