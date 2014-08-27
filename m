Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935763AbaH0Srr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:47:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36450 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933833AbaH0Srq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:47:46 -0400
Date: Wed, 27 Aug 2014 19:47:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org
Message-ID: <20140827184732.GP17528@sirena.org.uk>
References: <1409160402-30783-1-git-send-email-broonie@kernel.org>
 <alpine.DEB.2.10.1408272043100.3323@nanos>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ladI0+Q3TRASfl2l"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1408272043100.3323@nanos>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] irq: Export handle_fasteoi_irq() to modules
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ladI0+Q3TRASfl2l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2014 at 08:44:09PM +0200, Thomas Gleixner wrote:
> On Wed, 27 Aug 2014, Mark Brown wrote:

> > Currently handle_fasteoi_irq() is not exported which is causing build
> > failures in -next for ARM allmodconfig due to gpio-zynq using it. Since
> > it seems like a reasonable thing to use from a driver add an export for
> > the function.

> The export is already pending in tip/irq/urgent and scheduled for
> Linus tree.

OK, thanks - it's not showing up in -next yet for some reason.

--ladI0+Q3TRASfl2l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/ifBAAoJELSic+t+oim9h+0P/3L5fFm7sUsqJfKxZZgrhZau
1B94aMz2wpnATEHiCv6XQCifaLiyDFDJsDnfBsEmzh2JNdyPmhR/TWc+mu5VrGgj
AdlGdjpXcWZIj4f8OEKWkINjnsLEI0GE3v52rn3cuAZACtEX4kzct84wCe3qIvcy
CZ6s0/d91/PJyGRDapuf0pldzwgTUlOG/HK6A/Iibs6jvXGvkU8mA1OOt/qmaTr3
dwNYxCUY2MjJS5fuBYjAcz4VaXTfL9dU+bULfBsKAK5CCV7/HGNKfF6XdSfSj35E
5XcXlbjCNoTf07SRC9LxXZu/+2ocEAHYvqbNl2wd/NfTZB3Vzp8C0VLsXlcfRw6L
8JBxNMmrdvkgs/nnNEP7CNYl5jBqvpMzxEfodTOENKdcpJd8WAyWi2loUEZuWkYl
PELn8kCR91fCXodhNcv75BisQJziA3ZdzCEnlPsSj2a2qM6atqkFWDVIM7lCYEo/
Ti3XHEW65IHKMnIYNtQt7sSaXtxnWFpyVJinRM30iaw/XVpfDm4EuuTsUuZNlctN
apSxvD8vFvN/UryJiBS0wphf74EInojup40Jom/prLnQ/MoxvjFeWHJHkfTtaJV0
bw4X4hY6FaNPhb+RIX6gIlf8GzQu6Et0qh+gMWIIJs1mKPzv34Q7TD9jro+ktTCp
jDkxT6Nw0tuyhKKaOyqR
=UHoO
-----END PGP SIGNATURE-----

--ladI0+Q3TRASfl2l--
