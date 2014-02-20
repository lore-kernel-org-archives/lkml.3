Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaBTLXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:23:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47237 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaBTLXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:23:09 -0500
Date: Thu, 20 Feb 2014 20:23:00 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140220112300.GY2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-5-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gmML91PkUQnsc+kj"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-5-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 05/23] regulator: fixed: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gmML91PkUQnsc+kj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:05PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--gmML91PkUQnsc+kj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBeWRAAoJELSic+t+oim9JZUP/1PFZ21yvUf/NQD8MPStBwwn
zAtV/kKeuwc9yJyS/qFwIuRw7wb3RLAHDE+FkY7GoXFqucdKHZTOB1m74V/Y6DX2
vUN0mFy9yVLdiQBQctqABwLT5t+a6Tb6Oo/t546V8V5LrKWpptaHco3Zr6jeaCIx
ScvsZC6y2VDurh7EDMBkj8zlxgFG8kMMZsyWaFuxZs9b9s7GLyt7T0kxdSjNZzv8
zWuO6tXVM+00Qth3v53hykV6floSN/jm1aM769UjtLuCjx3OMVGndcq84zbu/ddG
wry6camO5wKM1repy0apQqe1UQ/EtMD1RvO80q1rY4/Pudy1u+CIAmzV/kYd4mjl
o7zVYqGg0/7td9RWUZB0Hd1KstMaWvlNMxeeC7tBJ9lD8FJBr1ZuKUgD514Rs3rZ
gZ/wgPlNYJ5Wt6ZSSjAz84gHOqc38NGYyWIt8Km9xMdU8xzyI4skbzJQFt/RzDl+
lyMUT3JRfYwPNTTuiFgzAjL68fcPliCHPy+hdQZhL7nqR3VkILdx/WwMv/HyYoDV
+gdSo7ICLJXoDv66YjzuV0Eyw1ImvEItWdDRTmFc1n7gh2MdMJsDG6rNKZp38sfE
+wU3j923hUwpgtwqTIe6mysvDylRI+dCeVDxJpdMY6CsVWSgFxz83TD++SQPvfVu
AyVAMa79JwtZJK6kneaP
=xoFj
-----END PGP SIGNATURE-----

--gmML91PkUQnsc+kj--
