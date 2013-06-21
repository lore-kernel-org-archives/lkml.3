Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab3FUJP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:15:26 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63490 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab3FUJPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:15:23 -0400
Message-ID: <51C419A8.3010707@monstr.eu>
Date: Fri, 21 Jun 2013 11:15:20 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] MAINTAINERS: Remove Hans J. Koch entries
References: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com> <71c482e15ee32fa304db73b984f6d5a63441cd92.1369317710.git.michal.simek@xilinx.com> <51A5E644.1040901@monstr.eu> <51AC8D43.100@monstr.eu> <20130603210513.GA22606@kroah.com> <20130620160126.GB22115@amd.pavel.ucw.cz> <1371745227.2146.13.camel@joe-AO722> <20130621025031.GG4775@local>
In-Reply-To: <20130621025031.GG4775@local>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2BBSWLHAESKEGKEXDECOW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2BBSWLHAESKEGKEXDECOW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/21/2013 04:50 AM, Hans J. Koch wrote:
> On Thu, Jun 20, 2013 at 09:20:27AM -0700, Joe Perches wrote:
>> On Thu, 2013-06-20 at 18:01 +0200, Pavel Machek wrote:
>>> Anyway, Hans disappeared, so Greg takes patches, again.
>=20
> I wasn't able to take part in kernel development because I was heavily
> involved in hardware development project. I always thought it would be =
just
> a few more days, but then it became half a year. I know I should have g=
iven
> an explanation and didn't. Sorry for that.
>=20
>>
>> Maybe this is appropriate then.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 69fea4f..dc9d04a 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -5253,9 +5253,8 @@ F:	Documentation/hwmon/max16065
>>  F:	drivers/hwmon/max16065.c
>> =20
>>  MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
>> -M:	"Hans J. Koch" <hjk@hansjkoch.de>
>>  L:	lm-sensors@lm-sensors.org
>> -S:	Maintained
>> +S:	Orphan
>>  F:	Documentation/hwmon/max6650
>>  F:	drivers/hwmon/max6650.c
>=20
> ACK to that one. It was never my idea to have a MAINTAINERS entry for t=
hat.
> Jean Delvare suggested it, so it came in. The MAX6650 was in a project =
I was
> working on 6 years ago, and I wrote the driver at that time. Meanwhile,=
 I
> don't even have hardware with a MAX6650 anymore.
>=20
> Does each little driver really need a MAINTAINERS entry? In my opinion,=
 it
> should only be there if it is clear that it's not just a short project =
work.
>=20
>> =20
>> @@ -8795,7 +8794,6 @@ F:	fs/hostfs/
>>  F:	fs/hppfs/
>> =20
>>  USERSPACE I/O (UIO)
>> -M:	"Hans J. Koch" <hjk@hansjkoch.de>
>>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>  S:	Maintained
>>  F:	Documentation/DocBook/uio-howto.tmpl
>=20
> Well, you can do that if you want. But I still feel associated with UIO=

> and sincerely hope I'm back again to fulfill my duties as a maintainer.=


ok then can you please comment my patches?
I think it is not necessary to have one driver which support UIO without =
IRQ
and then second which support both cases.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2BBSWLHAESKEGKEXDECOW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHEGagACgkQykllyylKDCE2cQCfZIaEaxaIXON4fihbifxxswEL
J8QAnjuhgaLaYS93c8ZWlD6DXuF7Lmk1
=WXyB
-----END PGP SIGNATURE-----

------enig2BBSWLHAESKEGKEXDECOW--
