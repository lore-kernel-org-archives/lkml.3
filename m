Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaIQSfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:35:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48512 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbaIQSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:35:38 -0400
Date: Wed, 17 Sep 2014 11:35:13 -0700
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Message-ID: <20140917183513.GS7960@sirena.org.uk>
References: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
 <1410959280-29662-3-git-send-email-zyw@rock-chips.com>
 <CAD=FV=WCQ4oU1O9JcZ9SuwWJ7g+GLsUiE=wmQQoWvL41o24eWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MhDS85o8hQkNlKhq"
Content-Disposition: inline
In-Reply-To: <CAD=FV=WCQ4oU1O9JcZ9SuwWJ7g+GLsUiE=wmQQoWvL41o24eWg@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] dt-bindings: add devicetree bindings for st-pwm
 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MhDS85o8hQkNlKhq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2014 at 11:16:23AM -0700, Doug Anderson wrote:

> I _think_ that the "regulators" subnode and the "pwm-regulator"
> subnode are not needed at all and should be removed.  Other instances
> of devices that are "just" regulators don't have it (like
> fixed-regulator, gpio-regulator, etc).
>=20
> I think your final example should be:

Yes, please.

--MhDS85o8hQkNlKhq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGdRhAAoJECTWi3JdVIfQOfEH/2hWOhknUcktMz6EOsYsnngU
1Gk3nXDFriOnIUyq0DiIXnyGL9EbUTEAb1PbM1DQilS+W3IjTdXKCO185n+w+BIc
6iZJCdl6jdqR5cPZUfqNA68Whdk8+Zvl2y7PF/I3GgNXZnvxFf1cWAdGUHQyEF14
hPjCEQnxZiwFT62bfp0A7SQfQn6IUyRgAOJWtnD1b7In6Cl6pCoSUyoKjwjmWDZ2
Xtidc1UHUmuCbMGq+MjmGik8oxhsO8G99fBuULcKGk39xZIkoAAII50PbWNlxqku
iNHI+ZbmK6ysZCZ8LvniBzNELHe2c0cRMfjrvOuob7ssehVYJfyUHdSpCHWKhG0=
=WHIV
-----END PGP SIGNATURE-----

--MhDS85o8hQkNlKhq--
