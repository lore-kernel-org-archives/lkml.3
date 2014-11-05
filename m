Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaKET63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:58:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54644 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbaKET61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:58:27 -0500
Message-ID: <1415217493.3398.11.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 019/102] xfs: don't dirty buffers beyond EOF
From: Ben Hutchings <ben@decadent.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Date: Wed, 05 Nov 2014 19:58:13 +0000
In-Reply-To: <20141104070908.GU16186@dastard>
References: <lsq.1414880882.522510247@decadent.org.uk>
	 <lsq.1414880883.633041348@decadent.org.uk> <20141104070908.GU16186@dastard>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/eTsRJuqwQazSzkcs5cs"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/eTsRJuqwQazSzkcs5cs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-11-04 at 18:09 +1100, Dave Chinner wrote:
> On Sat, Nov 01, 2014 at 10:28:03PM +0000, Ben Hutchings wrote:
> > 3.2.64-rc1 review patch.  If anyone has any objections, please let me k=
now.
>=20
> I'm not sure it's a good idea to pull stuff like this back into
> really old stable kernels.

OK, then I'll drop this.

> This was part of a much larger series of
> bug fixes that were fairly carefully tested. I very much doubt that
> there is specific XFS test coverage on these older kernels that
> would determine if this has introduced problems or not....
[...]

No, I'm not testing XFS at all.

Ben.

--=20
Ben Hutchings
The program is absolutely right; therefore, the computer must be wrong.

--=-/eTsRJuqwQazSzkcs5cs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFqBWue/yOyVhhEJAQqIbRAAgR5vt96h+ZWlIuAjs3LXmx1n8Y8dUzTE
XdEguLzr44ztDN6qUeEkD9bwNGBZ/pJNtI093DQXs9t3GgrGsFPQykXAdtNusAYX
jn17hqXQAQVBF0qN1lPPJd+sG+riV2JSh0vUW2HaMopELiRZQAYoy43Ub3OaAzUg
yMp30TDUZXhwsgv8bTp0FqKR97Yu+LdFP1T/1MPSwriuAVn3wqLrFuyCRglyla7P
8+spr+Q20VPZ4tUsP4EEXzJFzFXI6wk3hYRB6pU4f48Zs8TEEGglZo8CQ/TYVCod
L1OSsqlDqrbSwywJ/t5afg2lO+JbghBbcuU3631eHijFS/5v0doh7yNFUYRnXC5j
r1Nse8+6QGKS0G6inwHnVsWaOTQknY0cFAMUvh3RhCXSw82+AKyAuloUuKgqQcVF
zXEuLNi154Ig9CQvPMEE1AQboh4owxoBynXt/7ouy5YuH82CRpXIjq3UQ90y0NBO
2YunRQAmsLfL2PhDsOAhanJV2XcPiKYNA4Gth7wm+/kP+yf3a8tO/qHFAU2rz980
jpvyoIWKSFHggnERDw4+1UPilWEE3cwndJm0BHkgRV36ojWsx9M76VYVjndL6L0S
Ap9trARqyD/jWe8z0fui2xkt1HUY8ko7NCybvwo+zi41+a4C79rXQm+umtE95ZEY
sHW+tkEJufc=
=53W1
-----END PGP SIGNATURE-----

--=-/eTsRJuqwQazSzkcs5cs--
