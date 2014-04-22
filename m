Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbaDVOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:25:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39078 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaDVOZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:25:20 -0400
Date: Tue, 22 Apr 2014 09:22:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <peter@hurleysoftware.com>,
        <m-karicheri2@ti.com>, <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] tty: serial: add missing braces
Message-ID: <20140422142256.GC5524@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+B+y8wtTXqdUj1xM"
Content-Disposition: inline
In-Reply-To: <1395343807-21618-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+B+y8wtTXqdUj1xM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 20, 2014 at 02:29:57PM -0500, Felipe Balbi wrote:
> per CodingStyle we should have those braces, no
> functional changes.
>=20
> Signed-off-by: Felipe Balbi <balbi@ti.com>

Greg, do you want me to refresh and resend this series ?

--=20
balbi

--+B+y8wtTXqdUj1xM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVntAAAoJEIaOsuA1yqREYyUP/jA9FzIhfh8oc1uKvY4SuEA+
MB4tjfDMN9z10dQqwsSnGp3fu9iTdcDfS8Ch5ujFEpQs6ufZ8L8FZCurjI5JW7nC
Kh0uWeAgRbdAxRQUX2eZ1SQGN0Vs59hO5X5O0Uvi2sYfjLFUyhWSgVPSzccq/rcl
lMwWYqaF/5NjRpdGMoOT5tUPT2ElC72JLLBzm0AVbyvFwlbl3hgA8420vGfiinNr
dMV5UQl0YqdQpLdylDiv8RbplJVuEuucZPnMtHn07oO81loMOmk8YKgJV6w7fppP
sWw7GmTrl+/h40kPKhzMFQbNZ7KTHOo0nsUAzafj/wcdFsh2ehhV3Ah82wT8G7L+
q+YQN1rd5DjI7bQd0YqDoR7mFzKo9HMlNeXrKJZp4NFkHpbrO5mJr3LvA6s7wp4q
E7GYIGy6oBJZ+k1UIX51Yot2z+iW/e9tdUXoWNt/3uL18YvBXbpkQlZjoc7vaY/i
eOsc5cEkiRSYF5l87UBvpsf5JotPUnparWZysAR70bhrvSdZ9K6cVdNNQp1rdQiA
MH5yhnU7MHuDrWIvs0HFGnilPqFoYB1H8oCrvmsqTGEy8gbElHaOyxjAeASU+mHw
Uf+hcvD0ezaE+kCHyxxKKAxsxhZVoXy1n7d2zNVCNdijqNgDDJq6ed8m2lZLp6IQ
NKbYgqTRGmBoOyEFUQRg
=DQiI
-----END PGP SIGNATURE-----

--+B+y8wtTXqdUj1xM--
