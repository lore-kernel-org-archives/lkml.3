Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3LJQeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:34:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58297 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab3LJQeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:34:02 -0500
Date: Tue, 10 Dec 2013 10:32:49 -0600
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 08/15] mfd: menelaus: Pass menelaus_chip pointer to
 add/remove irq functions
Message-ID: <20131210163249.GF22750@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
 <1386606085-26838-8-git-send-email-balbi@ti.com>
 <20131210090021.GQ12675@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vA66WO2vHvL/CRSR"
Content-Disposition: inline
In-Reply-To: <20131210090021.GQ12675@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vA66WO2vHvL/CRSR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2013 at 09:00:21AM +0000, Lee Jones wrote:
> On Mon, 09 Dec 2013, Felipe Balbi wrote:
>=20
> > Those functions are static and can receive a menelaus_chip pointer very
> > easily.
> >=20
> > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/mfd/menelaus.c | 57 ++++++++++++++++++++++++++----------------=
--------
> >  1 file changed, 30 insertions(+), 27 deletions(-)
>=20
> Same here. I think this should be done in one fell swoop.

then it would become a much, much larger patch which would become a pain
to review.

--=20
balbi

--vA66WO2vHvL/CRSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSp0IxAAoJEIaOsuA1yqREUe0P/1gySk6TH9X9EPDRqQ2G5SVF
w4QNBiZAUuX6JmKh5Im27q0mrSmFn+QhVV57tNi9Y5PkhDhcuvN7qd4D9X5aFKVY
M4D/JllahafLXCvJ6ZPeSVdR6QnApK1nIpZSgackPrhNQ0StklRq/NLIiIWDQf/7
/VHN2iUahsPBgfyqTEsAQQaHVeOI5Q6KdJztDa6sderTNQPFX49pi0+mPuk5liUB
i4vjGWrSLQKnRiZvtsOl+1l7T3N6eOQxs5LDHupMrod5dy6LWj/45bMp4sOWiQoj
rMEDQdiyxSjQLQY1d5Brz0wkRgKJC36TFfPL8N054MOW0u+lkChmSWGCh066QoD6
XlclR2VTSdk8ZNlwm3sYhauHX6RD4+ppuZbyQJyh73MD7/BU6hsvupZEI1yp9cK4
SeOda2PVNxUGMVdR3EVgnGY1nSeQnxc8WuOv8R7kDXEjEkehMFFFcMVZl4NKgESd
ggz8o/DqK6ydIZ6uttDjJ8WjsMWc7c8GGxeLUPSwYRnorN8vKrQ9cgOytJkt1kcv
up2FtjNtGW+aZbzzj5IxjVRjoQXek5wC6tktPFWNpOLGd7e8PXTSc6q6Wzek416D
4EXQcUqYtuZv9WFJchHNx++rzT7fCVy5+22Xp9pCQdiENUEfuPbR5gU8OGVZbm3z
ZC5tsSQN+YlxzoTi3o5b
=ex5f
-----END PGP SIGNATURE-----

--vA66WO2vHvL/CRSR--
