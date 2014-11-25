Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaKYRPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:15:02 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38271 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaKYRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:14:59 -0500
Date: Tue, 25 Nov 2014 17:12:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Lee Jones <lee.jones@linaro.org>, robh <robh@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Message-ID: <20141125171234.GH7712@sirena.org.uk>
References: <1416918506-9366-1-git-send-email-romain.perier@gmail.com>
 <1416918506-9366-2-git-send-email-romain.perier@gmail.com>
 <20141125144007.9904BC44343@trevor.secretlab.ca>
 <20141125145410.GD19910@localhost>
 <CABgxDoKUecAd00X0znkGiQncF4MwnLAM4BFV2AV_oMPF=4G7UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jLmGyUepE/aZfh+l"
Content-Disposition: inline
In-Reply-To: <CABgxDoKUecAd00X0znkGiQncF4MwnLAM4BFV2AV_oMPF=4G7UA@mail.gmail.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/2] of: Rename "poweroff-source" property to
 "system-power-controller"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jLmGyUepE/aZfh+l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 04:57:56PM +0100, Romain Perier wrote:

> Thanks for your feedbacks.  I think that Mark will probably wait until
> there are more reviews on this serie. (this is exactly what he asked
> for the previous one)

Yeah, given the amount of often late arriving disagreement I'd rather
let things cook for a while unless there are a lot of people being vocal
about this being what we want to go with.

--jLmGyUepE/aZfh+l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdLiBAAoJECTWi3JdVIfQRL4IAIT4N24elGdFDrN0pdCuPxOm
rfkI6Qp8RmEHCZqaU2O/lpjYGYfZ6yB+CggQb8Nxx52QBZ6w79nEQ+3RN8lWyadG
ZuJNl5m63kXILtCAtkgEgvJlfSeN+8yth0aQY5/mAcLxzmpnwuOt3/f3D+r7nw5z
Ux2rKzk7CyqDsh3J+4SNL3z0WAQhDs8TYxTpt7BbWsa4niMSU1S0wXwChXjXR6E7
eul+LaY4DdaL+jmvrYA/4oZZtrHNtrFkOj8WcGhdhAFprTqEkYM5LmcAA2vEueAd
Q5KcXntuqecXDgWq5moSHSzDH9ivhTJhhqOOUX7dFD7u34hHYL2sXM4tkt55iUA=
=PQ9m
-----END PGP SIGNATURE-----

--jLmGyUepE/aZfh+l--
