Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3I3NYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:24:43 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33655 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab3I3NYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:24:39 -0400
Message-ID: <52497B8E.1030009@monstr.eu>
Date: Mon, 30 Sep 2013 15:24:30 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c: xilinx: Fix i2c sparse warnings
References: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com> <20130930102342.GC3222@katana>
In-Reply-To: <20130930102342.GC3222@katana>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="kA5gnpWEu1sUigpwhUtMH0dPSvtsxXlvi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kA5gnpWEu1sUigpwhUtMH0dPSvtsxXlvi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/30/2013 12:23 PM, Wolfram Sang wrote:
> On Mon, Sep 30, 2013 at 11:08:50AM +0200, Michal Simek wrote:
>> From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
>>
>> code changes to fix sparse warnings
>=20
> Would be nice to either have them listed here or at least shortly
> described.

I will send v2. I see that Kedar wrote sparse warning but they are
checkpatch warnings.
I will fix that.

Thanks,
Michal



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--kA5gnpWEu1sUigpwhUtMH0dPSvtsxXlvi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJJe44ACgkQykllyylKDCGoDQCfQUAvRKEr67tf56kYV5ivz5hP
O2cAn08VoPb2DFW7btZI5gvOtlK0md08
=ML9D
-----END PGP SIGNATURE-----

--kA5gnpWEu1sUigpwhUtMH0dPSvtsxXlvi--
