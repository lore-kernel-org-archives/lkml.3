Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3FKMAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:00:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48300 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3FKMAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:00:36 -0400
Date: Tue, 11 Jun 2013 13:00:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org
Message-ID: <20130611120008.GB1403@sirena.org.uk>
References: <89e4451e14f324d8bd480f843fa5960b481e3188.1370894247.git.marvin24@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vgqGEEhIUeLzQgKp"
Content-Disposition: inline
In-Reply-To: <89e4451e14f324d8bd480f843fa5960b481e3188.1370894247.git.marvin24@gmx.de>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] mfd: tps6586x: correct device name of the regulator
 cell
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vgqGEEhIUeLzQgKp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2013 at 10:27:55PM +0200, Marc Dietrich wrote:
> Change the device name of the regulator function to the one chosen for
> MODULE_ALIAS. This fixes kernel auto-module loading for the regulator function.

Applied, thanks.

--vgqGEEhIUeLzQgKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtxFFAAoJELSic+t+oim9SlEP/RPXlNluJ1tZFbgDrHusaEBD
9WNecvzDdFf0Vfxp1Bdxk9rGtjHLVW1vymHlKWQo5HkJx+mIsnvC1koNZwtc/jHG
1najWdJCFe9T0O5qk5wKG8ioBjFbn3iyOCAq3/ICu1JwTaXZGxf2AXJoaI/dMlee
fQSqFCDbMg9PfbwWdwp1V/mk4wfyJCGRjhfNGcBjEKcTb23mPn+59HhgEQ+ztbNy
UnmrpfNrNzxlg3sk8sEWN8VaV8JIbhNtwRKhyyGc0V/TIbxO7BgOa21OC3oWw/37
fM/Nw+MP4wAuNO92V38nBp0D3tKjS53Yb/QvezNCrxqn7mz7fDK1apYMa2Hr7n7c
MOOOu8RL5DDMUNy1LrtOGPO0PL72XJUQOwmB2Am8Ik1D/vAyj5vgWtfr802v9GX1
hepYKiMz1jJxxT6G5HeojVcGMkf1q1Wuc0SOA0+b4JnYXX6whLmIKkMvOVIkUmUw
FVYBRTRyZlgdMxAKhcGbBJ0yYaT6+qQcTeqSxYfLThk3lz16x+4BNBQ2d4QrC4po
9jb9lxfVKm7asnMc7hP2D7RWzxhayoN+c5/yxmlkqFJxtwLFyMYTnHZ7YKG5sVoF
1MlX8rHpi7Smy4QC3wXASB90B7/UmnzH5IIIlsheNqerUZJruQUzw7GiDzl3Ci4W
Kcdzqrp9uhSfmc7y09Ol
=QLgh
-----END PGP SIGNATURE-----

--vgqGEEhIUeLzQgKp--
