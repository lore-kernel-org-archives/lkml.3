Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaKQKJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:09:56 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61660 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaKQKJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:09:54 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Date: Mon, 17 Nov 2014 11:09:45 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: sre@debian.org, sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sakari.ailus@iki.fi, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20141116075928.GA9763@amd> <201411170943.20810@pali> <20141117100519.GA4353@amd>
In-Reply-To: <20141117100519.GA4353@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1476038.VxUQSkjrrd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411171109.47795@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1476038.VxUQSkjrrd
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 17 November 2014 11:05:19 Pavel Machek wrote:
> Hi!
>=20
> On Mon 2014-11-17 09:43:19, Pali Roh=C3=A1r wrote:
> > On Sunday 16 November 2014 08:59:28 Pavel Machek wrote:
> > > For device tree people: Yes, I know I'll have to create
> > > file in documentation, but does the binding below look
> > > acceptable?
> > >=20
> > > I'll clean up driver code a bit more, remove the printks.
> > > Anything else obviously wrong?
> >=20
> > I think that this patch is probably not good and specially
> > not for n900. adp1653 should be registered throw omap3 isp
> > camera subsystem which does not have DT support yet.
>=20
> Can you explain?
>=20
> adp1653 is independend device on i2c bus, and we have kernel
> driver for it (unlike rest of n900 camera system). Just now
> it is unusable due to lack of DT binding. It has two
> functions, LED light and a camera flash; yes, the second one
> should be integrated to the rest of camera system, but that
> is not yet merged. That should not prevent us from merging DT
> support for the flash, so that this part can be
> tested/maintained.
>=20

Ok. When ISP camera subsystem has DT support somebody will modify=20
n900 DT to add camera flash from adp1653 to ISP... I believe it=20
will not be hard.

> > See n900 legacy board camera code in file
> > board-rx51-camera.c.
>=20
> I have seen that.
> 									Pavel

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1476038.VxUQSkjrrd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRpyWsACgkQi/DJPQPkQ1Jy6QCglBKZqhyJBNS8eLewXZ7URYoB
2bwAoMfx6J2TFeyK/vaZlkPvXdihCxKe
=IbyL
-----END PGP SIGNATURE-----

--nextPart1476038.VxUQSkjrrd--
