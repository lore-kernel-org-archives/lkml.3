Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3GYJay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:30:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36096 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3GYJat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:30:49 -0400
Date: Thu, 25 Jul 2013 10:30:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130725093045.GW9858@sirena.org.uk>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-19-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dncj+IwC/iyYwPCk"
Content-Disposition: inline
In-Reply-To: <1374703539-9705-19-git-send-email-gregkh@linuxfoundation.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 18/36] regulator: convert class code to use dev_groups
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dncj+IwC/iyYwPCk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 24, 2013 at 03:05:21PM -0700, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the regulator class code to use
> the correct field.

Applied, thanks.

--Dncj+IwC/iyYwPCk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8PBCAAoJELSic+t+oim9G5oP/2tecxdhU3JM5suIF6tZH/iz
Qpap++5klKmqVA5MmGZz2Envn9bcOJqa9VXOWLBYL4S8+PS984rFqWXTGoQW1YYU
Rx0NToijNJ2mkWPfM93Ugw8Gq10WddFX1k9j6EEl0EWqvQ5VScYRJeEq+/H1rGrc
wGTlPMTpx9oFTk0PjfcKwsB6v85PWN1x3VSmLIU+eLH8mUIoaOmOy4q1+GYh4QSz
M4N8rJbCfKJ7lHFm7ssxJ+rNoAb8r+CC9t9O50nR+0XsBA5HZs3yA506Y1LkRaGA
LHHiJKvU2pZf0ORqEbza3CkvT9vgnHDwdTNQM8r+6iVToYS3ZhyBxUMpIqiEYqM6
ryiCs1oWaCQ/B8f0AeDmITvDroTYc1n1TTjVG1WHpmTxV1lktG+2QYkdpcFzMEqV
JbdWhpdjPbmL/KgitD3ipvm+cnp6mFHTt6B9Jvw+cNn81O1dIF/Jq9aIemjPntss
2MZ4QZnrK6kUTy3AkVvq6xiuRBfMzO7tHhBx45NEQbXLXnDPiL7MO7olX4r+YXPr
L6Dp03sKE8iUafU4DoHAZw/Vs1a4fZoLH3BupAQjkEugQR3UoB3Uh+KTI98HI3fw
nSqxyj4sTol4+9kgx+uuVqrMDd5KTmB7RwFwYeqMtBPtaL+al5Edq0ZmiXDTBKMB
GQqqUT8Brr69bKCQInsy
=I2fS
-----END PGP SIGNATURE-----

--Dncj+IwC/iyYwPCk--
