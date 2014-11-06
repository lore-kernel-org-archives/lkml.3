Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaKFKAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:00:11 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48556 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752282AbaKFKAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:00:03 -0500
Date: Thu, 6 Nov 2014 10:58:24 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] dmaengine: Cleanup chancnt
Message-ID: <20141106095824.GH2989@lukather>
References: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141106060653.GT1870@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="enLffk0M6cffIOOh"
Content-Disposition: inline
In-Reply-To: <20141106060653.GT1870@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--enLffk0M6cffIOOh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 11:36:53AM +0530, Vinod Koul wrote:
> On Thu, Oct 16, 2014 at 11:00:52AM +0200, Maxime Ripard wrote:
> > Hi everyone,
> >=20
> > As pointed out in the documentation thread [1], the chancnt variable
> > is filled during the driver registration in dma_async_device_register,
> > from the liste of channels that has been set.
> >=20
> > This serie removes the occurences of the drivers that set it in their
> > probe function.
>=20
> Applied all, thanks

Great, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--enLffk0M6cffIOOh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUW0ZAAAoJEBx+YmzsjxAg2skP/0yGeh3IssVbJqSDLJU/27KK
r9L/uCqqiXIZ42WayC+HuKDf6oy0ATXhmvxwreKHjvwiQLnGgQj4jThpNDpkCKr0
hzMRY3IAmXndhnwg7SWKCet70XJzxhXRMEidMrIanIZXZCdUIls08gwnB7ysAtsP
o1znAorVYTP8zkKv+1xLW/EHVT1YYCPnkrN0Hglx9dja/aTHvIn2HtoGW8bBDrlO
r7K3rUjmkAZTlvGKfmYsTdM5CbF3WqRmcxMDY9M8ZQ3oaUVEqhktgGzXo9TAhDaj
b7r4tioJN6Zer/9BcE3OWhy+Z50l1XH9raFsL7HFL4FtahEICB6roAjjW9JMQwTs
a8XBkV8zxl8TWLhR8/1gkctir+EOqviNfNKqMgOcZ7ck4V6Fs3Hf2BJfm5eBOCsH
z7G2jdkN/teVGawLCmXLU+XFA121NJJlMQtRBaSHOY1CWkB3PWIpA5VGkzlgGJpi
emy1ipFZ++arvz7jGX2vJuhUSC8fjVqycYnObTymk53aAuEpdT1pTgg3mo5p7voK
+h58IK0jNtlfox+k4bKttRlFLo9F/BxOZsHYpVck1kSUc+9FcBcmzunW0PkBss+Q
0N5hs9NCvBqOKSqcRp6KQz7J5sPw/DAPYwjP6D+iLFJ30NXj3mQGirDcYXDNUcz9
Ll+ElSdfL0N1m87QX3NE
=WSBU
-----END PGP SIGNATURE-----

--enLffk0M6cffIOOh--
