Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaFGXL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 19:11:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaFGXLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 19:11:54 -0400
Date: Sat, 7 Jun 2014 16:11:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.42
Message-ID: <20140607231149.GA1847@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.42 kernel.

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

 Documentation/i2c/busses/i2c-i801                     |    2=20
 Documentation/input/elantech.txt                      |    5=20
 Documentation/ja_JP/HOWTO                             |    2=20
 Documentation/ja_JP/stable_kernel_rules.txt           |    6=20
 Documentation/zh_CN/HOWTO                             |    2=20
 Documentation/zh_CN/stable_kernel_rules.txt           |    2=20
 Makefile                                              |    2=20
 arch/arm/boot/dts/imx53.dtsi                          |    2=20
 arch/arm/kernel/crash_dump.c                          |    2=20
 arch/metag/include/asm/barrier.h                      |    3=20
 arch/metag/include/asm/processor.h                    |    2=20
 arch/mips/cavium-octeon/octeon-irq.c                  |    2=20
 arch/mips/lantiq/dts/easy50712.dts                    |    1=20
 arch/mips/ralink/dts/mt7620a_eval.dts                 |    1=20
 arch/mips/ralink/dts/rt2880_eval.dts                  |    1=20
 arch/mips/ralink/dts/rt3052_eval.dts                  |    1=20
 arch/mips/ralink/dts/rt3883_eval.dts                  |    1=20
 arch/parisc/include/asm/processor.h                   |    2=20
 arch/powerpc/Makefile                                 |    4=20
 arch/powerpc/include/asm/ppc_asm.h                    |    7=20
 arch/powerpc/kernel/process.c                         |   10=20
 arch/s390/crypto/aes_s390.c                           |    3=20
 arch/s390/crypto/des_s390.c                           |    3=20
 arch/x86/include/asm/hugetlb.h                        |    1=20
 arch/x86/kernel/ldt.c                                 |    4=20
 arch/x86/vdso/vdso32-setup.c                          |    8=20
 crypto/crypto_wq.c                                    |    2=20
 drivers/acpi/blacklist.c                              |   13=20
 drivers/ata/libata-core.c                             |    9=20
 drivers/ata/pata_at91.c                               |   11=20
 drivers/base/dd.c                                     |   17 +
 drivers/base/topology.c                               |    3=20
 drivers/block/xen-blkfront.c                          |  125 +++++++--
 drivers/bluetooth/ath3k.c                             |    2=20
 drivers/bluetooth/btusb.c                             |    1=20
 drivers/bus/mvebu-mbus.c                              |    6=20
 drivers/char/ipmi/ipmi_kcs_sm.c                       |    5=20
 drivers/char/ipmi/ipmi_si_intf.c                      |   46 ++-
 drivers/clk/versatile/clk-vexpress-osc.c              |    2=20
 drivers/clocksource/exynos_mct.c                      |    4=20
 drivers/crypto/caam/error.c                           |   10=20
 drivers/gpu/drm/i915/intel_display.c                  |   26 +
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c       |   19 -
 drivers/gpu/drm/nouveau/nouveau_acpi.c                |    3=20
 drivers/gpu/drm/radeon/radeon_atpx_handler.c          |    7=20
 drivers/gpu/drm/radeon/radeon_uvd.c                   |    4=20
 drivers/gpu/host1x/hw/intr_hw.c                       |    4=20
 drivers/hv/connection.c                               |    6=20
 drivers/hwmon/emc1403.c                               |    4=20
 drivers/i2c/busses/Kconfig                            |    2=20
 drivers/i2c/busses/i2c-designware-core.c              |    3=20
 drivers/i2c/busses/i2c-i801.c                         |    6=20
 drivers/i2c/busses/i2c-rcar.c                         |    9=20
 drivers/i2c/busses/i2c-s3c2410.c                      |    2=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c            |    7=20
 drivers/infiniband/ulp/isert/ib_isert.c               |   27 --
 drivers/infiniband/ulp/isert/ib_isert.h               |    2=20
 drivers/input/keyboard/atkbd.c                        |   29 ++
 drivers/input/mouse/elantech.c                        |   26 +
 drivers/input/mouse/elantech.h                        |    1=20
 drivers/input/mouse/synaptics.c                       |   10=20
 drivers/iommu/amd_iommu.c                             |    2=20
 drivers/irqchip/irq-gic.c                             |    8=20
 drivers/leds/leds-pwm.c                               |   23 -
 drivers/md/dm-crypt.c                                 |   61 ----
 drivers/md/md.c                                       |    3=20
 drivers/media/i2c/ov7670.c                            |    2=20
 drivers/media/media-device.c                          |    1=20
 drivers/media/platform/omap3isp/isp.c                 |    2=20
 drivers/media/tuners/fc2580.c                         |    6=20
 drivers/media/tuners/fc2580_priv.h                    |    1=20
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c         |   12=20
 drivers/net/wireless/ath/ath9k/xmit.c                 |    8=20
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |   14 -
 drivers/net/wireless/rt2x00/rt2x00mac.c               |   22 -
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c           |    2=20
 drivers/pci/hotplug/shpchp_ctrl.c                     |    4=20
 drivers/target/target_core_device.c                   |    8=20
 drivers/tty/serial/8250/8250_core.c                   |    2=20
 drivers/tty/serial/8250/8250_dma.c                    |    9=20
 drivers/usb/gadget/at91_udc.c                         |   10=20
 drivers/usb/host/ehci-fsl.c                           |    3=20
 drivers/usb/host/ohci-hub.c                           |   18 +
 drivers/usb/host/ohci-pci.c                           |    1=20
 drivers/usb/host/ohci.h                               |    2=20
 drivers/usb/serial/qcserial.c                         |   15 +
 drivers/usb/storage/shuttle_usbat.c                   |    2=20
 drivers/usb/storage/unusual_devs.h                    |   14 +
 fs/exec.c                                             |    6=20
 fs/nfsd/nfs4acl.c                                     |   17 -
 fs/nfsd/nfs4state.c                                   |   40 +--
 fs/posix_acl.c                                        |    6=20
 include/linux/ftrace.h                                |    2=20
 include/linux/hyperv.h                                |    7=20
 include/linux/interrupt.h                             |   40 ++-
 include/linux/irq.h                                   |    3=20
 include/trace/events/module.h                         |    2=20
 include/uapi/drm/tegra_drm.h                          |    1=20
 kernel/futex.c                                        |  239 +++++++++++++=
+----
 kernel/hrtimer.c                                      |   30 +-
 kernel/irq/manage.c                                   |   17 -
 kernel/module.c                                       |    3=20
 kernel/timer.c                                        |    2=20
 kernel/trace/ftrace.c                                 |   27 --
 kernel/workqueue.c                                    |   36 ++
 mm/memory-failure.c                                   |   15 -
 mm/memory.c                                           |    5=20
 mm/mremap.c                                           |    9=20
 mm/percpu.c                                           |    2=20
 net/bluetooth/hci_conn.c                              |    9=20
 net/bluetooth/hci_event.c                             |    6=20
 net/ceph/messenger.c                                  |   20 +
 net/mac80211/ieee80211_i.h                            |    2=20
 net/mac80211/mlme.c                                   |   26 +
 net/mac80211/offchannel.c                             |   25 +
 net/mac80211/pm.c                                     |   14 -
 sound/pci/hda/hda_intel.c                             |    3=20
 sound/soc/codecs/wm8962.c                             |   15 -
 sound/soc/codecs/wm8962.h                             |    4=20
 sound/usb/card.h                                      |    1=20
 sound/usb/endpoint.c                                  |   15 +
 121 files changed, 1026 insertions(+), 410 deletions(-)

Alan Stern (1):
      USB: OHCI: fix problem with global suspend on ATI controllers

Alex Deucher (1):
      drm/radeon: fix ATPX detection on non-VGA GPUs

Alex Williamson (1):
      iommu/amd: Fix interrupt remapping for aliased devices

Andy Grover (1):
      target: Don't allow setting WC emulation if device doesn't support

Anthony Iliopoulos (1):
      x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

Antti Palosaari (1):
      media: fc2580: fix tuning failure on 32-bit arch

Arnd Bergmann (1):
      genirq: Provide irq_force_affinity fallback for non-SMP

Atilla Filiz (1):
      iio:imu:mpu6050: Fixed segfault in Invensens MPU driver due to null d=
ereference

Bartlomiej Zolnierkiewicz (1):
      pata_at91: fix ata_host_activate() failure handling

Ben Hutchings (1):
      rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init=
()

Bj=F8rn Mork (1):
      usb: qcserial: add a number of Dell devices

Bodo Stroesser (1):
      ipmi: Fix a race restarting the timer

Charles Keepax (1):
      ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile

Chen Yucong (1):
      hwpoison, hugetlb: lock_page/unlock_page does not match for handling =
a free hugepage

Chew, Kean ho (1):
      i2c: i801: enable Intel BayTrail SMBUS

Christoph Hellwig (1):
      posix_acl: handle NULL ACL in posix_acl_equiv_mode

Chunwei Chen (1):
      libceph: fix corruption when using page_count 0 page in rbd

Clemens Ladisch (1):
      ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data

Corey Minyard (1):
      ipmi: Reset the KCS timeout when starting error recovery

Daeseok Youn (1):
      workqueue: fix bugs in wq_update_unbound_numa() failure path

Dan Carpenter (1):
      clk: vexpress: NULL dereference on error path

Daniele Forsi (2):
      usb: storage: shuttle_usbat: fix discs being detected twice
      USB: Nokia 5300 should be treated as unusual dev

Du, Wenkai (1):
      i2c: designware: Mask all interrupts during i2c controller enable

Egbert Eich (1):
      drm/i915: Break encoder->crtc link separately in intel_sanitize_crtc()

Emil Goode (1):
      brcmsmac: fix deadlock on missing firmware

Geert Uytterhoeven (1):
      Documentation: Update stable address in Chinese and Japanese translat=
ions

Grant Likely (1):
      drivercore: deferral race condition fix

Greg Kroah-Hartman (1):
      Linux 3.10.42

Guennadi Liakhovetski (2):
      media: V4L2: ov7670: fix a wrong index, potentially Oopsing the kerne=
l from user-space
      media: V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Guenter Roeck (1):
      powerpc: Fix 64 bit builds with binutils 2.24

Hans de Goede (4):
      Input: elantech - fix touchpad initialization on Gigabyte U2442
      Input: synaptics - add min/max quirk for the ThinkPad W540
      Input: synaptics - T540p - unify with other LEN0034 models
      ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015=
PX

Harald Freudenberger (1):
      crypto: s390 - fix aes,des ctr mode concurrency finding.

Horia Geanta (1):
      crypto: caam - add allocation failure handling in SPRINTFCAT macro

Ilia Mirkin (1):
      drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

J. Bruce Fields (2):
      nfsd4: warn on finding lockowner without stateid's
      nfsd4: remove lockowner when removing lock stateid

James Hogan (1):
      metag: Reduce maximum stack size to 256MB

James Ralston (1):
      i2c: i801: Add Device IDs for Intel Wildcat Point-LP PCH

Jean-Jacques Hiblot (1):
      usb: gadget: at91-udc: fix irq and iomem resource retrieval

Jianyu Zhan (1):
      percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

Jiri Bohac (1):
      timer: Prevent overflow in apply_slack

Johan Hedberg (2):
      Bluetooth: Fix triggering BR/EDR L2CAP Connect too early
      Bluetooth: Fix redundant encryption request for reauthentication

Johannes Berg (2):
      mac80211: fix suspend vs. authentication race
      mac80211: fix on-channel remain-on-channel

Josef Gajdusek (2):
      hwmon: (emc1403) fix inverted store_hyst()
      hwmon: (emc1403) Support full range of known chip revision numbers

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 ho=
sts

Kinglong Mee (1):
      NFSD: Call ->set_acl with a NULL ACL structure if no entries

Kirill A. Shutemov (1):
      mm, thp: close race between mremap() and split_huge_page()

Krzysztof Kozlowski (1):
      clocksource: Exynos_mct: Register clock event after request_irq()

Lai Jiangshan (2):
      workqueue: fix a possible race condition between rescuer and pwq-rele=
ase
      workqueue: make rescuer_thread() empty wq->maydays list before exiting

Laurent Pinchart (1):
      omap3isp: Defer probe when the IOMMU is not available

Leif Lindholm (1):
      mips: dts: Fix missing device_type=3D"memory" property in memory nodes

Leo Liu (1):
      drm/radeon: check buffer relocation offset

Leon Ma (1):
      hrtimer: Prevent remote enqueue of leftmost timers

Levente Kurusa (1):
      libata: clean up ZPODD when a port is detached

Linus Torvalds (2):
      mm: make fixup_user_fault() check the vma access rights too
      x86-64, modify_ldt: Make support for 16-bit segments a runtime option

Liu Hua (1):
      ARM: 8012/1: kdump: Avoid overflow when converting pfn to physaddr

Loic Poulain (2):
      serial: 8250: Fix thread unsafe __dma_tx_complete function
      8250_core: Fix unwanted TX chars write

Marcel Apfelbaum (1):
      PCI: shpchp: Check bridge's secondary (not primary) bus speed

Martin Peres (1):
      drm/nouveau/pm/fan: drop the fan lock in fan_update() before reschedu=
ling

Michael Neuling (1):
      powerpc/tm: Fix crash when forking inside a transaction

Mikulas Patocka (2):
      metag: fix memory barriers
      dm crypt: fix cpu hotplug crash by removing per-cpu structure

Mohammed Habibulla (1):
      Bluetooth: Add support for Lite-on [04ca:3007]

NeilBrown (1):
      md: avoid possible spinning md thread at shutdown.

Nikita Yushchenko (1):
      fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6

Olof Johansson (1):
      i2c: s3c2410: resume race fix

Roger Pau Monne (2):
      xen-blkfront: revoke foreign access for grants not mapped by the back=
end
      xen-blkfront: restore the non-persistent data path

Romain Izard (1):
      trace: module: Maintain a valid user count

Russell King (1):
      leds: leds-pwm: properly clean up after probe failure

Sagi Grimberg (2):
      Target/iser: Fix wrong connection requests list addition
      Target/iser: Fix iscsit_accept_np and rdma_cm racy flow

Salva Peir=F3 (1):
      media: media-device: fix infoleak in ioctl media_enum_entities()

Sascha Hauer (1):
      ARM: dts: i.MX53: Fix ipu register space size

Sheng-Liang Song (1):
      Input: atkbd - fix keyboard not working on some LG laptops

Stanislaw Gruszka (2):
      rt2x00: fix beaconing on USB
      ath9k: protect tid->sched check

Stephen Warren (1):
      gpu: host1x: handle the correct # of syncpt regs

Steven Rostedt (Red Hat) (1):
      ftrace/module: Hardcode ftrace_module_init() call into load_module()

Stuart Hayes (1):
      hrtimer: Prevent all reprogramming if hang detected

Takashi Iwai (1):
      ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets

Thierry Reding (1):
      drm/tegra: Remove gratuitous pad field

Thomas Gleixner (8):
      futex: Add another early deadlock detection check
      futex: Prevent attaching to kernel threads
      irqchip: Gic: Support forced affinity setting
      genirq: Allow forcing cpu affinity of interrupts
      futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr =3D=
=3D uaddr2 in futex_requeue(..., requeue_pi=3D1)
      futex: Validate atomic acquisition in futex_lock_pi_atomic()
      futex: Always cleanup owner tid in unlock_pi
      futex: Make lookup_pi_state more robust

Thomas Petazzoni (1):
      bus: mvebu-mbus: allow several windows with the same target/attribute

Tim Chen (1):
      crypto: crypto_wq - Fix late crypto work queue initialization

Trond Myklebust (2):
      NFSd: Move default initialisers from create_client() to alloc_client()
      NFSd: call rpc_destroy_wait_queue() from free_client()

Victor A. Santos (1):
      USB: Nokia 305 should be treated as unusual dev

Vincent Stehl=E9 (1):
      topology: Fix compilation warning when not in SMP

Viresh Kumar (1):
      hrtimer: Set expiry time before switch_hrtimer_base()

Wolfram Sang (1):
      i2c: rcar: bail out on zero length transfers


--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTk5w1AAoJEDjbvchgkmk+9RMQAJZwTsEMAlEPiNriQS/9sd1r
74ephjYmG9NOIXiTnGcnsLDb/qXusZNPCdpElD0ugFYqfrTHqiQnmIL4ogb2/m/f
Y3QZo4uJVhgBaK/qxdUiDqbAaMsdDiEH9jr1HYqrHleW3myB6bWwSMMg8BXVNRDs
zJt+MYyPmMoiid8M7Tycok6fYyuxDmnXeJrlPgkuGEIqZ/IeWTlgttMmHbwEZWJm
gepYpf9okQ7DBEujDsvto43GEmbKG6gwp3LZzvjraFTkvt/TbXbB7ylAWDEIuXLh
OVFSqIXcsdGZnP0u06+jDK/RVWYRwaa7oBT30Co4dQlMCWf9ufLMTchbmc1WmBkY
8zJN3SI2o8L65/Jq08lZaYOY3Ve9i5B9v8Adp3AOemrV17ojoyYdVgbFt8XF1CLz
18507iAgqmdbyDMokl6T0k4rBkkBZePXguWUvYpfUS9fZFgZFF3NYB90e5aThM1I
IBXhb3JK5e6hZZSIfqBtnfBiZm1bKMTHQbBmwuksAj7yMwARSvHlOqOwZbQbTy38
961yLEjnsovZLogKdG76WFYXxfrNh2Jqqab+AlBkknjQlT7sEIVTHe7jRzAQzeK0
sIdO9UcPygbYWthBOaPxEEDMrAWBPQkRZMvNy+/3aFBxb6qaNGNy6VyfIXCMjZzB
eLe8AKzvv4p8Z1in+V+R
=8pAX
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
