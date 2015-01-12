Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbbALQUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:20:44 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62472 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbbALQUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:20:42 -0500
Message-ID: <54B3F44F.2010408@googlemail.com>
Date: Mon, 12 Jan 2015 17:20:31 +0100
From: Tobias Powalowski <tobias.powalowski@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Possible bug in initramfs RAM handling
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FMv4ib6CcMJ982lBfb7qJLcpb464N6w6W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FMv4ib6CcMJ982lBfb7qJLcpb464N6w6W
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
I have a weird bug here with initramfs,
I have big initramfs files around 150MB zipped, 400MB extracted.
I suppose the needed RAM to boot this setup should be around:
150MB zipped initramfs+ 400MB extracted initramfs + 5MB kernel image.
Our distro kernel has tmpfs support, booting this setup without kernel
parameter needs around 1000MB RAM to boot.
Using rootfstype=3Dramfs makes it work with around 600MB RAM.

Is this a bug in kernel code?
Shouldn't both types not use the same amount of RAM?
I used kernel 3.18.2 at the moment but issue is reproducable with 3.15 to=
o.

Thanks for your help.
greetings
tpowa

--=20
Tobias Powalowski
Archlinux Developer & Package Maintainer (tpowa)
http://www.archlinux.org
tpowa@archlinux.org





--FMv4ib6CcMJ982lBfb7qJLcpb464N6w6W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUs/RPAAoJEHcd9mJ+32gfJioH/jENrPantGq1XV5kB/R2qZyy
vkUHF7tSqFa7B4MaU7//CCWZ3Da/Gl8/DJ10Ea/w0eIN8/AJ4X/WcjwDRwJUG0cD
QGAvBgJCIUTgK9VvGxJYxzsItn+IqBV1fs2wEk6I7w05FB2FpdBFT75udOMO+TVo
3zJXPBec5Dxz2klnNKV2Sf1o8zuTTA5MSSAN8gTxgHwoJQyvWEzyJLufSLZKAL7S
uOOSaJzt2CzqzrLz57WQySas+m5thpKbYemIiLNIEFMXdAwxF1Z7bFps7i/Puq87
9d7XtHUZ1aJQxz9NcORsTmknsELdO4JvNlD0VmZefI0w3ZtXQUFdc2EMrwAjaxo=
=67zZ
-----END PGP SIGNATURE-----

--FMv4ib6CcMJ982lBfb7qJLcpb464N6w6W--
