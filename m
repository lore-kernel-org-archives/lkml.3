Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbaFJBGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:06:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45474 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932990AbaFJBF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:05:59 -0400
Message-ID: <1402362352.23860.101.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.4 76/88] 8250/16?50: Add support for Broadcom
 TruManage redirected serial port
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stephen Hurd <shurd@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        Rui Xiang <rui.xiang@huawei.com>
Date: Tue, 10 Jun 2014 02:05:52 +0100
In-Reply-To: <20140610002426.983926719@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
	 <20140610002426.983926719@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YI6RYx6AautluNNt07sZ"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YI6RYx6AautluNNt07sZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-06-09 at 17:25 -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Stephen Hurd <shurd@broadcom.com>
>=20
> commit ebebd49a8eab5e9aa1b1f8f1614ccc3c2120f886 upstream.
>=20
> Add support for the UART device present in Broadcom TruManage capable
> NetXtreme chips (ie: 5761m 5762, and 5725).
>=20
> This implementation has a hidden transmit FIFO, so running in single-byte
> interrupt mode results in too many interrupts.  The UART_CAP_HFIFO
> capability was added to track this.  It continues to reload the THR as lo=
ng
> as the THRE and TSRE bits are set in the LSR up to a specified limit (102=
4
> is used here).
>=20
> Signed-off-by: Stephen Hurd <shurd@broadcom.com>
> Signed-off-by: Michael Chan <mchan@broadcom.com>
> [xr: Backported to 3.4:
>  - Adjust filenames
>  - Adjust context
>  - PORT_BRCM_TRUMANAGE is 22 not 24]

This last line isn't true any more.

Ben.

> Cc: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-YI6RYx6AautluNNt07sZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5ZZ8ee/yOyVhhEJAQrC6w//cKy02o0z4ZPVMz9GeRo83wVKoLxigh0O
snL/teeb4Ul/5Mj2wrMeWTqDHgW/NdvC+02WtQC8Y8odVDraSub5lgu643uMwEwC
F+W+SlKdew/4rrZirlrHDbyyUx1T0vaZNu2EZpOmqqo0wg4KsP/WccRiRivBIn9v
opIcox6Z1S9Oyxkp8C+eCT5+bZeZZTJD3GThChtH2E6KZCBglQgym8gzFLAlRBNr
+vTXEuxmbRW+HBcL+ZW70VzQJyEckr7tN5hPgorlsubewS8a+ccxpRL6bhYILeZb
duUW5uJWXmAHzwBRwEZTHwMcXDdNmrddnK3mIMfL+o55Jsc0nXyjOJgzY14Lgw1i
zd/2rQ3MD2W4POESlyq9NSoz/7AZ4zJF9Oj+9kL3/8Euq4+CnsI05XyGrl1pLqRl
yYZdp+FulcxLJW0x5ZMC17dTil2oxzr/9N+tv7eQ5Ic9uPHq7pJM6BtQPtP6mbwi
hLZq7lYFH9EHACI49NC2ZWH6hkV4E+n2d/kzKhVCQOtRt/OjFHK31hbQWR6ZKTek
8UmQyyzc3COT+I6iuZLTzpHbVD7Ae26DG2LULrfBb/2f8GA9ojnjl6XKYG8bPjLa
7z7CA7SyubyLsq0x94WldSz3CAeOnhXpYYW8J1U1OtJJ8ZT6qOweb/PegPc8fTuq
soJIo4KY34Y=
=auMZ
-----END PGP SIGNATURE-----

--=-YI6RYx6AautluNNt07sZ--
