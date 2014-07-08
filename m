Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaGHMeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:34:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52716 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbaGHMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:34:36 -0400
Date: Tue, 8 Jul 2014 13:53:26 +0200
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Message-ID: <20140708115326.GU30458@sirena.org.uk>
References: <1404215726-2480-1-git-send-email-broonie@kernel.org>
 <20140701120622.GJ32514@n2100.arm.linux.org.uk>
 <20140701121142.GM23300@sirena.org.uk>
 <CAAVeFuJqRW0ih8Mg9MFwLf=wQ7eVK5+pm8deW0vTUdozJ16FfQ@mail.gmail.com>
 <20140701122717.GN23300@sirena.org.uk>
 <CACRpkdZ7ai0AShAen=AkaorHt0ObhYCDC-OuHG-9nVb3LLt3KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kVhvBuyIzNBvw9vr"
Content-Disposition: inline
In-Reply-To: <CACRpkdZ7ai0AShAen=AkaorHt0ObhYCDC-OuHG-9nVb3LLt3KQ@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Still free GPIOs using gpio_free()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kVhvBuyIzNBvw9vr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2014 at 10:33:23AM +0200, Linus Walleij wrote:
> On Tue, Jul 1, 2014 at 2:27 PM, Mark Brown <broonie@kernel.org> wrote:

> > Right, but Linus said we didn't need this conversion to descriptors so
> > I'm a bit confused as to what the issue he was raising was.

> Now I'm probably confusing myself...

> All drivers should as far as possible use descriptors internally, doing
> things like gpio_to_desc() only for backward-compatibility where
> necessary, with the intent of eventually ridding the integer interfaces
> entirely.

> It may be an eternal project, but hey, we are atleast two of us
> pursuing it.

OK, so in that case Russell's code should be fine then and we don't need
to do anything - great!

--kVhvBuyIzNBvw9vr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTu9utAAoJELSic+t+oim9XWwP/27bSwFcDqn7YiNwMotXopdI
PQOsUyLI+5zedG6djkj3EY5X2Hj0Si7LEMY79pgwB8Zs/JCcN5zZUeMNZr9CZlxW
j/c2lMvkxqim6HDI+NkGxGXjOILgECM+Rn3itkgSL83rf/u6rWjDI9qlIHtGgjJ/
I58GcnDGXhzOfLezFpeygq8LCQQ6TjkDjEuQxTOqSnJDGnjn9o2t8KzEZvtJ9l/y
NKXuh5uMCm7OHO0tHwNF1bBju351spX8Vjr+RAPMwW5HjDRQxy409AYDxnMfts4q
HbsErtPzaftF8iXSBTHm0HMiUXgFSYOrZ43GGZsePhTFkHJRLoOksD/HxCYFLW4f
iKszM46HTG0ppGZ3ahIWVFvbUxLXvaiViWyygGxpIxtE/m2QeVSGf+NktcJpDlHc
VF9UYi5Qnm+PO4K7u0pSRxncGoxiLtPBgXypYj6gbXqrO/S9J/85FogT6L1fFXKT
4g4VpBQczF6L6NKOWP6HOzSB2RyRaVJFMXJHZZ9vkF5J+jxw3Q8QjyNQucldzSO2
lZX5InnBpCJoXrXZ+MlA9liCLn8MjBXcoPovGZcQJKeFKPhPDJryIdea7aQbWSZu
Jrz0nZesOZocXe4y4R38U3Tl/0Ofzr4jpUvc8A8vpeq5Lp5hRi8axxSXczlIOBCd
wAZ6cUiA00HiEXsFS3ZP
=0s6J
-----END PGP SIGNATURE-----

--kVhvBuyIzNBvw9vr--
