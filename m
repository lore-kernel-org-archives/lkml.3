Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbaI3WxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:53:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55510 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaI3WxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:53:23 -0400
Date: Tue, 30 Sep 2014 23:52:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Doug Anderson <dianders@chromium.org>, Chris Zhong <zyw@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140930225241.GO4273@sirena.org.uk>
References: <1412070294-5535-1-git-send-email-zyw@rock-chips.com>
 <CAD=FV=XViSBFyMEY9kQBMggnn+uA0wYarbseFOuZeakzBxZeqA@mail.gmail.com>
 <1716911.pj5CzLpxUR@phil>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk/CTwBz1VvfPIDp"
Content-Disposition: inline
In-Reply-To: <1716911.pj5CzLpxUR@phil>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: rk808: Fix min_uV for DCDC1 & DCDC2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pk/CTwBz1VvfPIDp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2014 at 06:57:51PM +0200, Heiko St=FCbner wrote:
> Am Dienstag, 30. September 2014, 09:43:47 schrieb Doug Anderson:
> > On Tue, Sep 30, 2014 at 2:44 AM, Chris Zhong <zyw@rock-chips.com> wrote:

> > > -       REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
> > > +       REGULATOR_LINEAR_RANGE(712500, 0, 63, 12500),

> > I have no problem with this (and the current "dts" file I see don't go
> > this low anyway), but it doesn't match the datasheet I have right now
> > which says "0.700 V" is the min.

> Then it would be problem.

> The original statement above says, that a register value of "0" equals 70=
0mV,=20
> so changing this in this way would mean everything runs 12.5mV above the=
=20
> target voltage.

> And I can confirm, that the current datasheet lists 700mV as equallying=
=20
> register value 0.

Has anyone got a voltmeter?

--Pk/CTwBz1VvfPIDp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUKzQ4AAoJECTWi3JdVIfQPIoH/3W6vkSgrUuDxnptXcbQBYDE
iH4GOg2S8Jx43EWZcMfk4qlSo1u58kFVYc3E52un5uMMsGZwp3p1tJRF7qMXee8h
vAp79td1FC/lI4Vb0gzmsOVs+LT97fkdocEx+G8RbaVP/m5qzTWUuvIVvLaUI3Pz
QTbQTzveR8oMwIUJ8dH5ObR9mV4L5iI/juqm8oC4JVZyCCnhn5elfnu0rA9d4BG3
IT9uwKlYOE+yiRg7dEP1bNAZMTmtbPOWqmlzPwYZVzDXzt4O7uXgTw6QAQDDReIc
2fQeCSDp60koqQNbHvHQe+CZnwEGDyjwdaXZypn/CdTL35i8PVa37dQdH1as0qc=
=6H56
-----END PGP SIGNATURE-----

--Pk/CTwBz1VvfPIDp--
