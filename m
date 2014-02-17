Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaBQHKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 02:10:40 -0500
Received: from kolab.o2s.ch ([77.109.136.180]:58210 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaBQHKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 02:10:37 -0500
From: David =?ISO-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
To: linux-arm-kernel@lists.infradead.org
Cc: Priit Laes <plaes@plaes.org>, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Emilio =?ISO-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [linux-sunxi] [PATCH v6 4/8] ARM: sunxi: Add driver for SD/MMC hosts found on Allwinner sunxi SoCs
Date: Mon, 17 Feb 2014 08:08:57 +0100
Message-ID: <1744603.zMUgfmoUUP@pagira.o2s.ch>
User-Agent: KMail/4.11.5 (Linux/3.11.10-7-desktop; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392542548.11093.13.camel@chi.lan>
References: <20140216050933.728.25526.stgit@dizzy-6.o2s.ch> <20140216051133.728.36386.stgit@dizzy-6.o2s.ch> <1392542548.11093.13.camel@chi.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3048959.7lgtbpbIvE"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3048959.7lgtbpbIvE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi
> > + * Driver for sunxi SD/MMC host controllers
> > + * (C) Copyright 2014-2015 Reuuimlla Technology Co., Ltd.
> > + * (C) Copyright 2014-2015 Aaron Maoye <leafy.myeh@reuuimllatech.c=
om>
> > + * (C) Copyright 2014-2015 O2S GmbH <www.o2s.ch>
> > + * (C) Copyright 2014-2015 David Lanzend=F6rfer
> > <david.lanzendoerfer@o2s.ch>
> > + * (C) Copyright 2014-2015 Hans de Goede <hdegoede@redhat.com>
> ETIMETRAVEL
I'm not really into this licensing and copyright stuff.
Could you maybe point out what the correct copyright would be?

> __SUNXI_MMC_H__
Ok. Will fix that.

> Also, you may want to rename SDXC_RESPONSE_* to SDXC_RESP_*, which lo=
oks
> better next to the SDXC_DATA_* defines...
Ok. I will change that :-)

=2Ddavid
--nextPart3048959.7lgtbpbIvE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMBtYwACgkQAeZw77btGjrVnACeOesTow5MFwdxX5un5yfbGWoM
L+0AniCZ+X7GbUJ1GTZiT7O/hN4keCks
=ZcbZ
-----END PGP SIGNATURE-----

--nextPart3048959.7lgtbpbIvE--

