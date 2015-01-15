Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbbAOG2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 01:28:37 -0500
Received: from ozlabs.org ([103.22.144.67]:50400 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbbAOG2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 01:28:36 -0500
Message-ID: <1421303314.11409.8.camel@ellerman.id.au>
Subject: [git pull] Please pull mpe/linux.git powerpc-3.19-4 tag
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: anton@samba.org, imunsie@au1.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 15 Jan 2015 17:28:34 +1100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1up06bJChQYA9ewoalpE"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1up06bJChQYA9ewoalpE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull some more powerpc fixes for 3.19:

The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115=
:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git tags/powerpc-=
3.19-4

for you to fetch changes up to a87e810f61b49f19bd29ea564b7cd1e92e43d989:

  powerpc: Work around gcc bug in current_thread_info() (2015-01-12 16:40:0=
2 +1100)

----------------------------------------------------------------
Anton Blanchard (1):
      powernv: Fix OPAL tracepoint code

Ian Munsie (1):
      cxl: Fix issues when unmapping contexts

Michael Ellerman (1):
      powerpc: Work around gcc bug in current_thread_info()

 arch/powerpc/include/asm/thread_info.h         | 13 ++--
 arch/powerpc/platforms/powernv/opal-wrappers.S |  1 -
 drivers/misc/cxl/context.c                     | 82 ++++++++++++++++++++--=
----
 drivers/misc/cxl/file.c                        | 14 +++--
 4 files changed, 78 insertions(+), 32 deletions(-)



--=-1up06bJChQYA9ewoalpE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUt14SAAoJEFHr6jzI4aWAG7sP/2t44f+VZh1g6Jx1EjiZotYi
o1QSfxQ6OuEXE8tMHQtLCVKy5FqKZHZjayS/+MyrF+5TCWeXchdoCEMuxooR0O1N
zpIvzepN+J6nGkjELRwqAI4sd5ifx37xL02Ex61NWYpTJEpatUbt12A9htEW4LSp
pNAc8RzyCmi72yepE77+ypdnckhl+efzzp6kSI0PMILw0RLyt0TrAVMd2XQGi62U
T8347j6LgX/HLBKDxpZhIiWqY6XNbX/yXG2SN1Zgjp2qMFPG5fF+VX4cEknSUQ5K
/EcHXo9O1OjNTT+q3EcJq7XqTrUPdBujRQw0OhsCQfToE8LX17PucAmcB35jtsKd
yk160kdqCEDOVLUmjVXphVCCfTIlcBuXtLS6uKYDYdAXuUEQKXs/PNMWwLNLF81t
/zJVfy38pj5fUHBC2jy5xEpRaGXw3s3gzd3qObl3jArNzYGLlQqf99odMBfVSShG
cqI9Yt5pfw8JE4ERjkGjibrRRg9/w24Tt/0BxbRaqEBq3empvXGwj0zDEEwDmM2n
vJJWcaIvNH5yU6+bkUzL9P2QDHodlwAUlP3jpmM+LtxPbxss6Tro4PP+/qtPEAbg
1ojeAGRWpymQDQb7GEQ4dW9fiWoJux2+1q+j7ZP5FPojqsDObUQX23UXvpErxgu9
X9kk2Ihn9UdMBJXanTJW
=QDxM
-----END PGP SIGNATURE-----

--=-1up06bJChQYA9ewoalpE--

