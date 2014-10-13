Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaJMGdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:33:13 -0400
Received: from ozlabs.org ([103.22.144.67]:60422 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbaJMGdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:33:11 -0400
Date: Mon, 13 Oct 2014 17:33:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Weinberger <richard@nod.at>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: status of the signal-cleanup tree
Message-ID: <20141013173301.0664c8ac@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/SBmHiDWyvlq=Zett1HN5S_J"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SBmHiDWyvlq=Zett1HN5S_J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Richard,

The signal-cleanup tree
(git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git#signal_v4)
has not bee touched since July and when merged into Linus' tree,
produces no changes (same patches different commits :-().  So all it is
doing at the moment is producing unnecessary conflicts :-(

Can you clean it up, please?  Or should I just remove it
from linux-next completely.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/SBmHiDWyvlq=Zett1HN5S_J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUO3IiAAoJEMDTa8Ir7ZwVCc8P/R6wytPJi7OZcecOA9091qNg
hXkLuqrsPMIe3i1f0d/9EnrIXxBdq/CqbpU+8miQ/XtONI+ZtBT4V11QV9GjpPix
sYUYbwP/1DE5odOT1829+LvUvSpRbrCOFPVWIUvCyc5Cub+kegR96LmP1eWeQiWo
5iPYiP46PaTTBIkE2BzPz79J70GaYverFlM/Kk7u8S81674gL/vTgyJ5yu6v18K/
i/qrEfbLAYHHP15jpOhJ2jZ4HeGsvDdZyH7RVihJmsKHVMPR9+tL8MEHs+MYpOmL
/YW8IO2DNqyUcqO3mVV+rNTMSZxXs1UW04n7cF3fuCtmA6Jk5YURFhhJkn0UVEXG
IvD94+7OqyHf7EYqMusksjsgdOgfMpSd0WBT8bpkyksQF8LF3jwVm2W4/ZVJxt5g
ye5cbnbbkTuQA6/aK2wOBcVokCLCPrt5SWngdMJmc39FdlPjljcTu0fBI571P4yT
gdUGzpFTcvshW+DBwr1bMeRLW4Dy7geTxEMJpPVLYy4jGYD6Ijm45848clJMajSp
Q+YZxYQsysXTS7tBkaJK8Stj31CXnkk3dhnh3Ffx4f8qpTuB35/7XYylt5YSEP6D
i9QQm6HGy6ZgD5NoT8YCdXKVUuzCxoEIkZVuX+bFUlERlAgbKOyaMfnE/L6sSg/C
zxRo43nUsaHpIMzHj8uQ
=74xi
-----END PGP SIGNATURE-----

--Sig_/SBmHiDWyvlq=Zett1HN5S_J--
