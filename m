Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaBVHd7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 02:33:59 -0500
Received: from kolab.o2s.ch ([77.109.136.180]:44530 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaBVHd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 02:33:57 -0500
From: David =?ISO-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?ISO-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 8/8] ARM: sunxi: Add documentation for driver for SD/MMC hosts found on Allwinner sunxi SoCs
Date: Sat, 22 Feb 2014 08:32:03 +0100
Message-ID: <1559221.mEv19UvCzF@pagira.o2s.ch>
User-Agent: KMail/4.11.5 (Linux/3.11.10-7-desktop; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140218154212.GL3142@lukather>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch> <20140217100302.15040.56273.stgit@pagira.o2s.ch> <20140218154212.GL3142@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4305757.gxGONMhGcj"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4305757.gxGONMhGcj
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi

> Please use the real compatibles here. It's much easier to search
> for. Plus, your driver doesn't support all the SoCs you're mentionning here.
> [...]
> Please provide the real property name to use. No need for an example
> here, you have a full-fledged one in a few lines.
Fixed that.
> Ditto. Plus, this is not a mod0 clock.
Yes it is! But maybe the formulation hasn't been clear enough...
> You never talked about the clock-names property, and which clocks were
> supposed to be provided.
Yes I did? But I expanded the text a little bit further...
> > +	interrupts = <0 32 4>;
> > +	bus-width = <4>;
> And you never talked about bus-width either.
I can throw in a line for refering to the mmc slot gpio lib docs.
> Isn't the cd-gpios property requested too?
I can refer to the docs there as well if you like... :-)

cheers
david
--nextPart4305757.gxGONMhGcj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMIUncACgkQAeZw77btGjodSwCdEkcG+urkDQ/kg+g0djh46sfr
QJoAnjY2CuqBqJeFhfHYTwSgil3241U0
=lY4z
-----END PGP SIGNATURE-----

--nextPart4305757.gxGONMhGcj--

