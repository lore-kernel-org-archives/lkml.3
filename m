Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3AQLw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:52:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48314 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3AQLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:52:26 -0500
Date: Thu, 17 Jan 2013 13:52:05 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 00/22] OMAP USB Host cleanup
Message-ID: <20130117115205.GJ18978@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYo4Elh1vtcYNvbq"
Content-Disposition: inline
In-Reply-To: <1358422231-24736-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zYo4Elh1vtcYNvbq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 17, 2013 at 01:30:09PM +0200, Roger Quadros wrote:
> Hi,
>=20
> This patchset addresses the following
>=20
> - Consolidate USB Host platform data.
> - Avoid addressing clocks one by one by name and use a for loop + bunch
>   of cleanups.
> - Get number of channels/ports dynamically either from revision register
>   or from platform data. Avoids getting clocks that are not present.
> - Add OMAP5 and HSIC mode (Not tested).
>=20
> v7:
> - Updated patch 4 to not hold a spinlock when using clk_get().
> - Updated patches 3 and 11 to return -EADDRNOTAVAIL on failure of
>   demv_request_and_ioremap().
>=20
> v6:
> - Added USB Host platform data consolidation patch as the first patch.
>   based on request from Tony.
> - Rebased on v3.8-rc3.
>=20
> v5:
> - Rebased on top of todays arm-soc/for-next.
> - Removed the clock merging patch from the list.
> - Updated patches 14, 19 and 20 to accomodate the above change.
> - Added patch 22 to fix a build warning.
>=20
> v4:
> - Added appropriate maintainers in to/cc.
> - minor print message fix in patch 23 to maintain consistency.
>=20
> v3:
> - Rebased on arm-soc/for-next commit f979306c4d38d213c6977aaf3b1115e8ded7=
1e3a.
> - Rearranged patch that get rids of cpu_is_omap..() macros.
> - Coding style fixes.
>=20
> v2:
> - Clocks are allocated dynamically based on number of ports available
>   on the platform.
> - Reduced console spam if non critical clocks are not found on the platfo=
rm.
> - Get rid of cpu_is_.. macros from USB host driver.
>=20
> cheers,
> -roger
>=20
> The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e=
20:
>=20
>   Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)
>=20
> are available in the git repository at:
>   git@github.com:rogerq/linux.git linux-usbhost12-part

not everybody has account on github, you need to set url to something
non-authenticated and pushurl to the ssh url.

anyway, after fixing a few comments on the patches below, I guess this
is all ready for mailine, you can add to the entire series:

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--zYo4Elh1vtcYNvbq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9+XlAAoJEIaOsuA1yqREpxkP/1ysTu7F6RVv4vjqVAmmELM5
qWm9PVnIx4Iy/TuBY6QBZH+aXJ47EBr4egpklKpM6FcgIA+koXQ2ff9qQcqIryzM
42Av2dqtXATlOSV+5D7CwCzy91T2rHX1WTtOTs5UQdyIZm4i5X6qoT4QfV6RwlA5
KizxWih5hiVwmvh/LaoaM/OfBpXgSaZ0NhZQAKiBlCjch8PyKrqDOYey8uwwQLq0
vzz2wV2CkKSNU4DFD9EiI7qQv5oH/lFY5m8aBgY9R/LzPPt5p5HdbMcLQt2+rl3H
B0ZqUIG9fOpfFTbCp+cPyPnbdL4G+QGDVRF3PMe/SeYDJgJ2qg0VYPQN74JmIVU1
ObLfTarZAxvX684mGYM9WciUJvAWCgYDBdDelmGOpWeQvnoMIKzsdORTMN8ffWNx
zLsLHhk4HEQNtxDx6B7LqWiSrZxHmGoGVgZx7OD2FMiLVR8CxN8CcpRqEm1Eo6dL
esgf9rmMepoYSX5j/kZu37YU/k7V8ZcDmSukcVZ7TJn+C/pqREqlfJlGvkWCNUa0
JGpscDvQI4FumqDP6rhWJxoLnDA9lWE05KnQYdRG+BS96BKxsUe4CyGQoEsXki7l
UkAO2er7uGaaySzpGpEcZN59myJrWTgAYB5DPfAMIOkxstqj+Oaw5/Brro7T8gtL
9Ue081gnusYmsEhankS/
=yNcU
-----END PGP SIGNATURE-----

--zYo4Elh1vtcYNvbq--
