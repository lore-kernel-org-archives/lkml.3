Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbaBDTha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:37:30 -0500
Received: from kolab.o2s.ch ([77.109.136.180]:58624 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbaBDTh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:37:27 -0500
From: David =?ISO-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
To: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 0/6] ARM: sunxi: Add driver for SD/MMC hosts found on allwinner sunxi SOCs
Date: Tue, 04 Feb 2014 20:37 +0100
Message-ID: <2036604.9RXHkpag8W@dizzy-6.o2s.ch>
Organization: O2S GmbH
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20140204191648.29809.14611.stgit@dizzy-6.o2s.ch>
References: <20140204191648.29809.14611.stgit@dizzy-6.o2s.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6914529.0bO68eztNJ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart6914529.0bO68eztNJ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi
I forgot to mention that the autoparenting patch of Emilios is a crucial 
depency...
http://git.o2s.ch/?p=linux-next.git;a=commit;h=f8e936772672a3a6ec934558d2a7aef030c663c4
Without it, the clock will return the wrong value and the card will refuse to 
initialize

regards
david
--nextPart6914529.0bO68eztNJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlLxQWsACgkQAeZw77btGjr+cACcCPHTHkFKjxLx6RD34E+MMR1r
tAYAoKen1mYCa5cG4CtyTHLjNO657oN6
=qtJ2
-----END PGP SIGNATURE-----

--nextPart6914529.0bO68eztNJ--

