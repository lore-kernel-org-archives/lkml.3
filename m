Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbbAWWi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:38:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40971 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbbAWWiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:38:24 -0500
Date: Fri, 23 Jan 2015 16:37:45 -0600
From: Felipe Balbi <balbi@ti.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: perf not capturing stack traces
Message-ID: <20150123223745.GJ26557@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <20150123195128.GE26557@saruman.tx.rr.com>
 <20150123205959.GD3073@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tAmVnWIZ6lqEAvSf"
Content-Disposition: inline
In-Reply-To: <20150123205959.GD3073@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tAmVnWIZ6lqEAvSf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 05:59:59PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 23, 2015 at 01:51:28PM -0600, Felipe Balbi escreveu:
> > I'm using v3.19-rc5 on an ARM Cortex A9 board. Unfortunately, perf is
> > not able to capture any stack traces even though I CONFIG_STACKTRACE,
> > CONFIG_FRAME_POINTER and CONFIG_ARM_UNWIND all enabled.
> >=20
> > I wonder if anybody else is facing similar issues.
>=20
> Did it work with a previous kernel?

haven't checked with this board. First time I tried to use perf for
anything.

--=20
balbi

--tAmVnWIZ6lqEAvSf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUws05AAoJEIaOsuA1yqRE8tsP/1RWi5wlQCGuuuGV/pYWw9va
iQUmX3q7q5vB00pPEEwmlNr85/NdA1xLZ00W7jEzhOGe/ysbu7dNQVtfJG0Evg0x
hQQG+mV/3ylkSd4BjzEs8Ar8f73zo9SxXLvhgzS4q1Gakz78C4577wklUuOO/Yj5
Afc9yZPmhoh9+7pTyKMfxpJmaFiv7WkO1xL4oKBhIALLafIddEXBItcK+uD9Qa+C
vgJaSHW13+PKd0SP9erMrIqmUWwgtUucU60BZtRZPJgVmbxtUYuAQ9EfZeXRNfDc
C2LmMZrgiPRW/w3SeiaxkqInb5nRIfpX6T/3Ozb74hy21dCZiUegCjjOafRUXiqV
61Cjc2e3psCTqDh2FXV2IN0quucY8kfRPsi8fgjq2N/HPkjTYb/meYe8aVZjpJpL
SQZEptkrbRNUiC9ATiurKG2ae6pTe9cpCB2nSUFgohCYpFKLSKoikj67Oz/ZuiRG
Lv24kx4S0gDrbV4MMiCavH7xYqGGhas//0v8mko5Mv3aLPKeF3Tfp+NQoKJrvYkC
zn3I/Rq7JRGKkvkPUISecwcEcEKa/jOd1CMt9S6qjvJkzGh/zfYTayxpndaD6GGF
pBdg8PxTioriHsBPbTKzpTgyv+NXxF3P9avx7W0svMUwsRndaHh8FShlxYH5Szx9
6/wqVAUfQFPv2fo7NsGH
=ZdoC
-----END PGP SIGNATURE-----

--tAmVnWIZ6lqEAvSf--
