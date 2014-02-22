Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaBVIkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 03:40:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:41900 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbaBVIkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 03:40:02 -0500
Date: Sat, 22 Feb 2014 09:37:18 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: David =?iso-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 8/8] ARM: sunxi: Add documentation for driver for
 SD/MMC hosts found on Allwinner sunxi SoCs
Message-ID: <20140222083718.GI3931@lukather>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
 <20140217100302.15040.56273.stgit@pagira.o2s.ch>
 <20140218154212.GL3142@lukather>
 <1559221.mEv19UvCzF@pagira.o2s.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g3RkK9jYN81zD2N+"
Content-Disposition: inline
In-Reply-To: <1559221.mEv19UvCzF@pagira.o2s.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g3RkK9jYN81zD2N+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Sat, Feb 22, 2014 at 08:32:03AM +0100, David Lanzend=F6rfer wrote:
> > Ditto. Plus, this is not a mod0 clock.
> Yes it is! But maybe the formulation hasn't been clear enough...

Technically, it's not, it has this phase controls features a mod0
clock doesn't have.

> > You never talked about the clock-names property, and which clocks
> > were supposed to be provided.
>
> Yes I did? But I expanded the text a little bit further...

I can't see any reference to the fact that clock-names should be set,
and what values should it hold.

Something like that:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Docume=
ntation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt#n11

> > > +	interrupts =3D <0 32 4>;
> > > +	bus-width =3D <4>;
> > And you never talked about bus-width either.
> I can throw in a line for refering to the mmc slot gpio lib docs.

Yes, that would be great :)

> > Isn't the cd-gpios property requested too?
> I can refer to the docs there as well if you like... :-)

That would be great too :)

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--g3RkK9jYN81zD2N+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTCGG+AAoJEBx+YmzsjxAg2PMP/3N76bxfD58hjd2LTrRw9Wp1
LG/yClUN9Uv3nAP5zIVzFWOwK5XQVqNgCrq7PLGMxwjkNVRhX3Vrq7K/ixHbvz92
HM4ivGapOLN+payQNU70TyZ7oviRc69f2klXKt9f4bbW9L2t4TxTAS/wAVd+yshh
jeDqHIbtCLHN3fT0Pm8b+jQmmBMnUkaU4h3lU2S3nw5rKbuFJRVjr9GpQeAVYuuX
/tcgWTx+05Yol9UmfFBt4zvQUALTFxyvmTC5zTeaAiw+4rRQu2XRtLDK/WdVKLLO
KxR843Z9FrDRbvATl/7IBlMZruISnbxzvs8n51ccot1rptoehSKHRt19SsZBv7wg
yjD3kNsZopQy/DpX6D/oEtbXLFO8YpbfJuP+sVXPrIs22F2G3T0+85CE3aanmfaZ
BVZwOye2rAOVvuXvtsWIlyN+MwHOZfRWhr5jj6bnelZTOE8gpVFZ40pDqnU6aOLB
lj0mxWoQbOzwt8dcmDUjCMMNjLHu/IlyLN4KQ3QDcCOh8rfbtdxJXINaJ4WJ+aGg
Q3mq6uHOq8D0qYNi5BAFXzdbqWuY3aaQtIrLWSibHR9Q9yfQiSsBAzQfkbH40J5x
M8p9yILN/FK5QbvoGnWkzjWNTAGVkHbf8KJwaxY7d9q4RDe9iTP1BFOCb5u3UPDK
gT6OfvaXESZ82nANHK1u
=a/tj
-----END PGP SIGNATURE-----

--g3RkK9jYN81zD2N+--
