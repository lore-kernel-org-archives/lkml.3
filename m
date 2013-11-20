Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3KTUwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:52:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59746 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab3KTUwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:52:12 -0500
Date: Wed, 20 Nov 2013 14:51:43 -0600
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, <ldewangan@nvidia.com>, <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: commit c368e5fc2a190923b786f2de3e79430ea3566a25 regresses MMC
Message-ID: <20131120205143.GA9182@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131120175814.GC27423@saruman.home>
 <20131120203400.GL2674@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20131120203400.GL2674@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 20, 2013 at 08:34:00PM +0000, Mark Brown wrote:
> On Wed, Nov 20, 2013 at 11:58:14AM -0600, Felipe Balbi wrote:
>=20
> > commit c368e5fc2a190923b786f2de3e79430ea3566a25 (regulator: fixed: get
> > rid of {get|list}_voltage()) regresses any MMC host controller which
> > uses fixed regulator for functionality.
>=20
> This is already fixed in -next.  Please remember to always CC
> maintainers on mails and please try to write subject lines which are

that's why Liam and Laxman are in Cc. Looks like only you were missed.

> readable by humans - full SHA1s for commits that obscure any actual
> content don't help.

right...

--=20
balbi

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSjSDfAAoJEIaOsuA1yqRE4JEP/0FfCWkqAtbMR7sV/GuNs/XS
eFjqZ8kliLz9DREw78maw/njTgZj3aA3kmK5Psm/4R3UGHb8UxNIMXPLzXUWIn/e
ymSPBJ5u8OsOb26kTqkhdYBMRGPq3WcoZ46W4UnzWswGAAFZwfWzGKWUyJp4di+Y
4z+waSMcWIMmhNWky9WzHCQJ/pmSbEi3BBkLS28JyASU2hH7nRM2z1TxrzaH7IV7
74oWE/SnAdoZyT4LRq0USFkEIx2mmf+q4Vp5ySaXJn6WaBU6d42IpeX4coft9vm5
z5WrmhhjQm4ZC5ajE94NhGbLmx4VbCybGeXyfsf0iTEOb3rxj6k2iNLF8xkwue85
xtONcEwf+RY+bEPL2gkQs6WUwDsUnYhZxyjr8gLFlqA9fTSA31Axfh3b6D9NB/I/
KdIK0RJqagRw1QGZs6ReCdwXngftb8coSwG3ABIrpyFnopo6uM/OCddn3VYVKOHF
lKl5Ha/9IGwmaBr26FgQzynCTQfxjuYbwoZPQVsugWgFU8xtRFLpe/SBwFfKjJVx
lST3Zw7XZ1MheQtTod6naEsrsuDwabS9IDg+4+FcsHBUCqRbcqM0/yG4Qa4xGWTA
mMKceyVK8m155OTlEavB2h7awNXhRWmGBXhXZnnpsTAL3rY7+U3vWJ+mgcaeiym0
eCO9sEUYBSTbIwTXYiQf
=0yj3
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
