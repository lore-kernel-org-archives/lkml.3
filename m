Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaGCMEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:04:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:24741 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbaGCMEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:04:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,595,1400050800"; 
   d="asc'?scan'208";a="564686902"
Date: Thu, 3 Jul 2014 17:32:56 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, dan.j.williams@intel.com,
        lars@metafoo.de, tiwai@suse.de, Liam Girdwood <lgirdwood@gmail.com>,
        joelf@ti.com, nsekhar@ti.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v3 3/5] ASoC: generic-dmaengine-pcm: Prepare formats
 mask for valid physical sample sizes
Message-ID: <20140703120256.GO2296@intel.com>
References: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com>
 <1404363116-10538-4-git-send-email-peter.ujfalusi@ti.com>
 <20140703120153.GZ410@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
In-Reply-To: <20140703120153.GZ410@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 01:01:53PM +0100, Mark Brown wrote:
> On Thu, Jul 03, 2014 at 07:51:54AM +0300, Peter Ujfalusi wrote:
> > Based on the dma_slave_caps's addr_widths queried from the dma driver
> > prepare the hw.formats mask to include only formats which is supported =
by
> > the DMA engine.
> > In case the dma driver does not implement the slave_caps the default
> > assumption is that it supports 1, 2 and 4 bytes widths.
>=20
> Acked-by: Mark Brown <broonie@linaro.org>

Do you want this to go thru dmaengine tree??

--=20
~Vinod

--3siQDZowHQqNOShm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTtUZwAAoJEHwUBw8lI4NH5MYQAIRfhT9eWWiu+M9mseyyTk8i
s1XFyZPOS8tQCbBmzacKsH8hxninEZUAEl1FUpOANin6vI7vggmB2vi3DvRmLwxw
vXoi/71kIPvQvhYIwKR20psHE9fYFIDt5ZTz+QipB684QOO6h3b6eZ+TtF5cY4Pw
trCHZItAjeWPRCRQVj6p+tk74RdKpwVixUQKa1b33Rv3BDzD3dpIDfBVeLu2yXd9
9S9j80vpg70MG2qvMC4XHwtJq8RdYx6bxGDj+P2QcpZLjYsRU3tUSiY+3QcE6oya
Rx9L/R4BioTLhm8+N9jK9GxVIJgZd7RbI12yi/L9UmAEB1SQwGYPSfHpgjP8aMEz
H45iHkWyqHXZ2jUUmjp5s+EyZMBwwbELXOLIbxLUBlLw1kDgou6LLfHm8Io9tq9j
cH9CG1n3jWKywuVbCIY7V7EGyhiB1NKHPEonAvope2zyVBXFuq3wZnLTvJ6zodCz
wsHahybXrJHb2qMg7qK6eABG+XYxOTGJrmVAFFobRP7D8dPRUeoi6eLe7oG3Pu6g
fqgCK0liwiXwISYEOY9bDpcEWKnvsOEFYj9/b7TqJx7D75I/Pjvziy4zmNn3Z8LC
8iCTjMzn3SVg1mJIZPgSUpfP/sZcZ5o0XCHCouJiGKLlql6sBDEANJgp9rEyC1Ey
LcV5jopjeJGNQV6eeG/0
=1tAG
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--
