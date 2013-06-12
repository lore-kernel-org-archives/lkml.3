Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab3FLPsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:48:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39622 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3FLPsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:48:30 -0400
Date: Wed, 12 Jun 2013 16:47:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Illia Smyrnov <illia.smyrnov@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-omap@vger.kernel.org
Message-ID: <20130612154755.GJ1403@sirena.org.uk>
References: <1370970556-11713-1-git-send-email-illia.smyrnov@ti.com>
 <1370970556-11713-3-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K511Q2pAJ3dpTMb/"
Content-Disposition: inline
In-Reply-To: <1370970556-11713-3-git-send-email-illia.smyrnov@ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] spi: omap2-mcspi: Add FIFO buffer support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K511Q2pAJ3dpTMb/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 11, 2013 at 08:09:15PM +0300, Illia Smyrnov wrote:
> The MCSPI controller has a built-in FIFO buffer to unload the DMA or interrupt
> handler and improve data throughput. This patch adds FIFO buffer support for SPI
> transfers in DMA mode.

> The FIFO could be enabled for SPI module by setting up the "ti,spi-fifo-enabled"
> configuration parameter in DT.
> If FIFO enabled, the largest possible FIFO buffer size will be calculated and
> setup for each SPI transfer. Even if the FIFO is enabled in DT, it won't be used
> for the SPI transfers when: calculated FIFO buffer size is less then 2 bytes or
> the FIFO buffer size isn't multiple of the SPI word length.

Why is the default to disable the FIFO?

--K511Q2pAJ3dpTMb/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuJgoAAoJELSic+t+oim9pRkP/2I71IggOYucK0rAHt0i0XUx
kDLv2kkdn7D8LJCWLTvMvIwaUDtL7/Xz6BTDnK88YUmmbeBMNxhRksFPg2Mto6+u
QK2qlQEwErIK7JPonWEq3Chr9iRaeCx1IHGFFE5RzYkI5RZtVrnHfQNtW8pfWj1Q
xGj77W+2Nvm+C5XWTWwXjQEdQ3cgAu7Xeumolsv9Kari8CqbFAxNI3ly42wN3rR7
8fjYpL4t2YtQBYveSy4DH9GppRyJf+ngAqv9Aqg6UoCgnEuxc0NEEJbuRwjqM6hM
DtLxDWrAcElZxxCW4XV93G0pMcX3P2NCcUoTH75FW4Z7hHFKS4Zg86i7L0/++tg+
YDLa1GKofUgWBcFUpHsz8/Pt0azdzkJpyPbuZuMSErxZaUHavXZ5wf13Uznqtiyg
9oiXM8tyAUELJTHOWaVnlvYSTuQ424gD9PCjYEQIDUlnMwwSbagxemCLYskNcsxy
zHv9SHWZn9B6itSNzFn9+21n/cjmFYWObUy4PoGlctvGOs5xWmkxE/KzB7UmbqQQ
RWb6MdRvbQkAuBiKgfd5vwXpTYdoaeIq1buP40vRLXEvTQxpSYrITBhIL359J9o2
6bxtxqAGDU6HURkL0pTIfSmYRUXHjhlUQIpslaVusqSJXXOAcKy1phJQr8r8DaQ6
C6xtBg4SLHzz3SOfdgBJ
=F1IR
-----END PGP SIGNATURE-----

--K511Q2pAJ3dpTMb/--
