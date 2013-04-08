Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935Ab3DHKEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:04:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35688 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964891Ab3DHKET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:04:19 -0400
Date: Mon, 8 Apr 2013 11:04:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/15] arizona updates for v3.10
Message-ID: <20130408100409.GB9243@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <20130403180423.GA6985@opensource.wolfsonmicro.com>
 <20130408092556.GL24058@zurbaran>
 <20130408093842.GA23639@zurbaran>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <20130408093842.GA23639@zurbaran>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 08, 2013 at 11:38:42AM +0200, Samuel Ortiz wrote:
> On Mon, Apr 08, 2013 at 11:25:56AM +0200, Samuel Ortiz wrote:

> > >   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-arizona-3.10

> > Thanks, I pulled this one into mfd-next now.

> Actually, this branch fails to build for 2 reasons:

> - arizona_runtime_resume() tries to goto err; while there is no err label.
> - arizona_of_get_core_pdata() is not defiined when !CONFIG_OF.

Can you be more specific about what you pulled?  I'm looking at the
mfd-arizona-3.10 tag just now and there's no reference I can see to
of_get_core_pdata() which is what I'd expect as this was a separate
patch series...  I'm just re-tagging and re-pushing but were you testing
both serieses together?

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRYpYRAAoJELSic+t+oim9MtAP/j6QfT7Pyz0lyKm0XIV1TRBU
b4FT1S3Wfmy/5D/2H8If9PkO5A7i1Qq2zLTPgV66RrIOM8mLeskITA7iI0edS48x
hNeznAow2FMyC+kdNnWuU06E9p/0NuNiQImGpnFYSTNXZLJIIfLdeihfewzyQlH7
GTi58rftyJsuE2HGj1znK2MmSchMrwvtC7lmJ8/A5Ftc0xlloapCJm6lrs3PVt5f
uza2fnlSkEy+n6J0/m59kvkYToOllB8ZmwaBsTHEioq28JPO7Vkc4QxaM6YnQYkb
DMvpyZt7+nDjFQF/9zx3AW+NA6RXN/zrYCMca9IQJcUpc35BluuanfKiG+TaIpKX
oli2GxUJdyija2cEt1UMUrfDVX0MSZ1kojsBoBLFztvHckrZt0xuAVB9xFE0Pf6J
OycomnIj31yocTIwxLi81LGsKY/Sq1/LXIleVeRePEnnx7s6tSleXCl0QPUVWnhw
AKiwfWTZs42CCazH6k661P0OGqrS4GCtsa8lf8PV0C1qXUT1cfwuCqP8uiyWwouq
tLw+KzQWpemgCEhjgaHLQ7NzcCNza4kF5isDyabDaW+Ox0NWcsbR9XbbXa1gOllk
JGw7qgmAJZrfunlCqlJ+46aodK4XTWv/014HHsV4T7hEr/5popO8q39/peOv+Fu8
PFpbFcYNRV97WGCpaHg5
=rqhC
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
