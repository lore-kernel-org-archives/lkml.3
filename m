Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbaGYRs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:48:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54983 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaGYRs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:48:57 -0400
Date: Fri, 25 Jul 2014 18:48:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, devicetree@vger.kernel.org
Message-ID: <20140725174830.GB17528@sirena.org.uk>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
 <1405957142-19416-3-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zQkbmZdDtNfaM5TR"
Content-Disposition: inline
In-Reply-To: <1405957142-19416-3-git-send-email-ttynkkynen@nvidia.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 02/16] regulator: Add helpers for low-level register
 access
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zQkbmZdDtNfaM5TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 21, 2014 at 06:38:48PM +0300, Tuomas Tynkkynen wrote:

> Add helper functions that allow regulator consumers to obtain low-level
> details about the regulator hardware, like the voltage selector register
> address and such. These details can be useful when configuring hardware
> or firmware that want to do low-level access to regulators, with no
> involvement from the kernel.

Applied, thanks.  I've also created a signed tag for this one:

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/getreg

for you to fetch changes up to 04eca28cde52cdf9eb91e127cc358ad79a8ec53b:

  regulator: Add helpers for low-level register access (2014-07-25 18:43:48 +0100)

----------------------------------------------------------------
regulator: Allow clients to retrieve voltage selection register
information

Some systems have embedded controllers that can automatically manage the
voltage of a regulator.  Help client drivers support this in a generic
fashion by providing access to the register information we have in the
framework.

----------------------------------------------------------------
Tuomas Tynkkynen (1):
      regulator: Add helpers for low-level register access

 Documentation/power/regulator/consumer.txt | 35 +++++++++++++++
 drivers/regulator/core.c                   | 71 ++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h         | 26 +++++++++++
 3 files changed, 132 insertions(+)

--zQkbmZdDtNfaM5TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT0phqAAoJELSic+t+oim98jYP/ROiXmfOX8whSlYCzUPrJuv7
BPyGJcWQarxfMiGfSkz7bw16BNliJjCuxxyMlUFc14fFiQGLYJptGEkHVjMUghgl
LGfMlFC3W3Xml8cD8NN5X8k6HfsC18z0xIktb+kkDLkXnvAqs4FbJlp7uaFr72D8
mm6iZ4QidjxGkfoCuUb+mbzAfZWuqqcLLuzed0zckXElXwoPaCf+2uFUDabiY6ap
QFvncNoBjUm4/O1gNSVeP2m/Ab4MwVJSQxJPDnVqYKtUFFZV/3DZJhXUiZIpDiW8
0GDqgD7bn1X0fyGGSSByFd9TYsoC2xSSpXvahcQ4632RV9rtV9an3egR8nBuI/8x
fUaZ1PKtO0ri+++IuaAjuL9P/1tgW2mzlzxHqzoXxgjQhLBMOTKDx/aWKBAenj0j
hSbC7daldZaWY6j51YgwHBs/SMcUYqW3D0XAeu+BvzqnaLB/IW+F6QM0IBV6S0js
t/l4CeLmoKz/O0lX5hbv4/UDRtgYwDm5zbZG8yapjxC3CK/0Mlh64cUyhqzWW2IB
cfLtXzyc9C2vqns+GAjO5yROG+dkMM80pEBNtfcNM7CxS6sQpxODWg8QfGzEKBD7
5ehykCWhtRs5E4KyHiIvtdmiRhg0r5Deho6bHR1DG4KOkHrCRQF05BpR9TPko+iA
rmNH8zXNGQmiclf+iIKm
=fMkx
-----END PGP SIGNATURE-----

--zQkbmZdDtNfaM5TR--
