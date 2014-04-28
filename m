Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaD1Bb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42811 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        akpm@linux-foundation.org
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.453080089@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 00/94] 3.2.58-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.58 release.
There are 94 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Apr 30 08:00:00 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.57 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Ajesh Kunhipurayil Vijayan (1):
      jffs2: Fix crash due to truncation of csize
         [41bf1a24c1001f4d0d41a78e1ac575d2f14789d7]

Alex Chen (1):
      ocfs2: do not put bh when buffer_uptodate failed
         [f7cf4f5bfe073ad792ab49c04f247626b3e38db6]

Alex Deucher (1):
      drm/radeon: call drm_edid_to_eld when we update the edid
         [16086279353cbfecbb3ead474072dced17b97ddc]

Andy Grover (1):
      target/tcm_fc: Fix use-after-free of ft_tpg
         [2c42be2dd4f6586728dba5c4e197afd5cfaded78]

Ben Hutchings (2):
      Revert "alpha: fix broken network checksum"
         [not upstream; it was a useful fix upstream]
      nfsd: Add fh_{want,drop}_write()
         [bad0dcffc21d17a07dbb83a2bf764f35a57feba5]

Christopher Friedt (1):
      drm/vmwgfx: correct fb_fix_screeninfo.line_length
         [aa6de142c901cd2d90ef08db30ae87da214bedcc]

Dan Carpenter (1):
      isdnloop: several buffer overflows
         [7563487cbf865284dcd35e9ef5a95380da046737]

Daniel Borkmann (1):
      net: sctp: fix skb leakage in COOKIE ECHO path of  chunk->auth_chunk
         [c485658bae87faccd7aed540fd2ca3ab37992310]

Daniel Vetter (1):
      drm/i915: inverted brightness quirk for Acer Aspire 4736Z
         [ac4199e0f047546aa40172785e26c82b54bbe811]

Dave Kleikamp (2):
      Revert "sparc64: Fix __copy_{to,from}_user_inatomic  defines."
         [16932237f2978a2265662f8de4af743b1f55a209]
      sparc64: don't treat 64-bit syscall return codes as  32-bit
         [1535bd8adbdedd60a0ee62e28fd5225d66434371]

David Fries (1):
      w1: fix w1_send_slave dropping a slave id
         [6b355b33a64fd6d8ead2b838ec16fb9b551f71e8]

Dennis Dalessandro (1):
      IB/ipath: Fix potential buffer overrun in sending diag packet routine
         [a2cb0eb8a64adb29a99fd864013de957028f36ae]

Emmanuel Grumbach (1):
      iwlwifi: dvm: take mutex when sending SYNC BT config command
         [82e5a649453a3cf23516277abb84273768a1592b]

Eric Dumazet (1):
      net: unix: non blocking recvmsg() should not return  -EINTR
         [de1443916791d75fdd26becb116898277bb0273f]

Eric Whitney (1):
      ext4: fix partial cluster handling for bigalloc file systems
         [c06344939422bbd032ac967223a7863de57496b5]

Felix Fietkau (1):
      ath9k: fix ready time of the multicast buffer queue
         [3b3e0efb5c72c4fc940af50b33626b8a78a907dc]

Gregory CLEMENT (1):
      usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is enabled
         [d8eb6c653ef6b323d630de3c5685478469e248bc]

H. Peter Anvin (1):
      x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
         [b3b42ac2cbae1f3cecbb6229964a4d48af31d382]

Hannes Frederic Sowa (1):
      ipv6: some ipv6 statistic counters failed to disable bh
         [43a43b6040165f7b40b5b489fe61a4cb7f8c4980]

Hannes Reinecke (1):
      tty: Set correct tty name in 'active' sysfs attribute
         [723abd87f6e536f1353c8f64f621520bc29523a3]

Heiner Kallweit (1):
      ipv6: Avoid unnecessary temporary addresses being  generated
         [ecab67015ef6e3f3635551dcc9971cf363cc1cd5]

Hidetoshi Seto (1):
      Btrfs: skip submitting barrier for missing device
         [f88ba6a2a44ee98e8d59654463dc157bb6d13c43]

Himangi Saraogi (1):
      staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to integer
         [abe5d64d1a74195a44cd14624f8178b9f48b7cc7]

Huacai Chen (1):
      MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()
         [c14af233fbe279d0e561ecf84f1208b1bae087ef]

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_devt
         [06f9b6e59661cee510b04513b13ea7927727d758]

J. Bruce Fields (4):
      nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
         [de3997a7eeb9ea286b15879fdf8a95aae065b4f7]
      nfsd4: fix setclientid encode size
         [480efaee085235bb848f1063f959bf144103c342]
      nfsd4: session needs room for following op to error out
         [4c69d5855a16f7378648c5733632628fa10431db]
      nfsd: notify_change needs elevated write count
         [9f67f189939eccaa54f3d2c9cf10788abaf2d584]

Jani Nikula (2):
      drm/i915/tv: fix gen4 composite s-video tv-out
         [e1f23f3dd817f53f622e486913ac662add46eeed]
      drm/i915: quirk invert brightness for Acer Aspire 5336
         [0f540c3a7cfb91c9d7a19eb0c95c24c5de1197d5]

Jason Wang (1):
      x86, hyperv: Bypass the timer_irq_works() check
         [ca3ba2a2f4a49a308e7d78c784d51b2332064f15]

Jeff Mahoney (1):
      reiserfs: fix race in readdir
         [01d8885785a60ae8f4c37b0ed75bdc96d0fc6a44]

Jens Axboe (1):
      lib/percpu_counter.c: fix bad percpu counter state during suspend
         [e39435ce68bb4685288f78b1a7e24311f7ef939f]

Jiri Slaby (1):
      Char: ipmi_bt_sm, fix infinite loop
         [a94cdd1f4d30f12904ab528152731fb13a812a16]

Josef Bacik (1):
      Btrfs: fix deadlock with nested trans handles
         [3bbb24b20a8800158c33eca8564f432dd14d0bf3]

Junxiao Bi (2):
      ocfs2: dlm: fix lock migration crash
         [34aa8dac482f1358d59110d5e3a12f4351f6acaa]
      ocfs2: dlm: fix recovery hung
         [ded2cf71419b9353060e633b59e446c42a6a2a09]

Kamlakant Patel (1):
      jffs2: Fix segmentation fault found in stress test
         [3367da5610c50e6b83f86d366d72b41b350b06a2]

Krzysztof Kozlowski (4):
      mfd: 88pm860x: Fix possible NULL pointer dereference on i2c_new_dummy error
         [159ce52a6b777fc82fa0b51c7440e25f9e4c6feb]
      mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy error
         [96cf3dedc491d2f1f66cc26217f2b06b0c7b6797]
      mfd: max8997: Fix possible NULL pointer dereference on i2c_new_dummy error
         [97dc4ed3fa377ec91bb60ba98b70d645c2099384]
      mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy error
         [ed26f87b9f71693a1d1ee85f5e6209601505080f]

Larry Finger (1):
      rtlwifi: rtl8192se: Fix too long disable of IRQs
         [2610decdd0b3808ba20471a999835cfee5275f98]

Li Zefan (2):
      jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
         [13b546d96207c131eeae15dc7b26c6e7d0f1cad7]
      jffs2: remove from wait queue after schedule()
         [3ead9578443b66ddb3d50ed4f53af8a0c0298ec5]

Linus Lüssing (1):
      bridge: multicast: add sanity check for query source  addresses
         [6565b9eeef194afbb3beec80d6dd2447f4091f8c]

Linus Walleij (1):
      mfd: Include all drivers in subsystem menu
         [a6e6e660baa5c583022e3e48c85316bace027825]

Lucien (1):
      ipv6: ip6_append_data_mtu do not handle the mtu of the  second fragment properly
         [e367c2d03dba4c9bcafad24688fadb79dd95b218]

Marek Vasut (1):
      gpio: mxs: Allow for recursive enable_irq_wake() call
         [a585f87c863e4e1d496459d382b802bf5ebe3717]

Masayoshi Mizuma (1):
      mm: hugetlb: fix softlockup when a large number of hugepages are freed.
         [55f67141a8927b2be3e51840da37b8a2320143ed]

Matt Fleming (1):
      sh: fix format string bug in stack tracer
         [a0c32761e73c9999cbf592b702f284221fea8040]

Matthew Leach (1):
      net: socket: error on a negative msg_namelen
         [dbb490b96584d4e958533fb637f08b557f505657]

Michael S. Tsirkin (2):
      vhost: fix total length when packets are too short
         [d8316f3991d207fe32881a9ac20241be8fa2bad0]
      vhost: validate vhost_get_vq_desc return value
         [a39ee449f96a2cd44ce056d8a0a112211a9b1a1f]

Mike Snitzer (1):
      dm thin: fix dangling bio in process_deferred_bios error path
         [fe76cd88e654124d1431bb662a0fc6e99ca811a5]

Mikulas Patocka (8):
      framebuffer: fix cfb_copyarea
         [00a9d699bc85052d2d3ed56251cd928024ce06a3]
      mach64: fix cursor when character width is not a multiple of 8 pixels
         [43751a1b8ee2e70ce392bf31ef3133da324e68b3]
      mach64: use unaligned access
         [c29dd8696dc5dbd50b3ac441b8a26751277ba520]
      matroxfb: restore the registers M_ACCESS and M_PITCH
         [a772d4736641ec1b421ad965e13457c17379fc86]
      powernow-k6: correctly initialize default parameters
         [d82b922a4acc1781d368aceac2f9da43b038cab2]
      powernow-k6: disable cache when changing frequency
         [e20e1d0ac02308e2211306fc67abcd0b2668fb8b]
      powernow-k6: reorder frequencies
         [22c73795b101597051924556dce019385a1e2fa0]
      tgafb: fix data copying
         [6b0df6827bb6fcacb158dff29ad0a62d6418b534]

Nicholas Bellinger (1):
      iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug
         [d444edc679e7713412f243b792b1f964e5cff1e1]

Oftedal (1):
      sparc: PCI: Fix incorrect address calculation of PCI  Bridge windows on Simba-bridges
         [557fc5873ef178c4b3e1e36a42db547ecdc43f9b]

Oleg Nesterov (1):
      wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race
         [dfccbb5e49a621c1b21a62527d61fc4305617aca]

Oleksij Rempel (1):
      [media] uvcvideo: Do not use usb_set_interface on bulk EP
         [b1e43f232698274871e1358c276d7b0242a7d607]

Pablo Neira (1):
      netlink: don't compare the nul-termination in  nla_strcmp
         [8b7b932434f5eee495b91a2804f5b64ebb2bc835]

Paul Durrant (1):
      xen-netback: remove pointless clause from if statement
         [0576eddf24df716d8570ef8ca11452a9f98eaab2]

Paul Gortmaker (2):
      hvc: ensure hvc_init is only ever called once in hvc_console.c
         [f76a1cbed18c86e2d192455f0daebb48458965f3]
      sparc32: fix build failure for arch_jump_label_transform
         [4f6500fff5f7644a03c46728fd7ef0f62fa6940b]

Paul Moore (1):
      selinux: correctly label /proc inodes in use before the policy is loaded
         [f64410ec665479d7b4b77b7519e814253ed0f686]

Peter Boström (1):
      vlan: Set correct source MAC address with TX VLAN  offload enabled
         [dd38743b4cc2f86be250eaf156cf113ba3dd531a]

Qiang Huang (1):
      drivers: hv: additional switch to use mb() instead of smp_mb()
         [35848f68b07df3f917cb13fc3c134718669f569b]

Rafał Miłecki (1):
      b43: Fix machine check error due to improper access of B43_MMIO_PSM_PHY_HDR
         [12cd43c6ed6da7bf7c5afbd74da6959cda6d056b]

Richard Guy Briggs (2):
      audit: convert PPIDs to the inital PID namespace.
         [c92cdeb45eea38515e82187f48c2e4f435fb4e25]
      pid: get pid_t ppid of task in init_pid_ns
         [ad36d28293936b03d6b7996e9d6aadfd73c0eb08]

Roman Pen (1):
      blktrace: fix accounting of partially completed requests
         [af5040da01ef980670b3741b3e10733ee3e33566]

Rusty Russell (1):
      virtio_balloon: don't softlockup on huge balloon changes.
         [1f74ef0f2d7d692fcd615621e0e734c3e7771413]

Sabrina Dubroca (1):
      ipv6: don't set DST_NOCOUNT for remotely added routes
         [c88507fbad8055297c1d1e21e599f46960cbee39]

Sasha Levin (1):
      rds: prevent dereference of a NULL device in  rds_iw_laddr_check
         [bf39b4247b8799935ea91d90db250ab608a58e50]

Takashi Iwai (1):
      ALSA: ice1712: Fix boundary checks in PCM pointer ops
         [4f8e940095536bc002a81666a4107a581c84e9b9]

Vlastimil Babka (1):
      mm: try_to_unmap_cluster() should lock_page() before mlocking
         [57e68e9cd65b4b8eb4045a1e0d0746458502554c]

W. Trevor King (1):
      ALSA: hda - Enable beep for ASUS 1015E
         [a4b7f21d7b42b33609df3f86992a8deff80abfaf]

Will Deacon (2):
      ARM: 7954/1: mm: remove remaining domain support from ARMv6
         [b6ccb9803e90c16b212cf4ed62913a7591e79a39]
      ARM: mm: introduce present, faulting entries for PAGE_NONE
         [26ffd0d43b186b0d5186354da8714a1c2d360df0]

Wolfram Sang (1):
      [media] media: gspca: sn9c20x: add ID for Genius Look 1320 V2
         [61f0319193c44adbbada920162d880b1fdb3aeb3]

YOSHIFUJI Hideaki / 吉藤英明 (1):
      isdnloop: Validate NUL-terminated strings from user.
         [77bc6bed7121936bb2e019a8c336075f4c8eef62]

Yann Droneaud (3):
      IB/ehca: Returns an error on ib_copy_to_udata() failure
         [5bdb0f02add5994b0bc17494f4726925ca5d6ba1]
      IB/mthca: Return an error on ib_copy_to_udata() failure
         [08e74c4b00c30c232d535ff368554959403d0432]
      IB/nes: Return an error on ib_copy_from_udata() failure instead of NULL
         [9d194d1025f463392feafa26ff8c2d8247f71be1]

 Documentation/video4linux/gspca.txt          |   1 +
 Makefile                                     |   4 +-
 arch/arm/include/asm/futex.h                 |   6 -
 arch/arm/include/asm/pgtable-2level.h        |   2 +
 arch/arm/include/asm/pgtable.h               |   6 +-
 arch/arm/mm/Kconfig                          |   3 +-
 arch/arm/mm/mmu.c                            |   8 +
 arch/arm/mm/proc-macros.S                    |  19 +-
 arch/arm/mm/proc-v7.S                        |   7 +-
 arch/mips/power/hibernate.S                  |   1 +
 arch/sh/kernel/dumpstack.c                   |   2 +-
 arch/sparc/Kconfig                           |   2 +-
 arch/sparc/include/asm/uaccess_64.h          |   4 +-
 arch/sparc/kernel/pci.c                      |   4 +-
 arch/sparc/kernel/syscalls.S                 |   4 +-
 arch/x86/kernel/cpu/mshyperv.c               |   6 +
 arch/x86/kernel/ldt.c                        |  11 ++
 block/blk-core.c                             |   2 +-
 drivers/gpio/gpio-mxs.c                      |   3 +-
 drivers/gpu/drm/i915/intel_display.c         |   6 +
 drivers/gpu/drm/i915/intel_tv.c              |   9 +-
 drivers/gpu/drm/radeon/radeon_display.c      |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c           |   5 +-
 drivers/hv/ring_buffer.c                     |   2 +-
 drivers/infiniband/hw/ehca/ehca_cq.c         |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c     |  66 +++----
 drivers/infiniband/hw/mthca/mthca_provider.c |   1 +
 drivers/infiniband/hw/nes/nes_verbs.c        |   2 +-
 drivers/isdn/isdnloop/isdnloop.c             |  23 ++-
 drivers/md/dm-thin.c                         |   2 +-
 drivers/media/video/gspca/sn9c20x.c          |   1 +
 drivers/media/video/uvc/uvc_video.c          |  20 +-
 drivers/mfd/88pm860x-i2c.c                   |   6 +
 drivers/mfd/Kconfig                          |   6 +-
 drivers/mfd/max8925-i2c.c                    |   9 +
 drivers/mfd/max8997.c                        |  18 ++
 drivers/mfd/max8998.c                        |   4 +
 drivers/net/wireless/ath/ath9k/xmit.c        |   2 +-
 drivers/net/wireless/b43/phy_n.c             |  14 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |  24 ++-
 drivers/net/xen-netback/netback.c            |   4 +-
 drivers/staging/serqt_usb2/serqt_usb2.c      |   2 +-
 drivers/target/iscsi/iscsi_target.c          |   4 +-
 drivers/target/tcm_fc/tfc_sess.c             |   1 +
 drivers/tty/hvc/hvc_console.c                |   6 +-
 drivers/tty/tty_io.c                         |  20 +-
 drivers/usb/dwc3/core.h                      |   6 +-
 drivers/usb/gadget/atmel_usba_udc.c          |   5 +-
 drivers/vhost/net.c                          |  20 +-
 drivers/video/aty/mach64_accel.c             |   3 +-
 drivers/video/aty/mach64_cursor.c            |  22 ++-
 drivers/video/cfbcopyarea.c                  | 153 ++++++++--------
 drivers/video/matrox/matroxfb_accel.c        |  38 +++-
 drivers/video/matrox/matroxfb_base.h         |   2 +
 drivers/video/tgafb.c                        | 264 ++++++---------------------
 drivers/virtio/virtio_balloon.c              |   6 +
 drivers/w1/w1_netlink.c                      |  25 +--
 fs/btrfs/disk-io.c                           |   4 +
 fs/btrfs/transaction.c                       |  14 +-
 fs/ext4/extents.c                            |  21 +++
 fs/jffs2/compr_rtime.c                       |   4 +-
 fs/jffs2/nodelist.h                          |   2 +-
 fs/jffs2/nodemgmt.c                          |  14 +-
 fs/nfsd/nfs4proc.c                           |   9 +-
 fs/nfsd/nfs4xdr.c                            |   2 +
 fs/nfsd/vfs.c                                |   9 +
 fs/nfsd/vfs.h                                |  10 +
 fs/ocfs2/buffer_head_io.c                    |   2 -
 fs/ocfs2/dlm/dlmrecovery.c                   |  29 ++-
 fs/reiserfs/dir.c                            |   6 +-
 include/linux/sched.h                        |  20 +-
 include/trace/events/block.h                 |  33 +++-
 kernel/auditsc.c                             |   4 +-
 kernel/exit.c                                |  15 +-
 kernel/trace/blktrace.c                      |  20 +-
 lib/nlattr.c                                 |  10 +-
 lib/percpu_counter.c                         |   2 +-
 mm/hugetlb.c                                 |   1 +
 mm/mlock.c                                   |   2 +
 mm/rmap.c                                    |  14 +-
 net/8021q/vlan_dev.c                         |   3 +
 net/bridge/br_multicast.c                    |   6 +
 net/ipv6/addrconf.c                          |   5 +-
 net/ipv6/icmp.c                              |   2 +-
 net/ipv6/ip6_output.c                        |  18 +-
 net/ipv6/mcast.c                             |  11 +-
 net/ipv6/route.c                             |   2 +-
 net/rds/iw.c                                 |   3 +-
 net/sctp/sm_make_chunk.c                     |   4 +-
 net/sctp/sm_statefuns.c                      |   5 -
 net/socket.c                                 |   4 +
 net/unix/af_unix.c                           |  17 +-
 sound/pci/hda/patch_realtek.c                |   1 +
 sound/pci/ice1712/ice1712.c                  |  15 +-
 95 files changed, 713 insertions(+), 536 deletions(-)

-- 
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

