Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3FRI6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:58:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38157 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3FRI6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:58:36 -0400
Date: Tue, 18 Jun 2013 09:58:25 +0100
From: Mark Brown <broonie@kernel.org>
To: "J, KEERTHY" <j-keerthy@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Message-ID: <20130618085825.GL1403@sirena.org.uk>
References: <1371470954-9124-1-git-send-email-j-keerthy@ti.com>
 <1371470954-9124-2-git-send-email-j-keerthy@ti.com>
 <20130617161615.GH1403@sirena.org.uk>
 <DC88CAD03C0052499C1907B327FC63229EC277@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rRbIS5PUI9wLpAeF"
Content-Disposition: inline
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229EC277@DBDE04.ent.ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] MFD: Palmas: Add Interrupt feature
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rRbIS5PUI9wLpAeF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 05:15:03AM +0000, J, KEERTHY wrote:

> I understand your point. The IRQ is passed from device tree node.
> Say if the chip for some reason is not connected to any valid
> IRQ line the driver might end up requesting for a wrong IRQ line.

> So should I be validating the irq entry populated from  device tree?

Yes, you should be checking that there's actually an interrupt there -
the number will be zero if there isn't.

> Explicitly checking on chip ID helps to avoid wrongly populated
> Device tree data.=20

Right, but on the other hand it ought to be possible to handle chips
that could but aren't configured to do interrupts and if the driver can
do that then this becomes redundant.

--rRbIS5PUI9wLpAeF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwCEuAAoJELSic+t+oim99QoP/AoggKUOnjFfr9KsmRcZRQfj
Mi0kRNpTv/JWJyv7QmbHJckNfDGmRBp/xI1zL17Dli3Hgl7hpfvP2Sn+T5fDwX7m
fuAAFJViAXJ/fchPQIETRancmRRvZWe779bww/n1qf5xeOOPdiIhw+zLYqGpp34M
XEJsBwsK9Xo5PRbmcKFJMY6rvSxciWgV70OGnxBA7TCLlIASsIA77ImAIB83R4SL
TTT0Wr4mZXUJDyI6zG1FOuWoaRV+BvEJBtQ1C8U+/XYyS7UCY/AP09GR/M9T9fY+
cVOlN+TA7OtvmGHhOuWjWMV0PB7UfqN6n8zNwPFya/y0vDY9Z+4XNbJe0iMA39nC
6WXr8egdPDlA7pfI8buNub7+dDzwOJWH/dpQNvoGyyUQzy9wQXFHNbzou/VDyyrC
kFFPqJsOzdULRFDC0hFQQWstd3uHf5BO80SItkgc0fpJvga18GSDufQTe/TDR2QZ
+bl3CKItHVD6MkpB0OWh6wNopiTYidENfWirn8KxukFGN344rl8j01859qfQrIxb
Retqot7MEnfj/SFdBNY+/YEwh6sNoW8V40czeM/bvaCyw3+9vSUF+0j6VHi5bpMA
zvWo0y2PpyKxwNtOQIuX2Lsw7/02N7F/EvKSlopieNV+ENP55x8/rKuPHNkmzEgO
0+HX5kZkpn9xv7binTWi
=ZlCt
-----END PGP SIGNATURE-----

--rRbIS5PUI9wLpAeF--
