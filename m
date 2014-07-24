Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbaGXMQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:16:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47863 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751833AbaGXMQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:16:15 -0400
Date: Thu, 24 Jul 2014 14:13:15 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, Arnd Bergmann <arnd@arndb.de>,
        andriy.shevchenko@intel.com, dmaengine@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v11 0/2] Add support for the Allwinner A31 DMA Controller
Message-ID: <20140724121315.GV20328@lukather>
References: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e1+sTVyxRliB/aPL"
Content-Disposition: inline
In-Reply-To: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e1+sTVyxRliB/aPL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Vinod, Dan,

On Thu, Jul 17, 2014 at 09:46:14PM +0200, Maxime Ripard wrote:
> Hi,
>=20
> This patchset adds support for the DMA controller found in the
> Allwinner A31 and A23 SoCs.
>=20
> This has been tested using the newly introduced SPI driver on an A31
> EVK. Support for DMA-driven SPI transfers will be the subject of
> another patch serie.
>=20
> This has been around for around 5 monthes now, and didn't get any
> review but nitpicks for three versions, so I feel like it could be
> merged quite quickly.

Ok, so, who should I bribe to get this merged?

The first version was posted on the 2/24, we're at v11 already, and I
only got a single mail from either one of you.

Don't get me wrong, I'd be ok to make any change you deemed necessary,
but in order to do so, I at least have to get a sign of life from you,
and so far, you've both always been MIA.

We're pretty much in the same situation for the other DMA driver
Emilio has been sending for over a month now, that he is doing as part
as a GSoC for the Linux Foundation, with not a single maintainer
review so far.

I'm getting quite tired of this honestly, and I'm not sure it sends
the right message to the hobbyists and companies that try to get
things right by contributing.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--e1+sTVyxRliB/aPL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT0PhbAAoJEBx+YmzsjxAgVuUQAJBTrWfn5t0/vmqwpa28ftHJ
0D0mxEmS3ZwKlb6SW5SdZ5utL8gU7JaZ84SdRF6yKwU5QW2lN/xVucv1ZLE5RtSr
iHURIc9tW8y/8HBnRQzyZyF8bxB1CrUDJtBztGWk9JqeY1Cr94nD6BO+TtCqZbyU
jMMt40SauKEr35KN0fxz/23OXo3FOmMrLU8+SM4rydNF54Eyw9rIc43r6/zd0/n7
rRCh2FyT8O0hG/aGLTAuKC0kUC1isznwoRjtg/7Y+9l7xyEqxXO5JhladAE98oKj
wVekKGSPp1U4U5rjsAIrlae947Sjl6qSrCC5IF0R3LCD+p6AKqsPPj4skfemnOZ3
n4PPEj2vqHHr2kGvfyzvszZMvOWHT7nw7Sd07p5DVs2HCrjSj957qfsHjACfEaCE
1X96fn4fi/NZNXz48aYUMHX92bU11VNHNUyRXrSzIpxziY5faAv/VtTsqwlgD6CI
JK04j3W2OmrIA/7PS1x8WU5vEbyZv2iPj/nwBtAFt9TS+fJT/PnCbGw3P4y3VJyB
d8jya7PfTdCLVWYFOjpcnkXx7DONbBAZjz8Sny/7lp9wpIvmu8JU8ajWm7q19+E+
maWetFV7VZUJRVMk1GyHrO+u79DDkFz1jlgPpr+mQjBOBysgo2yPNYS907esZSA7
fA+F8Lg68dZ+/ZRlQoeO
=gpuN
-----END PGP SIGNATURE-----

--e1+sTVyxRliB/aPL--
