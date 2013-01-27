Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab3A0DXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 22:23:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45523 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab3A0DXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 22:23:13 -0500
Date: Sun, 27 Jan 2013 11:22:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] mc13892: sanity check num_regulators parsed vs.
 registered
Message-ID: <20130127032249.GG4650@opensource.wolfsonmicro.com>
References: <1358792745-1737-1-git-send-email-matt@genesi-usa.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nhYGnrYv1PEJ5gA2"
Content-Disposition: inline
In-Reply-To: <1358792745-1737-1-git-send-email-matt@genesi-usa.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nhYGnrYv1PEJ5gA2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 21, 2013 at 12:25:45PM -0600, Matt Sealey wrote:
> Imagine a situation where a device tree has a few regulators in an
> appropriate node:

Applied, thanks.  Always use subject lines appropriate for the
subsystem.

--nhYGnrYv1PEJ5gA2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBJ18AAoJELSic+t+oim9WZUP/ixFaDpqAsGPH6T2dUrfFU5d
jhaYzBGSysW0i8HipgCV4Vi6lBvmWRJ8xzOxX/9bEF366z9xBUtcEwvROGrgd6yH
rHsI94YBx6n1SDglMpnyHBKM1Lpg4t/FCoFqDSdwk7fJcCRMbZeEKqddUKtIv1z2
dhQdUoGxqqZ3bAHMa7G0CEEEmNLGXCmaP5Z7WOvRCJdA8JyNiNKAxxXxblZgPIHq
gTw6ByEncbXGwoLRYyqYNChDM234sUEGW+/fSKednBiInFQMmrsSIM/niLPvuUYB
WjtHCTrG7XN6fUqwrm+NxAQX0MYvRKhSpLwP7h7bapmhX3GZheyfWKa/skVDr9Qw
5reRap1dRROpL0464um+WU3TcqMHSHF7sWfGV5yEsYU6fE3oXwP1z9ogRiOZ4q/U
xYOD7mQWDwYjhi4jtObIbsByXQeZ/1g4IUNOwJy1I8xdWxsJZ+eRhJYdy4GzP+zr
Qg7dOzL5F+JcxAm2Fz4+OX0OD9v1DrYDryHLBd3wGO11MKusSeiiDwT6s/KJqNp2
wEDJLZkNtw+4APl2k6YUDWhGb3MLIuunjHl5/Jvg1/uFzBiRd73TdfctnGZrmz3k
Xkoekh/azgI4NlK2R7/Q8f4SAbL3jOlorcP4d24VI/ofWnz4pdSI+rJMEH0o4KLU
LvgXmcNJBcOppvcE1zhg
=Yyj4
-----END PGP SIGNATURE-----

--nhYGnrYv1PEJ5gA2--
