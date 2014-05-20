Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbaETUIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:08:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46290 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaETUIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:08:53 -0400
Date: Tue, 20 May 2014 15:08:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>, Felipe Balbi <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: ffs-test.c Compilation failure
Message-ID: <20140520200844.GB22996@saruman.home>
Reply-To: <balbi@ti.com>
References: <CA+V-a8v-y_=zjPKG2ui0y1eBhk-Ri3SKuv=X2sMReit2UOY=4A@mail.gmail.com>
 <xa1tfvk4z05m.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <xa1tfvk4z05m.fsf@mina86.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 20, 2014 at 10:05:09AM -1000, Michal Nazarewicz wrote:
> Commit [ac8dde11: =E2=80=9Cusb: gadget: f_fs: Add flags to descriptors bl=
ock=E2=80=9D]
> which introduced a new descriptor format for FunctionFS removed the
> usb_functionfs_descs_head structure, which is still used by ffs-test.
> tool.
>=20
> Convert ffs-test by converting it to use the new header format.  For
> testing kernels prior to 3.14 (when the new format was introduced) and
> parsing of the legacy headers in the new kernels, provide a compilation
> flag to make the tool use the old format.
>=20
> Finally, include information as to when the legacy FunctionFS headers
> format has been deprecated (which is also when the new one has been
> introduced).
>=20
> Reported-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

can you send as a proper patch with proper subject ?

--=20
balbi

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTe7ZMAAoJEIaOsuA1yqREz1UP/2DjgdzwsFFXOmCU7v02jSRT
RnBeVZQEnDa43t0GmqGrmC9TXLaBW9EhCfw4YWFSvuLAtNTwVuLtjZxu6V4qoDCn
xGFe21e37C3IYsL5mnZtjAb2a1+jWtfCz7RhcvuGL8O5UM+ZmG8uI9zEwRh4wDdL
Nl5nLMXbmzc+V3J6jwn1r+g8alUWCjoCW1kSmsE5UAmbgm5CmdpZCxC61LrZ8Spu
VGDaiNmxRy7tpQufT+MvxIy5MNowvfhURsjjzTM75JANCFcAslpYX1QMLk0m3Epe
9Hdwwl99SI6Qvv93ri2Oy/IJwpClYxx/dVq2WGkxFGjyc2TDKLy+p/OgY8cA7X/9
GuFVZIxylb6zHMEl9r77OXOt/xg+xtl0S6OiBO9hjOxYWwOsy89ICCcexdOLZHC2
FosR0KWDksFWwRmTpGBjWR8Pp9C378ZJ4zOMOGRw08+QEnGu8lZigPkN1MDUKysE
w5VrfQI23oo5hQM3JiIzg2a1K7SlGxQR0TEqQewd82noI+i6W88a6FWnR1jvEMLT
NJ7kOTGCtNC71BAduhAFFenTSwPQQDC/G8qOjq4E3X0z5OSwJfa0w9dQlXPKYCGN
D5h31D73gyxFR2fCypY5o6ptCNqvz9lx7tJdCqq65IzOpvwB80wLrg5GqWEwpDLu
ko/vCdpgNRg97fA2rsbu
=yo6P
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
