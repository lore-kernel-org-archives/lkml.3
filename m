Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab3K0AMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:12:48 -0500
Received: from ring0.de ([91.143.88.219]:45588 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab3K0AMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:12:46 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 27 Nov 2013 01:12:42 +0100
From: Sebastian Reichel <sre@debian.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add HSI subsystem
Message-ID: <20131127001241.GA20111@earth.universe>
Mail-Followup-To: Linus Walleij <linus.walleij@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Tony Lindgren <tony@atomide.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1385403450-18018-1-git-send-email-sre@debian.org>
 <CACRpkdYSXDAwS1mxLtUL7qpHkfD1efo1QF0OMKS-YHKM-689Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <CACRpkdYSXDAwS1mxLtUL7qpHkfD1efo1QF0OMKS-YHKM-689Kw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2013 at 12:30:48AM +0100, Linus Walleij wrote:
> > +M:     Sebastian Reichel <sre@debian.org>
> > +S:     Maintained
> > +F:     Documentation/hsi/
> > +F:     drivers/hsi/
> > +F:     include/linux/hsi/
> > +F:     include/uapi/linux/hsi/
>=20
> Don't add directories that do not exist (yet).

Sorry, that was not my intention. The documentation path was
supposed to be "Documentation/ABI/testing/sysfs-bus-hsi". The
other directories should exist. I will send an updated patch.

Am I right, that this should go through Greg?

-- Sebastian

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSlTj5AAoJENju1/PIO/qauVoP/2CXScA6Sa3/kQG1uXrW3xuk
03CWxx+HfPg5p/4IWcQu1OWEPI519mqyoq04DpgNaU9quWZsO8QVHfzLjQzndiz4
WWaaP1W1j8HaHK5bkRbbv14XqByWfGQ/1HF/hIp16F8gqKLtylwh2Zqy1kkrZj0l
6KdFPE4Y4KscXTXHmUIDaf1+LwtcY6Foycxi8rNgX94/W96PoiUNv+eeFAb2ybeN
s0FMh0bso2O4KcBlOX2+7E/V+XTI2XPGSCnJuDUeRIWD5j2bqZd3a4WOCf04DlpK
Wle+v9SvQdxpJPXK9cF8T/4vndoyuC4r/7xyhU8aJgDwC1KFA24yZ0ZGY2ZBp6lV
rmjqAOBFTryXWBm0+u9vNk8QaT3AT/KnpCZomhzyp6ZYbD2nROuXIJXlYbB6d2RY
T6L+zolhbc9K2pc9hpOtHHORVw04tMModFRbXIwIGbH8JO2CrDraNk1j/RKIegAp
+4HdjWl8f0WowLUc2QSi7Pc9vvvYmkqw984ltV9bwfbvNhLdKKcnTlzlhme3CaII
fs+PEQI+KXL5GAN10Cvvl67TYIWqo/hpcoVekSUdGnx9eybdaoxe6TgLENuZt4cG
1lx1CJnDGOTT5PBzGXa3B/zcm11h9QbqRs7aWo+mOZ8cNmSooiJYS8CyvHNt8j20
baKRsaX/g6kQY++n8Eva
=HYh+
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
