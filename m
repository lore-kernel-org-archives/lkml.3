Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3H2SAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:00:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab3H2SAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:00:52 -0400
Date: Thu, 29 Aug 2013 11:03:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.10
Message-ID: <20130829180315.GA32335@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.10 kernel.

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

 Makefile                                      |    2=20
 arch/arc/include/asm/ptrace.h                 |    2=20
 arch/arc/include/asm/syscall.h                |    5=20
 arch/arc/kernel/entry.S                       |    4=20
 arch/arc/lib/strchr-700.S                     |   10 +
 arch/arm/boot/dts/at91sam9n12ek.dts           |    4=20
 arch/arm/boot/dts/at91sam9x5.dtsi             |    2=20
 arch/arm/mach-davinci/board-dm355-leopard.c   |    1=20
 arch/arm/mach-davinci/board-dm644x-evm.c      |    1=20
 arch/arm/mach-davinci/board-dm646x-evm.c      |    1=20
 arch/arm/mach-davinci/board-neuros-osd2.c     |    1=20
 arch/arm/mm/Kconfig                           |    9 -
 arch/arm64/kernel/perf_event.c                |   10 +
 arch/s390/kvm/kvm-s390.c                      |   21 +-
 arch/x86/include/asm/bootparam_utils.h        |    4=20
 arch/x86/kernel/sys_x86_64.c                  |    2=20
 arch/x86/mm/mmap.c                            |    8 -
 arch/x86/xen/setup.c                          |   22 ++
 arch/x86/xen/smp.c                            |   11 +
 drivers/acpi/glue.c                           |   95 ++++++++++--
 drivers/ata/libata-pmp.c                      |   12 -
 drivers/ata/sata_fsl.c                        |    5=20
 drivers/gpu/drm/i915/i915_reg.h               |    2=20
 drivers/gpu/drm/i915/intel_ringbuffer.c       |   12 +
 drivers/gpu/drm/radeon/radeon.h               |    2=20
 drivers/gpu/drm/radeon/radeon_uvd.c           |    8 +
 drivers/gpu/drm/radeon/rv770.c                |   12 -
 drivers/md/bcache/btree.c                     |   23 ++-
 drivers/md/bcache/io.c                        |    2=20
 drivers/md/bcache/journal.c                   |    2=20
 drivers/md/bcache/request.c                   |   13 +
 drivers/misc/mei/hw-me.c                      |   14 +
 drivers/misc/mei/init.c                       |    3=20
 drivers/net/wireless/hostap/hostap_ioctl.c    |    4=20
 drivers/net/wireless/iwlwifi/dvm/mac80211.c   |    5=20
 drivers/net/wireless/iwlwifi/iwl-7000.c       |   12 -
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h  |    4=20
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h |    8 -
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   |   11 -
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |    6=20
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |    1=20
 drivers/net/wireless/iwlwifi/mvm/sta.c        |   11 -
 drivers/net/wireless/iwlwifi/mvm/tx.c         |    6=20
 drivers/net/wireless/iwlwifi/pcie/trans.c     |   10 -
 drivers/net/wireless/zd1201.c                 |    4=20
 drivers/of/fdt.c                              |    2=20
 drivers/pci/pci-acpi.c                        |   15 +
 drivers/platform/olpc/olpc-ec.c               |    2=20
 drivers/s390/scsi/zfcp_erp.c                  |   29 ++-
 drivers/s390/scsi/zfcp_qdio.c                 |    8 -
 drivers/scsi/Kconfig                          |    1=20
 drivers/staging/comedi/drivers.c              |    2=20
 drivers/usb/phy/phy-fsl-usb.h                 |    2=20
 drivers/usb/phy/phy-fsm-usb.c                 |    2=20
 drivers/xen/events.c                          |   13 +
 fs/bio.c                                      |   20 +-
 fs/namespace.c                                |    2=20
 fs/nilfs2/segbuf.c                            |    5=20
 include/acpi/acpi_bus.h                       |    6=20
 include/linux/ftrace_event.h                  |    2=20
 include/linux/mm_types.h                      |    1=20
 include/linux/sched.h                         |    1=20
 include/linux/wait.h                          |   57 +++++++
 kernel/trace/ftrace.c                         |   89 +++++++++--
 kernel/trace/trace.c                          |  173 ++++++++++------------
 kernel/trace/trace_events.c                   |  198 +++++++++++++++------=
-----
 kernel/trace/trace_events_filter.c            |   17 --
 kernel/trace/trace_kprobe.c                   |   42 ++++-
 kernel/trace/trace_uprobe.c                   |   51 ++++--
 net/mac80211/mlme.c                           |   15 +
 net/nfc/llcp.h                                |    1=20
 net/nfc/llcp_sock.c                           |    8 -
 72 files changed, 810 insertions(+), 361 deletions(-)

Alex Deucher (1):
      drm/radeon/r7xx: fix copy paste typo in golden register setup

Anatolij Gustschin (1):
      usb: phy: fix build breakage

Anthony Foiani (1):
      sata_fsl: save irqs while coalescing

Anton Blanchard (1):
      SCSI: lpfc: Don't force CONFIG_GENERIC_CSUM on

Chris Wilson (1):
      drm/i915: Invalidate TLBs for the rings after a reset

Christian K=C3=B6nig (1):
      drm/radeon: fix UVD message buffer validation

Chuck Anderson (1):
      xen/smp: initialize IPI vectors before marking CPU online

Dan Carpenter (2):
      VFS: collect_mounts() should return an ERR_PTR
      Hostap: copying wrong data prism2_ioctl_giwaplist()

Daniel Drake (2):
      x86: Don't clear olpc_ofw_header when sentinel is detected
      drivers/platform/olpc/olpc-ec.c: initialise earlier

David Vrabel (3):
      xen/events: initialize local per-cpu mask for all possible events
      xen/events: mask events when changing their VCPU binding
      x86/xen: do not identity map UNUSABLE regions in the machine E820

Dominik Dingel (1):
      KVM: s390: move kvm_guest_enter,exit closer to sie

Emmanuel Grumbach (7):
      iwlwifi: mvm: correctly configure MCAST in AP mode
      iwlwifi: mvm: fix MCAST in AP mode
      iwlwifi: mvm: properly tell the fw that a STA is awake
      iwlwifi: mvm: don't set the MCAST queue in STA's queue list
      iwlwifi: mvm: take the seqno from packet if transmit failed
      iwlwifi: mvm: unregister leds when registration failed
      iwlwifi: pcie: disable L1 Active after pci_enable_device

Greg Kroah-Hartman (1):
      Linux 3.10.10

Ian Abbott (1):
      staging: comedi: bug-fix NULL pointer dereference on failed attach

Jeff Wu (1):
      ACPI: add _STA evaluation at do_acpi_find_child()

Joern Rennecke (1):
      ARC: [lib] strchr breakage in Big-endian configuration

Johannes Berg (3):
      mac80211: don't wait for TX status forever
      iwlwifi: bump required firmware API version for 3160/7260
      iwlwifi: mvm: adjust firmware D3 configuration API

Jussi Kivilinna (1):
      zd1201: do not use stack as URB transfer_buffer

Kent Overstreet (1):
      bcache: FUA fixes

Kumar Amit Mehta (1):
      md: bcache: io.c: fix a potential NULL pointer dereference

Linus Torvalds (1):
      Revert "x86 get_unmapped_area(): use proper mmap base for bottom-up d=
irection"

Martin Peschke (2):
      SCSI: zfcp: fix lock imbalance by reworking request queue locking
      SCSI: zfcp: fix schedule-inside-lock in scsi_device list loops

Masami Hiramatsu (1):
      tracing/kprobe: Wait for disabling all running kprobe handlers

Namhyung Kim (1):
      tracing: Do not call kmem_cache_free() on allocation failure

Nicolas Ferre (2):
      ARM: at91: at91sam9x5 RTC is not compatible with at91rm9200 one
      ARM: at91/DT: fix at91sam9n12ek memory node

Nicolas Pitre (1):
      ARM: 7816/1: CONFIG_KUSER_HELPERS: fix help text

Oleg Nesterov (13):
      tracing: Introduce trace_create_cpu_file() and tracing_get_cpu()
      tracing: Change tracing_pipe_fops() to rely on tracing_get_cpu()
      tracing: Change tracing_buffers_fops to rely on tracing_get_cpu()
      tracing: Change tracing_stats_fops to rely on tracing_get_cpu()
      tracing: Change tracing_entries_fops to rely on tracing_get_cpu()
      tracing: Change tracing_fops/snapshot_fops to rely on tracing_get_cpu=
()
      tracing: Turn event/id->i_private into call->event.type
      tracing: Change event_enable/disable_read() to verify i_private !=3D =
NULL
      tracing: Change event_filter_read/write to verify i_private !=3D NULL
      tracing: Change f_start() to take event_mutex and verify i_private !=
=3D NULL
      tracing: Introduce remove_event_file_dir()
      tracing: Change remove_event_file_dir() to clear "d_subdirs"->i_priva=
te
      tracing: trace_remove_event_call() should fail if call/file is in use

Radu Caragea (1):
      x86 get_unmapped_area: Access mmap_legacy_base through mm_struct memb=
er

Rafael J. Wysocki (1):
      ACPI: Try harder to resolve _ADR collisions for bridges

Rafa=C5=82 Mi=C5=82ecki (1):
      drm/radeon: fix WREG32_OR macro setting bits in a register

Roland Dreier (1):
      SCSI: sg: Fix user memory corruption when SG_IO is interrupted by a s=
ignal

Samuel Ortiz (1):
      NFC: llcp: Fix non blocking sockets connections

Sekhar Nori (1):
      ARM: davinci: nand: specify ecc strength

Stanislaw Gruszka (1):
      iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL

Steven Rostedt (Red Hat) (4):
      ftrace: Add check for NULL regs if ops has SAVE_REGS set
      tracing/kprobes: Fail to unregister if probe event files are in use
      tracing/uprobes: Fail to unregister if probe event files are in use
      ftrace: Check module functions being traced on reload

Terry Suereth (1):
      libata: apply behavioral quirks to sil3826 PMP

Tomas Winkler (3):
      mei: me: fix reset state machine
      mei: don't have to clean the state on power up
      mei: me: fix waiting for hw ready

Vineet Gupta (2):
      ARC: gdbserver breakage in Big-Endian configuration #1
      ARC: gdbserver breakage in Big-Endian configuration #2

Vyacheslav Dubeyko (2):
      nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPN=
OTSUPP error
      nilfs2: fix issue with counting number of bio requests for BIO_EOPNOT=
SUPP error detection

Will Deacon (2):
      arm64: perf: fix array out of bounds access in armpmu_map_hw_event()
      arm64: perf: fix event validation for software group leaders

Wladislav Wiebe (1):
      of: fdt: fix memory initialization for expanded DT


--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSH4zjAAoJEDjbvchgkmk+AXUP/RfNUkYfP9/r6GioejnQnURh
vm72nmBomeKlk5QwniWg5QG82R3aLGY+D5YCl5L2KhUBRsjSlmgzOXRyDfVvCoi0
/QQL7qPBDHpw419mH7XRK8ZONgxTtdasIdWn0A3n2AGKMZe5nL4IsgjeSjfNIP97
L3C8R2uAAjoLO9kMArUDrz7ltCzAt0rHtmLCBQdb3w5q64Y7ym6SsmwuTLKFvCR7
x0tnrqhPyGPw8sDtUpSgFi+8Nx2GfjSpT/uW9Fer7/ziMob9oGyVC+fsm/vWaq5E
dQc2UszArnBEvY6S7KTb9pcpipUq2IBJA0OB9dDCvkE+WzAjWIz4LJtd0UPc5rte
1N/vanN4t6ddn2BbYAC4p4LToQ1aTD+7EaMQblJ26JKU6yJdxKPYseHfW6ZMCprl
t0dtrjwz1G1iVY4yHltffr1uJsjggJIZAmKj4sHOQp9D2ambTkEsBvS3peehLM4u
VYev1VW00hfR9qjo88A2Wi3jwe9daXsUNKsNDZigXttvPIuae9AD72+vJ7VjokO5
Q3u3Oq56T1NOvZwpahehWgZyBlJ2LbLMnNnq1xy4OcKdQm0KV/1jc91x7Po/csLU
D/o3BKNhOb86V7WktwcLl0p2cxh+zcYjeGFpjd6KPXPEKr0ak7Al/IO6m6YfK3eI
s7JUSJFzrBjqaVu6/ukE
=bvEf
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
