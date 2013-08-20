Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3HTWu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 18:50:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47282 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3HTWu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 18:50:26 -0400
Message-ID: <1377039008.20316.79.camel@fourier>
Subject: Re: [3.10][3.8][3.5] ARM: Fix FIQ code on VIVT CPUs (was Re: [PATCH
 076/133] ARM: update FIQ support for relocation of vectors)
From: Kamal Mostafa <kamal@canonical.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Date: Tue, 20 Aug 2013 15:50:08 -0700
In-Reply-To: <20130819160740.GS23006@n2100.arm.linux.org.uk>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
	 <1376692475-28413-77-git-send-email-kamal@canonical.com>
	 <20130818210952.GI3067@blackmetal.musicnaut.iki.fi>
	 <1376928143.18111.12.camel@fourier>
	 <20130819160740.GS23006@n2100.arm.linux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-njH6kwxtnAuJyH4CYITA"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-njH6kwxtnAuJyH4CYITA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-08-19 at 17:07 +0100, Russell King - ARM Linux wrote:
> On Mon, Aug 19, 2013 at 09:02:23AM -0700, Kamal Mostafa wrote:
> > Thanks Aaro.  I'll apply "2ba85e7 ARM: Fix FIQ code on VIVT CPUs" to
> > 3.8-stable.
> >=20
> > Greg KH and Luis Henriques:  Heads up!  3.10-stable and 3.5-stable also
> > need 2ba85e7 but it isn't marked cc: stable.
>=20
> There's others from that branch which are probably also needed but I want
> them to sit in -rc for a bit before I request them to move into the stabl=
e
> trees - in case anyone finds anything more from the security fixes a whil=
e
> back.


[ 3.8-stable ]

On Russell's advice I intend to hold off on applying some of the ARM
security-fixes commits to the imminent v3.8.13.7 release, and instead
pick them up in the next 3.8-stable cycle.  Specifically:

These previously announced commits will NOT be included in 3.8.13.7:

        2ba85e7 ARM: Fix FIQ code on VIVT CPUs
        f6f91b0 ARM: allow kuser helpers to be removed from the vector page
        e39e3f3 ARM: update FIQ support for relocation of vectors

These still WILL be included in 3.8.13.7:

        0cb79f8 ARM: use linker magic for vectors and vector stubs
        b9e2c32 ARM: move vector stubs
        6810219 ARM: poison memory between kuser helpers
        73c083a ARM: poison the vectors page

(Aaro, I'll make sure to keep e39e3f3 and 2ba85e7 together when I pick
them up).

Any objections?

 -Kamal


--=-njH6kwxtnAuJyH4CYITA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJSE/KgAAoJEHqwmdxYrXhZV64P/R6CtGP9ncbZ+OqP7QLuWtrJ
iDQgD01gy/4DIAnG38yJfB6+oTWM8+ayQL+xQaICDIqwC1AuB8J9rWrHMxQMLFQb
nxBbwlDYnQLAu21ruwO9Jv6BWrbRFDqfvBDqmv987sr4RB1qf4bgXJ7PN23Aw+7m
+RTL6obVx1Sfbw/5wk6J4aFtMDU6hAuoVEpdAANa4/D0Yk/SfRkd35rAKzHdOaoC
I14IvMhJgnhp92r2ToX9czJxLnICgGCgH0ZvCLNUiG7hIQJTfVPKsoYUUW9sqrxB
bpd/H3EMPn593EwdHASN7LreyK3+e6SNY2Ksl2vmANyLTGL1kidgP2l86543/rJj
UHMkNr/Xf8VPECnoUenLOqWh3MZCJn3cJN7qh1a8lJNle9qdt2zhXDwEUrvJQeGb
jsYOcxD6Wt+eqe7GxDNzu8R1fauvil+svY7bV7UA6yXFNot011crXxRDRsAuxpa4
ewuRLdg7ZS3UWvkCNbHu1RtDYYegAFybbmW3TXSOh64V/p/OPNwj72vVFqjTOWF0
AYbGnFKQ3+dsEgbeWl/oOizgHsfu9ylktappxGX2e0RqW7Pv7xT96ikCjYrttahK
qrYvc58gBlFBTwAWqungDJky1Ycm9XN2Its/BGQXN9m/7zsNuw2tpBLcCWCCmXqE
L16K8UyoJCqrUPWy24s9
=ggc0
-----END PGP SIGNATURE-----

--=-njH6kwxtnAuJyH4CYITA--

