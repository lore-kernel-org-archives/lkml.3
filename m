Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaBKC0C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:26:02 -0500
Received: from ozlabs.org ([203.10.76.45]:47983 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbaBKCZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:25:59 -0500
Date: Tue, 11 Feb 2014 13:25:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>
Subject: linux-next: build failure after merge of the mfd-lj tree
Message-Id: <20140211132552.68b0802fd8742c6d72dfa738@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Feb_2014_13_25_52_+1100_oNImwvJr3nuTDAzc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Feb_2014_13_25_52_+1100_oNImwvJr3nuTDAzc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

After merging the mfd-lj tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/mfd/tps65218: struct i2c_device_id is 32 bytes.  The last of 1 is:
0x74 0x70 0x73 0x36 0x35 0x32 0x31 0x38 0x00 0x00 0x00 0x00 0x00 0x00 0x00 =
0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0xf0 0x00 0x00 0x00 0x00 0x00 =
0x00 0x00=20
FATAL: drivers/mfd/tps65218: struct i2c_device_id is not terminated with a =
NULL entry!

Caused by commit cc493e30e3a1 ("mfd: tps65218: Add driver for the
TPS65218 PMIC").

I have used the mfd-lj tree from next-20140210 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__11_Feb_2014_13_25_52_+1100_oNImwvJr3nuTDAzc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+Yo0AAoJEMDTa8Ir7ZwVif0QAIPb5UxzxRtQkvKlXjdZobBK
ahSa7kDNkrIR3SFCzHx3zktaIceiorkW+HcN66wW1Wuk40z9LFTkqcMCp/L2+bMN
vZ4Qtpr2IXUuTvy+j8DSQn5obmM77QT1QR9C6WAqwxoHdHwHnbu3LyhvzhYTdoIW
B/HwE3LPzJhKU4DRlTtUHfi2hQoebyBP9MkayhQkFBGtpHF+AbotcuUePe30VPdw
UjdouOwwt3NoBlTZY0eicnBUyiHF6MnLrTvClAPVALkmu40wUvLFyJVwP+Z/lXz/
26v6T65wazfoU2O9j/FaD0l8LHwAn5eaDwOLDWgOYatWFE7r9R0mVmZRt3HQlqk7
CxaEFZ1tN4KKnCHwuIQ+BfsomIBYHKoL+Gp3mVa55HofbthYdCbVC8ZjoSC1dxjh
u3O9dPgnGE36qIStWRJ39YWluoipVC706wTQTc9n/DPJTQYKeVHmM5TJbAt8qqgd
icci2FiN3k3glb5JSKGlcAo9jcX4j7mX9bEeWIoissB8PMwsPmM1eeLZxmAEYVPA
/ZmJlR1iMeD/9LHG+m/M6MNfIc1BHsBrLACPDXZCudT4ESUVw8IZtjDgx2ACcuWk
oLVvf8ScZtMoycYdz73yx/wOZmtkrscMwEDDz8cIG4/sYs7o6wUMRXZEur8rheH9
uAsVDVn530GTBRs6ZY23
=q/5k
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Feb_2014_13_25_52_+1100_oNImwvJr3nuTDAzc--
