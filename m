Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3AQVA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:00:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44511 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab3AQVA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:00:56 -0500
Date: Thu, 17 Jan 2013 23:00:34 +0200
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>,
        <balbi@ti.com>, <sameo@linux.intel.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Rajendra Nayak <rnayak@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@linaro.com>
Subject: Re: [PATCH v7 19/22] ARM: OMAP3: clock data: get rid of unused USB
 host clock aliases and dummies
Message-ID: <20130117210034.GA27671@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
 <1358422231-24736-20-git-send-email-rogerq@ti.com>
 <20130117170321.GJ14149@atomide.com>
 <alpine.DEB.2.00.1301171854280.14118@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1301171854280.14118@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 17, 2013 at 07:00:00PM +0000, Paul Walmsley wrote:
> Hi Roger,
>=20
> On Thu, 17 Jan 2013, Tony Lindgren wrote:
>=20
> > * Roger Quadros <rogerq@ti.com> [130117 03:34]:
> > > We don't need multiple aliases for the OMAP USB host clocks and neith=
er
> > > the dummy clocks so remove them.
> >=20
> > It's best that Paul queues this and the next patch as these clock alias
> > clean-up patches can be done separately. That way the dependency between
> > arch/arm/*omap* code is cut away as these files should be moved to live
> > under drivers/clk/omap.
>=20
> Per Tony's request, I'll queue these two cleanup patches for 3.10 -- or=
=20
> whatever Linus will call it.

do you mean v3.9 ?

--=20
balbi

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+GZyAAoJEIaOsuA1yqREs3QP/1IPmpKggK+3L301ktZ2veFo
FoZy5CKQDqvnt0aJPb/N0DksQ7Z35Pd8ftwdVkh71vAWhHHpx7GRZZ7/FNbEu4n2
YwggQVP9nSrHaoFs1KyDQcKOapECpLBU8PZtBGQcNp2Wpyn/l+kwVdpiMirA+3ks
WzMri85F+ZEY+ZEyQcwckBAw2q0s6VQF3G5fMbxT5Bx2XF/tCi6WhbyAr2kjFAU+
92xcn2kTD/2h3hrlhx1x0Jj0NSCatkD2PHkbeMbVBHzOh6g+6ScNITkPnsKyB0Nb
fiRLHmMvMaxEjzOlh1oHqVpvY6gDl6ErvPRGs37uf6EuxauKPTeYtDENA5HagISp
okfuCNnd+ZbAiGysAtP8EQS1adtkhRIWw7c0EZvUHOkEmtfahQu+ehd/Sq0E8uVL
tDTcL9pNCHpJ9G9o4GCLNWYKgn+33SKaPx0PEcYVjN5yIRxjpSnHawDyECigevN2
CdkFIOUCRo50WwQsopUx7o54F0CgQ0XRFt4asI1s80Uo0Ptmz5/Q2tjAI0Ki7yEb
Y1xu78E8Q+zfSLwHNXiqvRsGV6ZDis5b0UTrkXBpqXq1dIm+2YR0b2VPm5U8L7ob
kr3n6Nz8HEUAotXlxU7MIDCG5bKgl/KA+9fj0k8wMnGNZevHBEbjwsVLNfYH4cJD
PPGhbV5pugYXQhVxCZx4
=IuWq
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
