Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab3FQKFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:05:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35663 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3FQKFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:05:31 -0400
Date: Mon, 17 Jun 2013 11:05:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130617100525.GA1403@sirena.org.uk>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
 <1370864113-17895-12-git-send-email-tushar.behera@linaro.org>
 <51BED2F9.1020307@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9teSV9pdwBI9hpI9"
Content-Disposition: inline
In-Reply-To: <51BED2F9.1020307@linaro.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 11/15] regulator: ti-abb: Convert to use
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9teSV9pdwBI9hpI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 17, 2013 at 02:42:25PM +0530, Tushar Behera wrote:
> On 06/10/2013 05:05 PM, Tushar Behera wrote:
> > Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> > introduced devm_ioremap_resource() and deprecated the use of
> > devm_request_and_ioremap().

> Ping.

Don't send contentless pings.  I seem to recall you already got some
review on this.

--9teSV9pdwBI9hpI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRvt9iAAoJELSic+t+oim9mmQP/1ZN/haU1ebXkXdono+0Jacb
t0o0cOgPUHjLprfhLbF6HUd3yg0t5/jt5ayUqxxfnSBMa9K/35I4ZGD2mMh9rEGi
pfiFK2RrcHDRqDR/FVLOPtWqg+Ywgwtzyd3vovQTUVQ5qBP9Jythz2LLqIwFEGH1
6VYKHbX+HizqlBCl94Sq3ySYtA+O1DnEXjSVR5Web1I3bUlTsYgcunW8TW/nvULw
MjbRd2vLXb/v9Dx1lcwbBnITyY6B0TyG25XcR/WuwJSSim4WoeOAlG9HSb+ZuKhr
Z2VdJNKAyCAFINcKZJd+x+xZ+BYJdV6wPMV57gx5Mg9fH1l+Jzfy/ZGptdMA+GEi
25ExewymnVaxJ57cIqCPqmFGkH8scZDqu+hUfJGZVEjkEtBLb35DDQ4omjHKeGAU
ekBYGLo+z/8L/0T1tBMJhhrUSQ57zhf0HxGOoeJZVj/HfHSi2xY8kj9Rli+0q102
aNMhI0u5DIllv9tNvijjQbfY2hQbwACXilKUgTugeYfSoR0oa5riqoijArHQJkDT
VB5HCIlIVFL1ZrccPaYKxMFGVnbVRMlp1Pj1sYclGlV60gT46+aCNwfMTI9M00hq
sDZUHrUaDWU4WL/tG8ld4V40lY/Faj7V5qYGluJDhdYEuVOUOoRQ3o0AKBtwY8U0
76SrlYN9m4POKLGx0v88
=oOz7
-----END PGP SIGNATURE-----

--9teSV9pdwBI9hpI9--
