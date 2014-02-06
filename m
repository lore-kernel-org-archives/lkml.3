Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaBFAZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:25:18 -0500
Received: from ring0.de ([5.45.105.125]:33437 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbaBFAZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:25:16 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 6 Feb 2014 01:25:12 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, freemangordon@abv.bg
Subject: Re: [PATCH] ARM: OMAP2+: Add support for thumb mode on DT booted N900
Message-ID: <20140206002512.GA654@earth.universe>
References: <1391603582-11371-1-git-send-email-sre@debian.org>
 <CAHYPw2Ep9VP6Tem979ewcztdxkHkG8eR_U31U=f5ibsVa5AS4Q@mail.gmail.com>
 <20140205163117.GA15996@earth.universe>
 <CAHYPw2HX478ZZPfDTKCKSGhVdFc1-G5DszUR4vG+WRgZx=8+dQ@mail.gmail.com>
 <20140205171729.GA17974@earth.universe>
 <CAHYPw2FRbcR_anv9f2igcFV6XnCfpjJMHaeZmcNs8KpXuG96cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <CAHYPw2FRbcR_anv9f2igcFV6XnCfpjJMHaeZmcNs8KpXuG96cQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 05, 2014 at 09:42:30PM +0100, Pali Roh=E1r wrote:
> 2014-02-05 Sebastian Reichel <sre@debian.org>:
> > Hi,
> >
> > On Wed, Feb 05, 2014 at 05:38:54PM +0100, Pali Roh=E1r wrote:
> >> > I assumed, that the workaround is not needed for this device type.
> >>
> >> That rx51 secure call must not be called on non secure devices (e.g.
> >> qemu), because it cause kernel crash. So I thought that kernel should
> >> write something like secure call is disabled on that device types.
> >> Kernel code for errata 430973 will update ibe bit for non secure
> >> devices.
> >
> > Do you see any advantage in having that message?
> >
>=20
> Consistency. Print message 1) only if secure rx51 smc instruction is
> called or 2) print message always (also if smc is not called). With
> that patch message is printed (enabled/disabled) only if device is
> rx51 and device type is HS.
>=20
> For information it is also good to know that in qemu that special
> secure smc instruction was not called.

Assuming I do not know about this errata/workaround and have some
problems with crashing binaries I may have a look at the kernel
warnings. Without the additional message I won't get any hint about
the errata/workaround at all.

On the other hand there is no such information gain on qemu. It just
tells the user, that some workaround, which is not needed, has not
been activated.

-- Sebastian

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJS8tZoAAoJENju1/PIO/qa8d4P/Aoe227SzOt17In+sY1/dCLL
A+8u/krwEQ/yjiTl9p1+mLNGZ6p/xhvvXFspjDjF3fAIaTx/h+J74FimxM5PRD3q
oCsrz1HdSU92nD5+5h8V8NKD+7LXuf2R1pQ8inqpXRoUtEkSdUE3bFhMhBbdkrmv
Bi3wm3o+Qhh4rC8hWZkhGX98BBcSx5C8SI6yWDWBRCj6TkArvBy698SshsnIMlAc
vF8h9IIsIsyCcktWjKQ0O70sJ4amC1FUZTTFZaot7ANeze30e3vV3SNrPUgb9lDB
x5amu4YbOc95f0LNUDiWrYfg7mQQqJ/TlaNePxx6z3zRiBb22XcJ9g54C0tAnzgb
gV781vkS4K75p+ClJefBwXPTPSHWjEVhxCrkKeJAWedYwLLKhhIr4icMuE1K0G9D
xAs1MNdMVh7C9N4jVAdkkF1NNOOREkwYPuUxsmicemHaHlvIKvBcNeDoTIJcj0jJ
pvC9C24DFHBzAQSkEf709VhXqNwkXz2r/j9JeCMq6lXxwd+Y2vUfcOzTDGT/eYNa
ohbPXhg8gKfv42VonfjRXIK1GR6lP/yHBofN8zfM52m9MjOkDTvYq0lXFXJCCTjq
tYDgNBiSM3Xk0QbeJTj50H3OTYOIO51QiJ1HeH1kTVvYDpcoNmntJ3tFkvHGN0DT
Bh24nOqUyP/spcrDO0Ep
=h/SN
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
