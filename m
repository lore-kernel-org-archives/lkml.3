Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3IQPnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:43:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43542 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab3IQPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:43:31 -0400
Date: Tue, 17 Sep 2013 10:42:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@denx.de>
CC: kernel list <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>
Subject: Re: Fix style in s3c-hsotg.c
Message-ID: <20130917154229.GI15645@radagast>
Reply-To: <balbi@ti.com>
References: <20130902135832.GA22300@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJAclU0AInkryoed"
Content-Disposition: inline
In-Reply-To: <20130902135832.GA22300@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IJAclU0AInkryoed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 02, 2013 at 03:58:32PM +0200, Pavel Machek wrote:
> Hi!
>=20
> checkpatch.pl has some valid complaints about style in s3c-hsotg.c :
> macro with if should be really enclosed in do {} while, and puts is
> going to be slightly faster.
>=20
> Here's suggested patch. I don't have the hardware, so it is completely
> untested.
>=20
> Signed-off-by: Pavel Machek, <pavel@denx.de>

this is not how you send a patch, please read
Documentation/SubmittingPatches

--=20
balbi

--IJAclU0AInkryoed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOHhlAAoJEIaOsuA1yqREZ+oQAKkLOhPtMMCrWNh2YLUhfqVV
Mh8N6VhHUOiXyOYWXRjZk0mIq6U+svR2t+yzE14AlVRemoYCgJxEG7TQQtUtgDjc
Jc+dg6aJXd0txNeD+Uw88pNmTAn37uBYGqtCVC7ZJGWDqT3hLOpg+QQSWT8MNfWc
JyFFrSgZFGtwGXUk4KPtQeAYeGpxGMpep4XpS5qRlQTBHwrHb7l/NIRV7WGYQxyS
QisiTvidozLx2lA2Lax5yM9eFZ5K8E+DKPPlKcde1CvmHFOCDsTkVUgruSGqkJY8
YCAaU/uwiBhAEzGhmay8AxJvBy6DoJOEA0sf+t+EaUXn+eGM/cxtpbmDH7hvW7Y5
RBPR9uwt8Sonsp63lHLInmHXYX5N8IGv2TKc+KMwlAnODU3zIkH0z1iNi/+s1T1G
M95O7GAX9AL35UsS7zxEjw9aGXvbhVpeey1nHQYNf4LecznLepWqbx7cHdxHUviV
bsfOjIGxl2pTgfQsdPi8ouPLWsah2k7+Ul/w6bwVHM7LabNkizoDXub9IfdyXEg/
Ggr4Ej9C/3IbkhvalSh7EP6gSuAEYWfnnyCJ7V3SWPIfElFwHj435FPa0kmJyyin
A7lKUPIna/N3hGeCJfxl110bp/dG0tCsAdqztpn8Z0Y0CX3ZReG732mnnxZwp5Gl
ZV6s6w50kVtixkR/Dff0
=RaRS
-----END PGP SIGNATURE-----

--IJAclU0AInkryoed--
