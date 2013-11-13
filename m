Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab3KMObe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:31:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:49955 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759084Ab3KMObb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:31:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="asc'?scan'208";a="434618081"
Date: Wed, 13 Nov 2013 19:05:36 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Florian Meier <florian.meier@koalo.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        Martin Sperl <martin@sperl.org>
Subject: Re: [PATCH] dmaengine: Add support for BCM2835.
Message-ID: <20131113133536.GZ8834@intel.com>
References: <527D1DDA.2040004@koalo.de>
 <20131108181743.GR2493@sirena.org.uk>
 <20131113050017.GO8834@intel.com>
 <20131113125111.GE878@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <20131113125111.GE878@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2013 at 12:51:11PM +0000, Mark Brown wrote:
> On Wed, Nov 13, 2013 at 10:30:17AM +0530, Vinod Koul wrote:
> > On Fri, Nov 08, 2013 at 06:17:43PM +0000, Mark Brown wrote:
>=20
> > > Adding in Martin Sperl who's been looking at DMA with regard to the S=
PI
> > > controller (which will want non-cyclic mode but I guess there's a lot=
 of
> > > shared code).
>=20
> > Is there a plan to add a library in SPI for dma ops, on lines of what
> > is done in sound?
>=20
> I'm probably going to be looking at that at some point, though perhaps
> Martin will get to it since he seems to be looking at this.
Okay sounds good. This will also help in streamline the implementations..

--
~Vinod

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSg4AoAAoJEHwUBw8lI4NHxJwP/iL+nkFcKmg18yC6Vav+mtc1
mqEMa2wU7W/moUxuckpzPhnuPo2OjP6QYyt7NboQHtOTH5xCJXOtD1s5P6QJvFow
dziG2YW9uFbLlDOeGTdRTJeOVZtbFg2V+mC0/prVwvAPhYmJQu7ScMpRagpe1//5
d+/g0ZEbrxfap0S4oMJVL/tsRWT0UtlPCja0kCwFgqtF4lk8A9PIg9Il6WbVaVKu
hDSlgapGU7VpvWE0rPA9qc5AGxJcILGUFM0Rt+nj0+8wqLhr9XmNNr8Ppb3euzc2
tjLrHGhreuntGkD2nU/t82OZ0e/nODYIZRoSuwaA2xKIPPo6OCUIMFM9jrye2tz0
qSsPB6h2oXtjq3k4ffxRtdT/6GaSe5u58OSPRim0lXjm8YhPypIbvAz3yoA/ThyC
rnC3PwspK7MZY4r3uP6IBQZeJgR9yjMaiYaOwfMqQ9zRodpZLuKlrkiynRleeUR9
q/SP9bp0GVdrXsKjbR07QJLe8I8JkNk0tk1Qfcs/UHiinc0grY9qmJdwYPIIvqB2
wcnQX3dXRj6Jm97kU2B7amryy+WRuCCvNwF5kJrRR1/Nna6xPa4dtd2iOherMSJ5
1307zGfAGokY3nM5L/20C4/SCXg37FpPdWIBdkqiQvbXXi/25ZSdG2wqkaFeJ7i3
SVC8cFBvO9+CXRg2UuWi
=FCN3
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
