Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaCaXQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:16:21 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:54331 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaCaXQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:16:20 -0400
Message-ID: <5339F739.2060207@archlinux.org>
Date: Tue, 01 Apr 2014 01:16:09 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <52E4CF03.8030208@archlinux.org>
In-Reply-To: <52E4CF03.8030208@archlinux.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="f7v2f6th4Naq9aAtjIIHt8je5vJRaxepm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--f7v2f6th4Naq9aAtjIIHt8je5vJRaxepm
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 26.01.2014 10:01, schrieb Thomas B=E4chler:
> Good morning,
>=20
> I am trying to build Linux 3.13 on i686 with CONFIG_MODVERSIONS enabled=

> (for configuration, see [2]). Upon booting it in a VM, I discovered tha=
t
> I was unable to load several kernel modules, like ext4:
>=20
> ext4: disagrees about version of symbol d_tmpfile
> ext4: Unknown symbol d_tmpfile (err -22)
> ext4: disagrees about version of symbol iov_shorten
> ext4: Unknown symbol iov_shorten (err -22)
> ext4: disagrees about version of symbol in_group_p
> ext4: Unknown symbol in_group_p (err -22)
> ext4: disagrees about version of symbol do_sync_read
> ext4: Unknown symbol do_sync_read (err -22)
> ext4: disagrees about version of symbol current_fs_time
> ext4: Unknown symbol current_fs_time (err -22)
> ext4: disagrees about version of symbol generic_write_sync
> ext4: Unknown symbol generic_write_sync (err -22)
> ext4: disagrees about version of symbol generic_getxattr
> ext4: Unknown symbol generic_getxattr (err -22)

This problem persists in v3.14, i.e. I still have to revert
83460ec8dcac14142e7860a01fa59c267ac4657c in order to get a working
kernel on i686. I would really appreciate if someone would actually read
my original mail from about 3 months ago and write an answer.



--f7v2f6th4Naq9aAtjIIHt8je5vJRaxepm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTOfc/AAoJEChPw0yOSxolAbsQALzaoc899MFNygzYlGJBWIsX
eZehVg0j+poGX1La+8Yp8YRJhbj0n24bBUYuKFb7/lpk4JXH9vFgBAJiaWdFyrIa
3UNH4VGWvWOGsUfQ4MThnq0XGTfIWNH86KYkfT/aXgf4HTJtdpnOTfWffelxhJlW
AeGJW5S6TGP6GilofiRQ4Hy+BVpAyoc06ufRQtGCDcQGVUpTDamhDUXZ3cwxrEyb
UQgBF+Z0A9U861B4k0EuwtE4ct41LcUfmJ63LeiaFW4G8/n7SZcXnMph/g/XXSmy
RXE8x18dy2oDfHldCYMSnDxewh6jHdspezH+MfriTwx5w6dz2qFm9faIDN3MpMdp
2KGNi8/ottvCvplD31OcFXwP746Pjh5+Ct2lSMxJgK0dN7v+YuRAs8pola8jx27n
x3VlE6TKyLZW4owhSJMxsYmFLzPB+VyflWW8+oe2ezk8XlEoofo8dYf8xLC3AGsm
qTgaFdkKi9C+/LOEywDSSU+OwETlpkVLaEZW3z/BjU2S6wr9DNENbSrsUHh+Irrx
yr3WdaWSofNhDOLUxu3dHi50TTfTb7wTOokTkNB7TY1PJ72L9Vj04uxvOv5Xrruc
Ao3tRQLk1kjBBLCLzzZRLG2/CIS4cJjsmtYWQ43FMZRaW9yCEkgLIuwG5mFJGrWB
A+hlUelV6f3MGYDsQgZG
=DJed
-----END PGP SIGNATURE-----

--f7v2f6th4Naq9aAtjIIHt8je5vJRaxepm--
