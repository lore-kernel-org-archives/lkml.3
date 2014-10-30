Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161138AbaJ3QzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:55:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759549AbaJ3Qyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:54:54 -0400
Date: Thu, 30 Oct 2014 09:53:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.16.7
Message-ID: <20141030165342.GA7199@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

-----------------------------------
NOTE, this is the LAST 3.16-stable kernel to be released, it is now
end-of-life, please move to the 3.17-stable series at this point in
time.
-----------------------------------

I'm announcing the release of the 3.16.7 kernel.

All users of the 3.16 kernel series must upgrade.

The updated 3.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.16.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/lzo.txt                          |  164 +++++++
 Documentation/virtual/kvm/mmu.txt              |   14=20
 Makefile                                       |    2=20
 arch/arm/boot/dts/Makefile                     |    4=20
 arch/arm/boot/dts/armada-370-netgear-rn102.dts |    4=20
 arch/arm/boot/dts/armada-370-netgear-rn104.dts |    4=20
 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts |    4=20
 arch/arm/boot/dts/at91sam9263.dtsi             |    2=20
 arch/arm/boot/dts/imx28-evk.dts                |    1=20
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts |   16=20
 arch/arm/boot/dts/kirkwood-rd88f6281-a.dts     |   43 +
 arch/arm/boot/dts/kirkwood-rd88f6281-a0.dts    |   26 -
 arch/arm/boot/dts/kirkwood-rd88f6281-a1.dts    |   31 -
 arch/arm/boot/dts/kirkwood-rd88f6281-z0.dts    |   35 +
 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi      |   27 -
 arch/arm/boot/dts/kirkwood.dtsi                |    4=20
 arch/arm/boot/dts/sama5d3_can.dtsi             |    2=20
 arch/arm/mach-at91/clock.c                     |    1=20
 arch/arm64/include/asm/compat.h                |    4=20
 arch/arm64/kernel/entry.S                      |    1=20
 arch/m68k/mm/hwtest.c                          |    6=20
 arch/powerpc/kernel/eeh_pe.c                   |   21=20
 arch/powerpc/platforms/pseries/iommu.c         |   51 +-
 arch/s390/kvm/interrupt.c                      |    1=20
 arch/sparc/Kconfig                             |    1=20
 arch/sparc/include/asm/hypervisor.h            |   11=20
 arch/sparc/include/asm/irq_64.h                |    7=20
 arch/sparc/include/asm/ldc.h                   |    5=20
 arch/sparc/include/asm/oplib_64.h              |    3=20
 arch/sparc/include/asm/page_64.h               |   33 -
 arch/sparc/include/asm/pgalloc_64.h            |   28 +
 arch/sparc/include/asm/pgtable_64.h            |  100 ++--
 arch/sparc/include/asm/setup.h                 |    2=20
 arch/sparc/include/asm/spitfire.h              |    2=20
 arch/sparc/include/asm/thread_info_64.h        |    4=20
 arch/sparc/include/asm/tsb.h                   |   87 ++-
 arch/sparc/include/asm/visasm.h                |    8=20
 arch/sparc/kernel/cpu.c                        |   12=20
 arch/sparc/kernel/cpumap.c                     |    2=20
 arch/sparc/kernel/ds.c                         |    4=20
 arch/sparc/kernel/dtlb_prot.S                  |    6=20
 arch/sparc/kernel/entry.h                      |    3=20
 arch/sparc/kernel/head_64.S                    |   52 --
 arch/sparc/kernel/hvapi.c                      |    1=20
 arch/sparc/kernel/hvcalls.S                    |   16=20
 arch/sparc/kernel/hvtramp.S                    |    1=20
 arch/sparc/kernel/ioport.c                     |    5=20
 arch/sparc/kernel/irq_64.c                     |  507 +++++++++++++++-----=
--
 arch/sparc/kernel/ktlb.S                       |  125 -----
 arch/sparc/kernel/ldc.c                        |   41 -
 arch/sparc/kernel/nmi.c                        |    1=20
 arch/sparc/kernel/pcr.c                        |   47 +-
 arch/sparc/kernel/perf_event.c                 |   10=20
 arch/sparc/kernel/process_64.c                 |    3=20
 arch/sparc/kernel/setup_64.c                   |   36 +
 arch/sparc/kernel/smp_64.c                     |    8=20
 arch/sparc/kernel/sun4v_tlb_miss.S             |   35 -
 arch/sparc/kernel/trampoline_64.S              |   12=20
 arch/sparc/kernel/traps_64.c                   |   15=20
 arch/sparc/kernel/tsb.S                        |    6=20
 arch/sparc/kernel/viohs.c                      |    4=20
 arch/sparc/kernel/vmlinux.lds.S                |   10=20
 arch/sparc/lib/NG4memcpy.S                     |   14=20
 arch/sparc/lib/memset.S                        |   18=20
 arch/sparc/mm/fault_64.c                       |    3=20
 arch/sparc/mm/gup.c                            |   30 +
 arch/sparc/mm/init_64.c                        |  554 ++++++++++++--------=
-----
 arch/sparc/mm/init_64.h                        |   18=20
 arch/sparc/net/bpf_jit_asm.S                   |    3=20
 arch/sparc/net/bpf_jit_comp.c                  |   27 -
 arch/sparc/power/hibernate_asm.S               |    4=20
 arch/sparc/prom/bootstr_64.c                   |    5=20
 arch/sparc/prom/cif.S                          |    5=20
 arch/sparc/prom/init_64.c                      |    6=20
 arch/sparc/prom/p1275.c                        |    9=20
 arch/x86/include/asm/kvm_host.h                |    1=20
 arch/x86/kernel/cpu/intel.c                    |   15=20
 arch/x86/kvm/mmu.c                             |   29 -
 arch/x86/kvm/vmx.c                             |   16=20
 arch/x86/kvm/x86.h                             |   20=20
 crypto/async_tx/async_xor.c                    |    3=20
 drivers/base/firmware_class.c                  |    3=20
 drivers/base/regmap/regmap-debugfs.c           |    8=20
 drivers/base/regmap/regmap.c                   |    7=20
 drivers/bluetooth/btusb.c                      |    9=20
 drivers/bluetooth/hci_h5.c                     |    2=20
 drivers/edac/mpc85xx_edac.c                    |    2=20
 drivers/hid/hid-rmi.c                          |   44 +
 drivers/hv/channel.c                           |   49 +-
 drivers/hv/connection.c                        |   17=20
 drivers/hv/hv.c                                |   27 -
 drivers/hv/hyperv_vmbus.h                      |    4=20
 drivers/message/fusion/mptspi.c                |    5=20
 drivers/misc/mei/bus.c                         |    2=20
 drivers/net/wireless/ath/ath9k/ar5008_phy.c    |    4=20
 drivers/net/wireless/iwlwifi/mvm/constants.h   |    2=20
 drivers/net/wireless/iwlwifi/pcie/drv.c        |    4=20
 drivers/net/wireless/rt2x00/rt2800.h           |    2=20
 drivers/pci/host/pci-mvebu.c                   |    6=20
 drivers/pci/pci-sysfs.c                        |    2=20
 drivers/pci/quirks.c                           |   20=20
 drivers/pci/setup-bus.c                        |    2=20
 drivers/regulator/ltc3589.c                    |    1=20
 drivers/rtc/rtc-cmos.c                         |    5=20
 drivers/scsi/be2iscsi/be_mgmt.c                |   13=20
 drivers/scsi/qla2xxx/qla_os.c                  |    6=20
 drivers/scsi/qla2xxx/qla_target.c              |    5=20
 drivers/spi/spi-dw-mid.c                       |   10=20
 drivers/tty/serial/omap-serial.c               |   12=20
 drivers/usb/gadget/Kconfig                     |    3=20
 drivers/usb/gadget/pch_udc.c                   |   22=20
 fs/btrfs/dev-replace.c                         |    3=20
 fs/btrfs/extent-tree.c                         |    8=20
 fs/btrfs/file.c                                |   25 -
 fs/btrfs/inode.c                               |    3=20
 fs/btrfs/ioctl.c                               |    9=20
 fs/btrfs/relocation.c                          |   93 ++--
 fs/btrfs/transaction.c                         |   12=20
 fs/ecryptfs/inode.c                            |    2=20
 fs/namespace.c                                 |    2=20
 fs/nfs/nfs4proc.c                              |    2=20
 fs/nfs/nfs4renewd.c                            |   12=20
 fs/nfs/nfs4state.c                             |   18=20
 fs/nfs/pagelist.c                              |   10=20
 fs/nfsd/nfs4xdr.c                              |    8=20
 fs/notify/fanotify/fanotify_user.c             |    2=20
 fs/xfs/xfs_aops.c                              |   16=20
 include/linux/compiler-gcc5.h                  |   66 ++
 include/linux/pci_ids.h                        |    1=20
 include/linux/sched.h                          |    6=20
 include/uapi/linux/hyperv.h                    |    2=20
 kernel/futex.c                                 |    2=20
 lib/lzo/lzo1x_decompress_safe.c                |  103 ++--
 net/bluetooth/l2cap_core.c                     |    6=20
 net/bluetooth/smp.c                            |    5=20
 security/integrity/ima/ima_appraise.c          |    7=20
 security/integrity/ima/ima_crypto.c            |    8=20
 security/integrity/ima/ima_main.c              |   12=20
 security/integrity/integrity.h                 |    1=20
 sound/core/pcm_native.c                        |    2=20
 sound/firewire/bebob/bebob_terratec.c          |    4=20
 sound/pci/emu10k1/emu10k1_callback.c           |    6=20
 sound/pci/hda/hda_local.h                      |    4=20
 sound/pci/hda/patch_hdmi.c                     |   15=20
 sound/pci/hda/patch_realtek.c                  |    7=20
 sound/usb/quirks-table.h                       |   30 +
 virt/kvm/kvm_main.c                            |   34 +
 147 files changed, 2154 insertions(+), 1191 deletions(-)

Alexander Usyskin (1):
      mei: bus: fix possible boundaries violation

Alexei Starovoitov (2):
      sparc: bpf_jit: fix support for ldx/stx mem and SKF_AD_VLAN_TAG
      sparc: bpf_jit: fix loads from negative offsets

Alexey Kardashevskiy (1):
      powerpc/iommu/ddw: Fix endianness

Allen Pais (3):
      sparc64: correctly recognise M6 and M7 cpu type
      sparc64: support M6 and M7 for building CPU distribution map
      sparc64: cpu hardware caps support for sparc M6 and M7

Anatol Pomozov (1):
      ALSA: pcm: use the same dma mmap codepath both for arm and arm64

Andreas Henriksson (1):
      ARM: at91: fix at91sam9263ek DT mmc pinmuxing settings

Andreas Larsson (1):
      sparc: Let memset return the address argument

Andrew Lunn (1):
      ARM: Kirkwood: Fix DT based DSA.

Andy Adamson (1):
      NFSv4.1: Fix an NFSv4.1 state renewal regression

Andy Lutomirski (2):
      fs: Add a missing permission check to do_umount
      x86,kvm,vmx: Preserve CR4 across VM entry

Andy Shevchenko (3):
      spi: dw-mid: respect 8 bit mode
      spi: dw-mid: check that DMA was inited before exit
      spi: dw-mid: terminate ongoing transfers at exit

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix missing ELD change event on plug/unplug

Arnaud Ebalard (2):
      ARM: mvebu: Netgear RN104: Use Hardware BCH ECC
      ARM: mvebu: Netgear RN2120: Use Hardware BCH ECC

Arun Easi (1):
      qla2xxx: Use correct offset to req-q-out for reserve calculation

Benjamin Tissoires (1):
      HID: rmi: check sanity of the incoming report

Borislav Petkov (1):
      mpc85xx_edac: Make L2 interrupt shared too

Bryan O'Donoghue (2):
      usb: pch_udc: usb gadget device support for Intel Quark X1000
      x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead

Catalin Marinas (1):
      futex: Ensure get_futex_key_refs() always implies a barrier

Champion Chen (1):
      Bluetooth: Fix issue with USB suspend in btusb driver

Chao Yu (1):
      ecryptfs: avoid to access NULL pointer when write metadata in xattr

Chris J Arges (1):
      mptfusion: enable no_write_same for vmware scsi disks

Christian Borntraeger (1):
      KVM: s390: unintended fallthrough for external call

Daniel Gl=F6ckner (1):
      rtc-cmos: fix wakeup from S5 without CONFIG_PM_SLEEP

Daniel Hellstrom (1):
      sparc32: dma_alloc_coherent must honour gfp flags

Dave Chinner (1):
      xfs: ensure WB_SYNC_ALL writeback handles partial pages correctly

Dave Kleikamp (1):
      sparc64: Increase size of boot string to 1024 bytes

David Dueck (1):
      ARM: at91/dt: Fix typo regarding can0_clk

David Henningsson (1):
      ALSA: hda - Add missing terminating entry to SND_HDA_PIN_QUIRK macro

David Matlack (3):
      kvm: x86: fix stale mmio cache bug
      kvm: fix potentially corrupt mmio cache
      kvm: don't take vcpu mutex for obviously invalid vcpu ioctls

David S. Miller (18):
      sparc64: Do not disable interrupts in nmi_cpu_busy()
      sparc64: Fix pcr_ops initialization and usage bugs.
      sparc64: Fix corrupted thread fault code.
      sparc64: Fix reversed start/end in flush_tlb_kernel_range()
      sparc64: Fix lockdep warnings on reboot on Ultra-5
      sparc64: Fix FPU register corruption with AES crypto offload.
      sparc64: Do not define thread fpregs save area as zero-length array.
      sparc64: Fix hibernation code refrence to PAGE_OFFSET.
      sparc64: Switch to 4-level page tables.
      sparc64: Define VA hole at run time, rather than at compile time.
      sparc64: Adjust KTSB assembler to support larger physical addresses.
      sparc64: Fix physical memory management regressions with large max_ph=
ys_bits.
      sparc64: Use kernel page tables for vmemmap.
      sparc64: Increase MAX_PHYS_ADDRESS_BITS to 53.
      sparc64: Adjust vmalloc region size based upon available virtual addr=
ess bits.
      sparc64: Kill unnecessary tables and increase MAX_BANKS.
      sparc64: Fix register corruption in top-most kernel stack frame durin=
g boot.
      sparc64: Implement __get_user_pages_fast().

David Sterba (1):
      btrfs: wake up transaction thread from SYNC_FS ioctl

Dmitry Kasatkin (2):
      ima: fix fallback to use new_sync_read()
      ima: provide flag to identify new empty files

Douglas Lehr (1):
      PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size

Emmanuel Grumbach (1):
      iwlwifi: mvm: disable BT Co-running by default

Fabio Estevam (1):
      ARM: dts: imx28-evk: Let i2c0 run at 100kHz

Felix Fietkau (1):
      Revert "ath9k_hw: reduce ANI firstep range for older chips"

Filipe Manana (1):
      Btrfs: add missing compression property remove in btrfs_ioctl_setflags

Frans Klaver (1):
      tty: omap-serial: fix division by zero

Gavin Shan (1):
      powerpc/eeh: Clear frozen device state in time

Geert Uytterhoeven (1):
      m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()

Greg Kroah-Hartman (1):
      Linux 3.16.7

Harsha Priya (1):
      ALSA: ALC283 codec - Avoid pop noise on headphones during suspend/res=
ume

Himanshu Madhani (1):
      qla2xxx: fix kernel NULL pointer access

J. Bruce Fields (1):
      nfsd4: reserve adequate space for LOCK op

Joe Lawrence (1):
      qla2xxx: Fix shost use-after-free on device removal

Johan Hedberg (2):
      Bluetooth: Fix incorrect LE CoC PDU length restriction based on HCI M=
TU
      Bluetooth: Fix setting correct security level when initiating SMP

Josef Ahmad (1):
      pci_ids: Add support for Intel Quark ILB

Josef Bacik (4):
      Btrfs: don't do async reclaim during log replay
      Btrfs: try not to ENOSPC on log replay
      Btrfs: cleanup error handling in build_backref_tree
      Btrfs: fix build_backref_tree issue with multiple shared blocks

Junxiao Bi (1):
      mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set

K. Y. Srinivasan (7):
      Drivers: hv: util: Properly pack the data for file copy functionality
      Drivers: hv: vmbus: Cleanup vmbus_post_msg()
      Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
      Drivers: hv: vmbus: Cleanup vmbus_close_internal()
      Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
      Drivers: hv: vmbus: Fix a bug in vmbus_open()
      Drivers: hv: vmbus: Cleanup hv_post_message()

Kees Cook (1):
      firmware_class: make sure fw requests contain a name

Liu Bo (1):
      Btrfs: fix up bounds checking in lseek

Loic Poulain (1):
      Bluetooth: Fix HCI H5 corrupted ack value

Ludovic Desroches (1):
      ARM: at91/PMC: don't forget to write PMC_PCDR register to disable clo=
cks

Mike Christie (1):
      be2iscsi: check ip buffer before copying

Olga Kornievskaia (1):
      Fixing lease renewal

Oren Givon (1):
      iwlwifi: Add missing PCI IDs for the 7260 series

Pankaj Dubey (1):
      regmap: fix NULL pointer dereference in _regmap_write/read

Paolo Bonzini (1):
      KVM: do not bias the generation number in kvm_current_mmio_generation

Qu Wenruo (1):
      btrfs: Fix a deadlock in btrfs_dev_replace_finishing()

Ricardo Ribalda Delgado (1):
      PCI: Generate uppercase hex for modalias interface class

Sage Weil (1):
      Btrfs: fix race in WAIT_SYNC ioctl

Sasha Levin (1):
      kernel: add support for gcc 5

Sowmini Varadhan (1):
      sparc64: Move request_irq() from ldc_bind() to ldc_alloc()

Stanislaw Gruszka (1):
      rt2800: correct BBP1_TX_POWER_CTRL mask

Steffen Trumtrar (1):
      regulator: ltc3589: fix broken voltage transitions

Takashi Iwai (2):
      ALSA: emu10k1: Fix deadlock in synth voice lookup
      ALSA: hda - Fix inverted LED gpio setup for Lenovo Ideapad

Takashi Sakamoto (1):
      ALSA: bebob: Fix failure to detect source of clock for Terratec Phase=
 88

Thomas Petazzoni (1):
      PCI: mvebu: Fix uninitialized variable in mvebu_get_tgt_attr()

Trond Myklebust (4):
      NFSv4: Fix lock recovery when CREATE_SESSION/SETCLIENTID_CONFIRM fails
      NFSv4: fix open/lock state recovery error handling
      NFS: Fix an uninitialised pointer Oops in the writeback error path
      NFS: Fix a bogus warning in nfs_generic_pgio

Victor Kamensky (1):
      arm64: compat: fix compat types affecting struct compat_elf_prpsinfo

Vlad Catoi (1):
      ALSA: usb-audio: Add support for Steinberg UR22 USB interface

Will Deacon (1):
      arm64: debug: don't re-enable debug exceptions on return from el1_dbg

Willy Tarreau (3):
      Documentation: lzo: document part of the encoding
      Revert "lzo: properly check for overruns"
      lzo: check for length overrun in variable length encoding.

Xiubo Li (2):
      regmap: debugfs: fix possbile NULL pointer dereference
      regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.

Xuelin Shi (1):
      dmaengine: fix xor sources continuation

Yann Droneaud (1):
      fanotify: enable close-on-exec on events' fd when requested in fanoti=
fy_init()

Yinghai Lu (1):
      PCI: Add missing MEM_64 mask in pci_assign_unassigned_bridge_resource=
s()

bob picco (4):
      sparc64: sun4v TLB error power off events
      sparc64: find_node adjustment
      sparc64: T5 PMU
      sparc64: sparse irq

klightspeed@killerwolves.net (1):
      ARM: mvebu: Netgear RN102: Use Hardware BCH ECC


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUm0WAAoJEDjbvchgkmk+SLUP/0cCMmoJFKVSalkntTiVwrjz
t9/HhjgtFmaki6qqtJ0ulUTFqlh6WV+hPXZOdCoGSYsdgzUADqL4TSbbWIhQ6dh9
jAKxjnz0G/8gNkI15R1s3YDTRx3GrZg/5ABWZ0s/9e5FF5kiAYlNzxCFFY821MTp
MVmufav/jS0nmOTd3/ME8VDPh4eDq67LPbbv1T4gbYHZydLJVm/F8AC+dYuJBR3A
IPKa+0DSpnf3gv4kmLp66yKTciM6hUHwQvRAz/hVIi5K8wbMMRKXNayWJ9EWwzaF
RVBqBcPoGC2MIGrmQejdBskQTDAt2jzPQ5Ni/b4D1DP3nHx6g1FiJksOyK23OG5q
21TCbTEmkPKXcEDo4UG7dVX8R7VxmwBsVAZAbAWmvbvYxDSmG9OeluC/sD3wybig
X+hZjKy/X0egwAstfBrOlbtA7hqPAeo6mc7xWuGM2nEpsWd/hgXUW9/gsfp4wSxk
QFBKb3fIGHRvNQcHHWlGCLRAgVDIxWkk+FUMpbDckUeMebYSRE0yhsEeE8Wlr214
Lrb3S8p6IPlaL4kvXwXSu4ikzTHqIrxtfGBehGYX9S2En0nWMm1f82TJdi+sVMeL
x4Kxy3SfsxwMyVKU5lce/hjns4Ecx74/6s/EX2UycNwlmRc86Ii4HNmLadmLgS/s
wpNG0btZEo+RdvzWhRY5
=rsXT
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
