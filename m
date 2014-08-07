Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbaHGJps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:45:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51109 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaHGJpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:45:46 -0400
Date: Thu, 7 Aug 2014 10:45:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, b42378@freescale.com,
        b02247@freescale.com
Message-ID: <20140807094527.GC17528@sirena.org.uk>
References: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Gpwijd/hIJ1U6yrH"
Content-Disposition: inline
In-Reply-To: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Add asynchronous mode support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Gpwijd/hIJ1U6yrH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 05, 2014 at 03:32:05PM +0800, Nicolin Chen wrote:
> From: Nicolin Chen <Guangyu.Chen@freescale.com>
>=20
> SAI supports these operation modes:
> 1) asynchronous mode
>    Both Tx and Rx are set to be asynchronous.
> 2) synchronous mode (Rx sync with Tx)
>    Tx is set to be asynchronous, Rx is set to be synchronous.
> 3) synchronous mode (Tx sync with Rx)
>    Rx is set to be asynchronous, Tx is set to be synchronous.
> 4) synchronous mode (Tx/Rx sync with another SAI's Tx)
> 5) synchronous mode (Tx/Rx sync with another SAI's Rx)

This seems to conflict with something else on my branch - not checked
what.  Can you take a look please?

> +Note:
> +- If both fsl,sai-asynchronous and fsl,sai-synchronous-rx are absent, the
> +  default synchronous mode (sync Rx with Tx) will be used, which means b=
oth
> +  transimitter and receiver will send and receive data by following cloc=
ks
> +  of transimitter.
> +- fsl,sai-asynchronous will be ignored if fsl,sai-synchronous-rx propert=
y is
> +  already present.

Might be worth printing an error here.

--Gpwijd/hIJ1U6yrH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT40q0AAoJELSic+t+oim9L/IP/09XmprJfNXyU1qqKlJhv70c
tj+U4iIPJlroeCqeOWfpG4qfqsJ8cGKkT7y9/c2+MFbh5aKn4yD8/WaG9gBzDZ6n
WwXLuD5c/yaAhWnlN2ekYOS7oG/Odzmb//BZNnPssxQW21hR8pqAT+KgUN6waslu
qlv7s/p1qqg67J/bEzHeh+D9VhCJooVdRvl843TDDZDUeaM/PyXOyJKpz8KawSs2
Txn5PKLh6UOOFSHQegZ7i84k8gjEwo0Rtl3edLtHjKUKGZf2azDrd4iffb9heiGH
OXb+N20qzFgCi6afkzx8B8fU4vvwd8tCGALe3kiStokVfYZvNG/2MB5MB7as+/7Z
XLpd1JCqJo3UXFBGS57RGH2jguIxla+0RJLbGMU4+4JCsHicUws3AqQl/yAtkgJs
2Xp++ABOQRum9jx/6q6LQfkegVzStr6KMC/aaIVUZCRFXRsdVpHMxqi/9hq7/7AB
ALG0R2J6qTCRTpCUNCmw6M+Xa0REODq4e6zZhyZy2UKrPwfYk1+f0HQfNTieCmmP
al8tU58vpKfMEjPSMcAA0SHb94VbBansfK8/43jm7itnVJYAZ6WNw5+nr/LmkmRz
gyh/7qrOeNml4NAs3CpPyrBgSP2CacH/LFpPEoDSytaPXbafUlisTtQBRDriYIRU
sO39I/WMNnI9lYcXI80e
=yhVo
-----END PGP SIGNATURE-----

--Gpwijd/hIJ1U6yrH--
