Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaKJTju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:39:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55685 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaKJTjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:39:47 -0500
Date: Mon, 10 Nov 2014 13:40:14 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roman Byshko <rbyshko@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: replace hard coded registers with defines
Message-ID: <20141110194013.GA1041@saruman>
Reply-To: <balbi@ti.com>
References: <1414442919-28251-1-git-send-email-rbyshko@gmail.com>
 <20141103160836.GJ27425@saruman>
 <CAMXmWBnYRUiuehJ2EemtcM1wDkWwrsjyVuOVfu0CHrsRQjRc3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <CAMXmWBnYRUiuehJ2EemtcM1wDkWwrsjyVuOVfu0CHrsRQjRc3Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2014 at 07:31:23PM +0100, Roman Byshko wrote:
> musb registers can be dumped using the file regdump
> which is created in debugfs. Up to now  hard coded
> register addresses are used for that. Different glue
> layers however have different register addresses. The
> patch addresses this issue by substituting bare register
> addresses with defines.
>=20
> Signed-off-by: Roman Byshko <rbyshko@gmail.com>

TABs were converted into spaces, please fix and rebase on my
testing/next. Make sure TABs remain as TABs.

--=20
balbi

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUYRSdAAoJEIaOsuA1yqREfm8P/0zEvE2Cs/GzaRsOwa5Mhibm
sTmPUcCTMKp8Xh0E92RxhS4bdzJLVY9LM8j7KslAF+uj9RjTEBAmvxKW3XYpybeV
mJjTsYw2nmbhn6Ly/bGKMVqoD2UShpJGm4Xe8PpKTKKkrPXnE4Ktr1Z70cK8GpCJ
AKdrgOMdgQQQtjbXWIZSfgPfeOOjVNc9x2kbvGC9FKVC+yK1GafLLkKSNrPzC+ka
qi9GSz/DNmQEHA3rS4WH9bwEDEE1D7Tk62EfKyqzC5Z7RDuzs2tRbalxZLhX1NZq
HN4F5nIifCGicyn0jU2kd/ifLoEXz8dOfL3CwyJz+Is2jgDCJaXy84A1Naki7Nyu
aRWZFxvxqmNFrxj0oOdQWGFsyXhoFtRYcpVM5SpZLETvMdYbSNjQDzgJ3TRAxX2x
MMQu2yMYmnOCKnMKngrMh2yaIo5xLrKaC2KQX8JCLIeim+9VmW0WRWffOoMF0lSm
YsMVYHTOIGOD/bKQ9OV9gXTNP1z/aVVI7mT0KrD/v5hrjAGl/GQxXQGX7x86nNwJ
cqj6vjfVxQLLQxW1EBzJIzaNzGFGK99RUUXmASOHRZtjRdJCFV+4r0IlZj/OxlTf
VrjBCpzIKPkkLre/eJfWdkvVqRnTroy1gF0DGIBerYkrX2S/V2i9GoEJe23pNPiG
S/K4ybbuiRyiyGnV23zV
=OuCK
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
