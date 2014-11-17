Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaKQPPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:15:41 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62298 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaKQPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:15:39 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Date: Mon, 17 Nov 2014 16:15:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Pavel Machek <pavel@ucw.cz>,
        sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, bcousson@baylibre.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, freemangordon@abv.bg
References: <20141116075928.GA9763@amd> <201411171601.32311@pali> <20141117150407.GP8907@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141117150407.GP8907@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2555655.kPujV8QnPf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411171615.34822@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2555655.kPujV8QnPf
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 17 November 2014 16:04:07 Sakari Ailus wrote:
> Hi Pali,
>=20
> On Mon, Nov 17, 2014 at 04:01:31PM +0100, Pali Roh=C3=A1r wrote:
> > On Monday 17 November 2014 15:55:46 Tony Lindgren wrote:
> > > * Pavel Machek <pavel@ucw.cz> [141117 02:17]:
> > > > On Mon 2014-11-17 11:09:45, Pali Roh=C3=A1r wrote:
> > > > > On Monday 17 November 2014 11:05:19 Pavel Machek wrote:
> > > > > > Hi!
> > > > > >=20
> > > > > > On Mon 2014-11-17 09:43:19, Pali Roh=C3=A1r wrote:
> > > > > > > On Sunday 16 November 2014 08:59:28 Pavel Machek=20
wrote:
> > > > > > > > For device tree people: Yes, I know I'll have to
> > > > > > > > create file in documentation, but does the
> > > > > > > > binding below look acceptable?
> > > > > > > >=20
> > > > > > > > I'll clean up driver code a bit more, remove the
> > > > > > > > printks. Anything else obviously wrong?
> > > > > > >=20
> > > > > > > I think that this patch is probably not good and
> > > > > > > specially not for n900. adp1653 should be
> > > > > > > registered throw omap3 isp camera subsystem which
> > > > > > > does not have DT support yet.
> > > > > >=20
> > > > > > Can you explain?
> > > > > >=20
> > > > > > adp1653 is independend device on i2c bus, and we
> > > > > > have kernel driver for it (unlike rest of n900
> > > > > > camera system). Just now it is unusable due to lack
> > > > > > of DT binding. It has two functions, LED light and
> > > > > > a camera flash; yes, the second one should be
> > > > > > integrated to the rest of camera system, but that
> > > > > > is not yet merged. That should not prevent us from
> > > > > > merging DT support for the flash, so that this part
> > > > > > can be tested/maintained.
> > > > >=20
> > > > > Ok. When ISP camera subsystem has DT support somebody
> > > > > will modify n900 DT to add camera flash from adp1653
> > > > > to ISP... I believe it will not be hard.
> > > >=20
> > > > Exactly. And yes, I'd like to get complete camera
> > > > support for n900 merged. But first step is "make sure
> > > > existing support does not break".
> > >=20
> > > There's nothing stopping us from initializing the camera
> > > code from pdata-quirks.c for now to keep it working.
> > > Certainly the binding should be added to the driver, but
> > > that removes a dependency to the legacy booting mode if
> > > things are otherwise working.
> > >=20
> > > Regards,
> > >=20
> > > Tony
> >=20
> > Tony, legacy board code for n900 is not in mainline tree.
> > And that omap3 camera subsystem for n900 is broken since
> > 3.5 kernel... (both Front and Back camera on n900 show only
> > green picture).
>=20
> Can you capture raw bayer images correctly? I assume green
> means YUV buffers that are all zero.
>=20
> Do you know more specifically which patch breaks it?

CCing freemangordon (Ivaylo Dimitrov). He tried to debug it=20
months ago but without success. Should know more info about this=20
problem.

I think that commit which broke it was not bisected...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2555655.kPujV8QnPf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRqERYACgkQi/DJPQPkQ1IBYwCgzhsqRQpQfxZG0dnW1YH87R3Q
nxYAnjpVF3iWJp95KDWjl5Xf/mVWpHV+
=nJ+y
-----END PGP SIGNATURE-----

--nextPart2555655.kPujV8QnPf--
