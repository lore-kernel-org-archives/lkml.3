Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaIPJXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:23:49 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44694 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaIPJXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:23:46 -0400
Message-ID: <5418019E.1010202@monstr.eu>
Date: Tue, 16 Sep 2014 11:23:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Rob Herring <rob.herring@calxeda.com>, Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [PATCH] arch/microblaze/kernel/setup.c: Add default 'screen_info"
 for fixing compiling break
References: <541552B8.8020807@gmail.com> <CAMuHMdU6adYoOafUZ2STZCeuQa3cU-_kD7FHW3x=Tq-O+aqrZw@mail.gmail.com> <541559C2.8070703@gmail.com>
In-Reply-To: <541559C2.8070703@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WooM2wQdxnShijkHQOsIaJmEBpMUidW82"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WooM2wQdxnShijkHQOsIaJmEBpMUidW82
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/14/2014 11:02 AM, Chen Gang wrote:
> On 09/14/2014 04:45 PM, Geert Uytterhoeven wrote:
>> Hi Chen,
>>
>> On Sun, Sep 14, 2014 at 10:32 AM, Chen Gang <gang.chen.5i5j@gmail.com>=
 wrote:
>>> Add default one just like other architectures have done (e.g. cris,
>>> score, sh ...), the related error with allmodconfig:
>>>
>>>     LD      init/built-in.o
>>>   drivers/built-in.o: In function `vgacon_save_screen':
>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x834d0): undefined refe=
rence to `screen_info'
>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x834ec): undefined refe=
rence to `screen_info'
>>>   drivers/built-in.o: In function `vgacon_resize':
>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83cdc): undefined refe=
rence to `screen_info'
>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83d38): undefined refe=
rence to `screen_info'
>>>   drivers/built-in.o: In function `vgacon_switch':
>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83f50): undefined refe=
rence to `screen_info'
>>>   drivers/built-in.o:drivers/video/console/.tmp_vgacon.o:(.text+0x840=
7c): more undefined references to `screen_info' follow
>>>   make: *** [vmlinux] Error 1
>>
>> Can microblaze actually have VGA?
>>
>> If not, it's better to disable it.
>>
>=20
> Welcome the related microblaze maintainers ideas for it

Is this is just about VGA or video console in general?
There is xilinx FB driver and other FB are around too.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--WooM2wQdxnShijkHQOsIaJmEBpMUidW82
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQYAZ4ACgkQykllyylKDCFkFgCdEydPtS/5mzK1FBUVY40x/nnj
+hoAoItv7oVZHNcYQsEXW+Hj+9oe7KW+
=16Lf
-----END PGP SIGNATURE-----

--WooM2wQdxnShijkHQOsIaJmEBpMUidW82--
