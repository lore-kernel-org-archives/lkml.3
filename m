Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab3IIIIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:08:47 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:64190 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3IIIIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:08:45 -0400
Message-ID: <522D820A.9020304@monstr.eu>
Date: Mon, 09 Sep 2013 10:08:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/microblaze changes for 3.12
References: <52299BD2.2020307@monstr.eu> <CA+55aFw6XSH2J4DALGF9Mp-sZHpFwiZnwoGYjiXH=rz5NkSeZA@mail.gmail.com>
In-Reply-To: <CA+55aFw6XSH2J4DALGF9Mp-sZHpFwiZnwoGYjiXH=rz5NkSeZA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oquO3A8prN2q2nVe9PGEwsP8tB9STI8os"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oquO3A8prN2q2nVe9PGEwsP8tB9STI8os
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/06/2013 08:09 PM, Linus Torvalds wrote:
> On Fri, Sep 6, 2013 at 2:09 AM, Michal Simek <monstr@monstr.eu> wrote:
>> Hi Linus,
>>
>> please pull these Microblaze patches to your tree.
>=20
> Hmm. You've started using signed tags, nice. I just wonder why you use
> use one that seems to be a relatively weak 1024-bit key (ID: 294A0C21)
> when you have stronger ones available?
>=20
> Not a huge deal, I'm just wondering.

I am using signed tags for Xilinx Zynq (arm-soc tree) for several months
because Olof asked for it. But this was the first time I used it for Micr=
oblaze.

The problem is that I can't see 2048-bit key in my secretkeys but it is
in my public key. Probably I removed it when I was playing with it.
I don't know if I can import this public subkey back to my secret key or
just revoke it. This is the reason why you can see stronger key but git c=
an't use it.

BTW: In that time I setup my PC that I can even send signed patches with =
git send-email.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--oquO3A8prN2q2nVe9PGEwsP8tB9STI8os
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlItggoACgkQykllyylKDCEX+ACgm/2hUiWCBCX0iNxJTNMqFGrm
mxMAniZgpM0bC+f/kosRRNcvqvsR4SaB
=iN5e
-----END PGP SIGNATURE-----

--oquO3A8prN2q2nVe9PGEwsP8tB9STI8os--
