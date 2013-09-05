Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3IEPfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:35:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46809 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3IEPfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:35:07 -0400
Date: Thu, 5 Sep 2013 16:34:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>
Message-ID: <20130905153432.GD3084@sirena.org.uk>
References: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com>
 <20130823095841.GG25263@sirena.org.uk>
 <522897FD.2030509@nvidia.com>
 <20130905143431.GI8980@lee--X1>
 <52289BD4.9060607@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tk7bxryrhVQGv1nz"
Content-Disposition: inline
In-Reply-To: <52289BD4.9060607@nvidia.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] regulator: palmas: add support for external control
 of rails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tk7bxryrhVQGv1nz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 05, 2013 at 08:27:24PM +0530, Laxman Dewangan wrote:
> On Thursday 05 September 2013 08:04 PM, Lee Jones wrote:

> >It won't go in until v3.12 now, but I have applied the patch.

> Thanks Lee for taking care.

If it's going to wait for v3.12 there's no point applying it to MFD as
the dependency will be in mainline after the merge window.

--Tk7bxryrhVQGv1nz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSKKSEAAoJELSic+t+oim9RIwQAI3/xUvZccENj93+7I7XUtHc
ykabf7B3qzIhQ2egdI9UibwgPAI+8gESgTZVBzOsV+n7ArCbu4zjIXZl3JSXkVLD
rZ0Sxst5MYLXWuC6zxkAfnXpee2ObRMBgEcOnP9HZz2Y714WMinokRlF4osP6Hmt
dGHpmwCIXpA31fgsoqYeQmEigwwHTElOk77wPmGbfMWZ3NGKV/eJ9aLh1pT0G1at
hB7xVXmw29EI/tWzdOPM34Unr31rel3+Hj2DmwObO+TCQ64DvPwmV42KVOIzy5az
GQ6RL6jPBCdI1VRIAkNOnUhPtKh6qG1bzT//gE7oS3eHFkK7gtJuf7qdS36kQFUp
5RqcYnnVz3ZnqQxAppjNaiutIqVoEBCrkrPDRRYmF6PqdaxuUPOuq6Oim50gkk4o
Ib9i2M/GyzKSqyFSzu50rpXEO5dVJWMM6D1CoOmaq6EjAjKr6WUHeiZqtU8zJWMg
CBY7peWZ1jZPmbUWRduzVZMgg31ADhRKqekQjVIryOYtzVeVarStmE3RcUK+sU6+
v75VSosJbI8APLpG6bhzJzmV1BenyZSU9z5ZHYK3qON8SUvagPpcjtq7BL8bmwm3
CgeSojNyijIBY6XubKYaGH6UGRV/OS1U0s96+JIZXBJ+BSOsPSx72CROoCdlqdp6
aoHigbWCcBaU0r3adc+h
=b56E
-----END PGP SIGNATURE-----

--Tk7bxryrhVQGv1nz--
