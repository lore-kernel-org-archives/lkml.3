Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832Ab3BNL5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:57:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46866 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759704Ab3BNL5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:57:49 -0500
Date: Thu, 14 Feb 2013 11:57:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regmap: irq: do not write mask register if it is not
 supported
Message-ID: <20130214115746.GF13249@opensource.wolfsonmicro.com>
References: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com>
 <1360761290-15976-2-git-send-email-ldewangan@nvidia.com>
 <20130213142036.GJ5062@opensource.wolfsonmicro.com>
 <511CC520.8050104@nvidia.com>
 <20130214113531.GC13249@opensource.wolfsonmicro.com>
 <511CD0A1.70606@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AH+kv8CCoFf6qPuz"
Content-Disposition: inline
In-Reply-To: <511CD0A1.70606@nvidia.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AH+kv8CCoFf6qPuz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 05:25:13PM +0530, Laxman Dewangan wrote:
> On Thursday 14 February 2013 05:05 PM, Mark Brown wrote:

> >This doesn't sound like something that should be open coded in
> >individual interrupt controller drivers, obviously it's a bit rubbish
> >that there's no way to enable or disable the interrupt but presumably
> >other hardware has the same "feature" and the IRQ subsystem ought to
> >understand it.

> To support such case, can we assume that mask is always enabled
> (interrupt enabled) so that it can be use in irq_thread to mask the
> interrupt status. So during initialization, if there is no mask_base
> register then all mask_buf is such that it enabled interrupt.

...and have any attempt to mask the interrupt return an error?

--AH+kv8CCoFf6qPuz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHNE0AAoJELSic+t+oim9m4AQAJcFa0xQ8Z+d3LCiIcuyoUd9
UPBqd5It30sTCSzyZLopbtGvowFwnM2C5YHLOclU+Rs+VSyMMybZPCGMC/fS0Ksm
H8YXS3nU3w9Fig2PWB68Et4cyqKKrKoFN8VrmPWFiU2u2AK1pL82KQMEIxqkoIDN
uXwzUnBvlb+GUlfTS+wSu0+UAkvtqmjdkNXUeSjI+wnq8Gw1AjTpedfznTWXKRvG
sintWec2rq4WNcs79kBNBN4gW624E8E80sClWcN2jBPI7Jaw0NDzHctqeoy7xVVR
/aOdz/ZcSMnZKwYwlQcklHHehoKu5lZPkXiJl3x0Rw8MKrs/f1GUTeMvVNbJQo5V
p4rVsYOhnF1oG4gr+x/JEg5k4pMX8PnYItD8iZF0ij+eO2l6XN7vI14Zt8QXZN/T
x4nyW3HBkdPdbK3Rafy/ElEyv7abjRMchdOdRP/m6U5BQ6UiZDOyb2sevHW6UKgH
yvK0pjofHvUVMWOJxmPuoMAhp9aduZbd1ZQ/wrRl8fE85+l1JQmh1JomNw1LY7nB
Z3IQGjIhLJOk/ZwhU3gefThFu/aGZpdZarIWBXqDIoKgAkloQj8EQv78Jy0sdyiR
nzBPZ3e//tplx1jthKSSoiTOBcKcZJF0ACdo3jLG6bbwLWkVnNixiBZ05Uu7HO46
kM2B+jsmNXnuPbAOIrg8
=+N55
-----END PGP SIGNATURE-----

--AH+kv8CCoFf6qPuz--
