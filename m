Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536Ab3GaPt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:49:59 -0400
Received: from up.free-electrons.com ([94.23.35.102]:48489 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760451Ab3GaPt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:49:58 -0400
Date: Wed, 31 Jul 2013 17:49:53 +0200
From: "maxime.ripard" <maxime.ripard@free-electrons.com>
To: "kevin.z.m" <kevin.z.m.zh@gmail.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        =?utf-8?B?5a2Z5b2m6YKm?= <sunny@allwinnertech.com>,
        =?utf-8?B?5ZC05Lmm6ICV?= <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH 4/4] ARM: sun6i: Enable clock support in the DTSI
Message-ID: <20130731154953.GG2911@lukather>
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375195462-19566-5-git-send-email-maxime.ripard@free-electrons.com>
 <51F86A2E.10505@elopez.com.ar>
 <20130731073724.GA24439@lukather>
 <2013073116110750016327@gmail.com>
 <20130731114957.GD2911@lukather>
 <2013073120102496855035@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ijf6z65S790CMqo8"
Content-Disposition: inline
In-Reply-To: <2013073120102496855035@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ijf6z65S790CMqo8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



On Wed, Jul 31, 2013 at 08:10:32PM +0800, kevin.z.m wrote:
> > How does one select either the internal or the external 32kHz
> > oscillator? Is this done in software (I can't find any reference to that
> > in the user manuals) or in hardware?
> For A20, it should be in the Timer module, and there is a register named =
"LOSC_CTRL_REG".
> For A31, it is in the RTC module, same name of "LOSC_CTRL_REG".

Ok, just so that we're on the same page, we have two oscillators running
at 32kHz, the internal being always there, and the external that could
or could not be there, and it's each different hardware block that can
be wired to one, the other or both?

There's no global mux that could use either one of the two 32k to
provide the only 32kHz source in the system, right?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ijf6z65S790CMqo8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+TIhAAoJEBx+YmzsjxAgl9kP/2rdk4RofktvLbLY8IluAE/h
y0UCLnYqaJMjgiFqj8Bj5o9GBlgTAT5lGeMmKCIrDlz3VKi2SGBJgrfdQ3uwypvw
OVGwUk1LpkfKSBPMnxwF2FY6RPXYNuJc3rnilD2eV1FW2E7e8O6yNrI9Qr7Rii8s
RFbt3YJ8u7RhY2GH1Zw804wUkTQXTwIQGINjgDdo9gnUxxzN1aOHPTmRVtKTK75X
h0cV/8FOKjXjXGWEFYcJLZzBWMRkjMOQUsY/lZNwV0coElFxkDrrC1B4lC1GQwBS
hefJBQNOxB5FNHSgl2TnrISpagT29AFKXiz3JOwwyHx10hIHhvHvhQpbqLC90YMe
xOm+4CPGWHM5AOabaHKwZFrvciPjAlBKSTC6csicQDsiB3IsHj/6L4GR4i/0JN8p
EyL2hrxSokbuwkG49c2T5lMzlMTCt1cv+D0vRHKCBs0YdlbEYGyNqAURhz5IyARF
Nd7Xiw23mYwzqFsZjXTVSaCZbfMrVILlgGeWzXgfp2HcU42tMSjo6/Yhpa5RFPyL
Y9XjaGiIbFHGw+CePWqr0huIYwnPa8OAMaOnydCk1FKrPpNCAfw6plBMxKlBR6X4
M5h+/gGR3Dlr4nlEYZZwB0FIVEMI5Bjxwtbn1/mXFecBzc5rxaWJTM1xcZdz4jlQ
lOoybXDkTWbF0ajE/5Xf
=kvM4
-----END PGP SIGNATURE-----

--ijf6z65S790CMqo8--
