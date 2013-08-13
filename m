Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3HMLGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:06:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47246 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab3HMLGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:06:36 -0400
Date: Tue, 13 Aug 2013 12:06:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20130813110632.GV6427@sirena.org.uk>
References: <5204BFC7.4090106@nsn.com>
 <20130809114426.GZ6427@sirena.org.uk>
 <52052401.7030707@nsn.com>
 <5209DD78.7050700@nsn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xV/tcm3TpxxBlS6c"
Content-Disposition: inline
In-Reply-To: <5209DD78.7050700@nsn.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regmap: flat: use the cache_present bitmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xV/tcm3TpxxBlS6c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 09:17:12AM +0200, Ionut Nicu wrote:

> Do you have any feedback for this patch? =09

Not yet, please allow some time for response especially over weekends.

> If you think the change is too complex, I have a simpler solution that co=
uld make
> things work with devices that set use_single_rw. Instead of enabling cach=
e_bypass
> in regcache_hw_init(), we could temporarily set map->cache_type to REGCAC=
HE_NONE
> and then call regmap_bulk_read() instead of regmap_raw_read().

Well, we probably don't want to be doing raw reads on random devices
though - they should really only be being done if the device can
actuallly support them.  Too much room for confusion otherwise.

--xV/tcm3TpxxBlS6c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSChM1AAoJELSic+t+oim9CZMP/2x1wOytdlB17whStBzZlvwN
Wa3LTMH3s73YqlUsWjHnA+sNdo+/W8OcNHNkLrGqofBfxc61ZUFRiS5EnltQU4Qk
1daNvpulUWJoh0unlM1Otz8OCSREoSvO0VM+QUq1DY3j89oo1LizUxoHymR+1Uhb
dmpgP3QVeX70PmV7f+dlYK2aAJhuwqceonHjgSqaB0qP6RpSzKDQx13SggtGyJ31
CS5KJCI69bXmQX2oHdCKS9EFa+7uxyG8vLIGQssXFjs/BqeY8m0+v6cE7QBp9MKC
aNdUCBDpZ/uj+tDfDsH2sUlVjdod4Oe5VcmAVYaKvVtWPh/l+BYoF5UlwS3Cv93n
Yp3o/7MZqZ2ndtV1sd2GCcZHduwvUovKar87zUyUuSbGHGyZdXg6pCMn7YYv3tVc
/4hAytMOc1Kn9mbtdxcdwh4WmKECZ86I9s4GoEpF0oGCYZdJeEAmwACB5mUOJtb+
n6d3iMVZ3Y60lB5gPK7E3BpemUa8t8eBAv9rObEjloeNRfIWzjZOW/In85YbX/z4
qTTmAO2jYHWr5HCxiQKInVQi9ff2wJgRtO877lIn0fFErZZivOuxSYlmFqiCl9rB
a0jqdgoXBmJ4Jhm1AHgHjROFq3tjrhEwKfBVL2N4oQnra5Y30vnyuRjXf21gcklM
d5KwH5kZQRi9dLevSY8H
=Grq4
-----END PGP SIGNATURE-----

--xV/tcm3TpxxBlS6c--
