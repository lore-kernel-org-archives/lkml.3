Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbbAZTYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:24:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35071 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbAZTX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:23:56 -0500
Date: Mon, 26 Jan 2015 19:23:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150126192344.GH21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422029330-10971-2-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="R8CP7fzfAHpwDIZp"
Content-Disposition: inline
In-Reply-To: <1422029330-10971-2-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/18] spi/xilinx: Support for spi mode LSB_FIRST
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R8CP7fzfAHpwDIZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 23, 2015 at 05:08:33PM +0100, Ricardo Ribalda Delgado wrote:
> Hardware supports LSB_FIRST mode. Support it also in the driver.

Applied, thanks.

--R8CP7fzfAHpwDIZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxpQ/AAoJECTWi3JdVIfQzhQH/1DmOTqHDDxN11dZIkiaQbB/
xczfP5xpaq/cTq11hOpf50Z1ID7kg1o/hQQUyf9Wk4hhC/sex0j6ZKyZlzJqnndU
83Q+KTCBKs3SPnUasjpB3tADR4IHTwV4nNcs9esas8GhbY1l3KBH8qZVIiKVOQOT
cQe3+x87xDTQoxRtLchNIlGHCzj8fwmVoV2LTQHS++AFj2zVKiEc1xr/l53VeJaE
5+XNQkygJ8fjBNvv4OGRj81TB+lagu/2w3yms99Y2VO1QBp0l47sWPLbfilYTzd1
JYEolfYmvn3zvOP+UxUe+1GeARSaqnf3klQ2SLHqc1e78lShV/EBSCzp/y23Lss=
=mJq6
-----END PGP SIGNATURE-----

--R8CP7fzfAHpwDIZp--
