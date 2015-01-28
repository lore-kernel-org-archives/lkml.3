Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbbA2BZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38401 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbbA2BZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:43 -0500
Date: Wed, 28 Jan 2015 19:56:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, agross@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20150128195658.GP21293@sirena.org.uk>
References: <1422413199-17273-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1422413199-17273-4-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bEqt7M/HQTrIE9YV"
Content-Disposition: inline
In-Reply-To: <1422413199-17273-4-git-send-email-bjorn.andersson@sonymobile.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/9] regulator: ab8500: move to set_optimum_mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bEqt7M/HQTrIE9YV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2015 at 06:46:33PM -0800, Bjorn Andersson wrote:
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  drivers/regulator/ab8500.c | 48 +++++++++++++++++++++++-----------------------
>  1 file changed, 24 insertions(+), 24 deletions(-)

These refactorings are surprising and don't seem like an obvious
advantage - they mean that we now have two different paths to setting
the mode (one explict and the other via this).  For regulators that do
want to just do a lookup of a mode based on parameters I'd expect to
keep the operations separate in the same way that we do for things like
voltage setting in case we come up with ways of using the two bits
separately.

--bEqt7M/HQTrIE9YV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyT8KAAoJECTWi3JdVIfQRjgH/2PBLCph1IN13+lwZtfXWJ+S
z9tsoKakv5B3BVKdtuz3UsAPr5RqrW62mOndo9ZBwWrqF0FPTQ66Jzv40C3oJ94a
sInM98M6EOsnxglIeHijRv8vrjXM0X0raUKSxqVfHwKz95bZg8rLHHxdlMCW7uVb
lx5awd4JRkB3meCAMNcgSPUWnvGT5ywBwCiC72/pGIA1jwHF5fFvE1D+IxQGSHHM
n2+7RMLJX0wZeAPriCiAo7IswaOOBO3UOi94zEhICsG6jI13CRRkEBGcws4f+UGL
xAW89wsI8VOCuD9NQJ4yJ4NTYQ/1+lDNhW5xlE403dUV+cDfxUJIsEstAwf4tLc=
=6g/u
-----END PGP SIGNATURE-----

--bEqt7M/HQTrIE9YV--
