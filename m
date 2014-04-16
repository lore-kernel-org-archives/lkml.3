Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422721AbaDPQUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:20:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53255 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422648AbaDPQUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:20:41 -0400
Date: Wed, 16 Apr 2014 11:16:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH 2/2] ARM: dts: omap5: Add dr_mode for dwc3
Message-ID: <20140416161619.GH28035@saruman.home>
Reply-To: <balbi@ti.com>
References: <1381402195-29257-1-git-send-email-kishon@ti.com>
 <1381402195-29257-2-git-send-email-kishon@ti.com>
 <52580F34.8030809@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wZdghQXYJzyo6AGC"
Content-Disposition: inline
In-Reply-To: <52580F34.8030809@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wZdghQXYJzyo6AGC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2013 at 05:46:12PM +0300, Roger Quadros wrote:
> Hi,
>=20
> On 10/10/2013 01:49 PM, Kishon Vijay Abraham I wrote:
> > From: George Cherian <george.cherian@ti.com>
> >=20
> > Added dr_mode property in dwc3 and set its default mode to device.
>=20
> If there is a specific reason why this is not set to "otg", we need
> to explain it here.
>=20
> AFAIK the port is meant to be used as OTG port.

we still don't have the workaround for dual role ports, I've been
working on it but still need to retest and make sure it's working fine
before merging upstream.

--=20
balbi

--wZdghQXYJzyo6AGC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTqzTAAoJEIaOsuA1yqREfaEP/RoDpVwvbrhix7yIKYOE55F3
IR3oD0L+SqVgBqcZnQGIzD20C8GqDnPBdk8YpG4v08hlvx1pLWChzup97E/Dc2A1
UfZTteVJRSnARflOkAH7ck/Jrqdp6lVTK2BWMKEkiHyvZmg3RGeteWdmambPeZhs
GIR2k58mSJguHEt9tRHzttvSSmZSk4lNoE14m/aGp1OqP1pQ/llWIJmNP/Up1iF1
WT1zB+8Zfj5QJx6mJK4kwDM3uYNAvMM7NkWWyz2qvuj3t+jvMM+6elIAu6pDt8XA
TtO3LqlVjOWYcyFCBPzoX3ZNPLEzKvklACUsecOJsSQ8bAFVyfTaco/Qa61wbR6b
sSwl00Qj9FEYN9KVdlCgbWWpxJ9oLGF1qD+uwwzuF59rD2c/AZspOiZu/pIy7519
ooLT9p5ENah0FkumSDPlTKbkB7EXhCl43uGqpB0Ae+D5fKvRnt3vBnOKE7YhNKob
m7wqRtgJN9FzGs9EuHrxkmH7YRMSdqMzQ//3+V9jWAVFCrfFgOjpfRU+v8IhfRx4
w4FEpKqW1j5A8nlQrx016gVaQ3rhgm0b7zUu7D9srAywYyv/jFp4YoMGVfFx9oCo
1vZ6frG1ex9/OzKzKmwqu7I8UJCs6vvXLDp6NkobkzflSXLtZNbyZ3TyxzvGkOxX
vyHH+G2aPh+Q9aOgMoEb
=XF8Y
-----END PGP SIGNATURE-----

--wZdghQXYJzyo6AGC--
