Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaJTKEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:04:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37680 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaJTKEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:04:37 -0400
Date: Mon, 20 Oct 2014 11:04:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141020100403.GO18557@sirena.org.uk>
References: <1413672385-8492-1-git-send-email-dg@emlix.com>
 <1413672650-8581-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JPKYlvo4+BwO1+FT"
Content-Disposition: inline
In-Reply-To: <1413672650-8581-1-git-send-email-dg@emlix.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: s6000: remove driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JPKYlvo4+BwO1+FT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 19, 2014 at 12:50:50AM +0200, Daniel Gl=F6ckner wrote:
> The s6000 Xtensa support is removed from the kernel. There are no
> other chips known to use this I2S controller.

Applied, thanks.

--JPKYlvo4+BwO1+FT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJURN4TAAoJECTWi3JdVIfQvxwH/3XQxZRZRjtnfRmer6/SI2ZN
0fkvmvDWX3w1FWdIGpWDLK0J6+L87r9X6wqtJidoG+hcCntr4a9qcHiAbefy0Cs+
OXjmmxSW1O+wrsSYPJAHrUvd6Azv/Tp9Zty3Kx3khn6whJiL1yrlOv0d+JF9YZlm
9dq2BaB60cBHzDirgprlq05t3OkYrl5CdTfweb26gwpi2gsYa7YhsDNLLDp8WvPD
4Av96037mfZJQovYo4b++HII1dFUqm7Yo+etaRagTQjSHcX0VNAPsQkzOXHvoMO2
nWM6imiYp/LBoSzCdWH3Ip60V1eHu3T1tqbuJfvW3J67v62Qa4uwVg5S9yJmxew=
=an6O
-----END PGP SIGNATURE-----

--JPKYlvo4+BwO1+FT--
