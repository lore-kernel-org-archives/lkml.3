Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbaGUMSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:18:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47823 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbaGUMSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:18:40 -0400
Date: Mon, 21 Jul 2014 13:18:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <bcousson@baylibre.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Charulatha V <charu@ti.com>
Message-ID: <20140721121820.GW17528@sirena.org.uk>
References: <1405683053-14104-1-git-send-email-LW@KARO-electronics.de>
 <20140718171035.GQ17528@sirena.org.uk>
 <20140721075144.251bb67d@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H25ow1gEc5p8sQPX"
Content-Disposition: inline
In-Reply-To: <20140721075144.251bb67d@ipc1.ka-ro>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: omap2-mcspi: fix blatant abuse of the resource
 subsystem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H25ow1gEc5p8sQPX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 07:51:44AM +0200, Lothar Wa=DFmann wrote:
> Mark Brown wrote:

> > I'm not going to apply this with a commit message such as the above.
> > Quite aside from the tone the fact that it doesn't describe the issue
> > is not helpful for review, one of the things done in review is to try to
> > check that the change has the intended effect.

> Maybe the original author or the maintainer who accepted this can come
> up with a decent fix for this.

Just to be clear the issue is with the presentation of your change, it
is not appropriate to provide a changelog which consists mainly of
widely directed personal insults especially given that it omits basic
technical content.

--H25ow1gEc5p8sQPX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzQUIAAoJELSic+t+oim9Q58P/jC360Y7iq9npvSiol1xL6hH
vja+q9PZe6hZBdjqsvM2mhIaCmTcKGexOTlquBkafYZlZrFUxUpH4LkgE9TZBOz8
X4UUr1M1N1bi3gCUYlNYiGPl0cx7tar4r2iv1xEclI3DvN2Q/jFGOQEFzwFrtJcY
L8DQjOn6TIwl/S43mYcly5E7AobuZGkmghMc6h8gEyhZQ+imSA/xj8KvvKGf4lAF
UX8L76X2cuaArCr1aEVp5orgaOnGxmeewmJPfyZ5pxPTZjNCFz/W7OjfOkPVlS97
Alc/4drzhyMRiJu4IfrUaDqsuLOkJVqoV7zir/ltS6PmDgRKcife6SphZx4kABss
FL69UO5H1TvUqnpTF/qevg+2Yo+UyzzxDkkHGWfso8YyuSb0xClEAJ0mjF9MBwsx
VRxl9bnfi1vOB5pkryZ97s0TaLnH4DOZYi78D0AwHAFY3CE4xqf+UUOfFcuw9oOI
Kdj3LedOfQvwDIZJ/99AzF/dmTBuGgVuGj68PJ35DX9dmZ7RMO7NdWCQmzY0wPAX
JfQQlhw2SgcuZ2AEmRHMIduSiWvi2nNokoqSd7lYzvnAnY8JlO9JFKjLx6zU7Utx
AR+q46BAtju6oF4zbvVgu5zvP6blHP2qfVoQAU2LEXvUnUwoDUkUVcCLiN7ZOc3G
eXBk1FwoiafhpRn0HEuq
=HS4X
-----END PGP SIGNATURE-----

--H25ow1gEc5p8sQPX--
