Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3FDMwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:52:39 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:62431 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3FDMwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:52:37 -0400
Message-ID: <51ADE312.3040801@monstr.eu>
Date: Tue, 04 Jun 2013 14:52:34 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] tty: serial: Enable uartlite for ARM zynq
References: <26d21aaa1f4a5b3bcae1d82f1524ea53ce9a36bd.1370348438.git.michal.simek@xilinx.com> <20130604124351.GC5107@pengutronix.de>
In-Reply-To: <20130604124351.GC5107@pengutronix.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2NGIFTJPWNWSOSGWCHLIO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2NGIFTJPWNWSOSGWCHLIO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/04/2013 02:43 PM, Steffen Trumtrar wrote:
> On Tue, Jun 04, 2013 at 02:20:43PM +0200, Michal Simek wrote:
>> Enable it in Kconfig.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>  drivers/tty/serial/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
>> index 7e7006f..64250b1 100644
>> --- a/drivers/tty/serial/Kconfig
>> +++ b/drivers/tty/serial/Kconfig
>> @@ -576,7 +576,7 @@ config SERIAL_IMX_CONSOLE
>>
>>  config SERIAL_UARTLITE
>>  	tristate "Xilinx uartlite serial port support"
>> -	depends on PPC32 || MICROBLAZE || MFD_TIMBERDALE
>> +	depends on PPC32 || MICROBLAZE || MFD_TIMBERDALE || ARCH_ZYNQ
>>  	select SERIAL_CORE
>>  	help
>>  	  Say Y here if you want to use the Xilinx uartlite serial controlle=
r.
>> --
>> 1.8.2.3
>>
>=20
> Hi!
>=20
> Doesn't the Zynq use xilinx_uartps ? (which in turn is actually a Caden=
ce UART)

You can add this soft IP to programmable logic.
It means 2 uartps are hard blocks in the zynq and then you can add unlimi=
ted number
of these uartlite drivers or ns16550 to PL.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2NGIFTJPWNWSOSGWCHLIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGt4xIACgkQykllyylKDCGHYQCdHbXfR67vWjTZ+z/I+Le86Vrc
00EAn3rqxKo8e2fl6xJ0J5b1Etah5voZ
=0i2i
-----END PGP SIGNATURE-----

------enig2NGIFTJPWNWSOSGWCHLIO--
