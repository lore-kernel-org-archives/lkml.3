Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3HWSRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:17:36 -0400
Received: from ring0.de ([91.143.88.219]:49898 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab3HWSRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:17:35 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Fri, 23 Aug 2013 20:17:26 +0200
From: Sebastian Reichel <sre@debian.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Subject: Re: [PATCH 2/3] ARM: OMAP2+: HSI: Introduce OMAP SSI driver
Message-ID: <20130823181726.GB5753@earth.universe>
Mail-Followup-To: Linus Walleij <linus.walleij@linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux-OMAP <linux-omap@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>
References: <1376237628-1077-1-git-send-email-sre@debian.org>
 <1376237877-1740-1-git-send-email-sre@debian.org>
 <1376237877-1740-2-git-send-email-sre@debian.org>
 <CACRpkdZpB0YjZzhOsyN9uNETQWJM=2N50eUBaxDF29jDw3ZJfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <CACRpkdZpB0YjZzhOsyN9uNETQWJM=2N50eUBaxDF29jDw3ZJfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 23, 2013 at 03:57:05PM +0200, Linus Walleij wrote:
> The HSI subsystem is lacking an active maintainer, interested?
> Given that you can apparently test the OMAP HSI driver you're
> one of the few applicable candidates.

I don't think I'm a good candidate for that. At least not yet. This
is my first patch sent to the kernel and I merly took the code from
Carlos Chinea and ported it to some new kernel frameworks. Apart
=66rom that I'm lacking any documentation for the interface (SSI is
not part of TI's public OMAP3 TRM).

> Overall there is one big problem with this patch in that it implements
> a lot of stuff that should not be implemented in the driver at all,
> but in the HSI core.

The actual implementation has not (yet?) been changed by me. It's
still the code as written by Carlos.

> For example compare commit
> ffbbdd21329f3e15eeca6df2d4bc11c04d9d91c0
> "spi: create a message queueing infrastructure"
>=20
> This patch basically seems to redo the mistake we did in
> SPI and not create a central message queue from day one,
> instead re-implementing the same code in each and every
> driver.
>=20
> Please attempt to draw the message queueuing into the
> driver core atlease.

I will have a look at it after conversion to DT. I will sent another
RFC before this change to speed up the DT review, though.

> Further the allocation of hosts seem pretty generic as well
> but I'm unsure about this. I'd prefer if you take a second
> look at the generalizeable parts.

OK.

> [...] (Code Comments)

Thanks for the review. The code has been written by Carlos, who
apparently had documentation for the SSI IP used in the OMAP3. I
cannot fix the magic numbers without either reverse engineering the
IP (which I do not have the time for) or access to the documentation.

I will fix the other comments in the next RFC patch.

-- Sebastian

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSF6c2AAoJENju1/PIO/qa4I0QAKQkXnJKN4C0+Qogh3luYXnz
E5glMVxX6mMUE5DGbR695Vrtp8NsR4Bop0RofaKhaj3QuohyghxwhBc6JH1oDyT0
rAVTJ1AX8BPOLcsQHuy6SiGh7wLOdoJsXUmzKgGGCwqxherjPWmm02u6T3DIHHz0
HPMTWD7PHOeVmeUulHOyKaD/fslzJ+/0dRn4U7qP6KnuRXS6TgoMjigN53ggq4c3
k1HuQEUK6geNLz8TekN6IOoJ0IzIbtklON7KOwDR8WuBFXOMYAapJJSXZRvhdFNa
CU1EtSO85+6DhGJPeZWuTq7SnzGmfBIlOvcu+xgBjhuIuHh2SE5AwQ5DrGKs+yHL
CygfZnSZAlc0EiZdfaq7FdVYFsJE23opYaAChs6bcvXn9dhUzFSbOq6P9XtcRFLT
4Ehklua6wvU6a9H+yABF8peliCmhtbQctIy88wQBuYgZxUrEKK1G+ni+21L/moTk
5i/axToVOeW14+CFj933iUlXIWTKBre6UVtp52Xs0NbbQ25c82mePxBfDIcJ0KD2
JRNQFdsEO0s86dJu7TcqL7fe4ccuHBcfpF03jkaKlLle66vTURaTessyzd8PUN17
EJA9+kU2K9wgLXlha2b0ESDJXw+vjxIc1V7oiYIGbC0oT602zgf0A4jr2e0hsK1y
atsTvtzpLcSTORUuDWmO
=5P5n
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
