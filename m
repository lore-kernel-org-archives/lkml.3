Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbaGCQSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:18:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:48433 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759457AbaGCQS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:18:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,595,1400050800"; 
   d="asc'?scan'208";a="564827296"
Date: Thu, 3 Jul 2014 21:47:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, dan.j.williams@intel.com,
        lars@metafoo.de, tiwai@suse.de, Liam Girdwood <lgirdwood@gmail.com>,
        joelf@ti.com, nsekhar@ti.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v3 3/5] ASoC: generic-dmaengine-pcm: Prepare formats
 mask for valid physical sample sizes
Message-ID: <20140703161708.GR2296@intel.com>
References: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com>
 <1404363116-10538-4-git-send-email-peter.ujfalusi@ti.com>
 <20140703120153.GZ410@sirena.org.uk>
 <20140703120256.GO2296@intel.com>
 <20140703134210.GC410@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G6nVm6DDWH/FONJq"
Content-Disposition: inline
In-Reply-To: <20140703134210.GC410@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 02:42:10PM +0100, Mark Brown wrote:
> On Thu, Jul 03, 2014 at 05:32:56PM +0530, Vinod Koul wrote:
> > On Thu, Jul 03, 2014 at 01:01:53PM +0100, Mark Brown wrote:
>=20
> > > Acked-by: Mark Brown <broonie@linaro.org>
>=20
> > Do you want this to go thru dmaengine tree??
>=20
> Well, I was expecting either ASoC or core ALSA.
Ah okay, wasnt thinking ALSA, either ways am fine.
Usually its asoc/dmaengine :)

--=20
~Vinod

--G6nVm6DDWH/FONJq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTtYIEAAoJEHwUBw8lI4NHohkP/18dbjAFf2WKADmVAG+UoBAl
NHM+PjEMiWhvZOQ2MhCZsZ5skp8FE9AFZ8eqiRssrQtunF47o3MvFNqdY0Uao4f7
T4I3jLjAZtex+cXA8+d+70p5OJTIvFBA7XmkolfyN6L50CdP5RYs1S1pRjOBBUfc
cmwp5rjYjDLgvuObs6fdnFwqa+zAv/0Bt5wUpspsGPz8/Vywod1MG/fwspDnO9FY
cXlA6/8asbtM9zw5XFH5wmWO+wGIbQSjWicmZtii/j9qE/Aj6u56ABYGH6kgXehj
YlQo2+iDmRWNF1AmpRNFQSvIsYVJogqgI670W9w0EH/fJtfmivmNAlTeK2hEloab
ZOcIrKjjXglaz6kANZPTtOKrqiPyt8TlLHYkUWNxcBYJLQZfUZUCkCL1HI9H57TQ
8RkUxanLGiAaOh7rSN+PuySeFn6hJ3Xo7JFK91rzYqfI6sYKPFz5UIjLNx2seprB
ZOH/SCqx67o0rhv+SDpb4g8VXau91RQwG9zXeQoi1vc8x/m44EeRRrrl+mvhrXP/
TWPOMXLa9kLxoTcKhNxPSt1p1cLMBAZ+oZoxFZWv9k4cprA/2FZKT+zzMAfhpDQ3
oHU3aylzPZyCj2Qgvc5LXiMh5aBMctIApA/lPy6Qm+0QZNp+fNo9hKBuawPl0hx5
f2LUOIilwWSSZoSGYTMC
=Us64
-----END PGP SIGNATURE-----

--G6nVm6DDWH/FONJq--
