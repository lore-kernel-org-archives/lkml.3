Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaKXTId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:08:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40847 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821AbaKXTIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:08:31 -0500
Date: Mon, 24 Nov 2014 13:08:40 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 2/4] i2c: omap: implement workaround for handling invalid
 BB-bit values
Message-ID: <20141124190840.GE25712@saruman>
Reply-To: <balbi@ti.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416518925-20679-3-git-send-email-al.kochet@gmail.com>
 <20141121160808.GM7508@saruman>
 <20141122132309.GC2679@katana>
 <B6D9B4D7-25CB-456F-88B4-EB6A53E33A9D@gmail.com>
 <20141122180222.GA9698@katana>
 <20141123044306.GA19898@saruman>
 <1CC68911-DF20-4FF0-A08A-1A6F0B565662@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Content-Disposition: inline
In-Reply-To: <1CC68911-DF20-4FF0-A08A-1A6F0B565662@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 23, 2014 at 04:18:40PM +0300, Alexander Kochetkov wrote:
>=20
> 23 =D0=BD=D0=BE=D1=8F=D0=B1. 2014 =D0=B3., =D0=B2 7:43, Felipe Balbi <bal=
bi@ti.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
> > maybe there was a typo? I tested on v3.18-rc3 :-)
>=20
> I do my tests on kernel from angstrom with almost all i2c-omap patches
> backported from linux/master.
> Then I rebased them to wrong (old) kernel version and posted to the
> list.
>=20
> Angstrom kernel is from meta-ti layer. It's the same kernel as for arago.
> http://arago-project.org/wiki/index.php/Main_Page
>=20
> I would really like to switch to the recent kernel, but I don't know
> how good codec engine (CE) is supported on it.
> Initially all ti drivers for codec engine was done for 2.6.x kernels
> and later some of them was ported for 3.2.x.
>=20
> Felipe, do you know how CE is supported on v3.18-rc3?

what's CE ?

--=20
balbi

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc4I3AAoJEIaOsuA1yqREEMEP/Rb3NyFytlPmHaKBocd194hC
IGNXEF6UnTJDNpnWZH88B5Z72GklsiGMkU2Zu1FyRNM9VF4E+ixhTx/vGcY1MIh7
+SZdpzdop+d7/Mfa3tgMgf7FL4LzaGVfVFNkXLKEwf501tAu5X3wbqmzTU9Iy9we
TMO61Q4By7TMBLky1IlkfWVstNJVZLMkpIfWnXXL6J49hG3n6ku7LF9jPoSxeN4+
KyJHtR8iMsLtMs1WBla8ew2xUktZblsXnS3MMegWPVwyKJZirdZVRd3xCRgKPLje
x+3vpHAO3dk8MtghGncejYHwEnJcNkbWudpHxF3V/uavbxhs+8KqG6FYQr20AfxZ
JBjyF4CGY4Vj9aWs28UfxHtTO9UuLh2HCpfsXIex1dLHYm9JQOAvO4tocKx5A5n/
jKL9cgOp8KvoQRWZ8LDUNsM2d7KusM8VwmIXpRIFze948o5anMIVsK0fGQwHl6gJ
Mg/6XPNHrYHsQt013wjyH2ep3HKhwXSbEBhEf6ZdwOz5j9oDeaUnRhW7rpSyjzQ8
MaNiCu1oFY419+2BJTq4AfOHxWiecO/tu1eQfwerUZo5R9o+iv89YgtLbZBpMdiV
Ddu+/PoGGO4/lt280ReU4n64o0tLLfsRSrXvpqFtTNPBkD3tAMOacWCGRE5/vEfb
XZlSA+svyFbCtJPMA/Cj
=vgAr
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
