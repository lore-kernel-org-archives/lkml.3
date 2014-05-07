Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaEGTTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:19:01 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:50275 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaEGTS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:18:59 -0400
Date: Wed, 7 May 2014 12:18:55 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: [GIT PULL] MTD update for 3.15-rc5
Message-ID: <20140507191855.GF28907@ld-irv-0074>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-mtd.git tags/for-linus-20140507

for you to fetch changes up to 28c015a9daabe4ed3aeb0ccf669a3f1c2b8b81d5:

  mtd: davinci-nand: disable subpage write for keystone-nand (2014-04-30 15:26:49 -0700)

----------------------------------------------------------------
MTD update for 3.15-rc5

A single update for Keystone SoC's, whose NAND controller does not support
subpage programming.

----------------------------------------------------------------
Murali Karicheri (1):
      mtd: davinci-nand: disable subpage write for keystone-nand

 drivers/mtd/nand/davinci_nand.c | 6 ++++++
 1 file changed, 6 insertions(+)

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTaocfAAoJEFySrpd9RFgtIK8P/RtmYYI7oSe3IKcms4t3tVtf
0GD82wDjiOOoDxySKM5uXgSvoJHYvuCfydeN0vLLl78kvLPV8eD1YAuUNhNxXjSk
0oxiE3Qmf97RMjKXEVLd5LPhAKtlxr3R6k4yqVMqafFXH3iHKwfKl81BYjcWR/MG
LSiO13AoZVXpr2ULKsMgZjP1PLj0P1QYWg4Ly5xbXeRrTia1lzuR3CxJHj/rz8BL
G4VlquLcvszJ1d5XdhCw3aLmjWYorazCAlJKE/WhUPGRNotgg2kRIXKl0P1kmXMr
sNI54Qg04z2dyxLceQUwrj/Pas4VGxrrzODXTt7EQvRWAHkzgTAm9dfWySfxDU/J
ij9QaPBdafMAEM/KAj+LbkN3Eztb6yZqLB50V3/x+rnTT4CkaWOwE8uBqLo3uzPK
Sdc3sqxYy6I8f/OQna8dgLKj/PIBaVpQWojDIKz+i/hiKhB3k6eD6FV6miYla75O
HFxPEtUzRAKNWEvlZjQqu0qri+aGiBZmoHN+byT412WgSViCWl6SUBkHTPUZKIk+
l7/8bUumlyvrerWPE3Jm+R0RuXlHbsuvvn7cvuvOwG6UIJHFI+3DEKf2T7rapvbL
aN1ZUVPmwtI1mTQkrxpHOXjoKoucjTK/WQq/oylLMxWSMutZ2Jaga9yHGbKVhUje
yqjma5WX5GV3x1WId34i
=m8w3
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
