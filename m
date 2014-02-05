Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaBERSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:18:06 -0500
Received: from kolab.o2s.ch ([77.109.136.180]:36061 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbaBERSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:18:02 -0500
From: David =?ISO-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
To: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?ISO-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 0/7] ARM: sunxi: Add driver for SD/MMC hosts found on allwinner sunxi SOCs
Date: Wed, 05 Feb 2014 18:17:46 +0100
Message-ID: <2733138.OsaPkZKnhk@dizzy-6.o2s.ch>
Organization: O2S GmbH
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20140205134741.3027.50207.stgit@dizzy-6.o2s.ch>
References: <20140205134741.3027.50207.stgit@dizzy-6.o2s.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1438517.AOmo1C3tjv"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1438517.AOmo1C3tjv
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

As Maxime has pointed out, I've forgotten to add a changelog
in my coverletter.
Here is, what has changed in this revision:

Changes since v1:
=2DUsing mmc_of_parse instead of diy dt parsing
=2DAdding nodes for all mmc controller to the dtsi files, including sofar=
 unused
  controllers
=2DUsing generic GPIO slot library
=2DAdding additional MMC device nodes into DTSI files

Changes since v2:
=2DAdd missing Signed-off-by tags
=2DStop using __raw_readl / __raw_writel so that barriers are properly us=
ed
=2DAdding missing new lines
=2DAdding missing patch for automatic reparenting of clocks

cheers
david
--nextPart1438517.AOmo1C3tjv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlLycj0ACgkQAeZw77btGjq4IgCfVDzZHDDb0w0JZ2ZrHfngQxay
Ed4AoLAsD7YPn2Biiwrp3lrn7zgmkaZG
=2Ypc
-----END PGP SIGNATURE-----

--nextPart1438517.AOmo1C3tjv--

