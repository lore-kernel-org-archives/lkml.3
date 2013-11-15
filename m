Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3KOGpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:45:32 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:35781 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3KOGpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:45:23 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Subject: Re: [PATCH 1/2] isp1704_charger: Add DT support
Date: Fri, 15 Nov 2013 07:45:16 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1384432734-1490-1-git-send-email-sre@debian.org> <201311141905.11046@pali> <20131114223416.GA6383@earth.universe>
In-Reply-To: <20131114223416.GA6383@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1397715.gDSUgNYlmo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311150745.18408@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1397715.gDSUgNYlmo
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 14 November 2013 23:34:19 Sebastian Reichel wrote:
> On Thu, Nov 14, 2013 at 07:05:06PM +0100, Pali Roh=C3=A1r wrote:
> > On Thursday 14 November 2013 13:38:53 Sebastian Reichel=20
wrote:
> > > diff --git a/drivers/power/isp1704_charger.c
> > > b/drivers/power/isp1704_charger.c index fc04d19..db96778
> > > 100644
> > > --- a/drivers/power/isp1704_charger.c
> > > +++ b/drivers/power/isp1704_charger.c
> > > @@ -28,6 +28,8 @@
> > >=20
> > >  #include <linux/platform_device.h>
> > >  #include <linux/power_supply.h>
> > >  #include <linux/delay.h>
> > >=20
> > > +#include <linux/of.h>
> > > +#include <linux/of_gpio.h>
> > >=20
> > >  #include <linux/usb/otg.h>
> > >  #include <linux/usb/ulpi.h>
> > >=20
> > > @@ -89,8 +91,8 @@ static void
> > > isp1704_charger_set_power(struct isp1704_charger *isp,
> > > bool on) {
> > >=20
> > >  	struct isp1704_charger_data	*board =3D
> > >=20
> > > isp->dev->platform_data;
> > >=20
> > > -	if (board && board->set_power)
> > > -		board->set_power(on);
> > > +	if (board)
> > > +		gpio_set_value(board->enable_gpio, on);
> > >=20
> > >  }
> >=20
> > You need to check if enable_gpio in board data was defined
> > or not.
>=20
> The device is not successful probed without valid enable_gpio.
>=20
> -- Sebastian

Then, OK.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1397715.gDSUgNYlmo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKFwv4ACgkQi/DJPQPkQ1JKvwCfftQMP0wzZ0b7Y9hoA5FRDhxg
HYcAnA8cdZf1SD+3XcWHIEDh6WpP+DNZ
=aF0P
-----END PGP SIGNATURE-----

--nextPart1397715.gDSUgNYlmo--
