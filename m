Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaIDKmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:42:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49656 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaIDKmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:42:37 -0400
Date: Thu, 4 Sep 2014 11:42:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Foley <pefoley2@pefoley.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Message-ID: <20140904104201.GI29327@sirena.org.uk>
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
 <53FB9DA0.7000301@infradead.org>
 <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com>
 <540651B3.8030400@infradead.org>
 <20140902232906.GG29327@sirena.org.uk>
 <CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com>
 <20140903232149.GG29327@sirena.org.uk>
 <5407A68F.5090805@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GH2w3bbsGmSMo31z"
Content-Disposition: inline
In-Reply-To: <5407A68F.5090805@infradead.org>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GH2w3bbsGmSMo31z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 03, 2014 at 04:38:55PM -0700, Randy Dunlap wrote:

> Hm, it could be a problem with the Index line.  I'll disable that option
> in quilt and see if that helps for the next time.

Still seems to be happening today I'm afraid.

--GH2w3bbsGmSMo31z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUCEH1AAoJELSic+t+oim980wP/0ggLUzKqKtgYvZLtNZXA8yB
jmRVupODlIP9R6Oq8cvhIatbTy4m7pxOi1YdW8RvN1PxEOmdWyby0aZww1BMWjLU
lPV5OwMIjPWLvgeDCIMDh7b0n3kH4ntlz9dNoJmIv1mHNj71Caa7KdcUU6IYmTmC
f7ruChlNaxee3iKa27dqiQgEJgfsnenjoiE5WtVaMISV1QuITgoYXgbWcEE9B4w0
PIt9M+JnxYqqPDlVmkQ9A2m55BdtTEpJpNSXbaGfmjqGJs9Mb8egaDwabZGNkhga
AyjQ9IAgw8AQC6snRaX0CcpPULJFblqJ2FJPLpRycmXU8sOQhOQgtL2nPtemaTvi
wPuwebHxnowaWgW9j7b3kBkWwxq5v7zGnkg0Nniy1G22bBqmVGil4HKIhezHh5o5
seXNEFkKlHr6z7WL3IswXz/imobUFSx/0FCuBVxmES5c1HIE8ZFfXTIq7Z7f9vIn
tqdnVeyVvaLuIsuX5NkSsTY8UiekXhGpXrNqZuYNeXoqYI8YDvBbldwDBBbWjs73
rmnz9qLvZslVZlHh2afrDkJPjQuOgnDBJjbMHkIk3HhvWl2C0wgHFtJkmY5cKDFE
95JDGJXV9MTCxQXXOkSFQ6B6I8pt8X4UsvHNgu62pQnQkEhWhzTxgCSnJLJAImf2
xxu3JgcUd9fuLGJS6WqH
=R393
-----END PGP SIGNATURE-----

--GH2w3bbsGmSMo31z--
