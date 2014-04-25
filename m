Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaDYVBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:01:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44932 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaDYVBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:01:07 -0400
Date: Fri, 25 Apr 2014 16:00:36 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        <dbaryshkov@gmail.com>, <dwmw2@infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] power: twl4030_charger: clear IRQs after handling them
Message-ID: <20140425210036.GO29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397661299-31342-1-git-send-email-balbi@ti.com>
 <20140416163526.GA3049@atomide.com>
 <535ACC62.102@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sd7l8P2TFUHagl4l"
Content-Disposition: inline
In-Reply-To: <535ACC62.102@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sd7l8P2TFUHagl4l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 03:58:10PM -0500, Nishanth Menon wrote:
> On 04/16/2014 11:35 AM, Tony Lindgren wrote:
> > * Felipe Balbi <balbi@ti.com> [140416 08:18]:
> >> TRM says we *must* write 1 to each bit we're handling
> >> in order to clear the IRQ status and bring IRQ line
> >> low. This patch implements that.
> >>
> >> Signed-off-by: Felipe Balbi <balbi@ti.com>
> >> ---
> >>
> >> Russell, I don't have HW to test, but this should
> >> solve the problem you saw when not using battery
> >> with Zoom board. Let me know if it doesn't.
> >=20
> > BTW, looks like we're enabling BCI automatically in twl4030.dtsi
> > while the legacy booting does not have TWL_COMMON_PDATA_BCI
> > enabled for LDP. Anyways, for LDP BCI should be enabled for
> > sure, that's the only way to power at least the earlier LDP
> > revisions.
> >=20
> I picked up https://patchwork.kernel.org/patch/4002371/ for testing.
>=20
> Unfortunately, it does not seem to work in my tests:

alright, I'll have a look after I get this other issue out of the way.
Probably not until next week.

> This patch should probably also acknowledge that Russell reported this
> issue.

sure I can add that, although it doesn't solve anything as it is ...

--=20
balbi

--sd7l8P2TFUHagl4l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWsz0AAoJEIaOsuA1yqRE99YQAJxRRZwPXpOVgZTQIzwUNKh0
o866g/MT5rqOQJAPDMY6fp4MvQzPJPLaSfHqRAbVuR+9VF8ydIhdpGh/T9zj5pUI
QktZqLxWeFklzyCuDb/FZSIfpkEYlR9K93E/hmZ7lJcZEYTkjxsjvq83HSVpatQH
EEvrnde4Kgf2L2u4YhrH5B4DQxxoGAW58VLJ9U4JUw2qIOgUscwVQ+GxrsUPFovK
fS88a21GorjFGk21DOOiTPgEovYjoW4NkvflAktiB5/tF6otUoJchylTLSVhFxSf
G7MvQjS5FfKsOn8E6+bYzb/jX1bslWYHHnJ/LBhTWM7UVOUDiAf7dqJ/1Yk+feOC
k3zNA7flQbVFw1kszSgy+WFo6qxQ3KUeF46zJuE+TyJfGVpvSxVNs0UM8zF1T4ND
wwOMMaET+u0yHBdh0I4sNKTnUef1ve0sbj8D/auiRXcRBVS0pCa0RnoPWjYOEWJu
qdMwAJreWjbRH/9rk7vRVEc7nVdSU7mOnjJzFLwYbZWRbCQQF6RdlFe84aAX13WM
k0K6XC8gY04smUodl6r/Penamv/243jWfEMjsaSahvMxOs2+7UB0lmmCk+41gtAW
9uV3e9cs5QQoNEDn4cy7EM1tpjLU7ZRzblMsBAu87URRWfmmW3vac/XXLH773Z2m
KZlUOEWqONecQSinFteJ
=3Yyl
-----END PGP SIGNATURE-----

--sd7l8P2TFUHagl4l--
