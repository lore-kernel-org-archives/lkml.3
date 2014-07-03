Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbaGCQG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:06:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:40875 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938AbaGCQG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:06:27 -0400
Date: Thu, 3 Jul 2014 18:06:23 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Robert Nelson <robertcnelson@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140703160622.GE23309@earth.universe>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
 <20140702160932.GF5541@saruman.home>
 <20140702190944.GA567@drone.musicnaut.iki.fi>
 <CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
 <20140703073411.GX28884@atomide.com>
 <20140703132509.GA5814@saruman.home>
 <CAOCHtYi0JwRO12gHa+KFGH1k7pPk4TL40igwhzRRxutw-tqf6A@mail.gmail.com>
 <20140703140736.GF5814@saruman.home>
 <20140703154425.GC23309@earth.universe>
 <20140703155240.GU5814@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ILuaRSyQpoVaJ1HG"
Content-Disposition: inline
In-Reply-To: <20140703155240.GU5814@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ILuaRSyQpoVaJ1HG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 03, 2014 at 10:52:40AM -0500, Felipe Balbi wrote:
> > DT is supposed to contain information about the hardware, so it
> > should stay the same? I think there is no non-hackish way to decide
>=20
> compatible would change, at a minimum.

why? I would expect it to stay the same (and the current patch uses
the same compatible strings).

-- Sebastian

--ILuaRSyQpoVaJ1HG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTtX9+AAoJENju1/PIO/qaAqQP/i6wmAtD3GC+2ckRvfcMAH7Q
odnga9BbrwqiLboinx1R0R9VW4KbcmLIMzyqGwKPn0Q4satEbYiYDYO5Tp4+fB7w
W7ejJdePM74SnvoI/WBTc5xN5aXoT5lmF96bE+vS6ljc7upKUrSn43oovjeg0IZG
gcPrcfdMBG55CaqK+JHNRUhucp8+Q3bk7OShFMVAl+tuaTaBif4XevIuzJhzhHmf
CBROfGzAVC2KjFQcgAHokmMbWNitIOO3TfLqEsrWHl/PQWP86YucLHqPEDwjFE4k
7A99jQe3/7Tq/YyjpnAwbeCAZRoRAARweiNrWq+MlT38mNWuEryyKkouU86eMe0a
T8jNCTITuNqCRF71GH80TtIvRndhoa9BzdRCgMnoPI75I6mPPcTRZq1zfG1bX2ZT
X/MoCKLJaCdyHCwsWHulKURu6vh5x72yk4/iz0yqGK/+YjwiBDVFMM3/K0c/bQWw
ZD+yoIskgf4MukHIcgrfdWfeJPJofJq2+vYCv/Jrw54Ewl8it/6RkycjEimICqgz
eLMXSZHEMSgrwklJj1pVzUMy4CS7LPR0Ogy45WDJVpomy3KNAv8169fhvmL8ZKHj
o5Oj2xFjDMG10GBTFWY4QRafVrIk0k/U/GJ4MyooEzuoA0f3COmou9zuXRBg3WZ6
CIdFZXM2ALsytfFSywvA
=5HEn
-----END PGP SIGNATURE-----

--ILuaRSyQpoVaJ1HG--
