Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3F1LhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:37:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52687 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3F1LhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:37:01 -0400
Date: Fri, 28 Jun 2013 12:36:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: lgirdwood@gmail.com, ldewangan@nvidia.com, gg@slimlogic.co.uk,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Message-ID: <20130628113632.GH27646@sirena.org.uk>
References: <1372150828-10519-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RAD8y4JU75Gxa8ob"
Content-Disposition: inline
In-Reply-To: <1372150828-10519-1-git-send-email-kishon@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: palmas: model SMPS10 as two regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RAD8y4JU75Gxa8ob
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 25, 2013 at 02:30:28PM +0530, Kishon Vijay Abraham I wrote:
> SMPS10 has two outputs OUT1 and OUT2 and have one input IN1.
> SMPS10-OUT2 is connected to SMPS10-IN1 and can be configured either
> in BOOST mode or BYPASS mode. regulator_enable of SMPS10-OUT2 configures
> it in BOOST mode. For BYPASS mode regulator_allow_bypass() API can be
> used. SMPS10-OUT1 is connected to SMPS10-OUT2 and can be enabled using
> regulator_enable().

Applied, thanks.

--RAD8y4JU75Gxa8ob
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRzXU9AAoJELSic+t+oim9900P/1F5NXhboz55GENNb+X1YLtn
y0xxGrIRaEY7ocHKadokGy3RcuJrIJHHgvfB+j2djANzSAWFFbYPOQGX/RvexN39
iG5KIiSPZO3Nc9jr2Cu8gjsUqFLPej0L8JN6+/P0YPcV1BsGXGTVKxEnY3kzPymk
ALAkFBYWx8GpmsHe8/Sl++/odOdfTb1T0FLQCP7WB6iTKxWEd3n38zncyylIHQSB
PtRfK1hCMoi/0V+W0ACTUkGqPtdfj4+x3Yg+5Uz/PkL8Kz6qMDrDMz87LozWIkaz
rSBLl7D0ks9I9bM2JE0VNFiUmiQ4pT6b/cvBQ2mJeye5Lod/wrbIWEBIlD6pXLid
qZsFyNw7+KAWpuXTeQwf4LdFabxNBwHRQyLTWwxce16PZXK2Y2CWzafDJ1jfV8ET
C5ssFvtg3uPvfC0G6DY/Z2Xdt/kockaq1imNnmCdDh5gGzysnQ5Cn4d7qXMDVFJ/
ZH6BO3lZxiNDhajfCJzB8KRdSycziU6NtJgjzl3ACF0QRl3BEHkacXSA9ou1hB4R
4+ICDlg1pnAo5uIIMte3Uyw6Dy8KLm53IPU4/GD/6BjT2+RYI4HzY9RdpTEmSIf8
BOHPj6y0NFYru6YGwhZR3pe4BjuG7/xLzMc6+0FYPBZIo9TK9YrxLdcK2XwPS7+E
J2tC234HOvHkHmRKgdfo
=8rnS
-----END PGP SIGNATURE-----

--RAD8y4JU75Gxa8ob--
