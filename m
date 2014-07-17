Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbaGQLbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:31:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41759 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbaGQLbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:31:53 -0400
Date: Thu, 17 Jul 2014 12:31:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Larsson <andreas@gaisler.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Kumar Gala <galak@kernel.crashing.org>
Message-ID: <20140717113129.GU17528@sirena.org.uk>
References: <53C79351.2080406@denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0WzQiIesntPPsVaS"
Content-Disposition: inline
In-Reply-To: <53C79351.2080406@denx.de>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: spi, spi_fsl-spi.c not working?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0WzQiIesntPPsVaS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 17, 2014 at 11:11:45AM +0200, Heiko Schocher wrote:

> Is it maybe the missing "support for the SPI subsystem's queue SPI messages"?

It shouldn't be that, that's still optional (sadly).

--0WzQiIesntPPsVaS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTx7QOAAoJELSic+t+oim9ZaUP/RVeH0pegoL7anagNM4PjTXo
RZEs6JTQRC4wm2aj7kewmwGTGvNTwOKBPKVDVGeKNuDokwoSTIVIBbyL3UeexRmA
0yiMwQ7lWPKqZtx/d+DOxXC/zY4P3D+0o+kqJ1Gh4ulAqc95kN9U2R3/kLqE2by3
P9PEeqqFBvd05NfOhjIDbC04Up53njdbFUStzXbGE/voOTWQf32j1TLziKZslb4p
Tr1YIMfJTX4tNTWMB+MUZyNxhg6ogcU9ENIEZBhiZNvGapzY5DclfRglb3lOwrzK
J75JxyxXIGTAbjzBmjYUAgL2rGwb73FVf3HgkRPxva5LrEtoBgKNtKU4k9GEqIw4
y7MvZ4Eps1CYkxTOMlWPxPvMapInhFAA7i6//ok4ZDp4JEdx+sEtsMfqg1xoNMNo
HyMX7D/KG6J36UV2K+VM8LteSo433alW9H4rfKBWB5fCAzK8aIpVfgsLThxwqG+3
e/VG4bbJ2cPNlHS4mUBZokiFS8UNnQ7X/E5fyDYfPsPK1eOm+cUevLjD6l8Qwaov
4TO9iD37SFdJINgrQiVnLAQAOx2nS9qUBK0+szzSXrMQzGglnF64qBblS03zP7ds
SnG72+WcMa38nA35UdDh0KlNdPTDHpJKTL1OsgBFrFm1HamYajailj3yQHFqO2A4
oJw5Y/BokJC3BnUV+r3u
=1jxs
-----END PGP SIGNATURE-----

--0WzQiIesntPPsVaS--
