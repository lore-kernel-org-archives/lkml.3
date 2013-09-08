Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab3IHFcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 01:32:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3IHFcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 01:32:22 -0400
Date: Sat, 7 Sep 2013 22:35:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.11
Message-ID: <20130908053516.GA8177@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.11 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/hwmon/k10temp                      |    1=20
 Makefile                                         |    2=20
 arch/arm/xen/enlighten.c                         |    1=20
 arch/powerpc/Kconfig                             |    1=20
 arch/powerpc/include/asm/page.h                  |   10 +++
 arch/powerpc/kernel/lparcfg.c                    |   22 +++-----
 arch/x86/mm/init.c                               |    4 -
 drivers/acpi/ec.c                                |    4 +
 drivers/base/memory.c                            |    2=20
 drivers/base/regmap/regcache-rbtree.c            |    2=20
 drivers/gpu/drm/i915/i915_reg.h                  |    2=20
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h |    7 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c    |    6 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.c    |    3 -
 drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c    |    3 -
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c    |    3 -
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c    |    3 -
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c    |    3 -
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c              |   58 +++++++++++++++---=
-----
 drivers/hwmon/Kconfig                            |    4 -
 drivers/hwmon/k10temp.c                          |    3 -
 drivers/misc/hpilo.c                             |    4 -
 drivers/misc/mei/hw-me.c                         |    8 +--
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c    |   10 +++
 drivers/net/wireless/ath/ath9k/init.c            |    3 -
 drivers/net/wireless/ath/ath9k/main.c            |    3 -
 drivers/net/wireless/ath/carl9170/main.c         |    3 -
 drivers/net/wireless/iwlegacy/4965-mac.c         |    2=20
 drivers/net/wireless/rt2x00/rt2800lib.c          |    3 -
 drivers/scsi/pm8001/pm8001_hwi.c                 |    4 -
 drivers/scsi/pm8001/pm80xx_hwi.c                 |    4 -
 drivers/staging/imx-drm/imx-drm-core.c           |    1=20
 drivers/target/iscsi/iscsi_target.c              |   17 +++---
 drivers/target/iscsi/iscsi_target_login.c        |    9 +--
 drivers/target/target_core_spc.c                 |    9 ++-
 drivers/tty/hvc/hvsi_lib.c                       |    4 -
 drivers/usb/gadget/f_acm.c                       |    1=20
 fs/jfs/jfs_dtree.c                               |   31 +++++++++---
 include/linux/regmap.h                           |    1=20
 include/net/mac80211.h                           |    1=20
 ipc/msg.c                                        |    5 +
 kernel/time/timer_list.c                         |   41 +++++++++-------
 kernel/workqueue.c                               |    9 +++
 mm/slab.h                                        |    2=20
 net/mac80211/ibss.c                              |    1=20
 net/mac80211/rc80211_minstrel_ht.c               |    3 +
 net/sunrpc/xdr.c                                 |    9 ++-
 sound/isa/opti9xx/opti92x-ad1848.c               |    8 ---
 sound/pci/hda/patch_hdmi.c                       |    3 +
 sound/pci/hda/patch_realtek.c                    |    1=20
 50 files changed, 220 insertions(+), 124 deletions(-)

Andrey Vagin (1):
      memcg: check that kmem_cache has memcg_params before accessing it

Ben Skeggs (1):
      drm/nouveau/mc: fix race condition between constructor and request_ir=
q()

Benjamin Herrenschmidt (1):
      powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hype=
rvisor

Dave Kleikamp (1):
      jfs: fix readdir cookie incompatibility with NFSv4

David Jander (1):
      regmap: rbtree: Fix overlapping rbnodes.

Eugene Surovegin (1):
      powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.

Fabio Estevam (1):
      imx-drm: imx-drm-core: Export imx_drm_encoder_get_mux_id

Felix Fietkau (1):
      mac80211: add a flag to indicate CCK support for HT clients

Graham Williams (1):
      usb: acm gadget: Null termintate strings table

Greg Kroah-Hartman (1):
      Linux 3.10.11

Hans Verkuil (1):
      SCSI: pm80xx: fix Adaptec 71605H hang

Helmut Schaa (1):
      ath9k_htc: Restore skb headroom when returning skb to mac80211

Imre Deak (1):
      drm/i915: ivb: fix edp voltage swing reg val

Jakob Bornecrantz (1):
      drm/vmwgfx: Split GMR2_REMAP commands if they are to large

Johannes Berg (1):
      mac80211: add missing channel context release

Julien Grall (1):
      xen/arm: missing put_cpu in xen_percpu_init

Kevin Hilman (1):
      regmap: Add another missing header for !CONFIG_REGMAP stubs

Lan Tianyu (1):
      ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

Mark Rusk (1):
      drivers/misc/hpilo: Correct panic when an AUX iLO is detected

Nathan Zimmer (1):
      timer_list: correct the iterator for timer_list

Nicholas Bellinger (4):
      target: Fix trailing ASCII space usage in INQUIRY vendor+model
      iscsi-target: Fix ImmediateData=3DYes failure regression in >=3D v3.10
      iscsi-target: Fix iscsit_transport reference leak during NP thread re=
set
      iscsi-target: Fix potential NULL pointer in solicited NOPOUT reject

Paul Mackerras (1):
      powerpc: Work around gcc miscompilation of __pa() on 64-bit

Russ Anderson (1):
      drivers/base/memory.c: fix show_mem_removable() to handle missing sec=
tions

Stanislaw Gruszka (1):
      iwl4965: fix rfkill set state regression

Sujith Manoharan (1):
      ath9k: Enable PLL fix only for AR9340/AR9330

Svenning Soerensen (1):
      IPC: bugfix for msgrcv with msgtyp < 0

Takashi Iwai (3):
      ALSA: hda - Fix NULL dereference with CONFIG_SND_DYNAMIC_MINORS=3Dn
      ALSA: hda - Add inverted digital mic fixup for Acer Aspire One
      ALSA: opti9xx: Fix conflicting driver object name

Tejun Heo (1):
      workqueue: cond_resched() after processing each work item

Tomas Winkler (1):
      mei: me: fix hardware reset flow

Trond Myklebust (1):
      SUNRPC: Fix memory corruption issue on 32-bit highmem systems

Wei Hu (1):
      hwmon: (k10temp) Add support for Fam16h (Kabini)

Yinghai Lu (1):
      x86/mm: Fix boot crash with DEBUG_PAGE_ALLOC=3Dy and more than 512G R=
AM


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLAyUAAoJEDjbvchgkmk+i1oQAJ9nxKIs04b3ZYOJfeu4ZAFc
UzGRUlQv9t7Xn2abVeaVtVgCQ7jrEIoKn5OIPJceq2H0nP138ugH4U81kF+OsVpO
hWWp+nHkuHOMhLmKEvn6NYA6vSpyGuMVcJfq7qrcfT2j0vN3tUnautLIbYtoaGXJ
MNDNOM1/qUIOeuv3KZBuLRUJY331F5zuMjKa1NzEedV8O2/RtbQ7qrpZa/ncOYgT
mHrxzKmRNf7jZnOosy/U49qDQER7hbTnYA/RRO59tqrfYNyB6Z3oleQ63myKBJ7c
60ySO87QhgENzVlZqV1IZ8ZWtU5g6iz/uuVv7hf6SdHDJ+tWzgK7TovG26z/VIYh
olMGpm7AptgnIo4bntTkDZ6qXbKtAY9UxFDRJQEB5NYUGTECfRthPys67yXdfW/H
UDimPrgDeYw5xONHWsu8ccJmbGeAxBA42mRY977jFHTCn5lhK8WfeJz1cRDrAiWV
OPVcfTo7zwiNoJoVgGMdbocW2wbfuAiZWV302oaesCn1lMWNhHVDa6WwcorSKe+r
Qeknuoz+oxq9nOUS0jZaV6YtlNHxC6jBe0BabIKgXih37DEMMJCC/Iu8ve36hroX
AS85+K9pXJOo/XRMfeWtx3xKw4mM9ECjFF6bFUO/onpxbt3I0oki2Hg8xvfk/RWR
gq83e5mdVdaV2lcC08sy
=9lkA
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
