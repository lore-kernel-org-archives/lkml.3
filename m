Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab3JQOQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:16:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52081 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab3JQOQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:16:36 -0400
Date: Thu, 17 Oct 2013 15:16:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>
Message-ID: <20131017141629.GP2443@sirena.org.uk>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C481E.1010908@infradead.org>
 <20131016192648.GA19637@kroah.com>
 <525EEBD4.7070800@infradead.org>
 <20131016194440.GA14416@kroah.com>
 <20131016203024.GA6579@mithrandir>
 <20131016203727.GB1633@kroah.com>
 <20131017140224.GA32734@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IBB0LaKsiecTRaga"
Content-Disposition: inline
In-Reply-To: <20131017140224.GA32734@ulmo.nvidia.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] misc: fix various misc/mic/host/ build errors
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IBB0LaKsiecTRaga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 17, 2013 at 04:02:25PM +0200, Thierry Reding wrote:
> On Wed, Oct 16, 2013 at 01:37:27PM -0700, Greg Kroah-Hartman wrote:

> > Yes, I'll do that as part of my normal tree submission process.

> Actually, ensuring correct merge order won't be enough, will it? That
> doesn't magically fixes that the function's signature actually changed.

> Shouldn't the update of the sysfs_get_dirent() call be fixed within the
> same patch that updates the sysfs_get_dirent() signature?

They're applied in different trees so they're both OK by themselves,
it's the merge that brings the two together that needs to do the fixup.

--IBB0LaKsiecTRaga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSX/E6AAoJELSic+t+oim9UB8QAJKCsjHtGq7dHGsDi7siixA8
c+c5Ob/eZKb+a21Mr6eUgpZV68bYcdG4sqQc8yvJXzjL4Kl0c6NMM819/kz/5kZE
ajLt3WNWblvv6dhgMgwX1mwhCckst/fF8rzitMsplpCLP93BZ2ZMOhiLyZCcmgmi
/2nEPlKVZ67VL+el4TX1vBFC3hLuz0g8h3SfAXNeSMBemc+c7fBCl+rRybJaeCRD
sGBogx60t5kUfBFNc4Zfo/ziJUNIcj2kWnruAYHh0LHvpBDYrgJoz8VYc77ORLbt
2YQWbDi+OZ/ctwoEcHYScur1kE3gF8m+l6xd/a36erbmmWL19FSih0WCDhWgh/Oa
kpmcX8HcuGUFo/L4Tm72i9OGbuMrm7Z54CO2YFfdSiGC4p/xK+fhIgPqUc1iF8sX
jRYG2d3EqC66wgwRyl4id1/04BQALrzMBWZx9uMX8vSUU7FwwTZksFLSdZFst3+W
/QjxiCQq4CULM5IYBYAEapVe0051AE/nElGX18NoUxFAa02XweG36RA/TiHL5l3u
Y3S17C26K5qS7lxMeHYWLyrEQEJTiZzQOlymee/QMpa7Ohq6W816WPE+UFuxrBqR
BBlLvTJLR81c2XFm8iVY0mL4xaB92RSGQEI6vuRHVpwk+2dCe/CD9AqNw+ZaJ57c
k556fO+TWo2eg1FUiiFq
=0Hed
-----END PGP SIGNATURE-----

--IBB0LaKsiecTRaga--
