Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab3DYKwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:52:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53146 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630Ab3DYKwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:52:03 -0400
Date: Thu, 25 Apr 2013 11:52:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Matt Sealey <matt@genesi-usa.com>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: mc13892: Fix MC13892_SWITCHERS0_SWxHI bit in
 set_voltage_sel
Message-ID: <20130425105200.GN5019@opensource.wolfsonmicro.com>
References: <1366775472.22788.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j1Wwy33+dU2Jf0xa"
Content-Disposition: inline
In-Reply-To: <1366775472.22788.1.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j1Wwy33+dU2Jf0xa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 24, 2013 at 11:51:12AM +0800, Axel Lin wrote:
> It is necessary to clear MC13892_SWITCHERS0_SWxHI bit when set voltage to the
> voltage range from 1100000 to 1375000. Leaving MC13892_SWITCHERS0_SWxHI bit
> untouched may result in wrong voltage setting.

Applied, thanks.

--j1Wwy33+dU2Jf0xa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJReQq7AAoJELSic+t+oim9ygIP/1WGfD+IzXpVZ8nwB/s3rkno
B/CCHym0kkXcNRPkcLgnYqNUTQTytfI3On7EUaVxGi3h4GINqpYXoFaCvpHDxW2D
ylh2VWlTAKjCTqom+Vt90GXRw7pRhaRiPGdZ2R8C1mTDJSIsbW7oFJmFzU7VLzPB
Mq+W5EO5u5jqVTFGv0dbYYhPrJAVUNYBrHNRmSd6A2zaJOJcRUnXPg9hXC1FdkIT
iTanX5CAtptxAGN1B9znDSlIDPFnjLDNtmoJGlo71Vmh7vxcSTdS4e0Wl+zzrDUs
l2znqZZokoEuSv2iwB876NtPRrKs/Og5Q60T8HPRrtyMj1gz31w+CJyk0fRn+PQy
tOtRgD3/m9zMRVXMv/KUwQxHrrM76+5Hr62q8sOF0ZJUvfDTxosrxFLJfa+Lnr0J
C1R5hfTwqSip/fnvGeVR0xv8oxqtgqy4OS93pMsuHJkhl7Ly3IUea/8RwRsnWA3n
NfpEfu/EjWpM4eqyURw17tLjeiWqY9lHEZksmkqVw1acASkFXWg8kygiOQMX5rlq
p1v3fm6mjn0ZW/kMW74zPc/JnJ8RymS2nQANWB0+2avAfXbrNHrIgL9uJ8+EV/2Y
eCX5ebRDHYRaNxqzUsvEjOW3x9KkvjSiYlhvV8rLfve30+E7P2jBfP7WUOPDmHZX
NuyV/zp2VATDASfgRWrT
=y4zq
-----END PGP SIGNATURE-----

--j1Wwy33+dU2Jf0xa--
