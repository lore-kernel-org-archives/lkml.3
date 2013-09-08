Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab3IHFbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 01:31:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab3IHFbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 01:31:41 -0400
Date: Sat, 7 Sep 2013 22:34:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.61
Message-ID: <20130908053443.GA3236@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.61 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/powerpc/Kconfig                          |    1=20
 arch/powerpc/include/asm/page.h               |   10 ++++
 drivers/acpi/ec.c                             |    4 +
 drivers/base/memory.c                         |    2=20
 drivers/base/regmap/regmap.c                  |    2=20
 drivers/gpu/drm/i915/i915_reg.h               |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c           |   58 +++++++++++++++++----=
-----
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   10 ++++
 drivers/net/wireless/iwlegacy/4965-mac.c      |    2=20
 drivers/target/target_core_cdb.c              |    9 ++--
 drivers/tty/hvc/hvsi_lib.c                    |    4 -
 fs/bio.c                                      |   20 ++++++--
 fs/jfs/jfs_dtree.c                            |   31 ++++++++++---
 net/sunrpc/xdr.c                              |    9 ++--
 sound/isa/opti9xx/opti92x-ad1848.c            |    8 ---
 16 files changed, 124 insertions(+), 50 deletions(-)

Dave Kleikamp (1):
      jfs: fix readdir cookie incompatibility with NFSv4

Eugene Surovegin (1):
      powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.

Greg Kroah-Hartman (1):
      Linux 3.4.61

Helmut Schaa (1):
      ath9k_htc: Restore skb headroom when returning skb to mac80211

Imre Deak (1):
      drm/i915: ivb: fix edp voltage swing reg val

Jakob Bornecrantz (1):
      drm/vmwgfx: Split GMR2_REMAP commands if they are to large

Lan Tianyu (1):
      ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

Nicholas Bellinger (1):
      target: Fix trailing ASCII space usage in INQUIRY vendor+model

Paul Bolle (1):
      regmap: silence GCC warning

Paul Mackerras (1):
      powerpc: Work around gcc miscompilation of __pa() on 64-bit

Roland Dreier (1):
      SCSI: sg: Fix user memory corruption when SG_IO is interrupted by a s=
ignal

Russ Anderson (1):
      drivers/base/memory.c: fix show_mem_removable() to handle missing sec=
tions

Stanislaw Gruszka (1):
      iwl4965: fix rfkill set state regression

Takashi Iwai (1):
      ALSA: opti9xx: Fix conflicting driver object name

Trond Myklebust (1):
      SUNRPC: Fix memory corruption issue on 32-bit highmem systems


--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLAxzAAoJEDjbvchgkmk+JfEP/icNDi9dG6EbnWusHwgoP8Wc
Qa/a8In12+XUAM28JQ0bdXx9GKhtGA770ohNiyorbu/iCA2X0xd8I1gsWKNqXyHd
7yrOD51bJKmtLVZe3p9rFDxWVbmqG8DaqlAdlTFTOaGuHIeEjFQZbrA4UqwjBT9q
HBF8W1l4GwGZ27fWTzFL5TSFcLTaJZQ7F6vbcpOezPri7H7CJ8agXSEYzWiMDGDL
6by+SYl7Kr8biEnjRkdAu0JLI6XUfGVcdINBSr1BWDN0uhU8Ix1JgjGdxQpvnfhY
dosGKF6RHXkqWe75Xxoga0CdWxYdNtOBPSPmlgU3wecBRM92od5qq3D5JoGj74MS
XZOMygmycvYcCnEhJ/CTLqroLt87R7Mlr+bEuT1Gwy+UEwWqbpSMeX55IaZ37wjk
sUADj7lG85m6fTy2FbQBnnf9CYdJH8ob4LKAZ+3I8eGpVgeEEQ/8sm7Qj+LmW4X0
XIrpTov25d9Y6lnXe79dmLh3qKOD2H3dsODv8FyPS+lgGBwXIqUXZekUn/YODak6
XeeimLRxpQPKv13b3ung2ODOulZ0XffplMDJSPeY52qHKiIhrVICMFciPJtIlvXB
2AKFwFitK0oiAZ0r7oqx6cestbppTH8lURYxuJflWantzE1D6IkRHJ+auPOKjCPW
fV7DRyoHbKsGoR8ZQ7/g
=jkyP
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
