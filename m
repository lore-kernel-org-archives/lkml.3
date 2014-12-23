Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbaLWXvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 18:51:08 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59971 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaLWXvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 18:51:05 -0500
Date: Tue, 23 Dec 2014 17:50:45 -0600
From: Felipe Balbi <balbi@ti.com>
To: Carsten Behling <carsten.behling@ridgerun.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: usb: musb: Scheduling of interrupt endpoints
Message-ID: <20141223235045.GC32702@saruman>
Reply-To: <balbi@ti.com>
References: <54947E99.4010908@ridgerun.com>
 <5499835B.508@ridgerun.com>
 <5499C4E2.8090407@ridgerun.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <5499C4E2.8090407@ridgerun.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

A: No.
Q: Should I include quotations after my reply?

On Tue, Dec 23, 2014 at 01:39:14PM -0600, Carsten Behling wrote:
> The following comment can be found in 'musb_schedule()':
>=20
> '* REVISIT what we really want here is a regular schedule tree
>  * like e.g. OHCI uses.'
>=20
> So I assume the best practice would be to make an implementation based
> on the code in in ohci-q.c. And it would be waste of time to port the
> old interrupt endpoint scheduling feature of TI.
>=20
> Am I right?

Frankly, OHCI is a better example than TI's MUSB from 200 years ago,
that's correct :-)

cheers

--=20
balbi

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmf/VAAoJEIaOsuA1yqRE6I0P/RDH7P4AN9It4/sdj2JOqvem
4tVRhddd9pe5fXewSptOAUxolt5JY+aym72ARaCh8zpFr3USIU9qFU4lI2dMpI7H
uifHkqrXHwY5EDhkBsGDns+Fkwv+RKTEaqH0EKDZSIpn6k99D2W5ralfOrxkbylZ
BkfDysrXyeS/Jw7qLBPAClpIbRg4d3+zgsl6j88+wgDuEpHyCxASCUyOitoX3Tmi
ccwygXOD8zzBc46TB2uPmlx7d+OQW4YbKrjEhbLDLIR3KF4dirp4/tvWawGKsQzk
hOriD3AFaEE39I8HwjDkqw1NRYAAeC8em+emGpgJfLcSr29EhahrXlHMqct8ceSE
iAaBcSJGokd1jGZKqjiO2bbHrBmxr2zuDQZG323aWLSFI8PZBzLQ/OrIAibbQpRc
EdPhw8Rtliy97RGE64KIHoAXe5KxQHf9SWZLWn46Xte8NXnAjHntpIT+srp1nRhT
fMIyzSQ8ZwJ4wzoigZeYltkZhGozomXZMzQkx6JxPieJTFRivXKGABnVrARvKCNs
MSXB+3bqpjtPZwwrTJ7vSHH6sQv+CjhiCdwbGEvcaY4ru6lCE0KwkupF27uhQyAk
VHCTLHAzaE25ffaKsAXPXIA5AByYg1SQ07OGOaqJpvJ/Z8BRPEQKf7R480FAL43m
L/HhrguUkgRFkvAX/Bmf
=u/U3
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
