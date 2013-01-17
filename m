Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3AQKF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:05:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44262 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454Ab3AQKFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:05:23 -0500
Date: Thu, 17 Jan 2013 12:05:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: <balbi@ti.com>, Luciano Coelho <coelho@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
Message-ID: <20130117100510.GI10814@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358372702-13102-1-git-send-email-coelho@ti.com>
 <50F7C4A7.5060202@ti.com>
 <20130117093417.GH10814@arwen.pp.htv.fi>
 <50F7CA82.4050509@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZQs1kEQY307C4ut"
Content-Disposition: inline
In-Reply-To: <50F7CA82.4050509@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YZQs1kEQY307C4ut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 17, 2013 at 10:55:14AM +0100, Peter Ujfalusi wrote:
> On 01/17/2013 10:34 AM, Felipe Balbi wrote:
> >> I just wonder how this is going to work with DT... You are not going t=
o have
> >> the ability to use callback in this form.
> >> I think the GPIO handling should be done in the driver itself rather t=
han in
> >> the board file.
> >=20
> > that can (should ?) be moved to ti-st eventually. In fact I don't know
> > why it was removed in the first place, we would need Pavan to help us
> > with that query.
>=20
> Yes, this is a good question. I don't know what is the spacial thing plat=
forms
> need to do in the callback..
>=20
> > Still, for -rc, the minimal patch had to be cooked, right ?
>=20
> Sure it need to be fixed. I would try to revert the patch which caused the
> issue (eccf2979 drivers/misc/ti-st: remove gpio handling).
>=20
> Should fix the legacy boot, but it is going to be even bigger fun to move=
 to
> DT (and get rid of the callbacks).
>=20
> I don't have anything against this patch as such. Just wanted to point ou=
t the
> obvious that the comfort of callbacks are not going to be around in some =
cases.

I guess Luca's choice was to cause the minimum impact to current code,
also reverting original commit isn't free os hassles either.

--=20
balbi

--YZQs1kEQY307C4ut
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ98zWAAoJEIaOsuA1yqREAOEP/2SacEiV9pnXTOrUHhZm48sS
8NaT/E5MoLViP//N8t8kSm48OH7V1KV1aUk9y+OoYD3ayt2CG/w48Qw+t7cu0x1k
0Br7f9UkyuBONWzYQ/I7KTdkU6qudaFN/0plBXkYxgy0/iKGHf9xUelFN4NSfDVf
dlcxUtocug2GZ8WiDmC3NCasLUEk/eQLRN3Hg6yTlUReSyKJeF9DSq5YOcDHFW/Y
W/80KSsJb+Jo4IlowVvdiL+XIBrq9NFm9ocyHA+IK+PEoIUlM2yQ3i5FVV+zMj/7
vDXioMCTsDjh/68dakNtQdtViqQ6U654HTQVLsj3sNW40o06ycgGk/zXKKV7YLgT
VyxkqYGT8IlBVXAKH9O7pHPZmtUfG3WkEO8NBKxiCjmTuzR074Xp2+1qt0jJ6Jwd
KprZKbyxZtbVYROSh+u80DvFYntJgZ7A2CQe4cELLXVWHUo8cXW8ELSxDmw8fD7Z
VrsvpCCoj1DCZAoXIxOP2ZLeU4AUaiHocowcEXK+8vXGr4eQ/ijpZlH7J/tHw5/n
qFVMoY1L8W3GTTXRwT5bSuMAYxFdYhuvGWtYdeewEP+Yu+G1DoDESrUuMjgYF+lv
0fijmBseXn06uyDXN3Zod4WengwFtn7lS7TO0u5GwBBvnk72VQhF9hnC50W4jCGt
s/3cNKR0tzTXzAqNVyj3
=Bkpa
-----END PGP SIGNATURE-----

--YZQs1kEQY307C4ut--
