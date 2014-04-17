Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaDQWGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 18:06:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47546 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbaDQWGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 18:06:08 -0400
Date: Thu, 17 Apr 2014 17:03:29 -0500
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <balbi@ti.com>, Nishanth Menon <nm@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sricharan R <r.sricharan@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 05/19] bus: omap_l3_noc: switch over to relaxed
 variants of readl/writel
Message-ID: <20140417220329.GF8504@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
 <1397767775-10965-6-git-send-email-nm@ti.com>
 <20140417215228.GD8504@saruman.home>
 <53504DFF.7090907@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBnjLfzoMQYIXCvq"
Content-Disposition: inline
In-Reply-To: <53504DFF.7090907@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UBnjLfzoMQYIXCvq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2014 at 05:56:15PM -0400, Santosh Shilimkar wrote:
> On Thursday 17 April 2014 05:52 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Thu, Apr 17, 2014 at 03:49:21PM -0500, Nishanth Menon wrote:
> >> Currently we use __raw_readl and writel in this driver, however, there
> >=20
> > __raw_* and *_relaxed variants are the same, just have a look <asm/io.h>
> >=20
> Except the relaxed version can take care of endian conversion if
> needed. :-)

right, but according to commit log, this commit is more concerned about
the memory barriers which writel()/readl() add, not endianness. Just a
matter of fixing up commit log.

--=20
balbi

--UBnjLfzoMQYIXCvq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTUE+xAAoJEIaOsuA1yqREzaoQAIImtV2Pt6Al5CViocqxiiTi
fEO/k96f49ypOuk1lNMC1PWYM02ClnuSwNu02my/LM0Ceyz+kPxhdbQWopWV6uAH
jSGdvUjIgI0kPIB/n4YiKA9usp5jer9fPufHa8v4YsYepu2FPApHYs6kZEkOhrZs
C06O9Eeu5RLUQ7AWx4Kfxpz2IYc5GWjZok+A2SHX/b7CmCgZwj8JcTfAVG2y6PD1
GHyUbOEc6kTWLg2fBAQo2/skBuAOB0e6z03Q/NvvUrBGtcyuIx8ZeJRlHsEki8wu
dZcjiYgXbpvTSpk4U+yGKtpFQGyjO/dfvwNxNEdxDy82zPLSR9YjbnKfOYa0GNbU
V4onhvFmgFvSFDJvZMTO5Tg2+8zEd11o/XL1ESmt+dXJ1yAOOR3PQPUXNCGhmGLh
3uFFApIthEDRw7DGKjnvyuoAA4z+YbIldDMoVBOJXK0gEI0u9zfsgd9aYRR9ZHaV
YSsk9bE9BaRVcwnBJ07q29hOeXSUd7t6UQ/IDJbCmMHC5L+8OW5bhPabY+Twguav
pdroFyElFv+P7Iy9l5otgasm6zyezSqP83v6idGRSVfHnk6eUwrymfuvJZE40g2I
ep9rAaXcR8VK0N3MazuMDgpuMYLhoTQDZNMbCIBKiEXp1Rthmyrwoy5/CohpQ/P2
rmxTUBm6zI3ldH8MftDq
=YXB6
-----END PGP SIGNATURE-----

--UBnjLfzoMQYIXCvq--
