Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3GJJHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:07:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53387 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3GJJHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:07:04 -0400
Date: Wed, 10 Jul 2013 10:06:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@linaro.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130710090612.GC3179@sirena.org.uk>
References: <adbc806cd75b1c1ffd6382dc1dae425c71a93168.1373441121.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <adbc806cd75b1c1ffd6382dc1dae425c71a93168.1373441121.git.michal.simek@xilinx.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1] spi/xilinx: Revert master->setup function removal
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 10, 2013 at 09:25:28AM +0200, Michal Simek wrote:
> master->setup() must be initialized to be able
> to successfully run spi_bitbang_start()
> and satisfy if/else logic there.

Applied, thanks.  We should still fix things so the bitbang stuff isn't
needed but for v3.12 not v3.11.

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3SP6AAoJELSic+t+oim9q8cP/0MXUOmvAL4EKohj4A+M1dPO
Ck0BRU9NbfrC07HnlVwGqHaHG7sw/0UufP/XhHjYRDgoPQl2zwpSKm2LR7wch35H
nVfhNl95IkhYmg6bzdOu+uGi1SJfN9rMK2Lovhnf92pME1k7SWUfv5CUzxzqEipO
aWkaNi53jOVzHhNyECUFwutJR9CNESdR3XasUpp863zu/ZQQKosAn5Bd+Aw+nHvy
UfuU5ertRgduqF5969JZ1hMRadS+RehXlfPMxC+9Q33lxHenK/UVyVhKawebQu7d
sZv+i/JhqCHB1J2iWETyU50OvpWBFChUDzUJxmhTvDyXHXlXr+ue9ysWLRMOan5D
uQ6uY+yNp2oj0iEmiUwglnjLQ+L6gkIG7k7oTnbY5IEfIpmek6C6XifjqXNTyry9
KdFcuHc9PVU8vtK2pnQ4Cul2JmZ4ExBVbKRe/kCktJvYgoGH+LaCGA0bsGzr7BfU
m60VilA3KnhNGnym7ptsdx1AjrJ6m2jmujYd2dIWN4SSLuF1ZERAn6OuR+hdFpAK
GXl8ds7miKsfjiZ/VMI6cRtKnMxsabRTj+WxNZuflIB4tguorPCJ/K/FMYLbpR7U
QEjKaXeed0IBQdfXYTfVfPTt2BGRfMRQPWfLw5qSbfPzm7i0Qh0+gKA6W4WJX2VT
itoEt7gByI7ODOEug7mv
=sSDt
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--
