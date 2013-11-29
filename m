Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3K2TQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 14:16:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3K2TQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 14:16:47 -0500
Date: Fri, 29 Nov 2013 11:17:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.71
Message-ID: <20131129191740.GA24681@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.71 kernel.

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

 Makefile                                  |    2=20
 arch/cris/include/asm/io.h                |    1=20
 arch/ia64/include/asm/processor.h         |    2=20
 arch/powerpc/kernel/signal_32.c           |   10 +
 arch/powerpc/kernel/vio.c                 |    4=20
 arch/powerpc/platforms/powernv/pci-ioda.c |   12 +-
 arch/x86/kernel/microcode_amd.c           |    2=20
 block/blk-core.c                          |    1=20
 block/blk-settings.c                      |    1=20
 block/blk-timeout.c                       |    3=20
 crypto/ansi_cprng.c                       |    4=20
 drivers/acpi/acpica/exoparg1.c            |   48 +++++++-
 drivers/acpi/acpica/exstore.c             |  151 ++++++++++++++++++--------
 drivers/block/brd.c                       |    2=20
 drivers/block/loop.c                      |    2=20
 drivers/hwmon/lm90.c                      |   11 +
 drivers/net/can/c_can/c_can.c             |    6 -
 drivers/net/ethernet/realtek/8139cp.c     |    1=20
 drivers/net/wireless/libertas/debugfs.c   |    6 -
 drivers/net/wireless/rt2x00/rt2800usb.c   |   12 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    3=20
 drivers/scsi/aacraid/commctrl.c           |    3=20
 drivers/uio/uio.c                         |   16 ++
 drivers/usb/serial/mos7840.c              |    4=20
 drivers/video/au1100fb.c                  |   26 ----
 drivers/video/au1200fb.c                  |   23 ---
 fs/configfs/dir.c                         |   16 ++
 fs/dcache.c                               |   16 +-
 fs/exec.c                                 |    9 +
 fs/nfs/inode.c                            |    2=20
 fs/nfs/nfs3proc.c                         |    6 -
 fs/nfs/nfs4filelayout.c                   |    1=20
 fs/nfs/nfs4proc.c                         |   19 ---
 fs/nfs/nfs4state.c                        |   21 ---
 fs/nfs/proc.c                             |   43 -------
 fs/nfsd/vfs.c                             |  173 +++++++++++++++++--------=
-----
 fs/proc/inode.c                           |   12 --
 include/linux/binfmts.h                   |    3=20
 include/linux/fs.h                        |    2=20
 include/linux/sched.h                     |   22 +--
 kernel/ptrace.c                           |    3=20
 kernel/trace/trace_event_perf.c           |    2=20
 net/sunrpc/clnt.c                         |    1=20
 net/sunrpc/xprtsock.c                     |   28 +++-
 security/integrity/ima/ima_policy.c       |    1=20
 sound/isa/msnd/msnd_pinnacle.c            |    4=20
 sound/usb/6fire/chip.c                    |    2=20
 47 files changed, 410 insertions(+), 332 deletions(-)

Al Viro (1):
      Nest rename_lock inside vfsmount_lock

Andy Adamson (2):
      SUNRPC handle EKEYEXPIRED in call_refreshresult
      SUNRPC: don't map EKEYEXPIRED to EACCES in call_refreshresult

Bob Moore (4):
      ACPICA: Interpreter: Fix Store() when implicit conversion is not poss=
ible.
      ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and Buffe=
rField refs.
      ACPICA: Return error if DerefOf resolves to a null package element.
      ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a fie=
ld.

Christoph Hellwig (2):
      nfsd: split up nfsd_setattr
      nfsd: make sure to balance get/put_write_access

Dan Carpenter (1):
      libertas: potential oops in debugfs

David Woodhouse (1):
      8139cp: re-enable interrupts after tx timeout

Fan Du (1):
      include/linux/fs.h: disable preempt when acquire i_size_seqcount writ=
e lock

Gavin Shan (1):
      powerpc/powernv: Add PE to its own PELTV

Greg Kroah-Hartman (1):
      Linux 3.4.71

Guenter Roeck (1):
      hwmon: (lm90) Fix max6696 alarm handling

Jeff Layton (1):
      nfs: don't allow nfs_find_actor to match inodes of the wrong type

Jeff Moyer (1):
      block: fix race between request completion and timeout handling

Johan Hovold (1):
      USB: mos7840: fix tiocmget error handling

Junxiao Bi (1):
      configfs: fix race between dentry put and lookup

Kees Cook (1):
      exec/ptrace: fix get_dumpable() incorrect tests

Linus Torvalds (2):
      vfs,proc: guarantee unique inodes in /proc
      Fix a few incorrectly checked [io_]remap_pfn_range() calls

Mahesh Rajashekhara (1):
      aacraid: prevent invalid pointer dereference

Markus Pargmann (1):
      can: c_can: Fix RX message handling, handle lost message before EOB

Mauro Carvalho Chehab (1):
      cris: media platform drivers: fix build

Michael Neuling (1):
      powerpc/signals: Mark VSX not saved with small contexts

Mike Snitzer (1):
      block: properly stack underlying max_segment_size to DM device

Mikulas Patocka (1):
      block: fix a probe argument to blk_register_region

Mimi Zohar (1):
      Revert "ima: policy for RAMFS"

Neil Horman (1):
      crypto: ansi_cprng - Fix off by one error in non-block size request

Oleg Nesterov (1):
      exec: do not abuse ->cred_guard_mutex in threadgroup_lock()

Prarit Bhargava (1):
      powerpc/vio: use strcpy in modalias_show

Stanislaw Gruszka (2):
      rt2x00: check if device is still available on rt2x00mac_flush()
      rt2800usb: slow down TX status polling

Steven Rostedt (1):
      perf/ftrace: Fix paranoid level for enabling function tracer

Takashi Iwai (2):
      ALSA: 6fire: Fix probe of multiple cards
      ALSA: msnd: Avoid duplicated driver name

Thomas Renninger (1):
      x86/microcode/amd: Tone down printk(), don't treat a missing firmware=
 file as an error

Trond Myklebust (2):
      NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()
      SUNRPC: Fix a data corruption issue when retransmitting RPC calls


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmOhUAAoJEDjbvchgkmk+VeoQAIpLtAL+emTTTKZ7/XPsF/Gc
EITthdlwbajee3YR3clT2ndI0rvnkz3aIr0KNPNbkdgZC+in8a1fMqN1z5oBMBg5
MlUDTAC4RJONVfJyQZQCR/yY3CqBU/cY5TRdHVVT1yIbvWBSZkPTb8fftcazq8QQ
R23GqQ8YTAKyn7o+2Vjov6YeCQWodQ1drN++Z9FazQtBbapwKjQqud+fXNWr9Uz9
Vpv7PAbrfmkO+u6ptkQFIH543zQKGzM3F96fvuUJWF9xCsizvlQo5xyW7hWFW8iV
RvvqkJlgBShfSbI5zezBcJ5FNlo6viB/Vfj6hRF+pGoaiQWbxGCp6ij4hThnimij
0gQkqm88XYcortxwp2cX5uG1krtb+idJIXxIrZihi850C0/FIGqzQ+/r89zNMo9K
zDdgj4jmbR2xSNvaGJcxA8o9+CYQ64Wy/1yv4vrcL8w8t4dAKN1AfZjcm4wCdYEU
j5N9R3FJl4GZKHFMGKv4E4O8tiCQvebrXUZbzSAxzQYG1Y2YiMDwshRAdA4XUeEu
ZL67Y3cRsgogy2xoEfSqRATSGz8HUKiaaRoK3/OcuiNnp10PgdrMR5mOKcPDYn+0
3Kmmln8ArDr6DxIanzlV/o7H3aCakWVq8rkOUItGk9EflnuoQKuwwNjYHXNNrBkG
YAeqPOOnURseHhruLobs
=FVkT
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
