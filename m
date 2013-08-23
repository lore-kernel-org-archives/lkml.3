Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3HWJ6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:58:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38554 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab3HWJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:58:54 -0400
Date: Fri, 23 Aug 2013 10:58:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, swarren@wwwdotorg.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, rob@landley.net,
        lee.jones@linaro.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, kishon@ti.com,
        j-keerthy@ti.com, ian.campbell@citrix.com
Message-ID: <20130823095841.GG25263@sirena.org.uk>
References: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bO4vSxwwZtUjUWHo"
Content-Disposition: inline
In-Reply-To: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] regulator: palmas: add support for external control
 of rails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bO4vSxwwZtUjUWHo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2013 at 04:18:16PM +0530, Laxman Dewangan wrote:
> Palmas rails like LDOs, SMPSs, REGENs, SYSENs can be enable and disable
> by register programming through I2C communication as well as it can be
> enable/disable with the external control input ENABLE1, ENABLE2 and NSLEEP.

Acked-by: Mark Brown <broonie@linaro.org>

--bO4vSxwwZtUjUWHo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSFzJOAAoJELSic+t+oim9aIMP/jXvUIcw3uShWBgbc5Y6NWZf
JzPcI3aIhge/ATd/5InQ8ZMOb8cZgcPEf5OzCdwQ+P+j8sR0n8CzK2xzZCPDGN1G
qdCwEK0D8Nimq/DDx3L65b7/cGp9xE6nDaAt5evEznL/wjbdjEau3zOvewYt78WP
aPWguzis+AShFpJGDJ+mMoN9d/SO4tnnDHmxBwkat/lva49rkJeL/EH5itNJfYMy
rR4FIzKO/7Aw+lMGf3MTahF3bk1BvYp5TyBbUDRz+fYLh081XIWUwInbgf7xpBDv
mgZ7+IKREy7LDcxcU/XmTh4I6pblP/PQ4XFwGGhLDE04SGftlUhK4RCPUaVU4rKj
VkaeLFFXDL4KzEDG+uM8qAaaEROxkTpJMH842L+FDAw27sKR+YiXGWQNO2TrD/Hu
/Nk8WIQ7NciFXDQ6N35T4o71iVdnmlg6v7/1xqQyZWcfBQ3UGvykiZ52UHPp3Il5
pZHtCtTcH4rr1E6T6W0TtaH7GhnQERqEwge7a9xUYBt3hFUCPVHnbe5xBez9QCww
um4O3NXv1LS/AIAGp6gFDNsCPN6kRW4/yQNLBBB5eQ3cP9eswV2+BNk16KXioa1o
bodNqN1dc9uTZ9Sm3DFJw3jtU/WqKmCmEW60q8Q7JrV106p5IIcihkC1krotznru
6S3wH8HOG2JK5r2sQMdJ
=5yDo
-----END PGP SIGNATURE-----

--bO4vSxwwZtUjUWHo--
