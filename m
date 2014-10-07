Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaJGWtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:49:11 -0400
Received: from ozlabs.org ([103.22.144.67]:48425 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaJGWtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:49:09 -0400
Date: Wed, 8 Oct 2014 09:48:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error fetching the devicetree tree
Message-ID: <20141008094858.759d0597@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/QBCVPwLY+LEwVrYQ6N9u7w9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QBCVPwLY+LEwVrYQ6N9u7w9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Fetching the devicetree tree this morning produced this error:

fatal: unable to connect to git.secretlab.ca:
git.secretlab.ca[0: 208.123.74.12]: errno=3DConnection timed out

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/QBCVPwLY+LEwVrYQ6N9u7w9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUNG3iAAoJEMDTa8Ir7ZwVcoIP/1hrLM0hJXPzMtvHbo4cjuNi
zAQ/wGnaG4UzKm9xb2xHW2zsvxQ/Ehj8Kmp7e0WC4WEx8Mp6NjFbP3A7ROgjDhYR
VPyXlAy59hveDDAZHPdKSF5ObVjzbOLMyPMB/bImA/Sp6JbgGC3hXkGWK+aVjX9A
W2Lik5E8fzflyMnCDTmoPgNaFoRJo5INLpCBOVQrAj1PvlmcpQ7KciUsObxPyyC/
rkFsIJijS9RNclnDMCdcBMKurmxSLTozVs4g/kcYnZnqIFGl9V+68tL8ieOB96Um
a6Uu5twJJl0+t6buWi7BffKPGjLS79ShBDVIjGC3GFOxDSrFaYu+0/BRYH3lQFT3
4yPZ9IX4VvwHs0GyGOznmVzOpcVZnCK0Bl5DMm8g0rQHXCaPJEnwBPY7+c9teX0l
zWsQenmG11GXgZToPwZHC55ul0qYmWKH3XYdh+x5hoM5y4fHea4XH8RWl+ApxwgQ
b1NpO71SRe0cgAxPJsHT9P4JpX262+sCrNEK5tPx3BC9W7cT+Jv1c0hY6KNYe5Lm
PPl6PLIB9RfMBbR7Yt0XdOjOCXoE2andmanV+U3us2AWAghM0IneLDkp1tsyfofn
3Md5ptNnUvB9wUcVxXrtqGdiGXUfSTlm3XInImXZysS4vArq3Ke+5wyZN0m950VI
tQhKXrZz3iWvowZm983q
=gZ5o
-----END PGP SIGNATURE-----

--Sig_/QBCVPwLY+LEwVrYQ6N9u7w9--
