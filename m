Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaJOOEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:04:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56300 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaJOOEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:04:06 -0400
Date: Wed, 15 Oct 2014 16:03:37 +0200
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Romain Perier <romain.perier@gmail.com>, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org, robh@kernel.org,
        mark.rutland@arm.com
Message-ID: <20141015140337.GI27755@sirena.org.uk>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
 <20141015124142.92D0EC40B00@trevor.secretlab.ca>
 <20141015134245.GH27755@sirena.org.uk>
 <40398493.mf2VbOGMuV@phil>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Av0MaMCQQeg4b3so"
Content-Disposition: inline
In-Reply-To: <40398493.mf2VbOGMuV@phil>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC v3 PATCH 1/5] of: Add standard property for poweroff
 capability
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Av0MaMCQQeg4b3so
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2014 at 03:56:03PM +0200, Heiko St=FCbner wrote:
> Am Mittwoch, 15. Oktober 2014, 15:42:45 schrieb Mark Brown:

> > I guess I should apply these (except the DTS update) since the first
> > user that's being added is a regulator driver?

> I'd think so.
> In any case, I'll take the "ARM: dts: ..." patch if you take the others.

Sounds like a plan.  I just tried applying and got some conflicts but
I'm guessing that this is due to changes that are landing in the merge
window so I'll try again once -rc1 is out.

--Av0MaMCQQeg4b3so
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUPn64AAoJECTWi3JdVIfQGQIH/A/b6j2HDLcddduEyBGASorE
5o0VdPyRTSWto0Gg4Ki2C1rJyNvUFFS/AAnC49uZS1nFFdSw+9lw8M2YJjtbTd7F
bwDQVavDbqzeiZN3ZuBvX81uhFzQfF18LN02JG7jvh8Amunq7xMtlX0VG447cje/
FYf9KT1mEITTIxC2MxTMnbGNMzXcZHoVQmSKEuXqDmjNJ1XOUi00+aPB50PASuk/
hLXXiRtS8x1iZwe0Vl+qXQBzwbsKQuVtyZwp/yphYx5qgA3WAJgCt5A/HbnqHZVg
v/Xc7X0UOzTZnWrGMBW58Bb1KU/9b4s/qiUBdkGOFKAO1wBWnMhsyP982bUnPRU=
=Cr1o
-----END PGP SIGNATURE-----

--Av0MaMCQQeg4b3so--
