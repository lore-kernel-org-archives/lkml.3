Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbaDBUDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:03:40 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62005 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaDBUDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:03:37 -0400
Message-ID: <533C6D15.3080902@suse.cz>
Date: Wed, 02 Apr 2014 22:03:33 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net
Subject: Linux 3.12.16
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm announcing the release of the 3.12.16 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

- ----------------------------------------------------------------
AKASHI Takahiro (1):
      arm64: check for number of arguments in syscall_get/set_arguments()

Alexei Starovoitov (1):
      x86: bpf_jit: support negative offsets

Anton Blanchard (1):
      ibmveth: Fix endian issues with MAC addresses

Ben Hutchings (3):
      sfc: Use the correct maximum TX DMA ring size for SFC9100
      deb-pkg: Fix building for MIPS big-endian or ARM OABI
      deb-pkg: Fix cross-building linux-headers package

Catalin Marinas (2):
      arm64: dts: Reserve the memory used for secondary CPU release
address
      arm64: Use Normal NonCacheable memory for writecombine

Charles Keepax (1):
      ALSA: compress: Pass through return value of open ops callback

Chris Wilson (1):
      drm/i915: Disable stolen memory when DMAR is active

Christian Riesch (1):
      net: davinci_emac: Replace devm_request_irq with request_irq

Christoffer Dall (1):
      ARM: 7950/1: mm: Fix stage-2 device memory attributes

Dan Carpenter (4):
      media: cxusb: unlock on error in cxusb_i2c_xfer()
      media: dw2102: some missing unlocks on error
      media: cx18: check for allocation failure in cx18_read_eeprom()
      p54: clamp properly instead of just truncating

Dave Jones (1):
      fs/proc/proc_devtree.c: remove empty /proc/device-tree when no
openfirmware exists.

Emmanuel Grumbach (1):
      iwlwifi: mvm: don't WARN when statistics are handled late

Fernando Luis Vazquez Cao (1):
      HID: hidraw: fix warning destroying hidraw device files after parent

Gavin Shan (1):
      powerpc/eeh: Handle multiple EEH errors

Hans de Goede (1):
      Input: elantech - improve clickpad detection

Heiko Carstens (1):
      s390/dasd: hold request queue sysfs lock when calling
elevator_init()

Ilya Dryomov (3):
      libceph: rename ceph_msg::front_max to front_alloc_len
      libceph: rename front to front_len in get_reply()
      libceph: fix preallocation check in get_reply()

Jiri Slaby (2):
      iscsi/iser-target: fix build warning
      Linux 3.12.16

Josh Durgin (2):
      libceph: block I/O when PAUSE or FULL osd map flags are set
      libceph: resend all writes after the osdmap loses the full flag

Li Zefan (1):
      cgroup: protect modifications to cgroup_idr with cgroup_mutex

Linus Torvalds (1):
      printk: fix syslog() overflowing user buffer

Magnus Damm (1):
      ARM: 7864/1: Handle 64-bit memory in case of 32-bit phys_addr_t

Marcelo Tosatti (3):
      KVM: MMU: handle invalid root_hpa at __direct_map
      KVM: x86: handle invalid root_hpa everywhere
      KVM: VMX: fix use after free of vmx->loaded_vmcs

Markus Pargmann (1):
      regulator: core: Replace direct ops->disable usage

Mengdong Lin (3):
      ALSA: hda - add device ID for Broadwell display audio controller
      ALSA: hda - add codec ID for Broadwell display audio codec
      ALSA: hda/hdmi - apply all Haswell fix-ups to Broadwell display
codec

Michele Baldessari (1):
      e100: Fix "disabling already-disabled device" warning

Ping Cheng (1):
      Input: wacom - make sure touch_max is set for touch devices

Russell King (1):
      ARM: ignore memory below PHYS_OFFSET

Sarah Sharp (1):
      xhci: Fix resume issues on Renesas chips in Samsung laptops

Simon Wood (1):
      HID:hid-lg4ff: Initialize device properties before we touch
autocentering.

Stefan Agner (1):
      clocksource: vf_pit_timer: use complement for sched_clock reading

Stephen Warren (2):
      ARM: tegra: only run PL310 init on systems with one
      ASoC: max98090: make REVISION_ID readable

Trond Myklebust (1):
      NFSv4: Fix another nfs4_sequence corruptor

Vaibhav Nagarnaik (1):
      tracing: Fix array size mismatch in format string

 Makefile                                   |   2 +-
 arch/arm/include/asm/pgtable-3level.h      |  13 ++-
 arch/arm/kernel/setup.c                    |  30 +++++-
 arch/arm/mach-tegra/common.c               |  11 +++
 arch/arm/mm/mm.h                           |   1 +
 arch/arm/mm/mmu.c                          |   7 +-
 arch/arm64/boot/dts/foundation-v8.dts      |   2 +
 arch/arm64/include/asm/pgtable.h           |   2 +-
 arch/arm64/include/asm/syscall.h           |   6 ++
 arch/powerpc/include/asm/eeh.h             |  10 ++
 arch/powerpc/kernel/eeh_driver.c           | 150
+++++++++++++++--------------
 arch/powerpc/platforms/powernv/eeh-ioda.c  |  39 +++++---
 arch/x86/kvm/mmu.c                         |  12 +++
 arch/x86/kvm/paging_tmpl.h                 |   8 ++
 arch/x86/kvm/vmx.c                         |   2 +-
 arch/x86/net/bpf_jit.S                     |   2 +-
 drivers/clocksource/vf_pit_timer.c         |   2 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c     |   7 ++
 drivers/hid/hid-lg4ff.c                    |  22 ++---
 drivers/hid/hidraw.c                       |   4 +-
 drivers/infiniband/ulp/isert/ib_isert.c    |   1 -
 drivers/input/mouse/elantech.c             |  45 ++++++++-
 drivers/input/tablet/wacom_sys.c           |   7 +-
 drivers/media/pci/cx18/cx18-driver.c       |   5 +-
 drivers/media/usb/dvb-usb/cxusb.c          |  21 +++-
 drivers/media/usb/dvb-usb/dw2102.c         |  52 +++++++---
 drivers/net/ethernet/ibm/ibmveth.c         |  25 +++--
 drivers/net/ethernet/ibm/ibmveth.h         |   1 -
 drivers/net/ethernet/intel/e100.c          |   2 +-
 drivers/net/ethernet/sfc/efx.h             |   3 +
 drivers/net/ethernet/sfc/ethtool.c         |   4 +-
 drivers/net/ethernet/ti/davinci_emac.c     |  25 ++++-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c |   7 +-
 drivers/net/wireless/p54/txrx.c            |   2 +-
 drivers/regulator/core.c                   |  34 +++----
 drivers/s390/block/dasd.c                  |   8 +-
 drivers/usb/host/xhci-pci.c                |   5 +
 fs/nfs/nfs4proc.c                          |  10 +-
 fs/proc/proc_devtree.c                     |   1 +
 include/linux/ceph/messenger.h             |   2 +-
 include/linux/ceph/osd_client.h            |   1 +
 include/linux/cgroup.h                     |   2 +
 include/linux/ftrace_event.h               |   4 -
 include/linux/nfs_xdr.h                    |   5 +
 include/trace/ftrace.h                     |   7 +-
 kernel/cgroup.c                            |  26 ++---
 kernel/printk/printk.c                     |   2 -
 kernel/trace/trace_events.c                |   6 --
 kernel/trace/trace_export.c                |   7 +-
 net/ceph/messenger.c                       |   7 +-
 net/ceph/mon_client.c                      |   8 +-
 net/ceph/osd_client.c                      |  66 ++++++++++---
 scripts/package/builddeb                   |  13 ++-
 sound/core/compress_offload.c              |   2 +-
 sound/pci/hda/hda_intel.c                  |   3 +
 sound/pci/hda/patch_hdmi.c                 |  17 ++--
 sound/soc/codecs/max98090.c                |   1 +
 57 files changed, 506 insertions(+), 263 deletions(-)

thanks,
- -- 
js
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTPG0VAAoJEL0lsQQGtHBJZI0P/RM8P0tu8cUwFYVHu/Ra2WWO
HEwAM8gOrnMLPuKj00fmQbgQk0fkL2sAoD/nrg1SWxfLEs/abPI8ISFuXI48z02V
Pb+xPtDvXOVw+FrlKYkXNT0Wvecm+XPmu6q8i49AR48FQqwZBfVfWmlxIKh9baD1
NlV9KHVpxvu6sbmjnaZsWBxYKUfqbVeqocCojew+Pyvjeq25WgaRd9LCUQWPT3kN
g82ZjzsA0DuMw6pX6l6EG1TTlUqbQF/PwphVK0xPR+JsStU6xo4mo6FIgopPajJn
n3QXLzjfr2lW8KrJB45GgHVJr+Pz96J5q0a3Jywf7SpY5cPhSgJVp4nUI9Wj+aRu
ymQXZDjcpV5/O5DU+nqQ828Qsgu3vEZ058MGC8uB3sK3RZIIrd6pP/oWmXyj4bPD
/f81BtAd8om3vr+IVDZNhQjOSUMkNjUDXeDVxEi/L8hU7bStY8vQscGPU+4pRjM1
inJHZg5pZrhE0knfRgQuMQgyIATgIhNU4/2JBNtAYR77kY6ZyDRXBAYLr8vD0GWV
edWKADWMjgaTRIX5yJO2B8ibK8EqcJ1pV58+uBoPZtdO3rpVHD/m98yfo9y+I611
l5RohP0S+xIBVSRkemlT4/Bdh5BORjwCGCP1lYzo31cm5pJQsfFd6SZDxvPx0Ws0
uNCJ/9hP/hSs1cZ22COS
=fHYT
-----END PGP SIGNATURE-----
