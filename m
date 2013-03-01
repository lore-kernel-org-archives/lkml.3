Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab3CAG42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:56:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43866 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab3CAG41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:56:27 -0500
Date: Fri, 1 Mar 2013 14:55:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Li Fei <fei.li@intel.com>
Cc: gregkh@linuxfoundation.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: [PATCH 1/5] regmap: irq: call pm_runtime_put in
 pm_runtime_get_sync failed case
Message-ID: <20130301065556.GE25302@opensource.wolfsonmicro.com>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RpqchZ26BWispMcB"
Content-Disposition: inline
In-Reply-To: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 28, 2013 at 03:37:11PM +0800, Li Fei wrote:
>=20
> Even in failed case of pm_runtime_get_sync, the usage_count
> is incremented. In order to keep the usage_count with correct
> value and runtime power management to behave correctly, call
> pm_runtime_put(_sync) in such case.

Oh, that is a surprising interface...  anyway, applied thanks.

--RpqchZ26BWispMcB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMFDeAAoJELSic+t+oim9hMAQAIuIuII92gr0R8QEZ2B4ftKX
UN1k1IxoSJI2QE5kEg6C5KFT9ZLxpUS13zKLJi4uLk/y+AF1et2yru5oYpcIQTwN
f6ieYJWTzFRjkzF8Pyp6GQ5Ze4UGhFQ9htHYcKrJYZBPjuwyDXymKGNEtO+F0Q+q
xuwCNQ/RTMGg7C6sEJ3w5Sa7ZgYuvbxWHM2PCqvTS61CiiAh6is05/wnwSE/qiXG
WikforOKxkjikNbhDnzFkVI7xisGJACgFn2vykFsir2YLy1A6WfRD55XA9O5+HyZ
CxTphFPvuEF5kJNTDRuX0qS+dkC2ZyBjYLovyRLkGwLwkfnuldoFncUkhvGRje4h
eCqJRIMbNPjZHkA1O4XLZtGEdNLsEU1bITE90fWNx3iQhys3aGAdUcTfdunlWjDk
2+3eo06/3D8eeOGKnwKeIz6F05XEftt6wAmSUvZmPsfQUpLdPs9EEPpYvVTc9mCS
OBy/nwuaMHmp8rFq1sQJthm+CrqvUmkejYZcl0j9AX69gik/N1BYprChQFNGNuin
NccLQbaU0XVxUNskBzgGiz3OON8SyLOLBO+UUxhe9mAE8LFD5tPQZ1oOA00RNEs9
fNnsrmuu8FCJsNP8BlAJZ7VGrLu6bbfUIUkbydOoDVx1DjHPjL0GPR7EffPMGOfY
MUxMU9kJXax5X99AF4CA
=g10L
-----END PGP SIGNATURE-----

--RpqchZ26BWispMcB--
