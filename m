Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3BUR34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:29:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41983 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542Ab3BUR3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:29:54 -0500
Date: Thu, 21 Feb 2013 17:29:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] spi: tegra114: add spi driver
Message-ID: <20130221172950.GA1766@opensource.wolfsonmicro.com>
References: <1361281115-20436-1-git-send-email-ldewangan@nvidia.com>
 <5123C18A.9010604@wwwdotorg.org>
 <5124C18F.6070108@nvidia.com>
 <20130220131112.GE2726@opensource.wolfsonmicro.com>
 <5124CEF5.3060605@nvidia.com>
 <512506F9.2030508@wwwdotorg.org>
 <20130221095654.GH23234@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20130221095654.GH23234@tbergstrom-lnx.Nvidia.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 21, 2013 at 11:56:54AM +0200, Peter De Schrijver wrote:
> On Wed, Feb 20, 2013 at 06:25:13PM +0100, Stephen Warren wrote:

> > OK, so that's certainly an argument for requesting a specific clock name
> > rather than NULL.

> The list of possible parents for each clock is determined by the SoC and is
> already known to CCF, so maybe we just need to add a function to CCF to allow
> the drivers to query the list of possible parents?

Assuming that "CCF" is the clock framework that's pretty much what I was
suggesting, yes.

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJlldAAoJELSic+t+oim9bFwP/11Vm+ANLvoLNzJEdpIfzzh6
904JEDRA2pDZm/C81SkBawdDg4F1lsgieLVmDZg7a8Qij67CmwjINvXQLBhpXPqo
7eW7FSLOpLAoJ5tXeOzQiMbJPldXnJ3C2vEkvCnuftI1AQXbY9WspBki12q5R2KM
1tXQaUCglB0PMfkO5cK9kre3StL2fMGgiygDBfAqKXicZoMArBI2x90kgjl1H4ox
Qy5sBBnX7PSJ0vfpYzRTy5lOfUYzhOi/Lu9bVSZJ8QnQEYlDhyuw0vDuallmr20L
QkIte9vCgETMgivhe5czBl7hoy2INyOpMNv4hqQgFTZSlQ7393Xmj6ycGDtMWQOn
zS/hW9sXy3PBwhfqOBhbOo2pFJYbiOdrKe5zSBadaD36w1kfxmZzN9iwIhdEuMMR
7p8LOBK/OfLwD7RiLXRZhpi4ep7NzC/41KdBCytk/y4gQXfkH2MqgC7tQl8RIp2q
pPVdDDS/0WGVCck6ZwASkvFCbq/WSDYws/vdAcBQ+16EsmSUL1+SX13i9gx+bCAe
mLiODb6CLIxIjlcBYYT+7ZO+VKbJvwooTFjoJIUVLAe0NNYvg/JQUik48VH+m2R1
s85RkupjcjWs/o+ZyMwdvQwfuaclbZ/91MPSQBZT0SLIyqCgA4YQGs8tmmA9aWmQ
H5G/VmwzVrYACm2Nra4e
=GU7B
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
