Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaFLMSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:18:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38431 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbaFLMSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:18:35 -0400
Date: Thu, 12 Jun 2014 13:18:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Message-ID: <20140612121806.GY5099@sirena.org.uk>
References: <20140607090944.GL23430@n2100.arm.linux.org.uk>
 <20140612094745.GD23430@n2100.arm.linux.org.uk>
 <6077426.uLBS643pC0@wuerfel>
 <20140612113445.GF23430@n2100.arm.linux.org.uk>
 <CAMuHMdV0F_FhtJwrzJLbxTbQPKs1XzR=Yb0wjMw2TBuXNPObpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lxgQg5DpJZV+j+ev"
Content-Disposition: inline
In-Reply-To: <CAMuHMdV0F_FhtJwrzJLbxTbQPKs1XzR=Yb0wjMw2TBuXNPObpA@mail.gmail.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Kconfig fails: big select-based circular dependency
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lxgQg5DpJZV+j+ev
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 12, 2014 at 01:57:03PM +0200, Geert Uytterhoeven wrote:

> Should we have a better separation between select and depends, i.e.
> should kconf plainly reject both being used on the same symbol?

> Is it ever valid to have a symbol that's both selected and used with depends on?

Architecture feature Kconfig symbols typically have the pattern that the
architecture selects ARCH_HAS_FOO and then code that needs the feature
depends on ARCH_HAS_FOO.

--lxgQg5DpJZV+j+ev
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTmZp7AAoJELSic+t+oim9/TAP+gIb+B3CaD44cjGw16dx76io
66Kcr41dbeUno94O1bXF1zozsw4zI+/v7RcBYb6QPgl6DITrT5Ts2b9+Dr0Ixlxd
VE7gOKWL1cdaIrJEHtIVO3ApbMi0YOcbl3dbJITs4Cs5yI/68EYRYofvuCYpnhx8
X5T+uIijJsw5sTvad8+C0F3vk/nhcaDNOVSj0UKkBUJdhANwBkC5yVRRVQGWC+s+
RxbbTSwOmXIacsJh3k2rpTS6DclDsoCwTZDfxyywcsFKwd6gPY+clEN/66ABlg6L
ENQbuSNgFlMS1KBmFZ/m1zYTI6yn4Wfw/Q63+TVKXr8MlJqRJGAm0n+OotEpv2J0
eQXGN+Y4NBiDXnuWk8y4n4ns9Z32BUwlROh3pq1/HhZxAt2+sm5wsSeuLSGJisue
L5jJJlrrItSONyvlpBMyC5ug0o9bVPVNmil4rZFIeX8od5QYobeUtLt9+p4ae7Cg
S1OQK4q/c9fng5fOPW1HkRaNAR4gdv/hEojuwQnoTzUzs1HbMfbW2qGcfW5mBgzv
3Y0Ygz/qUWXdh15dqlccdpi7vTw1qHlMk4YLekrYrf764L3E4pmi2QxPT4Mc6Y0y
mDkvmeTs0MmurjJzWUbyjdjAfkXjGNpxlc3BopGLc4B3Y/8hgIOAz5oK6yB/W9Bx
7MMlmcR/Ros1dO/QULSn
=IO55
-----END PGP SIGNATURE-----

--lxgQg5DpJZV+j+ev--
