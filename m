Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaKQPBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:01:39 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40898 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaKQPBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:01:37 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Date: Mon, 17 Nov 2014 16:01:31 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, bcousson@baylibre.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sakari.ailus@iki.fi, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20141116075928.GA9763@amd> <20141117101553.GA21151@amd> <20141117145545.GC7046@atomide.com>
In-Reply-To: <20141117145545.GC7046@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8237810.Y3XGAkWlkd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411171601.32311@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8237810.Y3XGAkWlkd
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 17 November 2014 15:55:46 Tony Lindgren wrote:
> * Pavel Machek <pavel@ucw.cz> [141117 02:17]:
> > On Mon 2014-11-17 11:09:45, Pali Roh=C3=A1r wrote:
> > > On Monday 17 November 2014 11:05:19 Pavel Machek wrote:
> > > > Hi!
> > > >=20
> > > > On Mon 2014-11-17 09:43:19, Pali Roh=C3=A1r wrote:
> > > > > On Sunday 16 November 2014 08:59:28 Pavel Machek wrote:
> > > > > > For device tree people: Yes, I know I'll have to
> > > > > > create file in documentation, but does the binding
> > > > > > below look acceptable?
> > > > > >=20
> > > > > > I'll clean up driver code a bit more, remove the
> > > > > > printks. Anything else obviously wrong?
> > > > >=20
> > > > > I think that this patch is probably not good and
> > > > > specially not for n900. adp1653 should be registered
> > > > > throw omap3 isp camera subsystem which does not have
> > > > > DT support yet.
> > > >=20
> > > > Can you explain?
> > > >=20
> > > > adp1653 is independend device on i2c bus, and we have
> > > > kernel driver for it (unlike rest of n900 camera
> > > > system). Just now it is unusable due to lack of DT
> > > > binding. It has two functions, LED light and a camera
> > > > flash; yes, the second one should be integrated to the
> > > > rest of camera system, but that is not yet merged. That
> > > > should not prevent us from merging DT support for the
> > > > flash, so that this part can be tested/maintained.
> > >=20
> > > Ok. When ISP camera subsystem has DT support somebody will
> > > modify n900 DT to add camera flash from adp1653 to ISP...
> > > I believe it will not be hard.
> >=20
> > Exactly. And yes, I'd like to get complete camera support
> > for n900 merged. But first step is "make sure existing
> > support does not break".
>=20
> There's nothing stopping us from initializing the camera code
> from pdata-quirks.c for now to keep it working. Certainly the
> binding should be added to the driver, but that removes a
> dependency to the legacy booting mode if things are otherwise
> working.
>=20
> Regards,
>=20
> Tony

Tony, legacy board code for n900 is not in mainline tree. And=20
that omap3 camera subsystem for n900 is broken since 3.5=20
kernel... (both Front and Back camera on n900 show only green=20
picture).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart8237810.Y3XGAkWlkd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRqDcwACgkQi/DJPQPkQ1KKoQCgwQG6qZ6AnoH3oSTwVbrwqa6o
BcAAn0kudF2gUH2gGE79y+X1d+p0T2Cz
=8fDr
-----END PGP SIGNATURE-----

--nextPart8237810.Y3XGAkWlkd--
