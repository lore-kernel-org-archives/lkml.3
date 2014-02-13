Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaBMW1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:27:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaBMW1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:27:42 -0500
Date: Thu, 13 Feb 2014 14:29:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.11
Message-ID: <20140213222900.GA14174@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.11 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/filesystems/proc.txt                 |    4=20
 Makefile                                           |    2=20
 arch/arm/mach-mvebu/mvebu-soc-id.c                 |    2=20
 arch/arm/plat-orion/irq.c                          |   47 +++++
 arch/sh/kernel/kgdb.c                              |    1=20
 arch/tile/include/asm/compat.h                     |    1=20
 arch/x86/include/asm/pgtable_types.h               |    3=20
 arch/x86/xen/platform-pci-unplug.c                 |   74 ++++++++
 arch/xtensa/platforms/xtfpga/setup.c               |   12 -
 drivers/acpi/bus.c                                 |    9=20
 drivers/block/xen-blkfront.c                       |    4=20
 drivers/char/tpm/xen-tpmfront.c                    |    4=20
 drivers/eisa/eisa-bus.c                            |   26 +-
 drivers/gpu/drm/ast/ast_fb.c                       |    2=20
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |    2=20
 drivers/gpu/drm/cirrus/cirrus_mode.c               |    4=20
 drivers/gpu/drm/drm_gem.c                          |    3=20
 drivers/gpu/drm/gma500/gma_display.c               |   12 +
 drivers/gpu/drm/i915/i915_dma.c                    |    1=20
 drivers/gpu/drm/i915/i915_drv.h                    |    1=20
 drivers/gpu/drm/i915/i915_gem_stolen.c             |    2=20
 drivers/gpu/drm/i915/i915_gpu_error.c              |   22 +-
 drivers/gpu/drm/i915/i915_reg.h                    |   10 -
 drivers/gpu/drm/i915/intel_dp.c                    |   40 +++-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   12 -
 drivers/gpu/drm/mgag200/mgag200_cursor.c           |    8=20
 drivers/gpu/drm/mgag200/mgag200_fb.c               |    2=20
 drivers/gpu/drm/mgag200/mgag200_mode.c             |    4=20
 drivers/gpu/drm/nouveau/core/engine/falcon.c       |   20 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   33 ---
 drivers/gpu/drm/radeon/atombios_crtc.c             |   25 ++
 drivers/gpu/drm/radeon/evergreen.c                 |    4=20
 drivers/gpu/drm/radeon/evergreen_cs.c              |    5=20
 drivers/gpu/drm/radeon/ni.c                        |   16 -
 drivers/gpu/drm/radeon/nid.h                       |    1=20
 drivers/gpu/drm/radeon/r600.c                      |   13 -
 drivers/gpu/drm/radeon/r600_cs.c                   |    5=20
 drivers/gpu/drm/radeon/r600d.h                     |    1=20
 drivers/gpu/drm/radeon/radeon_atombios.c           |    4=20
 drivers/gpu/drm/radeon/radeon_i2c.c                |    3=20
 drivers/gpu/drm/radeon/radeon_pm.c                 |    6=20
 drivers/gpu/drm/radeon/radeon_uvd.c                |    1=20
 drivers/gpu/drm/radeon/rv770_dpm.c                 |    6=20
 drivers/gpu/drm/radeon/si.c                        |    2=20
 drivers/gpu/drm/radeon/sid.h                       |    2=20
 drivers/gpu/drm/radeon/uvd_v2_2.c                  |    1=20
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |    1=20
 drivers/gpu/drm/rcar-du/rcar_du_plane.c            |   21 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |    9=20
 drivers/infiniband/hw/qib/qib_ud.c                 |    9=20
 drivers/input/misc/xen-kbdfront.c                  |    4=20
 drivers/iommu/intel-iommu.c                        |    2=20
 drivers/md/Kconfig                                 |    4=20
 drivers/md/Makefile                                |    1=20
 drivers/md/dm-builtin.c                            |   48 +++++
 drivers/md/dm-sysfs.c                              |    5=20
 drivers/md/dm-thin-metadata.c                      |   20 ++
 drivers/md/dm-thin-metadata.h                      |    2=20
 drivers/md/dm-thin.c                               |   71 ++++---
 drivers/md/dm.c                                    |   15 -
 drivers/md/dm.h                                    |   17 +
 drivers/md/persistent-data/dm-space-map-common.c   |    6=20
 drivers/md/persistent-data/dm-space-map-metadata.c |   28 ++-
 drivers/media/dvb-core/dvb-usb-ids.h               |    1=20
 drivers/media/dvb-frontends/dib8000.c              |   42 +++-
 drivers/media/dvb-frontends/m88rs2000.c            |  117 +++++++++---
 drivers/media/dvb-frontends/m88rs2000.h            |    2=20
 drivers/media/dvb-frontends/nxt200x.c              |    2=20
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   28 ---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    9=20
 drivers/media/usb/dvb-usb-v2/anysee.c              |    3=20
 drivers/media/usb/dvb-usb-v2/it913x.c              |    3=20
 drivers/media/v4l2-core/v4l2-dev.c                 |    2=20
 drivers/misc/mei/hbm.c                             |    2=20
 drivers/mmc/card/block.c                           |    7=20
 drivers/mmc/core/sd.c                              |   37 ++--
 drivers/mmc/host/atmel-mci.c                       |   13 +
 drivers/mmc/host/sdhci-pci.c                       |   12 +
 drivers/mtd/nand/mxc_nand.c                        |    1=20
 drivers/net/xen-netfront.c                         |    2=20
 drivers/pci/xen-pcifront.c                         |    4=20
 drivers/rtc/rtc-cmos.c                             |   52 +++++
 drivers/spi/spi-bcm63xx.c                          |    2=20
 drivers/spi/spi-pxa2xx.c                           |    2=20
 drivers/spi/spi.c                                  |    4=20
 drivers/target/iscsi/iscsi_target_util.c           |    8=20
 drivers/vhost/scsi.c                               |    2=20
 drivers/video/xen-fbfront.c                        |    4=20
 drivers/xen/xenbus/xenbus_probe_frontend.c         |    2=20
 fs/dcookies.c                                      |    2=20
 fs/exofs/ore.c                                     |   37 ++--
 fs/fuse/dev.c                                      |   22 --
 fs/nfs/nfs4client.c                                |   18 -
 fs/nfs/nfs4proc.c                                  |   40 +++-
 fs/nfs/nfs4xdr.c                                   |   47 +++--
 fs/nfs/write.c                                     |   11 -
 fs/notify/fanotify/fanotify_user.c                 |    4=20
 fs/read_write.c                                    |   16 -
 fs/splice.c                                        |   18 +
 include/linux/audit.h                              |    2=20
 include/linux/compat.h                             |   18 -
 include/linux/percpu_ida.h                         |    3=20
 include/linux/pipe_fs_i.h                          |    2=20
 include/linux/vmstat.h                             |    2=20
 include/scsi/osd_ore.h                             |    1=20
 include/xen/platform_pci.h                         |   23 ++
 kernel/audit.c                                     |    5=20
 kernel/time/timekeeping.c                          |   47 +++--
 kernel/trace/ftrace.c                              |  190 ++++++++++++++++=
-----
 kernel/trace/trace.c                               |    8=20
 lib/percpu_ida.c                                   |   21 +-
 mm/internal.h                                      |    1=20
 mm/memcontrol.c                                    |   37 ++--
 mm/memory-failure.c                                |   21 +-
 mm/mmap.c                                          |   12 +
 mm/oom_kill.c                                      |    2=20
 mm/page-writeback.c                                |   57 ++----
 mm/slub.c                                          |    8=20
 mm/vmscan.c                                        |   23 --
 net/core/skbuff.c                                  |   32 ---
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |    2=20
 net/sunrpc/auth_gss/svcauth_gss.c                  |   33 ---
 net/sunrpc/clnt.c                                  |    8=20
 net/sunrpc/netns.h                                 |    1=20
 security/selinux/ss/policydb.c                     |   14 +
 tools/power/x86/turbostat/Makefile                 |    2=20
 tools/power/x86/turbostat/turbostat.c              |   13 -
 127 files changed, 1301 insertions(+), 590 deletions(-)

AKASHI Takahiro (1):
      audit: correct a type mismatch in audit_syscall_exit()

Adrian Hunter (2):
      mmc: sdhci-pci: Fix BYT sd card getting stuck in runtime suspend
      mmc: sdhci-pci: Fix possibility of chip->fixes being null

Akash Goel (1):
      drm/i915: Fix the offset issue for the stolen GEM objects

Alex Deucher (9):
      drm/radeon: warn users when hw_i2c is enabled (v2)
      drm/radeon/dpm: disable mclk switching on desktop RV770
      drm/radeon: disable ss on DP for DCE3.x
      drm/radeon: fix surface sync in fence on cayman (v2)
      drm/radeon: set the full cache bit for fences on r7xx+
      drm/radeon: add UVD support for OLAND
      drm/radeon: fix DAC interrupt handling on DCE5+
      drm/radeon/DCE4+: clear bios scratch dpms bit (v2)
      drm/radeon/dce8: workaround for atom BlankCrtc table

Alex Williamson (1):
      intel-iommu: fix off-by-one in pagetable freeing

Andrey Vagin (1):
      mm: don't lose the SOFT_DIRTY flag on mprotect

Antti Palosaari (1):
      media: anysee: fix non-working E30 Combo Plus DVB-T

Bjorn Helgaas (1):
      Revert "EISA: Initialize device before its resources"

Boaz Harrosh (2):
      ore: Fix wrong math in allocation of per device BIO
      pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done

Borislav Petkov (1):
      rtc-cmos: Add an alarm disable quirk

Chris Wilson (2):
      drm/i915: Flush outstanding requests before allocating new seqno
      drm/i915: Decouple GPU error reporting from ring initialisation

Cyrill Gorcunov (1):
      mm: ignore VM_SOFTDIRTY on VMA merging

Daniel Santos (1):
      spidev: fix hang when transfer_one_message fails

Daniel Vetter (1):
      drm/gem: Always initialize the gem object in object_init

Dave Airlie (4):
      drm: ast,cirrus,mgag200: use drm_can_sleep
      drm/mgag200: fix oops in cursor code.
      drm/mgag200: fix typo causing bw limits to be ignored on some chips
      drm/mgag200,ast,cirrus: fix regression with drm_can_sleep conversion

David Rientjes (1):
      mm, oom: base root bonus on current usage

Greg Kroah-Hartman (1):
      Linux 3.12.11

Gregory CLEMENT (1):
      ARM: mvebu: Fix kernel hang in mvebu_soc_id_init() when of_iomap fail=
ed

Heiko Carstens (4):
      compat: fix sys_fanotify_mark
      fs/compat: fix parameter handling for compat readv/writev syscalls
      fs/compat: fix lookup_dcookie() parameter handling
      tile: remove compat_sys_lookup_dcookie declaration to fix compile err=
or

Hugh Dickins (1):
      mm/memcg: iteration skip memcgs not yet fully initialized

Ilia Mirkin (1):
      drm/nouveau/falcon: use vmalloc to create firwmare copies

Ira Weiny (1):
      IB/qib: Fix QP check when looping back to/from QP1

Jeff Layton (1):
      sunrpc: don't wait for write before allowing reads from use-gss-proxy=
 file

Joe Thornber (4):
      dm thin: fix discard support to a previously shared block
      dm space map common: make sure new space is used during extend
      dm space map metadata: fix extending the space map
      dm space map metadata: fix bug in resizing of thin metadata

Johannes Weiner (2):
      mm/page-writeback.c: fix dirty_balance_reserve subtraction from dirty=
able memory
      mm/page-writeback.c: do not count anon pages as dirtyable memory

John Stultz (6):
      timekeeping: Fix lost updates to tai adjustment
      timekeeping: Fix potential lost pv notification of time change
      timekeeping: Avoid possible deadlock from clock_was_set_delayed
      3.13.y: timekeeping: Fix clock_set/clock_was_set think-o
      timekeeping: Fix CLOCK_TAI timer/nanosleep delays
      timekeeping: Fix missing timekeeping_update in suspend path

Jonas Gorski (1):
      spi/bcm63xx: don't substract prepend length from total length

Josh Triplett (2):
      turbostat: Don't put unprocessed uapi headers in the include path
      turbostat: Use GCC's CPUID functions to support PIC

Kent Overstreet (1):
      percpu_ida: Make percpu_ida_alloc + callers accept task state bitmask

Konrad Rzeszutek Wilk (1):
      xen/pvhvm: If xen_platform_pci=3D0 is set don't blow up (v4).

Laurent Pinchart (1):
      drm/rcar-du: Update plane pitch in .mode_set_base() operation

Li Zefan (1):
      slub: Fix calculation of cpu slabs

Ludovic Desroches (1):
      mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA

Maarten Lankhorst (1):
      drm/nouveau: fix m2mf copy to tiled gart

Malcolm Priestley (3):
      it913x: Add support for Avermedia H335 id 0x0335
      m88rs2000: add m88rs2000_set_carrieroffset
      m88rs2000: set symbol rate accurately

Marek Ol=C5=A1=C3=A1k (1):
      drm/radeon: skip colorbuffer checking if COLOR_INFO.FORMAT is set to =
INVALID

Marek Szyprowski (2):
      media: media: v4l2-dev: fix video device index assignment
      media: s5p_mfc: remove s5p_mfc_get_node_type() function

Mark Brown (1):
      ACPI / init: Flag use of ACPI and ACPI idioms for power supplies to r=
egulator API

Mauro Carvalho Chehab (2):
      dib8000: make 32 bits read atomic
      nxt200x: increase write buffer size

Max Filippov (1):
      xtensa: xtfpga: fix definitions of platform devices

Michael Grzeschik (1):
      mtd: mxc_nand: remove duplicated ecc_stats counting

Michal Hocko (2):
      memcg: fix endless loop caused by mem_cgroup_iter
      memcg: fix css reference leak and endless loop in mem_cgroup_iter

Michel D=C3=A4nzer (1):
      radeon/pm: Guard access to rdev->pm.power_state array

Mika Westerberg (1):
      spi/pxa2xx: initialize DMA channels to -1 to prevent inadvertent match

Mike Snitzer (2):
      dm thin: initialize dm_thin_new_mapping returned by get_next_mapping
      dm thin: fix set_pool_mode exposed pool operation races

Miklos Szeredi (1):
      fuse: fix pipe_buf_operations

Mikulas Patocka (2):
      dm: wait until embedded kobject is released before destroying a device
      dm sysfs: fix a module unload race

Naoya Horiguchi (1):
      mm/memory-failure.c: shift page lock from head page to tail page afte=
r thp split

Nicholas Bellinger (1):
      iscsi-target: Fix connection reset hang with percpu_ida_alloc

Olivier Grenie (1):
      dib8000: fix regression with dib807x

Patrik Jakobsson (1):
      drm/gma500: Lock struct_mutex around cursor updates

Paul Bolle (1):
      mei: mei_hbm_dispatch() returns void

Ray Jui (1):
      mmc: fix host release issue after discard operation

Richard Guy Briggs (1):
      audit: reset audit backlog wait time after error recovery

Scott Mayhew (1):
      nfs: always make sure page is up-to-date before extending a write to =
cover the entire page

Sebastian Hesselbarth (1):
      ARM: orion: provide C-style interrupt handler for MULTI_IRQ_HANDLER

Stanislaw Gruszka (1):
      i915: remove pm_qos request on error

Steven Rostedt (Red Hat) (5):
      tracing: Have trace buffer point back to trace_array
      tracing: Check if tracing is enabled in trace_puts()
      ftrace: Synchronize setting function_trace_op with ftrace_trace_funct=
ion
      ftrace: Fix synchronization location disabling and freeing ftrace_ops
      ftrace: Have function graph only trace based on global_ops filters

Takashi Iwai (1):
      drm/cirrus: correct register values for 16bpp

Tetsuo Handa (1):
      SELinux: Fix memory leak upon loading policy

Thomas Hellstrom (1):
      drm/vmwgfx: Fix regression caused by "drm/ttm: make ttm reservation c=
alls behave like reservation calls"

Todd Previte (1):
      drm/i915: VLV2 - Fix hotplug detect bits

Trond Myklebust (3):
      NFSv4: OPEN must handle the NFS4ERR_IO return code correctly
      NFSv4.1: Handle errors correctly in nfs41_walk_client_list
      NFSv4: Fix a slot leak in nfs40_sequence_done

Wanlong Gao (1):
      arch/sh/kernel/kgdb.c: add missing #include <linux/sched.h>

Weston Andros Adamson (3):
      nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME
      nfs4: fix discover_server_trunking use after free
      sunrpc: Fix infinite loop in RPC state machine

Wolfram Sang (1):
      mmc: core: sd: implement proper support for sd3.0 au sizes


--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/UcsAAoJEDjbvchgkmk+oy4QAJuOnTKDa61cAKj0jV5U5BUg
ZI19uHPu3wHryQCEv7I5h/dhXL42ajyFsvQzWTyikNtSgE75jtssb+tAtreEeQxy
YsmecHfUykQAjVlId/z1PiJdjCW882QKhCxRjyzjR12jL1p82Tq9SsizPBK/ymvW
IKLYSHXge409S7rmzs0AD4VegpKz3VYkwdt8Dfi900Z5RKZkBBXarVE6JDsGI6NN
itklG32A0IIHr7aM2C9+HNoGUY/Opl3W3ja7l9Nw6b1oh9IQ2rgsh5Ddd8RYZph0
TcKWC8sxXMlLFozhpR2OsvqUi7wWUNRLMiNxO7NmALKY3SHSV/5gQWsmZD3vW1NX
5Eu9OXF8GmdksGYxYHWKXd0Jk9Ctndz8FqK9JuNQK1OblKCBdQrti4BUEUmUjL11
AJIGIDOUnNA613pQ/ZqqvKVyl7vNkcPlu0l5v8KTqvlWd4wC3538w5slGFQXJ5PH
PNXCsJ2fhJlx5R18JuXtRiE66xPFDhzFdI9KTIplo8x8pm4eNydFHsGnbJHVzMH7
SmFCxzOJHpqL/NWNLwdrxELqpBRDqO8G5B/gGUswC8SAXdEezb2mvtBY33X+nBWl
z0sZy2JL/ow+IyLlXs1/M232pDPzIpXvl59Ct635AlB1Vwk15917/ginT4BC6+lj
q6OJbGiJDOPLk4YJgXq1
=H8pt
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
