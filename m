Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaL2BMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:12:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33187 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbaL2BMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:17 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, Phil Jensen <pjensen@evernote.com>,
        akpm@linux-foundation.org
Date: Mon, 29 Dec 2014 02:11:30 +0100
Message-ID: <lsq.1419815490.288081487@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 00/27] 3.2.66-rc1 review
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.66 release.
There are 27 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Dec 31 12:00:00 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.65 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Al Viro (2):
      deal with deadlock in d_walk()
         [ca5358ef75fc69fee5322a38a340f5739d997c10]
      move d_rcu from overlapping d_child to overlapping d_alias
         [946e51f2bf37f1656916eb75bd0742ba33983c28]

Anatol Pomozov (1):
      ext4: make orphan functions be no-op in no-journal mode
         [c9b92530a723ac5ef8e352885a1862b18f31b2f5]

Andy Lutomirski (2):
      x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit
         [29fa6825463c97e5157284db80107d1bfac5d77b]
      x86/tls: Validate TLS entries to protect espfix
         [41bdc78544b8a93a9c6814b8bbbfef966272abbe]

Ard Biesheuvel (1):
      crypto: ghash-clmulni-intel - use C implementation for setkey()
         [8ceee72808d1ae3fb191284afc2257a2be964725]

Ben Hutchings (2):
      drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
         [5188cd44c55db3e92cd9e77a40b5baa7ed4340f7]
      drivers/net: macvtap and tun depend on INET
         [de11b0e8c569b96c2cf6a811e3805b7aeef498a3]

Dan Carpenter (1):
      [media] ttusb-dec: buffer overflow in ioctl
         [f2e323ec96077642d397bb1c355def536d489d16]

Daniel Borkmann (3):
      net: sctp: fix NULL pointer dereference in af->from_addr_param on malformed packet
         [e40607cbe270a9e8360907cb1e62ddf0736e4864]
      net: sctp: fix memory leak in auth key management
         [4184b2a79a7612a9272ce20d639934584a1f3786]
      net: sctp: use MAX_HEADER for headroom reserve in output path
         [9772b54c55266ce80c639a80aa68eeb908f8ecf5]

Daniel Vetter (1):
      drm/i915: Unlock panel even when LVDS is disabled
         [b0616c5306b342ceca07044dbc4f917d95c4f825]

David Herrmann (1):
      drm: fix DRM_IOCTL_MODE_GETFB handle-leak
         [101b96f32956ee99bf1468afaf572b88cda9f88b]

Devin Ryles (1):
      AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller
         [249cd0a187ed4ef1d0af7f74362cc2791ec5581b]

Dmitry Torokhov (1):
      sata_fsl: fix error handling of irq_of_parse_and_map
         [aad0b624129709c94c2e19e583b6053520353fa8]

Eric Dumazet (2):
      tcp: md5: do not use alloc_percpu()
         [349ce993ac706869d553a1816426d3a4bfda02b1]
      tcp: md5: remove spinlock usage in fast path
         [71cea17ed39fdf1c0634f530ddc6a2c2fc601c2b]

Grygorii Strashko (1):
      i2c: davinci: generate STP always when NACK is received
         [9ea359f7314132cbcb5a502d2d8ef095be1f45e4]

Hugh Dickins (1):
      mm: fix swapoff hang after page migration and fork
         [2022b4d18a491a578218ce7a4eca8666db895a73]

Jan Kara (1):
      udf: Avoid infinite loop when processing indirect ICBs
         [c03aa9f6e1f938618e6db2e23afef0574efeeb65]

Jiri Pirko (1):
      ipv4: fix nexthop attlen check in fib_nh_match
         [f76936d07c4eeb36d8dbb64ebd30ab46ff85d9f7]

Martin Schwidefsky (1):
      s390,time: revert direct ktime path for s390 clockevent device
         [8adbf78ec4839c1dc4ff20c9a1f332a7bc99e6e6]

Nadav Amit (1):
      KVM: x86: Don't report guest userspace emulation error to userspace
         [a2b9e6c1a35afcc0973acb72e591c714e78885ff]

Paolo Bonzini (1):
      x86: kvm: use alternatives for VMCALL vs. VMMCALL if kernel text is read-only
         [c1118b3602c2329671ad5ec8bdf8e374323d6343]

Tejun Heo (1):
      ahci: disable MSI on SAMSUNG 0xa800 SSD
         [2b21ef0aae65f22f5ba86b13c4588f6f0c2dbefb]

Vasily Averin (1):
      ipv4: dst_entry leak in ip_send_unicast_reply()
         [4062090e3e5caaf55bed4523a69f26c3265cc1d2]

 Makefile                                   |   4 +-
 arch/powerpc/platforms/cell/spufs/inode.c  |   4 +-
 arch/s390/kernel/time.c                    |  19 +--
 arch/x86/crypto/ghash-clmulni-intel_asm.S  |  28 -----
 arch/x86/crypto/ghash-clmulni-intel_glue.c |  14 ++-
 arch/x86/include/asm/cpufeature.h          |   1 +
 arch/x86/include/asm/kvm_para.h            |  10 +-
 arch/x86/kernel/cpu/amd.c                  |   7 ++
 arch/x86/kernel/kvm.c                      |   9 +-
 arch/x86/kernel/kvmclock.c                 |   1 -
 arch/x86/kernel/tls.c                      |  23 ++++
 arch/x86/kvm/x86.c                         |   2 +-
 drivers/ata/ahci.c                         |   4 +
 drivers/ata/sata_fsl.c                     |   2 +-
 drivers/gpu/drm/drm_crtc.c                 |  12 +-
 drivers/gpu/drm/i915/intel_lvds.c          |  25 ++--
 drivers/i2c/busses/i2c-davinci.c           |   8 +-
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c   |   3 +
 drivers/net/Kconfig                        |   2 +
 drivers/net/macvtap.c                      |   3 +
 drivers/net/tun.c                          |   5 +
 drivers/usb/core/inode.c                   |   6 +-
 fs/9p/vfs_inode_dotl.c                     |   2 +-
 fs/affs/amigaffs.c                         |   2 +-
 fs/autofs4/expire.c                        |  10 +-
 fs/autofs4/root.c                          |   2 +-
 fs/ceph/dir.c                              |   8 +-
 fs/ceph/inode.c                            |   6 +-
 fs/cifs/inode.c                            |   2 +-
 fs/coda/cache.c                            |   2 +-
 fs/dcache.c                                | 179 ++++++++++++++++-------------
 fs/debugfs/inode.c                         |   2 +-
 fs/exportfs/expfs.c                        |   2 +-
 fs/ext4/fsync.c                            |   2 +-
 fs/ext4/namei.c                            |   7 +-
 fs/libfs.c                                 |  12 +-
 fs/ncpfs/dir.c                             |   2 +-
 fs/ncpfs/ncplib_kernel.h                   |   4 +-
 fs/nfs/getroot.c                           |   2 +-
 fs/notify/fsnotify.c                       |   4 +-
 fs/ocfs2/dcache.c                          |   2 +-
 fs/udf/inode.c                             |  35 +++---
 include/linux/dcache.h                     |   8 +-
 include/net/ipv6.h                         |   1 +
 include/net/tcp.h                          |   8 +-
 kernel/cgroup.c                            |   4 +-
 mm/memory.c                                |  26 ++---
 net/ipv4/fib_semantics.c                   |   2 +-
 net/ipv4/ip_output.c                       |  12 +-
 net/ipv4/tcp.c                             | 131 +++++----------------
 net/ipv4/tcp_ipv4.c                        |   7 +-
 net/ipv4/tcp_minisocks.c                   |   7 +-
 net/ipv6/Makefile                          |   2 +-
 net/ipv6/output_core.c                     |  38 ++++++
 net/ipv6/tcp_ipv6.c                        |   7 +-
 net/sctp/auth.c                            |   2 -
 net/sctp/output.c                          |   4 +-
 net/sctp/sm_make_chunk.c                   |   3 +
 security/selinux/selinuxfs.c               |   6 +-
 59 files changed, 385 insertions(+), 362 deletions(-)

-- 
Ben Hutchings
Anthony's Law of Force: Don't force it, get a larger hammer.

