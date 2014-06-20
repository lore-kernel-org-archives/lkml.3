Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966547AbaFTKU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:20:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50385 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966224AbaFTKU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:20:57 -0400
Date: Fri, 20 Jun 2014 11:20:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, lgirdwood@gmail.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@codethink.co.uk, ian.molton@codethink.co.uk,
        ben.dooks@codethink.co.uk, heiko@sntech.de
Message-ID: <20140620102037.GV5099@sirena.org.uk>
References: <1403192765-3258-1-git-send-email-rob.jones@codethink.co.uk>
 <20140619175745.GS5099@sirena.org.uk>
 <53A3F305.9070903@codethink.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PfYdSB/Wheep+9ho"
Content-Disposition: inline
In-Reply-To: <53A3F305.9070903@codethink.co.uk>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Change gpio-reulator-probe() to use managed resources.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PfYdSB/Wheep+9ho
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 20, 2014 at 09:38:29AM +0100, Rob Jones wrote:

> I omitted to put "[Patch 0/4][v2]" on the front of the subject line.The
> actual patches followed.

Oh, so this is associated with a patch series?

> It was a consequence of lack of familiarity with the tools; I'm learning, so
> it shouldn't happen again. Would you like me to resubmit?

I do see another patch from you for the regulator subsystem which is
part of a series so I guess no need.

Please, if you are resubmitting try to use a changelog style consistent
with the code you're submitting against - you've got subject lines with
"drivers/" which the kernel doesn't do.

--PfYdSB/Wheep+9ho
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpAryAAoJELSic+t+oim9MuMQAJWSKMrOwfgwNzh5z8zrZhn/
x/DfvT58n7Pp50TX0CCOV57Y/72yq8H/mbgnzcNcnGP4wNEfR9jyqi0jOU86RJLu
Izjbu+Pn3bZq1uRNO0wHIA/KTVJAGfrp8FOJkXC1w5pNHuYQ88XTVKwf9ajJ1oBW
Oj+VXlTCXhD+QXNp0cb7oM6xJHz49vy5vNeQXvZKvkfcje+vg79dPrVIMASrqJwB
tj535YqDf3Kk8Wz1CcKRl6rmrc75sArdTauFpVjdJyWyfAeHwAJeekTV9StMqQTc
OoMZeAT2/8Fb6jsqNGxyUcZQ2NfiwHZCGY9jOnY/zcSfCSfcIH94EtWd+DfoB/s4
W+3LM9+pVu8gtwljBgLYYirjKSHiTHj77pTCDs/OsoF5RF9qcP62eR2PlMJBMMZl
FSpjMhsp0wXxON965/7E306HaBy1raDozqpeeht77S/Z/4vMcihxs1MBliRi42Yq
LXxJxBHVp8Qk8toewcOTqaFVG642uz2bECyA6n92POyo7aRF23hZmAhng5HxpOct
eu1usVIzdDhM9OAZdBuSjiPQRAPdLf3lyYasw+caHvntsszvZuOX6c8Wu0EKLNh2
GDaBEYX5Y2wv+brTowQ9IJ4UHZG85puzctM7gfqsSp4ay+DCvR/thYjBcXpqyZTB
s8gmWztLACn4Wj3Y8zKZ
=rTsz
-----END PGP SIGNATURE-----

--PfYdSB/Wheep+9ho--
