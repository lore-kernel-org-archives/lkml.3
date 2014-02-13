Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaBMK0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:26:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41172 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaBMK0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:26:31 -0500
Date: Thu, 13 Feb 2014 10:26:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140213102621.GO28112@sirena.org.uk>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
 <20140212175018.GJ28112@sirena.org.uk>
 <20140213082311.GA32508@lee--X1>
 <CAOMwXhPsQPvPn+kmBXyGq3WqsGhxTR2w1YjTzNbTyrEyxVHWxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B7kmwdlU7aE/dafw"
Content-Disposition: inline
In-Reply-To: <CAOMwXhPsQPvPn+kmBXyGq3WqsGhxTR2w1YjTzNbTyrEyxVHWxQ@mail.gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6] mfd: MAX6650/6651 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B7kmwdlU7aE/dafw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 09:14:11AM +0000, Laszlo Papp wrote:
> On Thu, Feb 13, 2014 at 8:23 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > Laszlo,
> >
> >> > +const struct regmap_config max665x_regmap_config = {
> >> > +   .reg_bits = 5,
> >> > +};

> >> This would normally be static too, and I'd *really* expect to see a
> >> val_bits set here.  I'm a bit surprised this works without one.

> > Mark (privately) mentioned to me that this patch can't possibly work
> > given the current Regmap configuration.

> Strange because I have tested the change, although not for days and
> weeks. What exactly cannot possible work?

The fact that it's using 5 bit registers should cause it to be rejected
when trying to initialise as the regmap code doesn't support 5 bit
registers, and I'd not expect us to have selected sensible value
formatting code either.

--B7kmwdlU7aE/dafw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/J3KAAoJELSic+t+oim9RVwP/RPPvAPEUkk4uEc6UFmyC/xG
3lIT3mvySvrVTY7ysVEbaqKtKS4wuN4i7Bl3uAAGJx39398p/Kt0K8UwGo64WMJd
MlHVg146xRSw6pcdwzlnAxNRJpoiz1ehmB5HkTEK6LYPXjkmKkngOYWLd4w1CeVa
5avFaJFgRurCfyl2QlAFxSwJGm2k7wdNdubFKxEGEe5LQKyR+q+e/kwCmA1wDzTJ
yzwCXUN8niEQZE2bjnFXhdUTvKcXHE/jHPetU/Uk30sF46ZsH/u5+tuvK+e9N87M
A2tly7yfKA4aczQoDVARlU14SN0E+Wq09B4+jRY28jTlA2NfqgfYO76+0iuAdr+C
h4A3gemZcCe0vU9C1JTFfakXQ0++UNgWTZw2OFnPQyWPPVcZ1qvzO4UJRPaFz96u
R1r1Pu6f5QReN0lzkIZwrQmQcr1flHi8RAFI2qJNP1bslT8+/6J0mdIKTt3djQGW
oCazTs7cpqED0daKcK9BJVrbY80oqIgc6dtvL/HTz9NZWI9NidWel3dojXxZqBDt
vduraGoq+IFBGytIJjeUzhhOMgBzPV1KWIfZd36CSc4R6NIqz3pb3ZAEUooBRHqO
9WBTfJd6EtuGQinbKSjcJpdXPwb9QosBcffIbZmbQlYaYMA/7EeTHwOStb4Iizjf
is4tZR0/MkVNPKMIo4RX
=EHZE
-----END PGP SIGNATURE-----

--B7kmwdlU7aE/dafw--
