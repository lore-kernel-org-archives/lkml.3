Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3ITTdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:33:05 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:52199 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab3ITTdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:33:01 -0400
Date: Fri, 20 Sep 2013 21:32:56 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RFC 0/5] New descriptor-based GPIO interface
Message-ID: <20130920193254.GA19130@mithrandir>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
 <CACRpkdYjkDf7c9VxfDTHtFx_upWWRAK8vpXTkrkrRsMjErq1dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <CACRpkdYjkDf7c9VxfDTHtFx_upWWRAK8vpXTkrkrRsMjErq1dQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2013 at 08:06:00PM +0200, Linus Walleij wrote:
> On Wed, Sep 4, 2013 at 1:29 PM, Alexandre Courbot <acourbot@nvidia.com> w=
rote:
>=20
> > Here is a first RFC for the new GPIO interface.
>=20
> I'm quite happy with this, and given that all DT-implementations will sta=
rt
> to use it from day 1 I'll happily merge it when you think it's tested eno=
ugh.
>=20
> On my wishlist is to also switch over the ACPI GPIO driver:
> drivers/gpio/gpiolib-acpi.c to use the descriptors directly, so
> I'd like one of the ACPI folks to have a look at this patch set
> and see how it looks from their angle.
>=20
> Mika, Rafael, Mathias, and either of you guys have a look
> at this?

Given that it seems like there won't be a linux-next from September 28
until close to the next merge window, it would be good to get this into
linux-next before that so that the series can receive broader testing. I
have some patches that could use this, but I'm hesitant to base them on
these patches because I want at least part of them to go into 3.13.

Thierry

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSPKLmAAoJEN0jrNd/PrOheNAP/1mGJ+f6aaJ/NbnUfeMRlB97
PBWv+0o90GDy+2Q4pgIRLvGYfr/FC6AWHPvy/8A3eksu/AxwmidColMqKfS8K/3n
vigBR9chWPdWQiA3DSqNDAglp2RNm0fGp5yIt06yRRyUYcTug04nET7iWvwJCbZ3
e71QfNmcFEsVdN590951JMZswS1ELBzPF+/KWMjXLkR2cqzJ6uGhjoijFXSGjhIV
/HXo3MC4N5mxRp4ZJLj2x2ABl1Fi+BFGkDeN9LLOmI4KzWK8TGcG44AM65hPkPv2
57gO6+STphUBF7kNSIeiuOOSLbERlPLOAhQAqDWzqhKdoMsWlYmDA4VSegi7LDZL
yjrvIy41x39Gga/Bh3+rp87eaQCBIRdw68q6i5EfFHgbYreE2pWt8cfQ6FPBheeV
0cBZJmJIed1yizv425GaVDaNvAiy58yc7Pic3oiU3ZmisPixe4Jl/OqgzdhPBawO
X7LQVimNyFSf1zWVdb+IwyVJi1doyNQZWQ2KgeAUXzlOitdfDQA8rdRo17P364ZB
/yfX7AHSzWZNxpQwo3PDiIfPFtZRg9tPSiUMSXju7BZeEtUO8sAKAKRLy+Ku/wIY
/9Q0jULABqY+A1ZgVKqoW/FDI9Bk6M1+LH/MfWdKImYGjs/zEHlKQy1WML4MIiUR
58IJpQ7eTHxCfq9J0Q/O
=HeqZ
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
