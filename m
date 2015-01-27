Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbbA0MAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:00:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36083 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbbA0MAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:00:09 -0500
Date: Tue, 27 Jan 2015 11:59:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20150127115953.GQ21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
 <20150127001419.GO21293@sirena.org.uk>
 <CAPybu_1==6gvwbWQWxSj_C3siGFTjvqNh1=Xj6jvu_xQFOA-Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gmAlUWRVDrnirEWv"
Content-Disposition: inline
In-Reply-To: <CAPybu_1==6gvwbWQWxSj_C3siGFTjvqNh1=Xj6jvu_xQFOA-Kw@mail.gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/18] spi/xilinx: Speed-up
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gmAlUWRVDrnirEWv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2015 at 11:17:42AM +0100, Ricardo Ribalda Delgado wrote:
> On Tue, Jan 27, 2015 at 1:14 AM, Mark Brown <broonie@kernel.org> wrote:

> >>   spi/xilinx: Support for spi mode LOOP
> >>   spi/xilinx: Simplify data read from the Rx FIFO
> >>   spi-xilinx: Simplify spi_fill_tx_fifo

> > spi-xilinx?

> Thanks! Fixed on the next version.

> BTW what is preferred spi/xilinx: or spi: xilinx: ?I have seen both naming.

Traditionally SPI always used spi/xilinx but that's too far out from the
normal kernel standards so it's hard to get people to follow it at all
so I don't worry about that specific bit too much.

--gmAlUWRVDrnirEWv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx324AAoJECTWi3JdVIfQhK8H/0ZXDUtTT+oo6vY86o4oGdYr
v5xw6IQAoXKBJeOoGxlZCcphe5f4ljPVorRhhGN687coWlUspsKnnwEbxaIkaZRU
ey5WwYXoIKV/uIAbHEhF6W/F5cURs8tPYIfZfAVGbqXKa3ONAmlXf2ZpPoaLJGbf
fYVsgOgsY7cx8ewVYBdB2F15ZNuNDoGGvNMYGaDO5TAmoj5e//K+T25HOSMgPJaY
MV+Ptn9womu9QEIwbIaFoZZMFDUT+l/NRK9qpSNOZOH6GwDQNDgy5s533qfRY3gO
wUDL76bShR8hSG8zRvgEi8za5MMcbzpbYW/7R16jw0shvf2fCLdEPmnGazOE+wU=
=v4Yv
-----END PGP SIGNATURE-----

--gmAlUWRVDrnirEWv--
