Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3LCBTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 20:19:13 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49494 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab3LCBTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 20:19:02 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH] Remove unnecessarily gendered language
Date: Mon,  2 Dec 2013 20:18:52 -0500
Message-Id: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.4.2
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel as a number of cases of gendered language. The majority of these
refer to objects that don't have gender in English, and so I've replaced
them with "it" and "its". Some refer to people (developers or users), and
I've replaced these with the singular "they" variant. Some are simply
typos that I've fixed up.

I've left cases where gendered language was used to refer to specific
individuals, was a quote or is part of license text.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml    |  2 +-
 Documentation/HOWTO                                |  2 +-
 Documentation/ManagementStyle                      | 27 +++++++++++-----------
 Documentation/SubmittingPatches                    |  4 ++--
 Documentation/arm/vlocks.txt                       |  2 +-
 Documentation/cgroups/cgroups.txt                  |  4 ++--
 Documentation/cgroups/memory.txt                   |  2 +-
 Documentation/development-process/2.Process        |  2 +-
 Documentation/development-process/5.Posting        |  4 ++--
 Documentation/development-process/6.Followthrough  |  8 +++----
 .../devicetree/bindings/net/broadcom-bcm87xx.txt   |  2 +-
 Documentation/filesystems/ntfs.txt                 |  2 +-
 Documentation/filesystems/quota.txt                | 11 +++++----
 Documentation/filesystems/romfs.txt                |  2 +-
 Documentation/filesystems/sharedsubtree.txt        |  2 +-
 Documentation/fmc/carrier.txt                      |  2 +-
 Documentation/hwmon/it87                           |  2 +-
 Documentation/kdump/kdump.txt                      |  2 +-
 Documentation/memory-hotplug.txt                   |  2 +-
 Documentation/padata.txt                           |  2 +-
 Documentation/scheduler/sched-rt-group.txt         |  2 +-
 Documentation/scsi/scsi-changer.txt                |  2 +-
 Documentation/security/Smack.txt                   |  2 +-
 Documentation/sound/oss/PSS-updates                |  8 +++----
 Documentation/usb/WUSB-Design-overview.txt         |  6 ++---
 Documentation/usb/iuu_phoenix.txt                  |  2 +-
 Documentation/usb/wusb-cbaf                        |  2 +-
 Documentation/video4linux/meye.txt                 |  2 +-
 arch/arc/kernel/troubleshoot.c                     |  2 +-
 arch/arm/kernel/crash_dump.c                       |  2 +-
 arch/avr32/mm/dma-coherent.c                       |  2 +-
 arch/ia64/kernel/palinfo.c                         |  2 +-
 arch/m68k/atari/stdma.c                            |  2 +-
 arch/m68k/include/asm/oplib.h                      |  2 +-
 arch/m68k/mac/psc.c                                |  2 +-
 arch/microblaze/pci/pci-common.c                   |  2 +-
 arch/mips/kernel/smtc.c                            |  2 +-
 arch/mips/math-emu/dsemul.c                        |  4 ++--
 arch/mips/mm/c-r4k.c                               |  2 +-
 arch/parisc/kernel/process.c                       |  2 +-
 arch/powerpc/kernel/pci-common.c                   |  2 +-
 arch/sh/kernel/cpu/sh5/entry.S                     |  2 +-
 arch/sparc/include/asm/processor_64.h              |  2 +-
 arch/sparc/include/asm/spinlock_32.h               |  4 ++--
 arch/sparc/include/asm/uaccess_32.h                |  2 +-
 arch/sparc/kernel/pci.c                            |  4 ++--
 arch/sparc/kernel/smp_64.c                         |  2 +-
 arch/sparc/kernel/wof.S                            |  2 +-
 arch/sparc/mm/fault_64.c                           |  2 +-
 arch/um/drivers/mconsole_kern.c                    |  2 +-
 arch/x86/include/asm/uaccess_32.h                  |  2 +-
 arch/xtensa/kernel/pci.c                           |  2 +-
 block/scsi_ioctl.c                                 |  2 +-
 drivers/acpi/video.c                               |  2 +-
 drivers/block/brd.c                                |  2 +-
 drivers/block/drbd/drbd_receiver.c                 |  2 +-
 drivers/block/loop.c                               |  2 +-
 drivers/char/nwbutton.c                            |  2 +-
 drivers/char/random.c                              |  4 ++--
 drivers/cpufreq/e_powersaver.c                     |  2 +-
 drivers/cpufreq/powernow-k8.c                      |  2 +-
 drivers/dma/cppi41.c                               |  2 +-
 drivers/extcon/extcon-class.c                      |  2 +-
 drivers/gpio/Kconfig                               |  2 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c             |  4 ++--
 drivers/gpu/drm/mga/mga_irq.c                      |  2 +-
 drivers/gpu/drm/vmwgfx/svga_escape.h               |  2 +-
 drivers/gpu/vga/vgaarb.c                           | 10 ++++----
 drivers/hwspinlock/hwspinlock_core.c               |  6 ++---
 drivers/infiniband/hw/amso1100/c2_intr.c           |  2 +-
 drivers/isdn/hardware/eicon/dadapter.c             |  4 ++--
 drivers/isdn/hardware/eicon/io.c                   |  2 +-
 drivers/isdn/i4l/isdn_ppp.c                        |  2 +-
 drivers/md/dm-ioctl.c                              |  2 +-
 drivers/media/dvb-frontends/dib0090.c              |  2 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |  2 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |  8 +++----
 drivers/media/pci/cx18/cx18-mailbox.h              |  4 ++--
 drivers/media/usb/stk1160/stk1160-v4l.c            |  4 ++--
 drivers/media/usb/stk1160/stk1160-video.c          |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c           |  2 +-
 drivers/message/i2o/iop.c                          |  4 ++--
 drivers/misc/sgi-xp/xpc_main.c                     |  4 ++--
 drivers/mtd/ubi/ubi-media.h                        |  4 ++--
 drivers/net/bonding/bond_3ad.c                     |  2 +-
 drivers/net/ethernet/3com/typhoon.c                |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h    |  2 +-
 drivers/net/ethernet/dec/tulip/pnic.c              |  2 +-
 drivers/net/ethernet/freescale/fec_main.c          |  2 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |  2 +-
 drivers/net/ethernet/smsc/smc911x.c                |  4 ++--
 drivers/net/ethernet/smsc/smc9194.c                |  2 +-
 drivers/net/ethernet/smsc/smc91x.c                 |  4 ++--
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |  2 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |  2 +-
 drivers/net/irda/bfin_sir.c                        |  2 +-
 drivers/net/irda/nsc-ircc.c                        |  2 +-
 drivers/net/netconsole.c                           |  2 +-
 drivers/net/ppp/ppp_generic.c                      |  6 ++---
 drivers/net/slip/slip.c                            |  2 +-
 drivers/net/wan/dscc4.c                            |  2 +-
 drivers/net/wimax/i2400m/driver.c                  |  2 +-
 drivers/net/wimax/i2400m/fw.c                      |  2 +-
 drivers/net/wimax/i2400m/usb.c                     |  2 +-
 drivers/net/wireless/airo.c                        |  2 +-
 drivers/net/wireless/ath/ath5k/debug.h             |  2 +-
 drivers/net/wireless/orinoco/main.c                |  2 +-
 drivers/parport/parport_pc.c                       |  2 +-
 drivers/s390/block/dcssblk.c                       |  2 +-
 drivers/scsi/aic7xxx_old.c                         |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |  2 +-
 drivers/scsi/iscsi_tcp.c                           |  4 ++--
 drivers/scsi/libiscsi.c                            |  2 +-
 drivers/scsi/mesh.c                                |  4 ++--
 drivers/scsi/pm8001/pm8001_hwi.c                   |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |  2 +-
 drivers/scsi/wd7000.c                              |  2 +-
 drivers/staging/bcm/DDRInit.c                      |  2 +-
 drivers/staging/dgrp/dgrp_net_ops.c                |  2 +-
 drivers/staging/dgrp/dgrp_tty.c                    |  2 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |  6 ++---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |  4 ++--
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |  2 +-
 drivers/staging/lustre/lnet/lnet/acceptor.c        |  4 ++--
 drivers/staging/lustre/lnet/lnet/api-ni.c          |  2 +-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |  4 ++--
 drivers/staging/lustre/lnet/lnet/router.c          |  4 ++--
 drivers/staging/lustre/lnet/selftest/console.c     |  2 +-
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |  2 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |  2 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |  6 ++---
 .../lustre/lustre/ptlrpc/gss/gss_krb5_mech.c       |  4 ++--
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |  2 +-
 drivers/staging/speakup/spkguide.txt               |  2 +-
 drivers/tty/n_tracesink.c                          |  6 ++---
 drivers/usb/core/hub.c                             |  2 +-
 drivers/usb/gadget/f_fs.c                          |  2 +-
 drivers/usb/serial/aircable.c                      |  4 ++--
 drivers/usb/wusbcore/devconnect.c                  |  4 ++--
 drivers/uwb/driver.c                               |  2 +-
 drivers/vfio/pci/vfio_pci_config.c                 |  4 ++--
 drivers/video/aty/mach64_ct.c                      |  2 +-
 drivers/video/fm2fb.c                              |  2 +-
 drivers/video/geode/lxfb_core.c                    |  2 +-
 drivers/xen/xen-pciback/xenbus.c                   |  2 +-
 fs/ext3/inode.c                                    |  2 +-
 fs/ext4/inode.c                                    |  2 +-
 fs/jffs2/wbuf.c                                    |  2 +-
 fs/jfs/jfs_logmgr.c                                |  4 ++--
 fs/namespace.c                                     |  2 +-
 fs/nfs/file.c                                      |  2 +-
 fs/ocfs2/dlm/dlmdomain.c                           | 10 ++++----
 fs/ocfs2/dlm/dlmmaster.c                           |  2 +-
 fs/ocfs2/dlm/dlmrecovery.c                         | 12 +++++-----
 fs/ocfs2/dlm/dlmthread.c                           |  2 +-
 fs/ocfs2/inode.h                                   |  2 +-
 fs/ocfs2/journal.c                                 |  6 ++---
 fs/ocfs2/quota_local.c                             |  4 ++--
 fs/ocfs2/suballoc.c                                |  2 +-
 fs/pipe.c                                          |  2 +-
 fs/quota/dquot.c                                   |  4 ++--
 fs/xfs/xfs_qm.c                                    |  2 +-
 include/drm/drm_crtc.h                             |  2 +-
 include/drm/ttm/ttm_bo_driver.h                    |  2 +-
 include/linux/edac.h                               |  2 +-
 include/linux/fs.h                                 |  2 +-
 include/linux/interrupt.h                          |  2 +-
 include/linux/lockdep.h                            |  2 +-
 include/linux/vmw_vmci_defs.h                      |  2 +-
 include/linux/wm97xx.h                             |  2 +-
 include/net/irda/irttp.h                           |  6 ++---
 include/net/iucv/iucv.h                            |  2 +-
 include/net/sock.h                                 |  2 +-
 include/uapi/linux/bpqether.h                      |  2 +-
 ipc/mqueue.c                                       |  2 +-
 kernel/cgroup.c                                    |  2 +-
 kernel/printk/printk.c                             |  2 +-
 kernel/sched/fair.c                                |  2 +-
 lib/idr.c                                          |  2 +-
 lib/lru_cache.c                                    |  7 +++---
 lib/random32.c                                     |  2 +-
 mm/memcontrol.c                                    |  4 ++--
 mm/swapfile.c                                      |  4 ++--
 net/batman-adv/bridge_loop_avoidance.c             |  2 +-
 net/bridge/netfilter/ebtables.c                    |  2 +-
 net/core/dst.c                                     |  2 +-
 net/core/sock.c                                    |  2 +-
 net/dccp/feat.c                                    |  2 +-
 net/ipv4/af_inet.c                                 |  2 +-
 net/ipv4/devinet.c                                 |  2 +-
 net/ipv4/tcp_input.c                               |  8 +++----
 net/ipv4/tcp_output.c                              |  4 ++--
 net/irda/af_irda.c                                 |  6 ++---
 net/irda/discovery.c                               |  4 ++--
 net/irda/irlan/irlan_eth.c                         |  2 +-
 net/irda/irlap_frame.c                             |  2 +-
 net/irda/irlmp.c                                   |  8 +++----
 net/irda/irnet/irnet_irda.c                        |  2 +-
 net/irda/irqueue.c                                 |  2 +-
 net/irda/irttp.c                                   |  8 +++----
 net/netfilter/nf_conntrack_core.c                  |  2 +-
 net/netfilter/xt_TPROXY.c                          |  4 ++--
 net/netrom/af_netrom.c                             |  2 +-
 net/rds/recv.c                                     |  2 +-
 net/sched/sch_cbq.c                                |  2 +-
 net/sctp/associola.c                               |  2 +-
 net/sctp/sm_make_chunk.c                           |  4 ++--
 net/wimax/op-rfkill.c                              |  2 +-
 scripts/basic/fixdep.c                             |  4 ++--
 sound/core/seq/seq_device.c                        |  2 +-
 sound/oss/pss.c                                    |  4 ++--
 sound/oss/sb_ess.c                                 |  2 +-
 sound/pci/echoaudio/echoaudio.c                    |  2 +-
 sound/pci/nm256/nm256.c                            |  2 +-
 sound/pci/rme9652/hdspm.c                          |  2 +-
 sound/soc/fsl/fsl_dma.c                            |  2 +-
 sound/soc/mxs/mxs-saif.c                           | 10 ++++----
 221 files changed, 332 insertions(+), 329 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index a9b15e3..07071a0 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -431,7 +431,7 @@ typedef enum fe_delivery_system {
 
 		<para>Example: Assume 8 ISDB-Tsb connected segments are broadcasted. The
 			broadcaster has several possibilities to put those channels in the
-			air: Assuming a normal 13-segment ISDB-T spectrum he can align the 8
+			air: Assuming a normal 13-segment ISDB-T spectrum they can align the 8
 			segments from position 1-8 to 5-13 or anything in between.</para>
 
 		<para>The underlying layer of segments are subchannels: each segment is
diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 27faae3..e1b5792 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -299,7 +299,7 @@ The maintainers of the various kernel subsystems --- and also many
 kernel subsystem developers --- expose their current state of
 development in source repositories.  That way, others can see what is
 happening in the different areas of the kernel.  In areas where
-development is rapid, a developer may be asked to base his submissions
+development is rapid, a developer may be asked to base their submissions
 onto such a subsystem kernel tree so that conflicts between the
 submission and other already ongoing work are avoided.
 
diff --git a/Documentation/ManagementStyle b/Documentation/ManagementStyle
index a211ee8..6296ce6 100644
--- a/Documentation/ManagementStyle
+++ b/Documentation/ManagementStyle
@@ -100,7 +100,7 @@ to admit that you are stupid when you haven't _yet_ done the really
 stupid thing.
 
 Then, when it really does turn out to be stupid, people just roll their
-eyes and say "Oops, he did it again".  
+eyes and say "Oops, they did it again".
 
 This preemptive admission of incompetence might also make the people who
 actually do the work also think twice about whether it's worth doing or
@@ -164,11 +164,11 @@ To solve this problem, you really only have two options:
    might even be amused. 
 
 The option of being unfailingly polite really doesn't exist. Nobody will
-trust somebody who is so clearly hiding his true character.
+trust somebody who is so clearly hiding their true character.
 
 (*) Paul Simon sang "Fifty Ways to Leave Your Lover", because quite
-frankly, "A Million Ways to Tell a Developer He Is a D*ckhead" doesn't
-scan nearly as well.  But I'm sure he thought about it. 
+frankly, "A Million Ways to Tell a Developer They Are a D*ckhead"
+doesn't scan nearly as well.  But I'm sure he thought about it.
 
 
 		Chapter 3: People II - the Good Kind
@@ -210,15 +210,16 @@ Things will go wrong, and people want somebody to blame. Tag, you're it.
 It's not actually that hard to accept the blame, especially if people
 kind of realize that it wasn't _all_ your fault.  Which brings us to the
 best way of taking the blame: do it for another guy. You'll feel good
-for taking the fall, he'll feel good about not getting blamed, and the
-guy who lost his whole 36GB porn-collection because of your incompetence
-will grudgingly admit that you at least didn't try to weasel out of it.
-
-Then make the developer who really screwed up (if you can find him) know
-_in_private_ that he screwed up.  Not just so he can avoid it in the
-future, but so that he knows he owes you one.  And, perhaps even more
-importantly, he's also likely the person who can fix it.  Because, let's
-face it, it sure ain't you. 
+for taking the fall, they'll feel good about not getting blamed, and the
+user who lost their whole 36GB porn-collection because of your
+incompetence will grudgingly admit that you at least didn't try to weasel
+out of it.
+
+Then make the developer who really screwed up (if you can find them)
+know _in_private_ that they screwed up.  Not just so they can avoid it
+in the future, but so that they know they owe you one.  And, perhaps
+even more importantly, they're also likely the person who can fix it.
+Because, let's face it, it sure ain't you.
 
 Taking the blame is also why you get to be manager in the first place. 
 It's part of what makes people trust you, and allow you the potential
diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 26b1e31..72cc8ac 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -358,7 +358,7 @@ exactly the same in your tree and the submitters'. If you stick strictly to
 rule (c), you should ask the submitter to rediff, but this is a totally
 counter-productive waste of time and energy. Rule (b) allows you to adjust
 the code, but then it is very impolite to change one submitter's code and
-make him endorse your bugs. To solve this problem, it is recommended that
+make them endorse your bugs. To solve this problem, it is recommended that
 you add a line between the last Signed-off-by header and yours, indicating
 the nature of your changes. While there is nothing mandatory about this, it
 seems like prepending the description with your mail and/or name, all
@@ -402,7 +402,7 @@ tree.
 13) When to use Acked-by: and Cc:
 
 The Signed-off-by: tag indicates that the signer was involved in the
-development of the patch, or that he/she was in the patch's delivery path.
+development of the patch, or that they were in the patch's delivery path.
 
 If a person was not directly involved in the preparation or handling of a
 patch but wishes to signify and record their approval of it then they can
diff --git a/Documentation/arm/vlocks.txt b/Documentation/arm/vlocks.txt
index 415960a..c467238 100644
--- a/Documentation/arm/vlocks.txt
+++ b/Documentation/arm/vlocks.txt
@@ -37,7 +37,7 @@ The easiest way to explain the vlocks algorithm is with some pseudo-code:
 		/* signal our desire to vote */
 		currently_voting[this_cpu] = 1;
 		if (last_vote != -1) {
-			/* someone already volunteered himself */
+			/* someone already volunteered */
 			currently_voting[this_cpu] = 0;
 			return false; /* not ourself */
 		}
diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 638bf17..8e8b31c 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -137,11 +137,11 @@ depending on who launched it (prof/student).
 With the ability to classify tasks differently for different resources
 (by putting those resource subsystems in different hierarchies),
 the admin can easily set up a script which receives exec notifications
-and depending on who is launching the browser he can
+and depending on who is launching the browser they can
 
     # echo browser_pid > /sys/fs/cgroup/<restype>/<userclass>/tasks
 
-With only a single hierarchy, he now would potentially have to create
+With only a single hierarchy, they now would potentially have to create
 a separate cgroup for every browser launched and associate it with
 appropriate network and other resource class.  This may lead to
 proliferation of such cgroups.
diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index e2bc132..98d7411 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -333,7 +333,7 @@ set:
     Overcommiting kernel memory limits is definitely not recommended, since the
     box can still run out of non-reclaimable memory.
     In this case, the admin could set up K so that the sum of all groups is
-    never greater than the total memory, and freely set U at the cost of his
+    never greater than the total memory, and freely set U at the cost of their
     QoS.
 
     U != 0, K >= U:
diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index 2e06179..ca8b44c 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -219,7 +219,7 @@ tree, usually (but certainly not always) using the git source management
 tool.  Tools like git (and related tools like quilt or mercurial) allow
 maintainers to track a list of patches, including authorship information
 and other metadata.  At any given time, the maintainer can identify which
-patches in his or her repository are not found in the mainline.
+patches in their repository are not found in the mainline.
 
 When the merge window opens, top-level maintainers will ask Linus to "pull"
 the patches they have selected for merging from their repositories.  If
diff --git a/Documentation/development-process/5.Posting b/Documentation/development-process/5.Posting
index 8a48c9b..50e64a6 100644
--- a/Documentation/development-process/5.Posting
+++ b/Documentation/development-process/5.Posting
@@ -196,8 +196,8 @@ summary.  Each of these lines has the format:
 
 The tags in common use are:
 
- - Signed-off-by: this is a developer's certification that he or she has
-   the right to submit the patch for inclusion into the kernel.  It is an
+ - Signed-off-by: this is a developer's certification that they have the
+   right to submit the patch for inclusion into the kernel.  It is an
    agreement to the Developer's Certificate of Origin, the full text of
    which can be found in Documentation/SubmittingPatches.  Code without a
    proper signoff cannot be merged into the mainline.
diff --git a/Documentation/development-process/6.Followthrough b/Documentation/development-process/6.Followthrough
index 41d324a..c113ca4 100644
--- a/Documentation/development-process/6.Followthrough
+++ b/Documentation/development-process/6.Followthrough
@@ -102,10 +102,10 @@ in mind, of course, that he may not agree with you either.
 If a patch is considered to be a good thing to add to the kernel, and once
 most of the review issues have been resolved, the next step is usually
 entry into a subsystem maintainer's tree.  How that works varies from one
-subsystem to the next; each maintainer has his or her own way of doing
-things.  In particular, there may be more than one tree - one, perhaps,
-dedicated to patches planned for the next merge window, and another for
-longer-term work.
+subsystem to the next; each maintainer has their own way of doing things.
+In particular, there may be more than one tree - one, perhaps, dedicated
+to patches planned for the next merge window, and another for longer-term
+work.
 
 For patches applying to areas for which there is no obvious subsystem tree
 (memory management patches, for example), the default tree often ends up
diff --git a/Documentation/devicetree/bindings/net/broadcom-bcm87xx.txt b/Documentation/devicetree/bindings/net/broadcom-bcm87xx.txt
index 7c86d5e..662aa7b 100644
--- a/Documentation/devicetree/bindings/net/broadcom-bcm87xx.txt
+++ b/Documentation/devicetree/bindings/net/broadcom-bcm87xx.txt
@@ -10,7 +10,7 @@ Optional Properties:
   is the MDIO Manageable Device (MMD) address, the second a register
   address within the MMD, the third cell contains a mask to be ANDed
   with the existing register value, and the fourth cell is ORed with
-  he result to yield the new register value.  If the third cell has a
+  the result to yield the new register value.  If the third cell has a
   value of zero, no read of the existing value is performed.
 
 Example:
diff --git a/Documentation/filesystems/ntfs.txt b/Documentation/filesystems/ntfs.txt
index 791af8d..5a3d72c 100644
--- a/Documentation/filesystems/ntfs.txt
+++ b/Documentation/filesystems/ntfs.txt
@@ -127,7 +127,7 @@ gid=
 umask=			Provide default owner, group, and access mode mask.
 			These options work as documented in mount(8).  By
 			default, the files/directories are owned by root and
-			he/she has read and write permissions, as well as
+			they have read and write permissions, as well as
 			browse permission for directories.  No one else has any
 			access permissions.  I.e. the mode on all files is by
 			default rw------- and for directories rwx------, a
diff --git a/Documentation/filesystems/quota.txt b/Documentation/filesystems/quota.txt
index 5e8de25..13d6164 100644
--- a/Documentation/filesystems/quota.txt
+++ b/Documentation/filesystems/quota.txt
@@ -7,10 +7,11 @@ number of used inodes (inode is a filesystem structure which is associated with
 each file or directory) for users and/or groups. For both used space and number
 of used inodes there are actually two limits. The first one is called softlimit
 and the second one hardlimit.  An user can never exceed a hardlimit for any
-resource (unless he has CAP_SYS_RESOURCE capability). User is allowed to exceed
-softlimit but only for limited period of time. This period is called "grace
-period" or "grace time". When grace time is over, user is not able to allocate
-more space/inodes until he frees enough of them to get below softlimit.
+resource (unless they have CAP_SYS_RESOURCE capability). User is allowed to
+exceed softlimit but only for limited period of time. This period is called
+"grace period" or "grace time". When grace time is over, user is not able to
+allocate more space/inodes until they free enough of them to get below
+softlimit.
 
 Quota limits (and amount of grace time) are set independently for each
 filesystem.
@@ -23,7 +24,7 @@ Quota netlink interface
 When user exceeds a softlimit, runs out of grace time or reaches hardlimit,
 quota subsystem traditionally printed a message to the controlling terminal of
 the process which caused the excess. This method has the disadvantage that
-when user is using a graphical desktop he usually cannot see the message.
+when user is using a graphical desktop they usually cannot see the message.
 Thus quota netlink interface has been designed to pass information about
 the above events to userspace. There they can be captured by an application
 and processed accordingly.
diff --git a/Documentation/filesystems/romfs.txt b/Documentation/filesystems/romfs.txt
index e2b07cc..6ecff95 100644
--- a/Documentation/filesystems/romfs.txt
+++ b/Documentation/filesystems/romfs.txt
@@ -162,7 +162,7 @@ Un*x like system, but romfs does not provide the full possibilities.
 I have never found this limiting, but others might.
 
 - The file system is read only, so it can be very small, but in case
-one would want to write _anything_ to a file system, he still needs
+one would want to write _anything_ to a file system, one still needs
 a writable file system, thus negating the size advantages.  Possible
 solutions: implement write access as a compile-time option, or a new,
 similarly small writable filesystem for RAM disks.
diff --git a/Documentation/filesystems/sharedsubtree.txt b/Documentation/filesystems/sharedsubtree.txt
index 4ede421..8f283a2 100644
--- a/Documentation/filesystems/sharedsubtree.txt
+++ b/Documentation/filesystems/sharedsubtree.txt
@@ -196,7 +196,7 @@ replicas continue to be exactly same.
 		namespaces.  But namespaces are associated with processes. If
 		namespaces are made first class objects with user API to
 		associate/disassociate a namespace with userid, then each user
-		could have his/her own namespace and tailor it to his/her
+		could have their own namespace and tailor it to their
 		requirements. Offcourse its needs support from PAM.
 
 	D)  Versioned files
diff --git a/Documentation/fmc/carrier.txt b/Documentation/fmc/carrier.txt
index 5e4f1dd..54c7337 100644
--- a/Documentation/fmc/carrier.txt
+++ b/Documentation/fmc/carrier.txt
@@ -119,7 +119,7 @@ Note: mezzanine_data may be redundant, because Linux offers the drvdata
 approach, so the field may be removed in later versions of this bus
 implementation.
 
-As I write this, she SPEC carrier is already completely functional in
+As I write this, the SPEC carrier is already completely functional in
 the fmc-bus environment, and is a good reference to look at.
 
 
diff --git a/Documentation/hwmon/it87 b/Documentation/hwmon/it87
index c263740..1c1844d 100644
--- a/Documentation/hwmon/it87
+++ b/Documentation/hwmon/it87
@@ -73,7 +73,7 @@ Module Parameters
 
   Force PWM polarity to active high (DANGEROUS). Some chips are
   misconfigured by BIOS - PWM values would be inverted. This option tries
-  to fix this. Please contact your BIOS manufacturer and ask him for fix.
+  to fix this. Please contact your BIOS manufacturer and ask them for fix.
 
 
 Hardware Interfaces
diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index 88d5a86..bfedd1a 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -118,7 +118,7 @@ There are two possible methods of using Kdump.
 Building a relocatable kernel is advantageous from the point of view that
 one does not have to build a second kernel for capturing the dump. But
 at the same time one might want to build a custom dump capture kernel
-suitable to his needs.
+suitable to one's needs.
 
 Following are the configuration setting required for system and
 dump-capture kernels for enabling kdump support.
diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
index 58340d5..52bae1a 100644
--- a/Documentation/memory-hotplug.txt
+++ b/Documentation/memory-hotplug.txt
@@ -342,7 +342,7 @@ Consideration:
 Memory hotplug's design direction is to make the possibility of memory offlining
 higher and to guarantee unplugging memory under any situation. But it needs
 more work. Returning -EBUSY under some situation may be good because the user
-can decide to retry more or not by himself. Currently, memory offlining code
+can decide to retry more or not by themselves. Currently, memory offlining code
 does some amount of retry with 120 seconds timeout.
 
 -------------------------
diff --git a/Documentation/padata.txt b/Documentation/padata.txt
index 7ddfe21..64c0f63 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.txt
@@ -70,7 +70,7 @@ To simply add or remove one CPU from a certain cpumask the functions
 padata_add_cpu/padata_remove_cpu are used. cpu specifies the CPU to add or
 remove and mask is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL.
 
-If a user is interested in padata cpumask changes, he can register to
+If a user is interested in padata cpumask changes, they can register to
 the padata cpumask change notifier:
 
     int padata_register_cpumask_notifier(struct padata_instance *pinst,
diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 71b54d5..c9d9536 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -19,7 +19,7 @@ CONTENTS
 ==========
 
  Fiddling with these settings can result in an unstable system, the knobs are
- root only and assumes root knows what he is doing.
+ root only and assumes root knows what they are doing.
 
 Most notable:
 
diff --git a/Documentation/scsi/scsi-changer.txt b/Documentation/scsi/scsi-changer.txt
index ade046e..7f86a45 100644
--- a/Documentation/scsi/scsi-changer.txt
+++ b/Documentation/scsi/scsi-changer.txt
@@ -20,7 +20,7 @@ First some words about how changers work: A changer has 2 (possibly
 more) SCSI ID's. One for the changer device which controls the robot,
 and one for the device which actually reads and writes the data. The
 later may be anything, a MOD, a CD-ROM, a tape or whatever. For the
-changer device this is a "don't care", he *only* shuffles around the
+changer device this is a "don't care", it *only* shuffles around the
 media, nothing else.
 
 
diff --git a/Documentation/security/Smack.txt b/Documentation/security/Smack.txt
index 7a2d30c..ae351d5 100644
--- a/Documentation/security/Smack.txt
+++ b/Documentation/security/Smack.txt
@@ -363,7 +363,7 @@ With the isolation provided by Smack access separation is simple. There are
 many interesting cases where limited access by subjects to objects with
 different labels is desired. One example is the familiar spy model of
 sensitivity, where a scientist working on a highly classified project would be
-able to read documents of lower classifications and anything she writes will
+able to read documents of lower classifications and anything they write will
 be "born" highly classified. To accommodate such schemes Smack includes a
 mechanism for specifying rules allowing access between labels.
 
diff --git a/Documentation/sound/oss/PSS-updates b/Documentation/sound/oss/PSS-updates
index c84dd75..7738f11 100644
--- a/Documentation/sound/oss/PSS-updates
+++ b/Documentation/sound/oss/PSS-updates
@@ -43,13 +43,13 @@ pss_no_sound
 just configure non-sound components.  0 configures all components, a non-0 
 value will only attept to configure the CDROM and joystick ports.  This 
 parameter can be used by a user who only wished to use the builtin joystick 
-and/or CDROM port(s) of his PSS sound card.  If this driver is loaded with this 
+and/or CDROM port(s) of their PSS sound card.  If this driver is loaded with this 
 parameter and with the parameter below set to true then a user can safely unload 
 this driver with the following command "rmmod pss && rmmod ad1848 && rmmod 
 mpu401 && rmmod sound && rmmod soundcore" and retain the full functionality of 
-his CDROM and/or joystick port(s) while gaining back the memory previously used 
-by the sound drivers.  This default setting of this parameter is 0 to retain 
-full behavioral compatibility with previous versions of this driver.
+their CDROM and/or joystick port(s) while gaining back the memory previously
+used by the sound drivers.  This default setting of this parameter is 0 to
+retain full behavioral compatibility with previous versions of this driver.
 
 pss_keep_settings
 
diff --git a/Documentation/usb/WUSB-Design-overview.txt b/Documentation/usb/WUSB-Design-overview.txt
index 4c5e379..fa92b927 100644
--- a/Documentation/usb/WUSB-Design-overview.txt
+++ b/Documentation/usb/WUSB-Design-overview.txt
@@ -236,8 +236,8 @@ the event stream that is funneled into the API with
 daemon through a notification list.
 
 UWBD wakes up and scans the event list; finds a beacon and adds it to
-the BEACON CACHE (/uwb_beca/). If he receives a number of beacons from
-the same device, he considers it to be 'onair' and creates a new device
+the BEACON CACHE (/uwb_beca/). If it receives a number of beacons from
+the same device, it considers it to be 'onair' and creates a new device
 [/drivers/uwb/lc-dev.c:uwbd_dev_onair()/]. Similarly, when no beacons
 are received in some time, the device is considered gone and wiped out
 [uwbd calls periodically /uwb/beacon.c:uwb_beca_purge()/ that will purge
@@ -318,7 +318,7 @@ into /devconnect/). This process starts the authentication process for
 the device. First we allocate a /fake port/ and assign an
 unauthenticated address (128 to 255--what we really do is
 0x80 | fake_port_idx). We fiddle with the fake port status and /khubd/
-sees a new connection, so he moves on to enable the fake port with a reset.
+sees a new connection, so it moves on to enable the fake port with a reset.
 
 So now we are in the reset path -- we know we have a non-yet enumerated
 device with an unauthorized address; we ask user space to authenticate
diff --git a/Documentation/usb/iuu_phoenix.txt b/Documentation/usb/iuu_phoenix.txt
index e5f0480..82acf4a 100644
--- a/Documentation/usb/iuu_phoenix.txt
+++ b/Documentation/usb/iuu_phoenix.txt
@@ -15,7 +15,7 @@ I never had any problem with it, but I'm not a real
 guru, so don't blame me if your system is unstable
 
 You can plug more than one IUU. Every unit will
-have his own device file(/dev/ttyUSB0,/dev/ttyUSB1,...)
+have its own device file(/dev/ttyUSB0,/dev/ttyUSB1,...)
 
 
 
diff --git a/Documentation/usb/wusb-cbaf b/Documentation/usb/wusb-cbaf
index 8b3d43e..e01903a 100644
--- a/Documentation/usb/wusb-cbaf
+++ b/Documentation/usb/wusb-cbaf
@@ -44,7 +44,7 @@ COMMAND/ARGS are
    If we allow the device to connect, set a random new CDID and CK
    (connection key). Device saves them for the next time it wants to
    connect wireless. We save them for that next time also so we can
-   authenticate the device (when we see the CDID he uses to id
+   authenticate the device (when we see the CDID it uses to id
    itself) and the CK to crypto talk to it.
 
 CHID is always 16 hex bytes in 'XX YY ZZ...' form
diff --git a/Documentation/video4linux/meye.txt b/Documentation/video4linux/meye.txt
index a051152..931b2dc 100644
--- a/Documentation/video4linux/meye.txt
+++ b/Documentation/video4linux/meye.txt
@@ -91,7 +91,7 @@ Private API:
 	MEYEIOC_S_PARAMS
 		Get and set the extended parameters of the motion eye camera.
 		The user should always query the current parameters with
-		MEYEIOC_G_PARAMS, change what he likes and then issue the
+		MEYEIOC_G_PARAMS, change what they like and then issue the
 		MEYEIOC_S_PARAMS call (checking for -EINVAL). The extended
 		parameters are described by the meye_params structure.
 
diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
index 73a7450..c86957e 100644
--- a/arch/arc/kernel/troubleshoot.c
+++ b/arch/arc/kernel/troubleshoot.c
@@ -268,7 +268,7 @@ static ssize_t tlb_stats_output(struct file *file,	/* file descriptor */
 	size_t num;
 	char *kbuf = (char *)file->private_data;
 
-	/* All of the data can he shoved in one iteration */
+	/* All of the data can be shoved in one iteration */
 	if (*offset != 0)
 		return 0;
 
diff --git a/arch/arm/kernel/crash_dump.c b/arch/arm/kernel/crash_dump.c
index 90c50d4..c8375d0 100644
--- a/arch/arm/kernel/crash_dump.c
+++ b/arch/arm/kernel/crash_dump.c
@@ -24,7 +24,7 @@
  * @buf: buffer where the copied page is placed
  * @csize: number of bytes to copy
  * @offset: offset in bytes into the page
- * @userbuf: if set, @buf is int he user address space
+ * @userbuf: if set, @buf is in the user address space
  *
  * This function copies one page from old kernel memory into buffer pointed by
  * @buf. If @buf is in userspace, set @userbuf to %1. Returns number of bytes
diff --git a/arch/avr32/mm/dma-coherent.c b/arch/avr32/mm/dma-coherent.c
index 50cdb5b..2586c67 100644
--- a/arch/avr32/mm/dma-coherent.c
+++ b/arch/avr32/mm/dma-coherent.c
@@ -64,7 +64,7 @@ static struct page *__dma_alloc(struct device *dev, size_t size,
 	 * as uncached.
 	 *
 	 * Since the memory is newly allocated, there is no point in
-	 * doing a writeback. If the previous owner cares, he should
+	 * doing a writeback. If the previous owner cares, they should
 	 * have flushed the cache before releasing the memory.
 	 */
 	invalidate_dcache_region(phys_to_virt(page_to_phys(page)), size);
diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index ab33328..28163b3 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -856,7 +856,7 @@ typedef struct {
 
 
 /*
- * this function does the actual final call and he called
+ * this function does the actual final call and is called
  * from the smp code, i.e., this is the palinfo callback routine
  */
 static void
diff --git a/arch/m68k/atari/stdma.c b/arch/m68k/atari/stdma.c
index ddbf43c..099f39d 100644
--- a/arch/m68k/atari/stdma.c
+++ b/arch/m68k/atari/stdma.c
@@ -18,7 +18,7 @@
 /* The controlling functions set up a wait queue for access to the     */
 /* ST-DMA chip. Callers to stdma_lock() that cannot granted access are */
 /* put onto a queue and waked up later if the owner calls              */
-/* stdma_release(). Additionally, the caller gives his interrupt       */
+/* stdma_release(). Additionally, the caller gives its interrupt       */
 /* service routine to stdma_lock().                                    */
 /*                                                                     */
 /* On the Falcon, the IDE bus uses just the ACSI/Floppy interrupt, but */
diff --git a/arch/m68k/include/asm/oplib.h b/arch/m68k/include/asm/oplib.h
index f082d03..76f1754 100644
--- a/arch/m68k/include/asm/oplib.h
+++ b/arch/m68k/include/asm/oplib.h
@@ -62,7 +62,7 @@ extern void prom_unmapio(char *virt_addr, unsigned int num_bytes);
 
 /* Open the device described by the passed string.  Note, that the format
  * of the string is different on V0 vs. V2->higher proms.  The caller must
- * know what he/she is doing!  Returns the device descriptor, an int.
+ * know what they are doing!  Returns the device descriptor, an int.
  */
 extern int prom_devopen(char *device_string);
 
diff --git a/arch/m68k/mac/psc.c b/arch/m68k/mac/psc.c
index 6f026fc..0507f3d 100644
--- a/arch/m68k/mac/psc.c
+++ b/arch/m68k/mac/psc.c
@@ -49,7 +49,7 @@ static void psc_debug_dump(void)
 }
 
 /*
- * Try to kill all DMA channels on the PSC. Not sure how this his
+ * Try to kill all DMA channels on the PSC. Not sure how this is
  * supposed to work; this is code lifted from macmace.c and then
  * expanded to cover what I think are the other 7 channels.
  */
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 66804ad..bccb993 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -203,7 +203,7 @@ void pcibios_set_master(struct pci_dev *dev)
  * Adjust vm_pgoff of VMA such that it is the physical page offset
  * corresponding to the 32-bit pci bus offset for DEV requested by the user.
  *
- * Basically, the user finds the base address for his device which he wishes
+ * Basically, the user finds the base address for the device which they wish
  * to mmap.  They read the 32-bit value from the config space base register,
  * add whatever PAGE_SIZE multiple offset they wish, and feed this into the
  * offset parameter of mmap on /proc/bus/pci/XXX for that device.
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index dfc1b91..635ae20 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -923,7 +923,7 @@ void smtc_send_ipi(int cpu, int type, unsigned int action)
 			}
 			/*
 			 * Otherwise we queue the message for the target TC
-			 * to pick up when he does a local_irq_restore()
+			 * to pick up when it does a local_irq_restore()
 			 */
 			write_tc_c0_tchalt(0);
 			UNLOCK_CORE_PRA();
diff --git a/arch/mips/math-emu/dsemul.c b/arch/mips/math-emu/dsemul.c
index 7ea622a..24aa5b3 100644
--- a/arch/mips/math-emu/dsemul.c
+++ b/arch/mips/math-emu/dsemul.c
@@ -160,8 +160,8 @@ int do_dsemulret(struct pt_regs *xcp)
 	/*
 	 * At this point, we are satisfied that it's a BD emulation trap.  Yes,
 	 * a user might have deliberately put two malformed and useless
-	 * instructions in a row in his program, in which case he's in for a
-	 * nasty surprise - the next instruction will be treated as a
+	 * instructions in a row in their program, in which case they're in for
+	 * a nasty surprise - the next instruction will be treated as a
 	 * continuation address!  Alas, this seems to be the only way that we
 	 * can handle signals, recursion, and longjmps() in the context of
 	 * emulating the branch delay instruction.
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 62ffd20..7ee6549 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -1054,7 +1054,7 @@ static void probe_pcache(void)
 	 * #5.	With page sizes larger than 32kB there is no possibility
 	 * to get a VCE exception anymore so we don't care about this
 	 * misconfiguration.  The case is rather theoretical anyway;
-	 * presumably no vendor is shipping his hardware in the "bad"
+	 * presumably no vendor is shipping their hardware in the "bad"
 	 * configuration.
 	 */
 	if ((prid & PRID_IMP_MASK) == PRID_IMP_R4000 &&
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index 55f92b6..7b16df0 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -134,7 +134,7 @@ void machine_power_off(void)
 	pdc_chassis_send_status(PDC_CHASSIS_DIRECT_SHUTDOWN);
 		
 	/* It seems we have no way to power the system off via
-	 * software. The user has to press the button himself. */
+	 * software. The user has to press the button themselves */
 
 	printk(KERN_EMERG "System shut down completed.\n"
 	       "Please power this system off now.");
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index a1e3e40..53ed702 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -290,7 +290,7 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
  * Adjust vm_pgoff of VMA such that it is the physical page offset
  * corresponding to the 32-bit pci bus offset for DEV requested by the user.
  *
- * Basically, the user finds the base address for his device which he wishes
+ * Basically, the user finds the base address for the device which they wish
  * to mmap.  They read the 32-bit value from the config space base register,
  * add whatever PAGE_SIZE multiple offset they wish, and feed this into the
  * offset parameter of mmap on /proc/bus/pci/XXX for that device.
diff --git a/arch/sh/kernel/cpu/sh5/entry.S b/arch/sh/kernel/cpu/sh5/entry.S
index 0c8d037..17cc64d 100644
--- a/arch/sh/kernel/cpu/sh5/entry.S
+++ b/arch/sh/kernel/cpu/sh5/entry.S
@@ -822,7 +822,7 @@ no_underflow:
 	 *
 	 * On all SH5-101 revisions it is unsafe to raise the IMASK and at the
 	 * same time change BL from 1->0, as any pending interrupt of a level
-	 * higher than he previous value of IMASK will leak through and be
+	 * higher than the previous value of IMASK will leak through and be
 	 * taken unexpectedly.
 	 *
 	 * To avoid this we raise the IMASK and then issue another PUTCON to
diff --git a/arch/sparc/include/asm/processor_64.h b/arch/sparc/include/asm/processor_64.h
index 4c3f7f0..c7c78af 100644
--- a/arch/sparc/include/asm/processor_64.h
+++ b/arch/sparc/include/asm/processor_64.h
@@ -23,7 +23,7 @@
 #define wp_works_ok__is_a_macro /* for versions in ksyms.c */
 
 /*
- * User lives in his very own context, and cannot reference us. Note
+ * User lives in their very own context, and cannot reference us. Note
  * that TASK_SIZE is a misnomer, it really gives maximum user virtual
  * address that the kernel will allocate out.
  *
diff --git a/arch/sparc/include/asm/spinlock_32.h b/arch/sparc/include/asm/spinlock_32.h
index bcc98fc..78a33af 100644
--- a/arch/sparc/include/asm/spinlock_32.h
+++ b/arch/sparc/include/asm/spinlock_32.h
@@ -71,8 +71,8 @@ static inline void arch_spin_unlock(arch_spinlock_t *lock)
  *	 31                       8 7     0
  *
  * wlock signifies the one writer is in or somebody is updating
- * counter. For a writer, if he successfully acquires the wlock,
- * but counter is non-zero, he has to release the lock and wait,
+ * counter. For a writer, if it successfully acquires the wlock,
+ * but counter is non-zero, it has to release the lock and wait,
  * till both counter and wlock are zero.
  *
  * Unfortunately this scheme limits us to ~16,000,000 cpus.
diff --git a/arch/sparc/include/asm/uaccess_32.h b/arch/sparc/include/asm/uaccess_32.h
index 53a28dd..73e33f0 100644
--- a/arch/sparc/include/asm/uaccess_32.h
+++ b/arch/sparc/include/asm/uaccess_32.h
@@ -42,7 +42,7 @@
 /* We have there a nice not-mapped page at PAGE_OFFSET - PAGE_SIZE, so that this test
  * can be fairly lightweight.
  * No one can read/write anything from userland in the kernel space by setting
- * large size and address near to PAGE_OFFSET - a fault will break his intentions.
+ * large size and address near to PAGE_OFFSET - a fault will break their intentions.
  */
 #define __user_ok(addr, size) ({ (void)(size); (addr) < STACK_TOP; })
 #define __kernel_ok (segment_eq(get_fs(), KERNEL_DS))
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index cb02145..0d6e77c 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -659,7 +659,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 
 /* Platform support for /proc/bus/pci/X/Y mmap()s. */
 
-/* If the user uses a host-bridge as the PCI device, he may use
+/* If the user uses a host-bridge as the PCI device, they may use
  * this to perform a raw mmap() of the I/O or MEM space behind
  * that controller.
  *
@@ -700,7 +700,7 @@ static int __pci_mmap_make_offset_bus(struct pci_dev *pdev, struct vm_area_struc
 /* Adjust vm_pgoff of VMA such that it is the physical page offset
  * corresponding to the 32-bit pci bus offset for DEV requested by the user.
  *
- * Basically, the user finds the base address for his device which he wishes
+ * Basically, the user finds the base address for the device which they wish
  * to mmap.  They read the 32-bit value from the config space base register,
  * add whatever PAGE_SIZE multiple offset they wish, and feed this into the
  * offset parameter of mmap on /proc/bus/pci/XXX for that device.
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index b66a533..9daa2f9 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -254,7 +254,7 @@ static void smp_synchronize_one_tick(int cpu)
 	while (!go[MASTER])
 		rmb();
 
-	/* now let the client proceed into his loop */
+	/* now let the client proceed into its loop */
 	go[MASTER] = 0;
 	membar_safe("#StoreLoad");
 
diff --git a/arch/sparc/kernel/wof.S b/arch/sparc/kernel/wof.S
index 28a7bc6..23563db 100644
--- a/arch/sparc/kernel/wof.S
+++ b/arch/sparc/kernel/wof.S
@@ -195,7 +195,7 @@ spwin_finish_up:
 spwin_user_stack_is_bolixed:
 	/* LOCATION: Window to be saved */
 
-	/* Wheee, user has trashed his/her stack.  We have to decide
+	/* Wheee, user has trashed their stack.  We have to decide
 	 * how to proceed based upon whether we came from kernel mode
 	 * or not.  If we came from kernel mode, toss the window into
 	 * a special buffer and proceed, the kernel _needs_ a window
diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index 69bb818..4dc86ab 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -85,7 +85,7 @@ static void __kprobes bad_kernel_pc(struct pt_regs *regs, unsigned long vaddr)
  * We now make sure that mmap_sem is held in all paths that call 
  * this. Additionally, to prevent kswapd from ripping ptes from
  * under us, raise interrupts around the time that we look at the
- * pte, kswapd will have to wait to get his smp ipi response from
+ * pte, kswapd will have to wait to get its smp ipi response from
  * us. vmtruncate likewise. This saves us having to get pte lock.
  */
 static unsigned int get_user_insn(unsigned long tpc)
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 29880c9..516d1de 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -157,7 +157,7 @@ void mconsole_proc(struct mc_request *req)
 			mconsole_reply(req, "Read of file failed", 1, 0);
 			goto out_free;
 		}
-		/* Begin the file content on his own line. */
+		/* Begin the file content on its own line. */
 		if (first_chunk) {
 			mconsole_reply(req, "\n", 0, 1);
 			first_chunk = 0;
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 3c03a5d..abc01da 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -31,7 +31,7 @@ unsigned long __must_check __copy_from_user_ll_nocache_nozero
  *
  * Copy data from kernel space to user space.  Caller must check
  * the specified block with access_ok() before calling this function.
- * The caller should also make sure he pins the user space address
+ * The caller should also make sure it pins the user space address
  * so that we don't result in page fault and sleep.
  *
  * Here we special-case 1, 2 and 4-byte copy_*_user invocations.  On a fault
diff --git a/arch/xtensa/kernel/pci.c b/arch/xtensa/kernel/pci.c
index 5b34033..205c87b 100644
--- a/arch/xtensa/kernel/pci.c
+++ b/arch/xtensa/kernel/pci.c
@@ -264,7 +264,7 @@ pci_controller_num(struct pci_dev *dev)
  * Adjust vm_pgoff of VMA such that it is the physical page offset
  * corresponding to the 32-bit pci bus offset for DEV requested by the user.
  *
- * Basically, the user finds the base address for his device which he wishes
+ * Basically, the user finds the base address for the device which they wish
  * to mmap.  They read the 32-bit value from the config space base register,
  * add whatever PAGE_SIZE multiple offset they wish, and feed this into the
  * offset parameter of mmap on /proc/bus/pci/XXX for that device.
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 625e3e4..3c12ab0 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -361,7 +361,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	start_time = jiffies;
 
 	/* ignore return value. All information is passed back to caller
-	 * (if he doesn't check that is his problem).
+	 * (if it doesn't check that is its problem).
 	 * N.B. a non-zero SCSI status is _not_ necessarily an error.
 	 */
 	blk_execute_rq(q, bd_disk, rq, 0);
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 995e91b..7804012 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -486,7 +486,7 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
 		if (ACPI_SUCCESS(status)) {
 			if (raw) {
 				/*
-				 * Caller has indicated he wants the raw
+				 * Caller has indicated it wants the raw
 				 * value returned by _BQC, so don't furtherly
 				 * mess with the value.
 				 */
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index d91f1a5..30f3bb4 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -580,7 +580,7 @@ static int __init brd_init(void)
 		/*
 		 * Adjust max_part according to part_shift as it is exported
 		 * to user space so that user can decide correct minor number
-		 * if [s]he want to create more devices.
+		 * if they want to create more devices.
 		 *
 		 * Note that -1 is required because partition 0 is reserved
 		 * for the whole disk.
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6fa6673..ab77602 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3885,7 +3885,7 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 		return 0;
 	}
 
-	/* peer says his disk is inconsistent, while we think it is uptodate,
+	/* peer says its disk is inconsistent, while we think it is uptodate,
 	 * and this happens while the peer still thinks we have a sync going on,
 	 * but we think we are already done with the sync.
 	 * We ignore this to avoid flapping pdsk.
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c8dac73..c2980a0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1835,7 +1835,7 @@ static int __init loop_init(void)
 		/*
 		 * Adjust max_part according to part_shift as it is exported
 		 * to user space so that user can decide correct minor number
-		 * if [s]he want to create more devices.
+		 * if they want to create more devices.
 		 *
 		 * Note that -1 is required because partition 0 is reserved
 		 * for the whole disk.
diff --git a/drivers/char/nwbutton.c b/drivers/char/nwbutton.c
index 1fd00dc..ebbc38e 100644
--- a/drivers/char/nwbutton.c
+++ b/drivers/char/nwbutton.c
@@ -50,7 +50,7 @@ static int reboot_count = NUM_PRESSES_REBOOT; /* Number of presses to reboot */
  * fragmented, so we need to search through the list until we find the first
  * free entry.
  *
- * FIXME: Has anyone spotted any locking functions int his code recently ??
+ * FIXME: Has anyone spotted any locking functions in this code recently ??
  */
 
 int button_add_callback (void (*callback) (void), int count)
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75b..b0bd0cc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -337,10 +337,10 @@ static int random_min_urandom_seed = 60;
  * alterations to the pool's state is not important because we don't
  * consider such inputs to contribute any randomness.  The only
  * property we need with respect to them is that the attacker can't
- * increase his/her knowledge of the pool's state.  Since all
+ * increase their knowledge of the pool's state.  Since all
  * additions are reversible (knowing the final state and the input,
  * you can reconstruct the initial state), if an attacker has any
- * uncertainty about the initial state, he/she can only shuffle that
+ * uncertainty about the initial state, they can only shuffle that
  * uncertainty about, but never cause any collisions (which would
  * decrease the uncertainty).
  *
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 9012b8b..aa27095 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -421,7 +421,7 @@ static void __exit eps_exit(void)
 	cpufreq_unregister_driver(&eps_driver);
 }
 
-/* Allow user to overclock his machine or to change frequency to higher after
+/* Allow user to overclock their machine or to change frequency to higher after
  * unloading module */
 module_param(freq_failsafe_off, int, 0644);
 MODULE_PARM_DESC(freq_failsafe_off, "Disable current vs max frequency check");
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 0023c7d..68ad7f8 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -733,7 +733,7 @@ static int find_psb_table(struct powernow_k8_data *data)
 	}
 	/*
 	 * If you see this message, complain to BIOS manufacturer. If
-	 * he tells you "we do not support Linux" or some similar
+	 * they tell you "we do not support Linux" or some similar
 	 * nonsense, remember that Windows 2000 uses the same legacy
 	 * mechanism that the old Linux PSB driver uses. Tell them it
 	 * is broken with Windows 2000.
diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index c29dacf..0f6578c 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -588,7 +588,7 @@ static int cppi41_tear_down_chan(struct cppi41_channel *c)
 	c->td_retry--;
 	/*
 	 * If the TX descriptor / channel is in use, the caller needs to poke
-	 * his TD bit multiple times. After that he hardware releases the
+	 * its TD bit multiple times. After that the hardware releases the
 	 * transfer descriptor followed by TD descriptor. Waiting seems not to
 	 * cause any difference.
 	 * RX seems to be thrown out right away. However once the TearDown
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 15443d3..3c04743 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -433,7 +433,7 @@ static int _call_per_cable(struct notifier_block *nb, unsigned long val,
  * extcon_register_interest is a helper function for those who want to get
  * notification for a single specific cable's status change. If a user wants
  * to get notification for any changes of all cables of a extcon device,
- * he/she should use the general extcon_register_notifier().
+ * they should use the general extcon_register_notifier().
  *
  * Note that the second parameter given to the callback of nb (val) is
  * "old_state", not the current state. The current state can be retrieved
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0f04444..b5c1625 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -18,7 +18,7 @@ config ARCH_WANT_OPTIONAL_GPIOLIB
 	  user decide whether to actually build it or not.
 	  Select this instead of ARCH_REQUIRE_GPIOLIB, if your architecture does
 	  not depend on GPIOs being available, but rather let the user
-	  decide whether he needs it or not.
+	  decide whether they need it or not.
 
 config ARCH_REQUIRE_GPIOLIB
 	bool
diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index d284d89..ac5fc6a 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -33,8 +33,8 @@
 /*
  * The BIOS typically reserves some of the system's memory for the exclusive
  * use of the integrated graphics. This memory is no longer available for
- * use by the OS and so the user finds that his system has less memory
- * available than he put in. We refer to this memory as stolen.
+ * use by the OS and so the user finds that their system has less memory
+ * available than they put in. We refer to this memory as stolen.
  *
  * The BIOS will allocate its framebuffer from the stolen memory. Our
  * goal is try to reuse that object for our own fbcon which must always
diff --git a/drivers/gpu/drm/mga/mga_irq.c b/drivers/gpu/drm/mga/mga_irq.c
index 2b0ceb8..0ea2b57 100644
--- a/drivers/gpu/drm/mga/mga_irq.c
+++ b/drivers/gpu/drm/mga/mga_irq.c
@@ -125,7 +125,7 @@ int mga_driver_fence_wait(struct drm_device *dev, unsigned int *sequence)
 	int ret = 0;
 
 	/* Assume that the user has missed the current sequence number
-	 * by about a day rather than she wants to wait for years
+	 * by about a day rather than they want to wait for years
 	 * using fences.
 	 */
 	DRM_WAIT_ON(ret, dev_priv->fence_queue, 3 * DRM_HZ,
diff --git a/drivers/gpu/drm/vmwgfx/svga_escape.h b/drivers/gpu/drm/vmwgfx/svga_escape.h
index 8e8d968..d83e6cf 100644
--- a/drivers/gpu/drm/vmwgfx/svga_escape.h
+++ b/drivers/gpu/drm/vmwgfx/svga_escape.h
@@ -62,7 +62,7 @@
  * SVGA Hint commands.
  *
  * These escapes let the SVGA driver provide optional information to
- * he host about the state of the guest or guest applications. The
+ * the host about the state of the guest or guest applications. The
  * host can use these hints to make user interface or performance
  * decisions.
  *
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index af02597..f7f04d1 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -231,13 +231,13 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 			lwants = VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
 		}
 
-		/* Check if the guy has a lock on the resource. If he does,
+		/* Check if there's a lock on the resource. If there is,
 		 * return the conflicting entry
 		 */
 		if (conflict->locks & lwants)
 			return conflict;
 
-		/* Ok, now check if he owns the resource we want. We don't need
+		/* Ok, now check if it owns the resource we want. We don't need
 		 * to check "decodes" since it should be impossible to own
 		 * own legacy resources you don't decode unless I have a bug
 		 * in this code...
@@ -247,8 +247,8 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 		if (!match)
 			continue;
 
-		/* looks like he doesn't have a lock, we can steal
-		 * them from him
+		/* looks like it doesn't have a lock, we can steal
+		 * them from it
 		 */
 
 		flags = 0;
@@ -268,7 +268,7 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 
 		pci_set_vga_state(conflict->pdev, false, pci_bits, flags);
 		conflict->owns &= ~match;
-		/* If he also owned non-legacy, that is no longer the case */
+		/* If it also owned non-legacy, that is no longer the case */
 		if (match & VGA_RSRC_LEGACY_MEM)
 			conflict->owns &= ~VGA_RSRC_NORMAL_MEM;
 		if (match & VGA_RSRC_LEGACY_IO)
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 461a0d7..f16cc50 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -76,7 +76,7 @@ static DEFINE_MUTEX(hwspinlock_tree_lock);
  * minimize remote cores polling on the hardware interconnect.
  *
  * The user decides whether local interrupts are disabled or not, and if yes,
- * whether he wants their previous state to be saved. It is up to the user
+ * whether they want their previous state to be saved. It is up to the user
  * to choose the appropriate @mode of operation, exactly the same way users
  * should decide between spin_trylock, spin_trylock_irq and
  * spin_trylock_irqsave.
@@ -166,7 +166,7 @@ EXPORT_SYMBOL_GPL(__hwspin_trylock);
  * hardware interconnect.
  *
  * The user decides whether local interrupts are disabled or not, and if yes,
- * whether he wants their previous state to be saved. It is up to the user
+ * whether they want their previous state to be saved. It is up to the user
  * to choose the appropriate @mode of operation, exactly the same way users
  * should decide between spin_lock, spin_lock_irq and spin_lock_irqsave.
  *
@@ -219,7 +219,7 @@ EXPORT_SYMBOL_GPL(__hwspin_lock_timeout);
  * to call unlock on a @hwlock that is already unlocked.
  *
  * The user decides whether local interrupts should be enabled or not, and
- * if yes, whether he wants their previous state to be restored. It is up
+ * if yes, whether they want their previous state to be restored. It is up
  * to the user to choose the appropriate @mode of operation, exactly the
  * same way users decide between spin_unlock, spin_unlock_irq and
  * spin_unlock_irqrestore.
diff --git a/drivers/infiniband/hw/amso1100/c2_intr.c b/drivers/infiniband/hw/amso1100/c2_intr.c
index 8951db4..9def9fd 100644
--- a/drivers/infiniband/hw/amso1100/c2_intr.c
+++ b/drivers/infiniband/hw/amso1100/c2_intr.c
@@ -137,7 +137,7 @@ static void handle_vq(struct c2_dev *c2dev, u32 mq_index)
 
 	/*
 	 * If we can't get a host buffer, then we'll still
-	 * wakeup the waiter, we just won't give him the msg.
+	 * wakeup the waiter, we just won't give it the msg.
 	 * It is assumed the waiter will deal with this...
 	 */
 	if (!host_msg) {
diff --git a/drivers/isdn/hardware/eicon/dadapter.c b/drivers/isdn/hardware/eicon/dadapter.c
index 5142099..d692247 100644
--- a/drivers/isdn/hardware/eicon/dadapter.c
+++ b/drivers/isdn/hardware/eicon/dadapter.c
@@ -263,7 +263,7 @@ static void IDI_CALL_LINK_T diva_dadapter_request(	\
 	}
 }
 /* --------------------------------------------------------------------------
-   IDI client does register his notification function
+   IDI client does register its notification function
    -------------------------------------------------------------------------- */
 static dword diva_register_adapter_callback(		\
 	didd_adapter_change_callback_t callback,
@@ -286,7 +286,7 @@ static dword diva_register_adapter_callback(		\
 		return (0);
 }
 /* --------------------------------------------------------------------------
-   IDI client does register his notification function
+   IDI client does register its notification function
    -------------------------------------------------------------------------- */
 static void diva_remove_adapter_callback(dword handle) {
 	diva_os_spin_lock_magic_t irql;
diff --git a/drivers/isdn/hardware/eicon/io.c b/drivers/isdn/hardware/eicon/io.c
index 8851ce5..d30fb97 100644
--- a/drivers/isdn/hardware/eicon/io.c
+++ b/drivers/isdn/hardware/eicon/io.c
@@ -68,7 +68,7 @@ IDI_CALL Requests[MAX_ADAPTER] =
 /*****************************************************************************/
 /*
   This array should indicate all new services, that this version of XDI
-  is able to provide to his clients
+  is able to provide to its clients
 */
 static byte extended_xdi_features[DIVA_XDI_EXTENDED_FEATURES_MAX_SZ + 1] = {
 	(DIVA_XDI_EXTENDED_FEATURES_VALID       |
diff --git a/drivers/isdn/i4l/isdn_ppp.c b/drivers/isdn/i4l/isdn_ppp.c
index 38ceac5..51ce967 100644
--- a/drivers/isdn/i4l/isdn_ppp.c
+++ b/drivers/isdn/i4l/isdn_ppp.c
@@ -2360,7 +2360,7 @@ static void isdn_ppp_ccp_reset_trans(struct ippp_struct *is,
 	if (rp->valid) {
 		/* The decompressor defines parameters by itself */
 		if (rp->rsend) {
-			/* And he wants us to send a request */
+			/* And it wants us to send a request */
 			if (!(rp->idval)) {
 				printk(KERN_ERR "ippp_ccp: decompressor must"
 				       " specify reset id\n");
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 5152142..5611aef 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1189,7 +1189,7 @@ static int dev_wait(struct dm_ioctl *param, size_t param_size)
 	/*
 	 * The userland program is going to want to know what
 	 * changed to trigger the event, so we may as well tell
-	 * him and save an ioctl.
+	 * it and save an ioctl.
 	 */
 	__dev_status(md, param);
 
diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 3ee22ff..ac6225d 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -983,7 +983,7 @@ static void dib0090_gain_apply(struct dib0090_state *state, s16 gain_delta, s16
 			v = 0;	/* force the gain to write for the current amp to be null */
 		else if (ref >= g[1])	/* Gain to set is higher than the high working point of this amp */
 			v = g[2];	/* force this amp to be full gain */
-		else		/* compute the value to set to this amp because we are somewhere in his range */
+		else		/* compute the value to set to this amp because we are somewhere in its range */
 			v = ((ref - (g[1] - g[0])) * g[2]) / g[0];
 
 		if (i == 0)	/* LNA 1 reg mapping */
diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index e6588ee..5dd5632 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -870,7 +870,7 @@ static int cx25840_ir_tx_write(struct v4l2_subdev *sd, u8 *buf, size_t count,
 	 * input, and push them off to the hardware Tx FIFO right away, if the
 	 * HW TX fifo needs service.  The rest can be pushed to the tx_kfifo in
 	 * a less critical timeframe.  Also watch out for overruning the
-	 * tx_kfifo - don't let it happen and let the caller know not all his
+	 * tx_kfifo - don't let it happen and let the caller know not all its
 	 * pulses were written.
 	 */
 	u32 *ns_pulse = (u32 *) buf;
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index f9f95f8..f4f5bc8 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -590,8 +590,8 @@ static int mt9v022_s_ctrl(struct v4l2_ctrl *ctrl)
 				gain_val &= ~1;
 
 			/*
-			 * The user wants to set gain manually, hope, she
-			 * knows, what she's doing... Switch AGC off.
+			 * The user wants to set gain manually, hope they
+			 * knows what they're doing... Switch AGC off.
 			 */
 			if (reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x2) < 0)
 				return -EIO;
@@ -612,8 +612,8 @@ static int mt9v022_s_ctrl(struct v4l2_ctrl *ctrl)
 					479 + range / 2) / range + 1;
 
 			/*
-			 * The user wants to set shutter width manually, hope,
-			 * she knows, what she's doing... Switch AEC off.
+			 * The user wants to set shutter width manually, hope
+			 * they know what they're doing... Switch AEC off.
 			 */
 			data = reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x1);
 			if (data < 0)
diff --git a/drivers/media/pci/cx18/cx18-mailbox.h b/drivers/media/pci/cx18/cx18-mailbox.h
index b63fdfa..9ddc81f 100644
--- a/drivers/media/pci/cx18/cx18-mailbox.h
+++ b/drivers/media/pci/cx18/cx18-mailbox.h
@@ -52,13 +52,13 @@ struct cx18_mdl_ack {
 /* The cx18_mailbox struct is the mailbox structure which is used for passing
    messages between processors */
 struct cx18_mailbox {
-    /* The sender sets a handle in 'request' after he fills the command. The
+    /* The sender sets a handle in 'request' after it fills the command. The
        'request' should be different than 'ack'. The sender, also, generates
        an interrupt on XPU2YPU_irq where XPU is the sender and YPU is the
        receiver. */
     u32       request;
     /* The receiver detects a new command when 'req' is different than 'ack'.
-       He sets 'ack' to the same value as 'req' to clear the command. He, also,
+       It sets 'ack' to the same value as 'req' to clear the command. It, also,
        generates an interrupt on YPU2XPU_irq where XPU is the sender and YPU
        is the receiver. */
     u32       ack;
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index c45c988..31906d1 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -326,8 +326,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	struct stk1160 *dev = video_drvdata(file);
 
 	/*
-	 * User can't choose size at his own will,
-	 * so we just return him the current size chosen
+	 * User can't choose a size,
+	 * so we just return the current size chosen
 	 * at standard selection.
 	 * TODO: Implement frame scaling?
 	 */
diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 39f1aae..1307f5d 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -316,7 +316,7 @@ static void stk1160_isoc_irq(struct urb *urb)
 	case -ECONNRESET:   /* kill */
 	case -ENOENT:
 	case -ESHUTDOWN:
-		/* TODO: check uvc driver: he frees the queue here */
+		/* TODO: check uvc driver: it frees the queue here */
 		return;
 	default:
 		stk1160_err("urb error! status %d\n", urb->status);
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index b19b306..87a3a56 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2513,7 +2513,7 @@ int vb2_ioctl_reqbufs(struct file *file, void *priv,
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
 	res = __reqbufs(vdev->queue, p);
-	/* If count == 0, then the owner has released all buffers and he
+	/* If count == 0, then the owner has released all buffers and it
 	   is no longer owner of the queue. Otherwise we have a new owner. */
 	if (res == 0)
 		vdev->queue->owner = p->count ? file->private_data : NULL;
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index a8c08f3..9f1c9ab 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -1085,10 +1085,10 @@ struct i2o_controller *i2o_iop_alloc(void)
 };
 
 /**
- *	i2o_iop_add - Initialize the I2O controller and add him to the I2O core
+ *	i2o_iop_add - Initialize the I2O controller and add it to the I2O core
  *	@c: controller
  *
- *	Initialize the I2O controller and if no error occurs add him to the I2O
+ *	Initialize the I2O controller and if no error occurs add it to the I2O
  *	core.
  *
  *	Returns 0 on success or negative error code on failure.
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index 82dc574..ab9f113 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -359,11 +359,11 @@ xpc_channel_mgr(struct xpc_partition *part)
 		 *
 		 * The channel_mgr_requests is set to 1 after being awakened,
 		 * This is done to prevent the channel mgr from making one pass
-		 * through the loop for each request, since he will
+		 * through the loop for each request, since it will
 		 * be servicing all the requests in one pass. The reason it's
 		 * set to 1 instead of 0 is so that other kthreads will know
 		 * that the channel mgr is running and won't bother trying to
-		 * wake him up.
+		 * wake it up.
 		 */
 		atomic_dec(&part->channel_mgr_requests);
 		(void)wait_event_interruptible(part->channel_mgr_wq,
diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index ac2b24d..bcd1b26 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -79,7 +79,7 @@ enum {
  * eraseblocks, depending of particular chip instance. Manufacturers of NAND
  * chips usually guarantee that the amount of initial bad eraseblocks does not
  * exceed certain percent, e.g. 2%. When one creates an UBI image which will be
- * flashed to the end devices in production, he does not know the exact amount
+ * flashed to the end devices in production, one does not know the exact amount
  * of good physical eraseblocks the NAND chip on the device will have, but this
  * number is required to calculate the volume sized and put them to the volume
  * table of the UBI image. In this case, one of the volumes (e.g., the one
@@ -245,7 +245,7 @@ struct ubi_ec_hdr {
  * of their compatibility". It is always zero for user volumes. This field
  * provides a mechanism to introduce UBI extensions and to be still compatible
  * with older UBI binaries. For example, if someone introduced a journal in
- * future, he would probably use %UBI_COMPAT_DELETE compatibility for the
+ * future, they would probably use %UBI_COMPAT_DELETE compatibility for the
  * journal volume.  And in this case, older UBI binaries, which know nothing
  * about the journal volume, would just delete this volume and work perfectly
  * fine. This is similar to what Ext2fs does when it is fed by an Ext3fs image
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 187b1b7..8bbbd0e 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2266,7 +2266,7 @@ void bond_3ad_handle_link_change(struct slave *slave, char link)
 	}
 
 	// on link down we are zeroing duplex and speed since some of the adaptors(ce1000.lan) report full duplex/speed instead of N/A(duplex) / 0(speed)
-	// on link up we are forcing recheck on the duplex and speed since some of he adaptors(ce1000.lan) report
+	// on link up we are forcing recheck on the duplex and speed since some of the adaptors(ce1000.lan) report
 	if (link == BOND_LINK_UP) {
 		port->is_enabled = true;
 		port->actor_admin_port_key &= ~AD_DUPLEX_KEY_BITS;
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 465cc71..fde59c6 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2463,7 +2463,7 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		    dev->dev_addr);
 
 	/* xp_resp still contains the response to the READ_VERSIONS command.
-	 * For debugging, let the user know what version he has.
+	 * For debugging, let the user know what version they have.
 	 */
 	if(xp_resp[0].numDesc == 0) {
 		/* This is the Typhoon 1.0 type Sleep Image, last 16 bits
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 814d0ec..0aba509 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -6862,7 +6862,7 @@ static int bnx2x_init_hw_common(struct bnx2x *bp)
 		 * with dummy TM client
 		 *
 		 * we must use pretend since PXP2_REG_RQ_##blk##_FIRST_ILT
-		 * and his brother are split registers
+		 * and its brother are split registers
 		 */
 		bnx2x_pretend_func(bp, (BP_PATH(bp) + 6));
 		bnx2x_ilt_client_init_op_ilt(bp, &ilt, &ilt_cli, INITOP_CLEAR);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
index 3efbb35..f7c6348 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
@@ -3601,7 +3601,7 @@
 /* [RW 3] page size in L2P table for TM module; -4k; -8k; -16k; -32k; -64k;
    -128k */
 #define PXP2_REG_RQ_TM_P_SIZE					 0x120034
-/* [R 5] Number of entries in the ufifo; his fifo has l2p completions */
+/* [R 5] Number of entries in the ufifo; its fifo has l2p completions */
 #define PXP2_REG_RQ_UFIFO_NUM_OF_ENTRY				 0x12080c
 /* [RW 18] external first_mem_addr field in L2P table for USDM module port 0 */
 #define PXP2_REG_RQ_USDM0_EFIRST_MEM_ADDR			 0x120094
diff --git a/drivers/net/ethernet/dec/tulip/pnic.c b/drivers/net/ethernet/dec/tulip/pnic.c
index 5364563..69bd57b 100644
--- a/drivers/net/ethernet/dec/tulip/pnic.c
+++ b/drivers/net/ethernet/dec/tulip/pnic.c
@@ -95,7 +95,7 @@ void pnic_timer(unsigned long data)
 		/* the timer was called due to a work overflow
 		 * in the interrupt handler. Skip the connection
 		 * checks, the nic is definitively speaking with
-		 * his link partner.
+		 * its link partner.
 		 */
 		goto too_good_connection;
 	}
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 4cbebf3..2a1aaa5 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1882,7 +1882,7 @@ static void set_multicast_list(struct net_device *ndev)
 		}
 
 		/* only upper 6 bits (HASH_BITS) are used
-		 * which point to specific bit in he hash registers
+		 * which point to specific bit in the hash registers
 		 */
 		hash = (crc >> (32 - HASH_BITS)) & 0x3f;
 
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 68026f7..7205f32 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2545,7 +2545,7 @@ static int myri10ge_open(struct net_device *dev)
 		mgp->small_bytes = myri10ge_small_bytes;
 
 	/* Firmware needs the big buff size as a power of 2.  Lie and
-	 * tell him the buffer is larger, because we only use 1
+	 * tell it the buffer is larger, because we only use 1
 	 * buffer/pkt, and the mtu will prevent overruns.
 	 */
 	big_pow2 = dev->mtu + ETH_HLEN + VLAN_HLEN + MXGEFW_PAD;
diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 0f096a8..ff4c45b 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -914,7 +914,7 @@ static void smc911x_phy_configure(struct work_struct *work)
 		 PHY_INT_MASK_ANEG_COMP_ | PHY_INT_MASK_REMOTE_FAULT_ |
 		 PHY_INT_MASK_LINK_DOWN_);
 
-	/* If the user requested no auto neg, then go set his request */
+	/* If the user requested no auto neg, then go set their request */
 	if (lp->mii.force_media) {
 		smc911x_phy_fixed(dev);
 		goto smc911x_phy_configure_exit;
@@ -1909,7 +1909,7 @@ static int smc911x_probe(struct net_device *dev)
 	 * what the IRQ is.
 	 *
 	 * Specifying an IRQ is done with the assumption that the user knows
-	 * what (s)he is doing.  No checking is done!!!!
+	 * what they are doing.  No checking is done!!!!
 	 */
 	if (dev->irq < 1) {
 		int trials;
diff --git a/drivers/net/ethernet/smsc/smc9194.c b/drivers/net/ethernet/smsc/smc9194.c
index 67d9fde..4aefb8a 100644
--- a/drivers/net/ethernet/smsc/smc9194.c
+++ b/drivers/net/ethernet/smsc/smc9194.c
@@ -978,7 +978,7 @@ static int __init smc_probe(struct net_device *dev, int ioaddr)
 	 . the IRQs, and because this _should_ work in most configurations.
 	 .
 	 . Specifying an IRQ is done with the assumption that the user knows
-	 . what (s)he is doing.  No checking is done!!!!
+	 . what they are doing.  No checking is done!!!!
  	 .
 	*/
 	if ( dev->irq < 2 ) {
diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 0c9b5d9..cd23ee9 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -1071,7 +1071,7 @@ static void smc_phy_configure(struct work_struct *work)
 	SMC_SELECT_BANK(lp, 0);
 	SMC_SET_RPC(lp, lp->rpc_cur_mode);
 
-	/* If the user requested no auto neg, then go set his request */
+	/* If the user requested no auto neg, then go set their request */
 	if (lp->mii.force_media) {
 		smc_phy_fixed(dev);
 		goto smc_phy_configure_exit;
@@ -1946,7 +1946,7 @@ static int smc_probe(struct net_device *dev, void __iomem *ioaddr,
 	 * the IRQs, and because this _should_ work in most configurations.
 	 *
 	 * Specifying an IRQ is done with the assumption that the user knows
-	 * what (s)he is doing.  No checking is done!!!!
+	 * what they are doing.  No checking is done!!!!
 	 */
 	if (dev->irq < 1) {
 		int trials;
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index f7f2ef4..52f4366 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -731,7 +731,7 @@ static void gelic_descr_set_tx_cmdstat(struct gelic_descr *descr,
 					    GELIC_DESCR_TX_DMA_FRAME_TAIL);
 			else	/*
 				 * the stack should checksum non-tcp and non-udp
-				 * packets on his own: NETIF_F_IP_CSUM
+				 * packets on its own: NETIF_F_IP_CSUM
 				 */
 				descr->dmac_cmd_status =
 				cpu_to_be32(GELIC_DESCR_DMA_CMD_NO_CHKSUM |
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index bdd20b8..75b551d 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -1231,7 +1231,7 @@ do_start_xmit(struct sk_buff *skb, struct net_device *dev)
      * to provide some random data.
      * fixme: For Mohawk we can change this by sending
      * a larger packetlen than we actually have; the chip will
-     * pad this in his buffer with random bytes
+     * pad this in its buffer with random bytes
      */
     if (pktlen < ETH_ZLEN)
     {
diff --git a/drivers/net/irda/bfin_sir.c b/drivers/net/irda/bfin_sir.c
index 303c4bd..4d2c7db 100644
--- a/drivers/net/irda/bfin_sir.c
+++ b/drivers/net/irda/bfin_sir.c
@@ -109,7 +109,7 @@ static int bfin_sir_set_speed(struct bfin_sir_port *port, int speed)
 
 		/*
 		 * IRDA is not affected by anomaly 05000230, so there is no
-		 * need to tweak the divisor like he UART driver (which will
+		 * need to tweak the divisor like the UART driver (which will
 		 * slightly speed up the baud rate on us).
 		 */
 		quot = (port->clk + (8 * speed)) / (16 * speed);
diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
index 66bc03b..8d8ada6 100644
--- a/drivers/net/irda/nsc-ircc.c
+++ b/drivers/net/irda/nsc-ircc.c
@@ -830,7 +830,7 @@ static int nsc_ircc_init_39x(nsc_chip_t *chip, chipio_t *info)
 	int cfg_base = info->cfg_base;
 	int enabled;
 
-	/* User is sure about his config... accept it. */
+	/* User is sure about their config... accept it. */
 	IRDA_DEBUG(2, "%s(): nsc_ircc_init_39x (user settings): "
 		   "io=0x%04x, irq=%d, dma=%d\n", 
 		   __func__, info->fir_base, info->irq, info->dma);
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index ba2f5e7..4328e8c 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -305,7 +305,7 @@ static ssize_t show_remote_mac(struct netconsole_target *nt, char *buf)
  * This one is special -- targets created through the configfs interface
  * are not enabled (and the corresponding netpoll activated) by default.
  * The user is expected to set the desired parameters first (which
- * would enable him to dynamically add new netpoll targets for new
+ * would enable them to dynamically add new netpoll targets for new
  * network interfaces as and when they come up).
  */
 static ssize_t store_enabled(struct netconsole_target *nt,
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 72ff14b..621f7c6 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -2437,10 +2437,10 @@ ppp_ccp_peek(struct ppp *ppp, struct sk_buff *skb, int inbound)
 		 * A ConfReq indicates what the sender would like to receive
 		 */
 		if(inbound)
-			/* He is proposing what I should send */
+			/* It is proposing what I should send */
 			ppp->xstate &= ~SC_COMP_RUN;
 		else
-			/* I am proposing to what he should send */
+			/* I am proposing to what it should send */
 			ppp->rstate &= ~SC_DECOMP_RUN;
 
 		break;
@@ -2694,7 +2694,7 @@ ppp_create_interface(struct net *net, int unit, int *retp)
 		/*
 		 * if caller need a specified unit number
 		 * lets try to satisfy him, otherwise --
-		 * he should better ask us for new unit number
+		 * it should better ask us for new unit number
 		 *
 		 * NOTE: yes I know that returning EEXIST it's not
 		 * fair but at least pppd will ask us to allocate
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index cc70ecf..01d4777 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -48,7 +48,7 @@
  *					at module cleanup.
  *					With MODULE-loading ``insmod'', user
  *					can issue parameter:  slip_maxdev=1024
- *					(Or how much he/she wants.. Default
+ *					(Or how much they want.. Default
  *					is 256)
  *	Stanislav Voronyi	:	Slip line checking, with ideas taken
  *					from multislip BSDI driver which was
diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c
index 851dc7b..c9f6df4 100644
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -55,7 +55,7 @@
  *
  * IV. Notes
  * The current error (XDU, RFO) recovery code is untested.
- * So far, RDO takes his RX channel down and the right sequence to enable it
+ * So far, RDO takes its RX channel down and the right sequence to enable it
  * again is still a mystery. If RDO happens, plan a reboot. More details
  * in the code (NB: as this happens, TX still works).
  * Don't mess the cables during operation, especially on DTE ports. I don't
diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/net/wimax/i2400m/driver.c
index 9c34d2f..d841227 100644
--- a/drivers/net/wimax/i2400m/driver.c
+++ b/drivers/net/wimax/i2400m/driver.c
@@ -584,7 +584,7 @@ EXPORT_SYMBOL_GPL(i2400m_post_reset);
  * in case, leave the code to handle it.
  *
  * If there is a reset context, use it; this means someone is waiting
- * for us to tell him when the reset operation is complete and the
+ * for us to tell them when the reset operation is complete and the
  * device is ready to rock again.
  *
  * NOTE: if we are in the process of bringing up or down the
diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index c9c711d..5ead511 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -203,7 +203,7 @@ EXPORT_SYMBOL_GPL(i2400m_bm_cmd_prepare);
 /*
  * Database of known barkers.
  *
- * A barker is what the device sends indicating he is ready to be
+ * A barker is what the device sends indicating it is ready to be
  * bootloaded. Different versions of the device will send different
  * barkers. Depending on the barker, it might mean the device wants
  * some kind of firmware or the other.
diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index cd15a93..6d42eaf 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -655,7 +655,7 @@ int i2400mu_suspend(struct usb_interface *iface, pm_message_t pm_msg)
 		 * were the case, we'd be in status
 		 * I2400M_SS_CONNECTED_IDLE. But we are not.
 		 *
-		 * If we *tell* him to go power save now, it'll reset
+		 * If we *tell* it to go power save now, it'll reset
 		 * as a precautionary measure, so if this is an
 		 * autosuspend thing, say no and it'll come back
 		 * later, when the link is IDLE
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index edf4b57..5f31fb2 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2365,7 +2365,7 @@ static int airo_close(struct net_device *dev) {
 	if (ai->wifidev != dev) {
 #ifdef POWER_ON_DOWN
 		/* Shut power to the card. The idea is that the user can save
-		 * power when he doesn't need the card with "ifconfig down".
+		 * power when they don't need the card with "ifconfig down".
 		 * That's the method that is most friendly towards the network
 		 * stack (i.e. the network stack won't try to broadcast
 		 * anything on the interface and routes are gone. Jean II */
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index 0a3f916..e67a625 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -91,7 +91,7 @@ struct ath5k_dbg_info {
  * The debug level is used to control the amount and type of debugging output
  * we want to see. The debug level is given in calls to ATH5K_DBG to specify
  * where the message should appear, and the user can control the debugging
- * messages he wants to see, either by the module parameter 'debug' on module
+ * messages they want to see, either by the module parameter 'debug' on module
  * load, or dynamically by using debugfs 'ath5k/phyX/debug'. these levels can
  * be combined together by bitwise OR.
  */
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 38ec8d1..9d66ae7 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -720,7 +720,7 @@ static void orinoco_stat_gather(struct net_device *dev,
 	 * infrastructure (AP), will really slow down everything, because
 	 * the MAC address must be compared to each entry of the spy list.
 	 * If the user really asks for it (set some address in the
-	 * spy list), we do it, but he will pay the price.
+	 * spy list), we do it, but they will pay the price.
 	 * Note that to get here, you need both WIRELESS_SPY
 	 * compiled in AND some addresses in the list !!!
 	 */
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 9637615..718675a 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -1406,7 +1406,7 @@ static int get_superio_irq(struct parport *p)
  * Returns:
  *         0           :  No parallel port at this address
  *  PARPORT_MODE_PCSPP :  SPP port detected
- *                        (if the user specified an ioport himself,
+ *                        (if the user specified an ioport themselves,
  *                         this shall always be the case!)
  *
  */
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 6eca019..3f8ce0d 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -450,7 +450,7 @@ dcssblk_save_store(struct device *dev, struct device_attribute *attr, const char
 		}
 	} else if (inbuf[0] == '0') {
 		if (dev_info->save_pending) {
-			// device is busy & the user wants to undo his save
+			// device is busy & the user wants to undo their save
 			// request
 			dev_info->save_pending = 0;
 			pr_info("A pending save request for device %s "
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 33ec9c6..58bec2f 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -191,7 +191,7 @@
  *
  *   -- July 7, 18:49
  *     I needed it for testing, but it didn't make any difference, so back
- *     off she goes.
+ *     off it goes.
  *
  *   -- July 16, 23:04
  *     I turned it back on to try and compensate for the 2.1.x PCI code
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 854dad7..8b13576 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -76,7 +76,7 @@ static void bnx2i_get_write_cmd_bd_idx(struct bnx2i_cmd *cmd, u32 buf_off,
  *
  * identifies & marks various bd info for scsi command's immediate data,
  * unsolicited data and first solicited data seq which includes BD start
- * index & BD buf off. his function takes into account iscsi parameter such
+ * index & BD buf off. This function takes into account iscsi parameter such
  * as immediate data and unsolicited data is support on this connection.
  */
 static void bnx2i_setup_write_cmd_bd_info(struct iscsi_task *task)
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index add6d15..10d14dc 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -462,7 +462,7 @@ iscsi_sw_tcp_send_data_prep(struct iscsi_conn *conn, struct scatterlist *sg,
 			 "digest enabled" : "digest disabled");
 
 	/* Make sure the datalen matches what the caller
-	   said he would send. */
+	   said it would send. */
 	hdr_spec_len = ntoh24(tcp_sw_conn->out.hdr->dlength);
 	WARN_ON(iscsi_padded(len) != iscsi_padded(hdr_spec_len));
 
@@ -487,7 +487,7 @@ iscsi_sw_tcp_send_linear_data_prep(struct iscsi_conn *conn, void *data,
 			 "digest enabled" : "digest disabled");
 
 	/* Make sure the datalen matches what the caller
-	   said he would send. */
+	   said it would send. */
 	hdr_spec_len = ntoh24(tcp_sw_conn->out.hdr->dlength);
 	WARN_ON(iscsi_padded(len) != iscsi_padded(hdr_spec_len));
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e399561..ec7d94e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2490,7 +2490,7 @@ iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 
 	q->max = max;
 
-	/* If the user passed an items pointer, he wants a copy of
+	/* If the user passed an items pointer, they want a copy of
 	 * the array. */
 	if (items)
 		num_arrays++;
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index e8a04ae..ddb315d 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1190,8 +1190,8 @@ static void handle_msgin(struct mesh_state *ms)
 			if (tp->sdtr_state != sdtr_sent) {
 				/* reply with an SDTR */
 				add_sdtr_msg(ms);
-				/* limit period to at least his value,
-				   offset to no more than his */
+				/* limit period to at least its value,
+				   offset to no more than its */
 				if (ms->msgout[3] < ms->msgin[3])
 					ms->msgout[3] = ms->msgin[3];
 				if (ms->msgout[4] > ms->msgin[4])
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index f16ece9..ecd622a 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1831,7 +1831,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
  *
  * When FW has completed a ssp request for example a IO request, after it has
  * filled the SG data with the data, it will trigger this event represent
- * that he has finished the job,please check the coresponding buffer.
+ * that it has finished the job,please check the coresponding buffer.
  * So we will tell the caller who maybe waiting the result to tell upper layer
  * that the task has been finished.
  */
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8987b17..a4a6a8a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1486,7 +1486,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
  *
  * When FW has completed a ssp request for example a IO request, after it has
  * filled the SG data with the data, it will trigger this event represent
- * that he has finished the job,please check the coresponding buffer.
+ * that it has finished the job,please check the coresponding buffer.
  * So we will tell the caller who maybe waiting the result to tell upper layer
  * that the task has been finished.
  */
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index d92fe40..ff7058d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -936,7 +936,7 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 		sym_scsi_bus_mode(np->scsi_mode),
 		(np->rv_scntl0 & 0xa)	? "parity checking" : "NO parity");
 	/*
-	 *  Tell him more on demand.
+	 *  Tell them more on demand.
 	 */
 	if (sym_verbose) {
 		printf("%s: %s IRQ line driver%s\n",
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index f9a6e4b..1eafa55 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -108,7 +108,7 @@
  *  to enter BIOS ROM address in initialisation data (see struct Config).
  *  We cannot detect IRQ, DMA and I/O base address for now, so we have to
  *  enter them as arguments while wd_7000 is detected. If someone has IRQ,
- *  DMA or I/O base address set to some other value, he can enter them in
+ *  DMA or I/O base address set to some other value, they can enter them in
  *  configuration without any problem. Also I wrote a function wd7000_setup,
  *  so now you can enter WD-7000 definition as kernel arguments,
  *  as in lilo.conf:
diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 9f7e30f..89f8ac0 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -546,7 +546,7 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[]= {//	# DPLL Clock Setti
 								{0x0F00a044,0x1fffffff},
 								{0x0F00a040,0x1f000000},
 								{0x0f003050,0x00000021},//this is flash/eeprom clock divisor which set the flash clock to 20 MHz
-								{0x0F00a084,0x1Cffffff},//Now dump from her in internal memory
+								{0x0F00a084,0x1Cffffff},//Now dump from it in internal memory
 								{0x0F00a080,0x1C000000},
 								{0x0F00A000,0x00000016},
 								{0x0f007000,0x00010001},
diff --git a/drivers/staging/dgrp/dgrp_net_ops.c b/drivers/staging/dgrp/dgrp_net_ops.c
index 33ac7fb..e79339a 100644
--- a/drivers/staging/dgrp/dgrp_net_ops.c
+++ b/drivers/staging/dgrp/dgrp_net_ops.c
@@ -2454,7 +2454,7 @@ data:
 				/*
 				 *  If there is a read thread waiting
 				 *  in select, and we are in fastcook
-				 *  mode, wake him up.
+				 *  mode, wake it up.
 				 */
 
 				if (waitqueue_active(&ch->ch_tun.un_tty->read_wait) &&
diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
index 0d52de3..f03795c 100644
--- a/drivers/staging/dgrp/dgrp_tty.c
+++ b/drivers/staging/dgrp/dgrp_tty.c
@@ -1720,7 +1720,7 @@ static int dgrp_tty_write(struct tty_struct *tty,
 
 	/*
 	 * If the printer unit is waiting for completion
-	 * of terminal output, get him going again.
+	 * of terminal output, get it going again.
 	 */
 
 	if ((ch->ch_pun.un_flag & UN_PWAIT) != 0)
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 86397f9..45e29ea 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -724,7 +724,7 @@ kiblnd_create_conn(kib_peer_t *peer, struct rdma_cm_id *cmid,
 	 * If the new conn is created successfully it takes over the caller's
 	 * ref on 'peer'.  It also "owns" 'cmid' and destroys it when it itself
 	 * is destroyed.  On failure, the caller's ref on 'peer' remains and
-	 * she must dispose of 'cmid'.  (Actually I'd block forever if I tried
+	 * it must dispose of 'cmid'.  (Actually I'd block forever if I tried
 	 * to destroy 'cmid' here since I'm called from the CM which still has
 	 * its ref on 'cmid'). */
 	rwlock_t		*glock = &kiblnd_data.kib_global_lock;
@@ -1668,7 +1668,7 @@ kiblnd_fmr_pool_map(kib_fmr_poolset_t *fps, __u64 *pages, int npages,
 	if (fps->fps_increasing) {
 		spin_unlock(&fps->fps_lock);
 		CDEBUG(D_NET, "Another thread is allocating new "
-		       "FMR pool, waiting for her to complete\n");
+		       "FMR pool, waiting for it to complete\n");
 		schedule();
 		goto again;
 
@@ -1870,7 +1870,7 @@ kiblnd_pool_alloc_node(kib_poolset_t *ps)
 		/* another thread is allocating a new pool */
 		spin_unlock(&ps->ps_lock);
 		CDEBUG(D_NET, "Another thread is allocating new "
-		       "%s pool, waiting for her to complete\n",
+		       "%s pool, waiting for it to complete\n",
 		       ps->ps_name);
 		schedule();
 		goto again;
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 2ddc3aa..288ad75 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -1079,7 +1079,7 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 		goto failed_1;
 
 	/* Find out/confirm peer's NID and connection type and get the
-	 * vector of interfaces she's willing to let me connect to.
+	 * vector of interfaces it's willing to let me connect to.
 	 * Passive connections use the listener timeout since the peer sends
 	 * eagerly */
 
@@ -1777,7 +1777,7 @@ ksocknal_close_matching_conns (lnet_process_id_t id, __u32 ipaddr)
 void
 ksocknal_notify (lnet_ni_t *ni, lnet_nid_t gw_nid, int alive)
 {
-	/* The router is telling me she's been notified of a change in
+	/* The router is telling me it's been notified of a change in
 	 * gateway state.... */
 	lnet_process_id_t  id = {0};
 
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index 68a4f52..068d295 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -436,7 +436,7 @@ ksocknal_check_zc_req(ksock_tx_t *tx)
 	/* Set tx_msg.ksm_zc_cookies[0] to a unique non-zero cookie and add tx
 	 * to ksnp_zc_req_list if some fragment of this message should be sent
 	 * zero-copy.  Our peer will send an ACK containing this cookie when
-	 * she has received this message to tell us we can signal completion.
+	 * it has received this message to tell us we can signal completion.
 	 * tx_msg.ksm_zc_cookies[0] remains non-zero while tx is on
 	 * ksnp_zc_req_list. */
 	LASSERT (tx->tx_msg.ksm_type != KSOCK_MSG_NOOP);
diff --git a/drivers/staging/lustre/lnet/lnet/acceptor.c b/drivers/staging/lustre/lnet/lnet/acceptor.c
index 92c60a7..39579d0 100644
--- a/drivers/staging/lustre/lnet/lnet/acceptor.c
+++ b/drivers/staging/lustre/lnet/lnet/acceptor.c
@@ -229,7 +229,7 @@ lnet_accept(socket_t *sock, __u32 magic)
 			/* future version compatibility!
 			 * When LNET unifies protocols over all LNDs, the first
 			 * thing sent will be a version query.  I send back
-			 * LNET_PROTO_ACCEPTOR_MAGIC to tell her I'm "old" */
+			 * LNET_PROTO_ACCEPTOR_MAGIC to tell it I'm "old" */
 
 			memset(&cr, 0, sizeof(cr));
 			cr.acr_magic = LNET_PROTO_ACCEPTOR_MAGIC;
@@ -272,7 +272,7 @@ lnet_accept(socket_t *sock, __u32 magic)
 	if (cr.acr_version != LNET_PROTO_ACCEPTOR_VERSION) {
 		/* future version compatibility!
 		 * An acceptor-specific protocol rev will first send a version
-		 * query.  I send back my current version to tell her I'm
+		 * query.  I send back my current version to tell it I'm
 		 * "old". */
 		int peer_version = cr.acr_version;
 
diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index 160a429..89789e7 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -473,7 +473,7 @@ lnet_res_container_cleanup(struct lnet_res_container *rec)
 	if (count > 0) {
 		/* Found alive MD/ME/EQ, user really should unlink/free
 		 * all of them before finalize LNet, but if someone didn't,
-		 * we have to recycle garbage for him */
+		 * we have to recycle garbage for them */
 		CERROR("%d active elements on exit of %s container\n",
 		       count, lnet_res_type2str(rec->rec_type));
 	}
diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index b6f8ad3..ac1e9a3 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -1454,7 +1454,7 @@ lnet_parse_get(lnet_ni_t *ni, lnet_msg_t *msg, int rdma_get)
 	msg->msg_hdr.msg.reply.dst_wmd = reply_wmd;
 
 	if (rdma_get) {
-		/* The LND completes the REPLY from her recv procedure */
+		/* The LND completes the REPLY from its recv procedure */
 		lnet_ni_recv(ni, msg->msg_private, msg, 0,
 			     msg->msg_offset, msg->msg_len, msg->msg_len);
 		return 0;
@@ -2211,7 +2211,7 @@ lnet_set_reply_msg_len(lnet_ni_t *ni, lnet_msg_t *reply, unsigned int len)
 	LASSERT(reply->msg_type == LNET_MSG_GET);
 	LASSERT(reply->msg_ev.type == LNET_EVENT_REPLY);
 
-	/* NB I trusted my peer to RDMA.  If she tells me she's written beyond
+	/* NB I trusted my peer to RDMA.  If it tells me it's written beyond
 	 * the end of my buffer, I might as well be dead. */
 	LASSERT(len <= reply->msg_ev.mlength);
 
diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index a326ce0..5acdeb2 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -1524,7 +1524,7 @@ lnet_notify(lnet_ni_t *ni, lnet_nid_t nid, int alive, cfs_time_t when)
 		return -EINVAL;
 	}
 
-	if (ni != NULL && !alive &&	     /* LND telling me she's down */
+	if (ni != NULL && !alive &&	     /* LND telling me it's down */
 	    !auto_down) {		       /* auto-down disabled */
 		CDEBUG(D_NET, "Auto-down disabled\n");
 		return 0;
@@ -1546,7 +1546,7 @@ lnet_notify(lnet_ni_t *ni, lnet_nid_t nid, int alive, cfs_time_t when)
 	}
 
 	/* We can't fully trust LND on reporting exact peer last_alive
-	 * if he notifies us about dead peer. For example ksocklnd can
+	 * if it notifies us about dead peer. For example ksocklnd can
 	 * call us with when == _time_when_the_node_was_booted_ if
 	 * no connections were successfully established */
 	if (ni != NULL && !alive && when < lp->lp_last_alive)
diff --git a/drivers/staging/lustre/lnet/selftest/console.c b/drivers/staging/lustre/lnet/selftest/console.c
index f1152e4..df58852 100644
--- a/drivers/staging/lustre/lnet/selftest/console.c
+++ b/drivers/staging/lustre/lnet/selftest/console.c
@@ -106,7 +106,7 @@ lstcon_node_find(lnet_process_id_t id, lstcon_node_t **ndpp, int create)
 	memset(&ndl->ndl_node->nd_ping, 0, sizeof(lstcon_rpc_t));
 
 	/* queued in global hash & list, no refcount is taken by
-	 * global hash & list, if caller release his refcount,
+	 * global hash & list, if caller release its refcount,
 	 * node will be released */
 	list_add_tail(&ndl->ndl_hlink, &console_session.ses_ndl_hash[idx]);
 	list_add_tail(&ndl->ndl_link, &console_session.ses_ndl_list);
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
index e6069d7..fcbc73c 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
@@ -261,7 +261,7 @@ libcfs_sock_write (struct socket *sock, void *buffer, int nob, int timeout)
 	struct timeval tv;
 
 	LASSERT (nob > 0);
-	/* Caller may pass a zero timeout if she thinks the socket buffer is
+	/* Caller may pass a zero timeout if it thinks the socket buffer is
 	 * empty enough to take the whole message immediately */
 
 	for (;;) {
diff --git a/drivers/staging/lustre/lustre/llite/llite_nfs.c b/drivers/staging/lustre/lustre/llite/llite_nfs.c
index 1767c74..f84f6cf 100644
--- a/drivers/staging/lustre/lustre/llite/llite_nfs.c
+++ b/drivers/staging/lustre/lustre/llite/llite_nfs.c
@@ -178,7 +178,7 @@ ll_iget_for_nfs(struct super_block *sb, struct lu_fid *fid, struct lu_fid *paren
 #define LUSTRE_NFS_FID	  0x97
 
 /**
- * \a connectable - is nfsd will connect himself or this should be done
+ * \a connectable - is nfsd will connect itself or this should be done
  *		  at lustre
  *
  * The return value is file handle type:
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index 68a4d6a..5104691 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -768,7 +768,7 @@ int lustre_common_put_super(struct super_block *sb)
 			return rc;
 		}
 		/* BUSY just means that there's some other obd that
-		   needs the mgc.  Let him clean it up. */
+		   needs the mgc.  Let it clean it up. */
 		CDEBUG(D_MOUNT, "MGC still in use\n");
 	}
 	/* Drop a ref to the mounted disk */
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index c2ab0c8..3b3b485 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -149,7 +149,7 @@ struct ptlrpc_bulk_desc *ptlrpc_prep_bulk_imp(struct ptlrpc_request *req,
 	desc->bd_cbid.cbid_fn  = client_bulk_callback;
 	desc->bd_cbid.cbid_arg = desc;
 
-	/* This makes req own desc, and free it when she frees herself */
+	/* This makes req own desc, and free it when it frees itself */
 	req->rq_bulk = desc;
 
 	return desc;
@@ -1744,8 +1744,8 @@ int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 		if (req->rq_bulk->bd_failure) {
 			/* The RPC reply arrived OK, but the bulk screwed
 			 * up!  Dead weird since the server told us the RPC
-			 * was good after getting the REPLY for her GET or
-			 * the ACK for her PUT. */
+			 * was good after getting the REPLY for its GET or
+			 * the ACK for its PUT. */
 			DEBUG_REQ(D_ERROR, req, "bulk transfer failed");
 			req->rq_status = -EIO;
 		}
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c
index c106a9e..92110c5 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c
@@ -177,12 +177,12 @@ int krb5_init_keys(struct krb5_ctx *kctx)
 
 	ke = &enctypes[kctx->kc_enctype];
 
-	/* tfm arc4 is stateful, user should alloc-use-free by his own */
+	/* tfm arc4 is stateful, user should alloc-use-free by their own */
 	if (kctx->kc_enctype != ENCTYPE_ARCFOUR_HMAC &&
 	    keyblock_init(&kctx->kc_keye, ke->ke_enc_name, ke->ke_enc_mode))
 		return -1;
 
-	/* tfm hmac is stateful, user should alloc-use-free by his own */
+	/* tfm hmac is stateful, user should alloc-use-free by their own */
 	if (ke->ke_hash_hmac == 0 &&
 	    keyblock_init(&kctx->kc_keyi, ke->ke_enc_name, ke->ke_enc_mode))
 		return -1;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
index a0e0097..3dc212c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -216,7 +216,7 @@ int ptlrpc_register_bulk(struct ptlrpc_request *req)
 		 desc->bd_last_xid, req->rq_xid);
 
 	spin_lock(&desc->bd_lock);
-	/* Holler if peer manages to touch buffers before he knows the xid */
+	/* Holler if peer manages to touch buffers before it knows the xid */
 	if (desc->bd_md_count != total_md)
 		CWARN("%s: Peer %s touched %d buffers while I registered\n",
 		      desc->bd_export->exp_obd->obd_name, libcfs_id2str(peer),
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index 21de868..e11af4e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -2348,7 +2348,7 @@ static int ptlrpc_main(void *arg)
 	svcpt->scp_nthrs_running++;
 	spin_unlock(&svcpt->scp_lock);
 
-	/* wake up our creator in case he's still waiting. */
+	/* wake up our creator in case it's still waiting. */
 	wake_up(&thread->t_ctl_waitq);
 
 	/*
diff --git a/drivers/staging/speakup/spkguide.txt b/drivers/staging/speakup/spkguide.txt
index f321057..faa6f6f 100644
--- a/drivers/staging/speakup/spkguide.txt
+++ b/drivers/staging/speakup/spkguide.txt
@@ -1131,7 +1131,7 @@ The directory that speakupconf uses to store your settings depends on
 whether it is run from the root account.  If you execute speakupconf as
 root, it uses the directory /etc/speakup.  Otherwise, it uses the directory
 ~/.speakup, where ~ is your home directory.
-Anyone who needs to use Speakup from your console can load his own custom
+Anyone who needs to use Speakup from your console can load their own custom
 settings with this script.
 
 speakupconf takes one required argument: load or save.
diff --git a/drivers/tty/n_tracesink.c b/drivers/tty/n_tracesink.c
index ddce58b..1c38d34 100644
--- a/drivers/tty/n_tracesink.c
+++ b/drivers/tty/n_tracesink.c
@@ -46,10 +46,10 @@
 #define DRIVERNAME	"n_tracesink"
 
 /*
- * there is a quirk with this ldisc is he can write data
- * to a tty from anyone calling his kernel API, which
+ * there is a quirk with this ldisc is it can write data
+ * to a tty from anyone calling this kernel API, which
  * meets customer requirements in the drivers/misc/pti.c
- * project.  So he needs to know when he can and cannot write when
+ * project.  So it needs to know when it can and cannot write when
  * the API is called. In theory, the API can be called
  * after an init() but before a successful open() which
  * would crash the system if tty is not checked.
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a7c04e2..9952066 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3189,7 +3189,7 @@ static int finish_port_resume(struct usb_device *udev)
  * reset as before, it cannot provide a 100% guarantee.  Furthermore it's
  * quite possible for a device to remain unaltered but its media to be
  * changed.  If the user replaces a flash memory card while the system is
- * asleep, he will have only himself to blame when the filesystem on the
+ * asleep, they will have only themselves to blame when the filesystem on the
  * new card is corrupted and the system crashes.
  *
  * Returns 0 on success, else negative errno.
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 774e8b8..55c5aca 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -186,7 +186,7 @@ struct ffs_data {
 
 	/*
 	 * Device name, write once when file system is mounted.
-	 * Intended for user to read if she wants.
+	 * Intended for user to read if they want.
 	 */
 	const char			*dev_name;
 	/* Private data for our user (ie. gadget).  Managed by user. */
diff --git a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
index 6e320ce..36bd596 100644
--- a/drivers/usb/serial/aircable.c
+++ b/drivers/usb/serial/aircable.c
@@ -29,9 +29,9 @@
  * is any other control code, I will simply check for the first
  * one.
  *
- * The driver registers himself with the USB-serial core and the USB Core. I had
+ * The driver registers itself with the USB-serial core and the USB Core. I had
  * to implement a probe function against USB-serial, because other way, the
- * driver was attaching himself to both interfaces. I have tryed with different
+ * driver was attaching itself to both interfaces. I have tryed with different
  * configurations of usb_serial_driver with out exit, only the probe function
  * could handle this correctly.
  *
diff --git a/drivers/usb/wusbcore/devconnect.c b/drivers/usb/wusbcore/devconnect.c
index e538b72..84956e1 100644
--- a/drivers/usb/wusbcore/devconnect.c
+++ b/drivers/usb/wusbcore/devconnect.c
@@ -657,8 +657,8 @@ EXPORT_SYMBOL_GPL(wusbhc_handle_dn);
  * @wusbhc
  * @port     Fake port where the device is (wusbhc index, not USB port number).
  *
- * In Wireless USB, a disconnect is basically telling the device he is
- * being disconnected and forgetting about him.
+ * In Wireless USB, a disconnect is basically telling the device it is
+ * being disconnected and forgetting about it.
  *
  * We send the device a Device Disconnect IE (WUSB1.0[7.5.11]) for 100
  * ms and then keep going.
diff --git a/drivers/uwb/driver.c b/drivers/uwb/driver.c
index 3e5454a..89d6e1c 100644
--- a/drivers/uwb/driver.c
+++ b/drivers/uwb/driver.c
@@ -65,7 +65,7 @@
  * device who was represented by that beacon to be gone.
  *
  * ECMA-368[17.2.3, last para] establishes that a device must not
- * consider a device to be its neighbour if he doesn't receive a beacon
+ * consider a device to be its neighbour if it doesn't receive a beacon
  * for more than mMaxLostBeacons. mMaxLostBeacons is defined in
  * ECMA-368[17.16] as 3; because we can get only one beacon per
  * superframe, that'd be 3 * 65ms = 195 ~ 200 ms. Let's give it time
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index ffd0632..d87d96b 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -19,8 +19,8 @@
  * user driver, but cannot trust it with all of the config fields.
  * Tables determine which fields can be read and written, as well as
  * which fields are 'virtualized' - special actions and translations to
- * make it appear to the user that he has control, when in fact things
- * must be negotiated with the underlying OS.
+ * make it appear to the user that they have control, when in fact
+ * things must be negotiated with the underlying OS.
  */
 
 #include <linux/fs.h>
diff --git a/drivers/video/aty/mach64_ct.c b/drivers/video/aty/mach64_ct.c
index 51f29d6..66c0283 100644
--- a/drivers/video/aty/mach64_ct.c
+++ b/drivers/video/aty/mach64_ct.c
@@ -507,7 +507,7 @@ static int aty_init_pll_ct(const struct fb_info *info, union aty_pll *pll)
 	}
 #endif
 	/* Exit if the user does not want us to tamper with the clock
-	rates of her chip. */
+	rates of their chip. */
 	if (par->mclk_per == 0) {
 		u8 mclk_fb_div, pll_ext_cntl;
 		pll->ct.pll_ref_div = aty_ld_pll_ct(PLL_REF_DIV, par);
diff --git a/drivers/video/fm2fb.c b/drivers/video/fm2fb.c
index e69d47a..0739e1d 100644
--- a/drivers/video/fm2fb.c
+++ b/drivers/video/fm2fb.c
@@ -109,7 +109,7 @@
  *	frame buffer. This means 1.7 MByte read and 1.7 MByte write
  *	over the slow 16 bit wide Zorro2 bus! A scroll of one
  *	line needs 1 second so do not expect to much from this
- *	driver - he is at the limit!
+ *	driver - it is at the limit!
  *
  */
 
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index 9e1d19d..4d68cc9 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -538,7 +538,7 @@ static int lxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* Clear the screen of garbage, unless noclear was specified,
-	 * in which case we assume the user knows what he is doing */
+	 * in which case we assume the user knows what they are doing */
 
 	if (!noclear)
 		memset_io(info->screen_base, 0, info->fix.smem_len);
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index a9ed867..1645548 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -258,7 +258,7 @@ static int xen_pcibk_export_device(struct xen_pcibk_device *pdev,
 	 * have to calculate resource usage anyway) but we probably want to
 	 * put something in here to ensure that if a bridge gets given to a
 	 * driver domain, that all devices under that bridge are not given
-	 * to other driver domains (as he who controls the bridge can disable
+	 * to other driver domains (as whoever controls the bridge can disable
 	 * it and stop the other devices from working).
 	 */
 out:
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2bd8548..8ef9b30 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -206,7 +206,7 @@ void ext3_evict_inode (struct inode *inode)
 	 * journal_invalidatepage() (via truncate_inode_pages()) to discard
 	 * these buffers can cause data loss. Also even if we did not discard
 	 * these buffers, we would have no way to find them after the inode
-	 * is reaped and thus user could see stale data if he tries to read
+	 * is reaped and thus user could see stale data if they try to read
 	 * them before the transaction is checkpointed. So be careful and
 	 * force everything to disk here... We use ei->i_datasync_tid to
 	 * store the newest transaction containing inode's data.
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0757634..a1ca9f3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -196,7 +196,7 @@ void ext4_evict_inode(struct inode *inode)
 		 * (via truncate_inode_pages()) to discard these buffers can
 		 * cause data loss. Also even if we did not discard these
 		 * buffers, we would have no way to find them after the inode
-		 * is reaped and thus user could see stale data if he tries to
+		 * is reaped and thus user could see stale data if they try to
 		 * read them before the transaction is checkpointed. So be
 		 * careful and force everything to disk here... We use
 		 * ei->i_datasync_tid to store the newest transaction
diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index a6597d6..3f6031e 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -976,7 +976,7 @@ int jffs2_flash_read(struct jffs2_sb_info *c, loff_t ofs, size_t len, size_t *re
 		 * check the node.  If data are corrupted node check will sort
 		 * it out.  We keep this block, it will fail on write or erase
 		 * and the we mark it bad. Or should we do that now? But we
-		 * should give him a chance.  Maybe we had a system crash or
+		 * should give it a chance.  Maybe we had a system crash or
 		 * power loss before the ecc write or a erase was completed.
 		 * So we return success. :)
 		 */
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 360d27c..711f365 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -899,7 +899,7 @@ static void lmPostGC(struct lbuf * bp)
 	 * They are waiting for new group commit (above at (SLEEP 1))
 	 * or lazy transactions are on a full (queued) log page,
 	 * select the latest ready transaction as new group leader and
-	 * wake her up to lead her group.
+	 * wake it up to lead its group.
 	 */
 	if ((!list_empty(&log->cqueue)) &&
 	    ((log->gcrtc > 0) || (tblk->bp->l_wqnext != NULL) ||
@@ -912,7 +912,7 @@ static void lmPostGC(struct lbuf * bp)
 	/* no transaction are ready yet (transactions are only just
 	 * queued (GC_QUEUE) and not entered for group commit yet).
 	 * the first transaction entering group commit
-	 * will elect herself as new group leader.
+	 * will elect itself as new group leader.
 	 */
 	else
 		log->cflag &= ~logGC_PAGEOUT;
diff --git a/fs/namespace.c b/fs/namespace.c
index ac2ce8a..959daf5 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1319,7 +1319,7 @@ static int do_umount(struct mount *mnt, int flags)
 }
 
 /* 
- * Is the caller allowed to modify his namespace?
+ * Is the caller allowed to modify its namespace?
  */
 static inline bool may_mount(void)
 {
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index e2fcacf..20fddda 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -343,7 +343,7 @@ static int nfs_want_read_modify_write(struct file *file, struct page *page,
  * data from user space.
  *
  * If the writer ends up delaying the write, the writer needs to
- * increment the page use counts until he is done with the page.
+ * increment the page use counts until it is done with the page.
  */
 static int nfs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 8b3382a..70f7e539 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -646,7 +646,7 @@ static void dlm_leave_domain(struct dlm_ctxt *dlm)
 		 * -nodes cannot be added now as the
 		 *   query_join_handlers knows to respond with OK_NO_MAP
 		 * -we catch the right network errors if a node is
-		 *   removed from the map while we're sending him the
+		 *   removed from the map while we're sending it the
 		 *   exit message. */
 		spin_unlock(&dlm->spinlock);
 
@@ -908,7 +908,7 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 		} else {
 			/* Alright we're fully a part of this domain
 			 * so we keep some state as to who's joining
-			 * and indicate to him that needs to be fixed
+			 * and indicate to them that needs to be fixed
 			 * up. */
 
 			/* Make sure we speak compatible locking protocols.  */
@@ -958,7 +958,7 @@ static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
 		spin_lock(&dlm->spinlock);
 
 		/* Alright, this node has officially joined our
-		 * domain. Set him in the map and clean up our
+		 * domain. Set it in the map and clean up our
 		 * leftover join state. */
 		BUG_ON(dlm->joining_node != assert->node_idx);
 		set_bit(assert->node_idx, dlm->domain_map);
@@ -1364,7 +1364,7 @@ static int dlm_cancel_join_handler(struct o2net_msg *msg, u32 len, void *data,
 	if (dlm) {
 		spin_lock(&dlm->spinlock);
 
-		/* Yikes, this guy wants to cancel his join. No
+		/* Yikes, this one wants to cancel its join. No
 		 * problem, we simply cleanup our join state. */
 		BUG_ON(dlm->joining_node != cancel->node_idx);
 		__dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
@@ -1471,7 +1471,7 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
 
 	/* -ENOPROTOOPT from the net code means the other side isn't
 	    listening for our message type -- that's fine, it means
-	    his dlm isn't up, so we can consider him a 'yes' but not
+	    its dlm isn't up, so we can consider it a 'yes' but not
 	    joined into the domain.  */
 	if (status == -ENOPROTOOPT) {
 		status = 0;
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index af3f7aa..e46cdc1 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -3223,7 +3223,7 @@ top:
 			 * master dies. All UNKNOWN lockres' are sent to
 			 * whichever node becomes the recovery master. The new
 			 * master is responsible for determining if there is
-			 * still a master for this lockres, or if he needs to
+			 * still a master for this lockres, or if it needs to
 			 * take over mastery. Either way, this node should
 			 * expect another message to resolve this. */
 
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 7035af0..a018bd7 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -243,7 +243,7 @@ void dlm_complete_recovery_thread(struct dlm_ctxt *dlm)
  *    message to everyone
  * 8) upon receiving this message, the secondary queue node unlocks
  *    and responds to the ALLDONE
- * 9) once the new master gets responses from everyone, he unlocks
+ * 9) once the new master gets responses from everyone, it unlocks
  *    everything and recovery for this dead node is done
  *10) go back to 2) while there are still dead nodes
  *
@@ -444,8 +444,8 @@ static void dlm_end_recovery(struct dlm_ctxt *dlm)
 static void dlm_print_recovery_master(struct dlm_ctxt *dlm)
 {
 	printk(KERN_NOTICE "o2dlm: Node %u (%s) is the Recovery Master for the "
-	       "dead node %u in domain %s\n", dlm->reco.new_master,
-	       (dlm->node_num == dlm->reco.new_master ? "me" : "he"),
+	       "dead node %u in %s domain\n", dlm->reco.new_master,
+	       (dlm->node_num == dlm->reco.new_master ? "local" : "remote"),
 	       dlm->reco.dead_node, dlm->name);
 }
 
@@ -1737,7 +1737,7 @@ dlm_list_num_to_pointer(struct dlm_lock_resource *res, int list_num)
 * well.  For the lock case, there is no way a lock can be on the master
 * queue and not be on the secondary queue since the lock is always added
 * locally first.  This means that the new target node will never be sent
-* a lock that he doesn't already have on the list.
+* a lock that it doesn't already have on the list.
 * In total, this means that the local lock is correct and should not be
 * updated to match the one sent by the master.  Any messages sent back
 * from the master before the MIGRATING flag will bring the lock properly
@@ -2172,7 +2172,7 @@ static void dlm_revalidate_lvb(struct dlm_ctxt *dlm,
 
 	if (res->owner == dlm->node_num)
 		/* if this node owned the lockres, and if the dead node
-		 * had an EX when he died, blank out the lvb */
+		 * had an EX when it died, blank out the lvb */
 		search_node = dead_node;
 	else {
 		/* if this is a secondary lockres, and we had no EX or PR
@@ -2209,7 +2209,7 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
 
 	/* this node is the lockres master:
 	 * 1) remove any stale locks for the dead node
-	 * 2) if the dead node had an EX when he died, blank out the lvb
+	 * 2) if the dead node had an EX when it died, blank out the lvb
 	 */
 	assert_spin_locked(&dlm->spinlock);
 	assert_spin_locked(&res->spinlock);
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 9db869d..e5c7291 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -248,7 +248,7 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
 			/* Since resources are added to the purge list
 			 * in tail order, we can stop at the first
 			 * unpurgable resource -- anyone added after
-			 * him will have a greater last_used value */
+			 * it will have a greater last_used value */
 			spin_unlock(&lockres->spinlock);
 			break;
 		}
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 621fc73..1704b02 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -95,7 +95,7 @@ struct ocfs2_inode_info
  * was locally orphaned, then we're sure of the state and don't need
  * to twiddle i_nlink later - it's either zero or not depending on
  * whether our unlink succeeded. Otherwise we got this from a node
- * whose intention was to orphan the inode, however he may have
+ * whose intention was to orphan the inode, however it may have
  * crashed, failed etc, so we let ocfs2_drop_inode zero the value and
  * rely on ocfs2_delete_inode to sort things out under the proper
  * cluster locks.
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 44fc3e5..b3f801f 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1719,7 +1719,7 @@ done:
 	return status;
 }
 
-/* Test node liveness by trylocking his journal. If we get the lock,
+/* Test node liveness by trylocking its journal. If we get the lock,
  * we drop it here. Return 0 if we got the lock, -EAGAIN if node is
  * still alive (we couldn't get the lock) and < 0 on error. */
 static int ocfs2_trylock_journal(struct ocfs2_super *osb,
@@ -1809,8 +1809,8 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 		spin_unlock(&osb->osb_lock);
 
 		/* Ok, we have a slot occupied by another node which
-		 * is not in the recovery map. We trylock his journal
-		 * file here to test if he's alive. */
+		 * is not in the recovery map. We trylock its journal
+		 * file here to test if it's alive. */
 		status = ocfs2_trylock_journal(osb, i);
 		if (!status) {
 			/* Since we're called from mount, we know that
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 2e4344b..25e6ec2 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -615,7 +615,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 		}
 		status = ocfs2_inode_lock_full(lqinode, NULL, 1,
 						       OCFS2_META_LOCK_NOQUEUE);
-		/* Someone else is holding the lock? Then he must be
+		/* Something else is holding the lock? Then it must be
 		 * doing the recovery. Just skip the file... */
 		if (status == -EAGAIN) {
 			printk(KERN_NOTICE "ocfs2: Skipping quota recovery on "
@@ -1304,7 +1304,7 @@ int ocfs2_local_release_dquot(handle_t *handle, struct dquot *dquot)
 
 out:
 	/* Clear the read bit so that next time someone uses this
-	 * dquot he reads fresh info from disk and allocates local
+	 * dquot they read fresh info from disk and allocates local
 	 * dquot structure */
 	clear_bit(DQ_READ_B, &dquot->dq_flags);
 	return status;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 2c91452..f3ac7539 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1807,7 +1807,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	 * Keep track of previous block descriptor read. When
 	 * we find a target, if we have read more than X
 	 * number of descriptors, and the target is reasonably
-	 * empty, relink him to top of his chain.
+	 * empty, relink it to top of its chain.
 	 *
 	 * We've read 0 extra blocks and only send one more to
 	 * the transaction, yet the next guy to search has a
diff --git a/fs/pipe.c b/fs/pipe.c
index 0e0752e..d90a4af 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -280,7 +280,7 @@ EXPORT_SYMBOL(generic_pipe_buf_unmap);
  *	This function attempts to steal the &struct page attached to
  *	@buf. If successful, this function returns 0 and returns with
  *	the page locked. The caller may then reuse the page for whatever
- *	he wishes; the typical use is insertion into a different file
+ *	it wishes; the typical use is insertion into a different file
  *	page cache.
  */
 int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 831d49a..3a9e2a1 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2508,7 +2508,7 @@ static int do_set_dqblk(struct dquot *dquot, struct fs_disk_quota *di)
 			dm->dqb_btime = 0;
 			clear_bit(DQ_BLKS_B, &dquot->dq_flags);
 		} else if (!(di->d_fieldmask & FS_DQ_BTIMER))
-			/* Set grace only if user hasn't provided his own... */
+			/* Set grace only if user hasn't provided their own... */
 			dm->dqb_btime = get_seconds() + dqi->dqi_bgrace;
 	}
 	if (check_ilim) {
@@ -2517,7 +2517,7 @@ static int do_set_dqblk(struct dquot *dquot, struct fs_disk_quota *di)
 			dm->dqb_itime = 0;
 			clear_bit(DQ_INODES_B, &dquot->dq_flags);
 		} else if (!(di->d_fieldmask & FS_DQ_ITIMER))
-			/* Set grace only if user hasn't provided his own... */
+			/* Set grace only if user hasn't provided their own... */
 			dm->dqb_itime = get_seconds() + dqi->dqi_igrace;
 	}
 	if (dm->dqb_bhardlimit || dm->dqb_bsoftlimit || dm->dqb_ihardlimit ||
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 14a4996..d7283f2 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -868,7 +868,7 @@ xfs_qm_init_quotainfo(
 
 		/*
 		 * The warnings and timers set the grace period given to
-		 * a user or group before he or she can not perform any
+		 * a user or group before they can not perform any
 		 * more writing. If it is zero, a default is used.
 		 */
 		qinf->qi_btimelimit = ddqp->d_btimer ?
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index f32c5cd..2ea6d01 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -841,7 +841,7 @@ struct drm_mode_config {
 	/**
 	 * fb_lock - mutex to protect fb state
 	 *
-	 * Besides the global fb list his also protects the fbs list in the
+	 * Besides the global fb list this also protects the fbs list in the
 	 * file_priv
 	 */
 	struct mutex fb_lock;
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 8639c85..83d5faa 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -418,7 +418,7 @@ struct ttm_bo_driver {
 	/**
 	 * In case a driver writer dislikes the TTM fence objects,
 	 * the driver writer can replace those with sync objects of
-	 * his / her own. If it turns out that no driver writer is
+	 * their own. If it turns out that no driver writer is
 	 * using these. I suggest we remove these hooks and plug in
 	 * fences directly. The bo driver needs the following functionality:
 	 * See the corresponding functions in the fence object API
diff --git a/include/linux/edac.h b/include/linux/edac.h
index dbdffe8..e7ed3af 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -460,7 +460,7 @@ struct edac_mc_layer {
  * 3 layers, this is a little faster.
  * By design, layers can never be 0 or more than 3. If that ever happens,
  * a NULL is returned, causing an OOPS during the memory allocation routine,
- * with would point to the developer that he's doing something wrong.
+ * with would point to the developer that they're doing something wrong.
  */
 #define EDAC_DIMM_OFF(layers, nlayers, layer0, layer1, layer2) ({		\
 	int __i;							\
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 121f11f..c152201 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -144,7 +144,7 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
  *	coalescing of adjacent IO and thus reduces the number of IOs we
  *	have to send to the device. It also allows for better queuing,
  *	if the IO isn't mergeable. If the caller is going to be waiting
- *	for the IO, then he must ensure that the device is unplugged so
+ *	for the IO, then it must ensure that the device is unplugged so
  *	that the IO is dispatched to the driver.
  *
  *	All IO is handled async in Linux. This is fine for background
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index db43b58..41e953a 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -414,7 +414,7 @@ static inline struct task_struct *this_cpu_ksoftirqd(void)
      from tasklet itself), it is rescheduled for later.
    * Tasklet is strictly serialized wrt itself, but not
      wrt another tasklets. If client needs some intertask synchronization,
-     he makes it with spinlocks.
+     it does so with spinlocks.
  */
 
 struct tasklet_struct
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 92b1bfc..ac59f4b 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -398,7 +398,7 @@ static inline void lockdep_on(void)
 /*
  * We don't define lockdep_match_class() and lockdep_match_key() for !LOCKDEP
  * case since the result is not well defined and the caller should rather
- * #ifdef the call himself.
+ * #ifdef the call itself.
  */
 
 # define INIT_LOCKDEP
diff --git a/include/linux/vmw_vmci_defs.h b/include/linux/vmw_vmci_defs.h
index 65ac54c..7d539a9 100644
--- a/include/linux/vmw_vmci_defs.h
+++ b/include/linux/vmw_vmci_defs.h
@@ -426,7 +426,7 @@ enum {
  * a line in a store, for example, you walk up to the tail.
  *
  * consumer_head: the point in the queue from which the next element is
- * dequeued.  In other words, who is next in line is he who is at the
+ * dequeued.  In other words, who is next in line is whoever is at the
  * head of the line.
  *
  * Also, producer_tail points to an empty byte in the Queue, whereas
diff --git a/include/linux/wm97xx.h b/include/linux/wm97xx.h
index fd98bb9..3201762 100644
--- a/include/linux/wm97xx.h
+++ b/include/linux/wm97xx.h
@@ -151,7 +151,7 @@
 /* The pen is up (the first RC_VALID without RC_PENUP means pen is down) */
 #define RC_PENUP			0x00000004
 /* The pen is down (RC_VALID implies RC_PENDOWN, but sometimes it is helpful
-   to tell the handler that the pen is down but we don't know yet his coords,
+   to tell the handler that the pen is down but we don't know yet its coords,
    so the handler should not sleep or wait for pendown irq) */
 #define RC_PENDOWN			0x00000008
 
diff --git a/include/net/irda/irttp.h b/include/net/irda/irttp.h
index 98682d4..0eb5ce2 100644
--- a/include/net/irda/irttp.h
+++ b/include/net/irda/irttp.h
@@ -57,14 +57,14 @@
 /* Receive queue sizes */
 /* Minimum of credit that the peer should hold.
  * If the peer has less credits than 9 frames, we will explicitly send
- * him some credits (through irttp_give_credit() and a specific frame).
+ * it some credits (through irttp_give_credit() and a specific frame).
  * Note that when we give credits it's likely that it won't be sent in
  * this LAP window, but in the next one. So, we make sure that the peer
  * has something to send while waiting for credits (one LAP window == 7
- * + 1 frames while he process the credits). - Jean II */
+ * + 1 frames while it processes the credits). - Jean II */
 #define TTP_RX_MIN_CREDIT	8
 /* This is the default maximum number of credits held by the peer, so the
- * default maximum number of frames he can send us before needing flow
+ * default maximum number of frames it can send us before needing flow
  * control answer from us (this may be negociated differently at TSAP setup).
  * We want to minimise the number of times we have to explicitly send some
  * credit to the peer, hoping we can piggyback it on the return data. In
diff --git a/include/net/iucv/iucv.h b/include/net/iucv/iucv.h
index 0894ced..362cb30 100644
--- a/include/net/iucv/iucv.h
+++ b/include/net/iucv/iucv.h
@@ -152,7 +152,7 @@ struct iucv_handler {
 	 /*
 	  * The path_severed function is called after an iucv interrupt
 	  * type 0x03 has been received. The communication peer shutdown
-	  * his end of the communication path. The path still exists and
+	  * its end of the communication path. The path still exists and
 	  * remaining messages can be received until a iucv_path_sever
 	  * shuts down the other end of the path as well.
 	  */
diff --git a/include/net/sock.h b/include/net/sock.h
index e3a18ff..56dfb0c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -433,7 +433,7 @@ struct sock {
 
 /*
  * SK_CAN_REUSE and SK_NO_REUSE on a socket mean that the socket is OK
- * or not whether his port will be reused by someone else. SK_FORCE_REUSE
+ * or not whether this port will be reused by someone else. SK_FORCE_REUSE
  * on a socket means that the socket will reuse everybody else's port
  * without looking at the other's sk_reuse value.
  */
diff --git a/include/uapi/linux/bpqether.h b/include/uapi/linux/bpqether.h
index a6c35e1..e67ebb5 100644
--- a/include/uapi/linux/bpqether.h
+++ b/include/uapi/linux/bpqether.h
@@ -20,7 +20,7 @@ struct bpq_ethaddr {
 /* 
  * For SIOCSBPQETHOPT - this is compatible with PI2/PacketTwin card drivers,
  * currently not implemented, though. If someone wants to hook a radio
- * to his Ethernet card he may find this useful. ;-)
+ * to their Ethernet card they may find this useful. ;-)
  */
 
 #define SIOCGBPQETHPARAM	0x5000  /* get Level 1 parameters */
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 95827ce2..aff2ecc 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1176,7 +1176,7 @@ out:
 
 /*
  * Notes: the case when user wants us to deregister (with NULL as pointer)
- * and he isn't currently owner of notification, will be silently discarded.
+ * and they aren't currently owner of notification, will be silently discarded.
  * It isn't explicitly defined in the POSIX.
  */
 SYSCALL_DEFINE2(mq_notify, mqd_t, mqdes,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8b729c2..2e465aa 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3385,7 +3385,7 @@ int css_scan_tasks(struct cgroup_subsys_state *css,
 	while ((p = css_task_iter_next(&it))) {
 		/*
 		 * Only affect tasks that qualify per the caller's callback,
-		 * if he provided one
+		 * if it provided one
 		 */
 		if (test && !test(p, data))
 			continue;
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index be7c86b..3b87201 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1504,7 +1504,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	boot_delay_msec(level);
 	printk_delay();
 
-	/* This stops the holder of console_sem just where we want him */
+	/* This stops the holder of console_sem just where we want it */
 	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fd773ad..90015c3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4359,7 +4359,7 @@ wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
 
 	/*
 	 * Since its curr running now, convert the gran from real-time
-	 * to virtual-time in his units.
+	 * to virtual-time in its units.
 	 *
 	 * By using 'se' instead of 'curr' we penalize light tasks, so
 	 * they get preempted easier. That is, if 'se' < 'curr' then
diff --git a/lib/idr.c b/lib/idr.c
index bfe4db4..b0b1e04 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -16,7 +16,7 @@
  *
  * You call it to allocate an id (an int) an associate with that id a
  * pointer or what ever, we treat it as a (void *).  You can pass this
- * id to a user for him to pass back at a later time.  You then pass
+ * id to a user for them to pass back at a later time.  You then pass
  * that id to this code and it returns your pointer.
 
  * You can release ids at any time. When all ids are released, most of
diff --git a/lib/lru_cache.c b/lib/lru_cache.c
index 4a83ecd..6e5ec83 100644
--- a/lib/lru_cache.c
+++ b/lib/lru_cache.c
@@ -460,8 +460,9 @@ static struct lc_element *__lc_get(struct lru_cache *lc, unsigned int enr, unsig
  *
  * In case the requested number is not present, it needs to be added to the
  * cache. Therefore it is possible that an other element becomes evicted from
- * the cache. In either case, the user is notified so he is able to e.g. keep
- * a persistent log of the cache changes, and therefore the objects in use.
+ * the cache. In either case, the user is notified so they are able to
+ * e.g. keep a persistent log of the cache changes, and therefore the objects
+ * in use.
  *
  * Return values:
  *  NULL
@@ -487,7 +488,7 @@ static struct lc_element *__lc_get(struct lru_cache *lc, unsigned int enr, unsig
  *          typically serialize on lc_try_lock_for_transaction(), then call
  *          lc_committed(lc) and lc_unlock(), to finish the change.
  *
- * NOTE: The user needs to check the lc_number on EACH use, so he recognizes
+ * NOTE: The user needs to check the lc_number on EACH use, so they recognize
  *       any cache set change.
  */
 struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr)
diff --git a/lib/random32.c b/lib/random32.c
index 1e5b2df..381bcf8 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -154,7 +154,7 @@ static void prandom_seed_very_weak(struct rnd_state *state, u32 seed)
 	 * as we don't have a stronger entropy source available yet.
 	 * After late_initcall, we reseed entire state, we have to (!),
 	 * otherwise an attacker just needs to search 32 bit space to
-	 * probe for our internal 128 bit state if he knows a couple
+	 * probe for our internal 128 bit state if they know a couple
 	 * of prandom32 outputs!
 	 */
 #define LCG(x)	((x) * 69069U)	/* super-duper LCG */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f1a0ae6..8f22a27 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -845,8 +845,8 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
  * a periodic synchronizion of counter in memcg's counter.
  *
  * But this _read() function is used for user interface now. The user accounts
- * memory usage by memory cgroup and he _always_ requires exact value because
- * he accounts memory. Even if we provide quick-and-fuzzy read, we always
+ * memory usage by memory cgroup and they _alway_ requires exact value because
+ * they account memory. Even if we provide quick-and-fuzzy read, we always
  * have to visit all online cpus and make sum. So, for now, unnecessary
  * synchronization is not implemented. (just implemented for cpu hotplug)
  *
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 612a7c9..cf71f16 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1724,8 +1724,8 @@ add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
  * for swapping.
  *
  * For S_ISREG swapfiles we set S_SWAPFILE across the life of the swapon.  This
- * prevents root from shooting her foot off by ftruncating an in-use swapfile,
- * which will scribble on the fs.
+ * prevents root from shooting their foot off by ftruncating an in-use
+ * swapfile, which will scribble on the fs.
  *
  * The amount of disk space which a single swap extent represents varies.
  * Typically it is in the 1-4 megabyte range.  So we can have hundreds of
diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 28eb5e6..56e2c5b 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -500,7 +500,7 @@ static void batadv_bla_answer_request(struct batadv_priv *bat_priv,
 /* @backbone_gw: the backbone gateway from whom we are out of sync
  *
  * When the crc is wrong, ask the backbone gateway for a full table update.
- * After the request, it will repeat all of his own claims and finally
+ * After the request, it will repeat all of its own claims and finally
  * send an announcement claim with which we can check again.
  */
 static void batadv_bla_send_request(struct batadv_bla_backbone_gw *backbone_gw)
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ac78024..1f8f80d 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1037,7 +1037,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	t->private = newinfo;
 	write_unlock_bh(&t->lock);
 	mutex_unlock(&ebt_mutex);
-	/* so, a user can change the chains while having messed up her counter
+	/* so, a user can change the chains while having messed up their counter
 	   allocation. Only reason why this is done is because this way the lock
 	   is held only once, while this doesn't bring the kernel into a
 	   dangerous state. */
diff --git a/net/core/dst.c b/net/core/dst.c
index ca4231e..9f7c925 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -260,7 +260,7 @@ again:
 			/* Child is still referenced, return it for freeing. */
 			if (nohash)
 				return dst;
-			/* Child is still in his hash table */
+			/* Child is still in its hash table */
 		}
 	}
 	return NULL;
diff --git a/net/core/sock.c b/net/core/sock.c
index ab20ed9..cbe2a8e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2240,7 +2240,7 @@ static void sock_def_write_space(struct sock *sk)
 
 	rcu_read_lock();
 
-	/* Do not wake up a writer until he can make "significant"
+	/* Do not wake up a writer until it can make "significant"
 	 * progress.  --DaveM
 	 */
 	if ((atomic_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf) {
diff --git a/net/dccp/feat.c b/net/dccp/feat.c
index 9733ddb..ee33392 100644
--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -107,7 +107,7 @@ static int dccp_hdlr_ndp(struct sock *sk, u64 enable, bool rx)
 
 /*
  * Minimum Checksum Coverage is located at the RX side (9.2.1). This means that
- * `rx' holds when the sending peer informs about his partial coverage via a
+ * `rx' holds when the sending peer informs about its partial coverage via a
  * ChangeR() option. In the other case, we are the sender and the receiver
  * announces its coverage via ChangeL() options. The policy here is to honour
  * such communication by enabling the corresponding partial coverage - but only
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 70011e0..0534493 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -545,7 +545,7 @@ static long inet_wait_for_connect(struct sock *sk, long timeo, int writebias)
 	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 	sk->sk_write_pending += writebias;
 
-	/* Basic assumption: if someone sets sk->sk_err, he _must_
+	/* Basic assumption: if someone sets sk->sk_err, they _must_
 	 * change state of the socket from TCP_SYN_*.
 	 * Connect() does not allow to get error notifications
 	 * without closing the socket.
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index a1b5bcb..52eeb16 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1089,7 +1089,7 @@ int devinet_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 			 * with current netmask, then recalculate
 			 * the broadcast address. Otherwise it's a
 			 * funny address, so don't touch it since
-			 * the user seems to know what (s)he's doing...
+			 * the user seems to know what they're doing...
 			 */
 			if ((dev->flags & IFF_BROADCAST) &&
 			    (ifa->ifa_prefixlen < 31) &&
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c53b7f3..bc3a730 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -607,9 +607,9 @@ new_measure:
  * connection starts up, we want to ack as quickly as possible.  The
  * problem is that "good" TCP's do slow start at the beginning of data
  * transmission.  The means that until we send the first few ACK's the
- * sender will sit on his end and only queue most of his data, because
- * he can only send snd_cwnd unacked packets at any given time.  For
- * each ACK we send, he increments snd_cwnd and transmits more of his
+ * sender will sit on its end and only queue most of its data, because
+ * it can only send snd_cwnd unacked packets at any given time.  For
+ * each ACK we send, it increments snd_cwnd and transmits more of its
  * queue.  -DaveM
  */
 static void tcp_event_data_recv(struct sock *sk, struct sk_buff *skb)
@@ -3767,7 +3767,7 @@ static inline bool tcp_paws_discard(const struct sock *sk,
  * See tcp_data_queue(), for example.
  *
  * Also, controls (RST is main one) are accepted using RCV.WUP instead
- * of RCV.NXT. Peer still did not advance his SND.UNA when we
+ * of RCV.NXT. Peer still did not advance its SND.UNA when we
  * delayed ACK, so that hisSND.UNA<=ourRCV.WUP.
  * (borrowed from freebsd)
  */
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 7820f3a..be3aa33 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2332,7 +2332,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
 
 	cur_mss = tcp_current_mss(sk);
 
-	/* If receiver has shrunk his window, and skb is out of
+	/* If receiver has shrunk its window, and skb is out of
 	 * new window, do not retransmit it. The exception is the
 	 * case, when window is shrunk to zero. In this case
 	 * our retransmit serves as a zero window probe.
@@ -2773,7 +2773,7 @@ void tcp_connect_init(struct sock *sk)
 		tp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
 
-	/* If user gave his TCP_MAXSEG, record it to clamp */
+	/* If user gave their TCP_MAXSEG, record it to clamp */
 	if (tp->rx_opt.user_mss)
 		tp->rx_opt.mss_clamp = tp->rx_opt.user_mss;
 	tp->max_window = 0;
diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index de7db23..3d5fd0a 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -436,7 +436,7 @@ static void irda_selective_discovery_indication(discinfo_t *discovery,
  *    Timeout in the selective discovery process
  *
  * We were waiting for a node to be discovered, but nothing has come up
- * so far. Wake up the user and tell him that we failed...
+ * so far. Wake up the user and tell them that we failed...
  */
 static void irda_discovery_timeout(u_long priv)
 {
@@ -2520,7 +2520,7 @@ bed:
 		 * On the other hand, in here we assume that no device is
 		 * present and that at some point in the future a device will
 		 * come into range. When this device arrive, we just wake
-		 * up the caller, so that he has time to connect to it before
+		 * up the caller, so that it has time to connect to it before
 		 * the device goes away...
 		 * Note : once the node has been discovered for more than a
 		 * few second, it won't trigger this function, unless it
@@ -2590,7 +2590,7 @@ bed:
 		/* We return the daddr of the device that trigger the
 		 * wakeup. As irlmp pass us only the new devices, we
 		 * are sure that it's not an old device.
-		 * If the user want more details, he should query
+		 * If the user want more details, they should query
 		 * the whole discovery log and pick one device...
 		 */
 		if (put_user(daddr, (int __user *)optval)) {
diff --git a/net/irda/discovery.c b/net/irda/discovery.c
index b0b56a3..0979d16 100644
--- a/net/irda/discovery.c
+++ b/net/irda/discovery.c
@@ -252,7 +252,7 @@ void irlmp_dump_discoveries(hashbin_t *log)
  * This function implement a safe way for lmp clients to access the
  * discovery log. The basic problem is that we don't want the log
  * to change (add/remove) while the client is reading it. If the
- * lmp client manipulate directly the hashbin, he is sure to get
+ * lmp client manipulate directly the hashbin, it is sure to get
  * into troubles...
  * The idea is that we copy all the current discovery log in a buffer
  * which is specific to the client and pass this copy to him. As we
@@ -261,7 +261,7 @@ void irlmp_dump_discoveries(hashbin_t *log)
  * we have no control on how long they will hold it...
  * Note : we choose to copy the log in "struct irda_device_info" to
  * save space...
- * Note : the client must kfree himself() the log...
+ * Note : the client must kfree() itself the log...
  * Jean II
  */
 struct irda_device_info *irlmp_copy_discoveries(hashbin_t *log, int *pn,
diff --git a/net/irda/irlan/irlan_eth.c b/net/irda/irlan/irlan_eth.c
index ffcec22..5aa98d2 100644
--- a/net/irda/irlan/irlan_eth.c
+++ b/net/irda/irlan/irlan_eth.c
@@ -128,7 +128,7 @@ static int irlan_eth_open(struct net_device *dev)
 /*
  * Function irlan_eth_close (dev)
  *
- *    Stop the ether network device, his function will usually be called by
+ *    Stop the ether network device, its function will usually be called by
  *    ifconfig down. We should now disconnect the link, We start the
  *    close timer, so that the instance will be removed if we are unable
  *    to discover the remote device after the disconnect.
diff --git a/net/irda/irlap_frame.c b/net/irda/irlap_frame.c
index 9ea0c93..1ce8c7d 100644
--- a/net/irda/irlap_frame.c
+++ b/net/irda/irlap_frame.c
@@ -853,7 +853,7 @@ void irlap_send_data_primary_poll(struct irlap_cb *self, struct sk_buff *skb)
 	 * of our tx-window to let the other peer reply. So, we need
 	 * to add extra time to compensate for the fact that we
 	 * are really at the start of tx-window, otherwise the final timer
-	 * might expire before he can answer...
+	 * might expire before they can answer...
 	 * Jean II
 	 */
 	irlap_start_final_timer(self, self->final_timeout + transmission_time);
diff --git a/net/irda/irlmp.c b/net/irda/irlmp.c
index 98ad6ec..68ac85e 100644
--- a/net/irda/irlmp.c
+++ b/net/irda/irlmp.c
@@ -894,8 +894,8 @@ void irlmp_do_discovery(int nslots)
  *    Do a discovery of devices in front of the computer
  *
  * If the caller has registered a client discovery callback, this
- * allow him to receive the full content of the discovery log through
- * this callback (as normally he will receive only new discoveries).
+ * allow it to receive the full content of the discovery log through
+ * this callback (as normally it will receive only new discoveries).
  */
 void irlmp_discovery_request(int nslots)
 {
@@ -1049,7 +1049,7 @@ void irlmp_discovery_confirm(hashbin_t *log, DISCOVERY_MODE mode)
  *
  *	Note : called exclusively from discovery.c
  *	Note : this is no longer called under discovery spinlock, so the
- *		client can do whatever he wants in the callback.
+ *		client can do whatever it wants in the callback.
  */
 void irlmp_discovery_expiry(discinfo_t *expiries, int number)
 {
@@ -1308,7 +1308,7 @@ void irlmp_status_indication(struct lap_cb *self,
 					 (void *) &next) ) {
 		IRDA_ASSERT(curr->magic == LMP_LSAP_MAGIC, return;);
 		/*
-		 *  Inform service user if he has requested it
+		 *  Inform service user if they have requested it
 		 */
 		if (curr->notify.status_indication != NULL)
 			curr->notify.status_indication(curr->notify.instance,
diff --git a/net/irda/irnet/irnet_irda.c b/net/irda/irnet/irnet_irda.c
index 7f17a80..f93df32 100644
--- a/net/irda/irnet/irnet_irda.c
+++ b/net/irda/irnet/irnet_irda.c
@@ -1217,7 +1217,7 @@ irnet_connect_confirm(void *	instance,
   /* Allow higher layer to access IrTTP */
   set_bit(0, &self->ttp_open);
   clear_bit(0, &self->ttp_connect);	/* Not racy, IrDA traffic is serial */
-  /* Give a kick in the ass of ppp_generic so that he sends us some data */
+  /* Give a kick in the ass of ppp_generic so that it sends us some data */
   ppp_output_wakeup(&self->chan);
 
   /* Check size of received packet */
diff --git a/net/irda/irqueue.c b/net/irda/irqueue.c
index 7152624..7513d11 100644
--- a/net/irda/irqueue.c
+++ b/net/irda/irqueue.c
@@ -126,7 +126,7 @@
  * --------------------
  *	The spinlock that HB_LOCK uses is available for caller, so that
  * the caller can protect unprotected calls (see below).
- *	If the caller want to do entirely its own locking (HB_NOLOCK), he
+ *	If the caller want to do entirely its own locking (HB_NOLOCK), it
  * can do so and may use safely this spinlock.
  *	Locking is done like this :
  *		spin_lock_irqsave(&hashbin->hb_spinlock, flags);
diff --git a/net/irda/irttp.c b/net/irda/irttp.c
index 85372cf..6e5a7c9 100644
--- a/net/irda/irttp.c
+++ b/net/irda/irttp.c
@@ -1005,7 +1005,7 @@ static void irttp_status_indication(void *instance,
 		return;
 
 	/*
-	 *  Inform service user if he has requested it
+	 *  Inform service user if they have requested it
 	 */
 	if (self->notify.status_indication != NULL)
 		self->notify.status_indication(self->notify.instance,
@@ -1081,7 +1081,7 @@ void irttp_flow_request(struct tsap_cb *self, LOCAL_FLOW flow)
 		IRDA_DEBUG(1, "%s(), flow start\n", __func__);
 		self->rx_sdu_busy = FALSE;
 
-		/* Client say he can accept more data, try to free our
+		/* Client say it can accept more data, try to free our
 		 * queues ASAP - Jean II */
 		irttp_run_rx_queue(self);
 
@@ -1619,7 +1619,7 @@ static void irttp_disconnect_indication(void *instance, void *sap,
 
 	/* If we are here, we assume that is the higher layer is still
 	 * waiting for the disconnect notification and able to process it,
-	 * even if he tried to disconnect. Otherwise, it would have already
+	 * even if it tried to disconnect. Otherwise, it would have already
 	 * attempted to close the tsap and self->close_pend would be TRUE.
 	 * Jean II */
 
@@ -1791,7 +1791,7 @@ static void irttp_run_rx_queue(struct tsap_cb *self)
 		 * even if we have something to send in our Tx queue.
 		 * If we have credits, it means that our Tx queue is blocked.
 		 *
-		 * Let's suppose the peer can't keep up with our Tx. He will
+		 * Let's suppose the peer can't keep up with our Tx. It will
 		 * flow control us by not sending us any credits, and we
 		 * will stop Tx and start accumulating credits here.
 		 * Up to the point where the peer will stop its Tx queue,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 43549eb..8ccb30a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1268,7 +1268,7 @@ void nf_ct_iterate_cleanup(struct net *net,
 		if (del_timer(&ct->timeout))
 			nf_ct_delete(ct, portid, report);
 
-		/* ... else the timer will get him soon. */
+		/* ... else the timer will get it soon. */
 
 		nf_ct_put(ct);
 	}
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index ef8a926..288c6e0 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -90,8 +90,8 @@ tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
  *     regardless if it was bound to 0.0.0.0 or an explicit
  *     address. The reasoning is that if there's an explicit rule, it
  *     does not really matter if the listener is bound to an interface
- *     or to 0. The user already stated that he wants redirection
- *     (since he added the rule).
+ *     or to 0. The user already stated that they want redirection
+ *     (since they added the rule).
  *
  * Please note that there's an overlap between what a TPROXY target
  * and a socket match will match. Normally if you have both rules the
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 53c19a3..e86f464 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -967,7 +967,7 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	skb->sk             = make;
 	make->sk_state	    = TCP_ESTABLISHED;
 
-	/* Fill in his circuit details */
+	/* Fill in its circuit details */
 	nr_make = nr_sk(make);
 	nr_make->source_addr = *dest;
 	nr_make->dest_addr   = *src;
diff --git a/net/rds/recv.c b/net/rds/recv.c
index de339b2..95bcc70 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -307,7 +307,7 @@ int rds_notify_queue_get(struct rds_sock *rs, struct msghdr *msghdr)
 	 * with rs_lock held, so first grab as many notifications as we can stuff
 	 * in the user provided cmsg buffer. We don't try to copy more, to avoid
 	 * losing notifications - except when the buffer is so small that it wouldn't
-	 * even hold a single notification. Then we give him as much of this single
+	 * even hold a single notification. Then we give them as much of this single
 	 * msg as we can squeeze in, and set MSG_CTRUNC.
 	 */
 	if (msghdr) {
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 7a42c81..2b53e72 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -40,7 +40,7 @@
 
 	Algorithm skeleton was taken from NS simulator cbq.cc.
 	If someone wants to check this code against the LBL version,
-	he should take into account that ONLY the skeleton was borrowed,
+	they should take into account that ONLY the skeleton was borrowed,
 	the implementation is different. Particularly:
 
 	--- The WRR algorithm is different. Our version looks more
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 68a27f9..c830178 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -255,7 +255,7 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 	asoc->peer.sack_cnt = 0;
 	asoc->peer.sack_generation = 1;
 
-	/* Assume that the peer will tell us if he recognizes ASCONF
+	/* Assume that the peer will tell us if it recognizes ASCONF
 	 * as part of INIT exchange.
 	 * The sctp_addip_noauth option is there for backward compatibilty
 	 * and will revert old behavior.
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index fe69032..8341c67 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1772,7 +1772,7 @@ no_hmac:
 	 * for init collision case of lost COOKIE ACK.
 	 * If skb has been timestamped, then use the stamp, otherwise
 	 * use current time.  This introduces a small possibility that
-	 * that a cookie may be considered expired, but his would only slow
+	 * that a cookie may be considered expired, but this would only slow
 	 * down the new association establishment instead of every packet.
 	 */
 	if (sock_flag(ep->base.sk, SOCK_TIMESTAMP))
@@ -2007,7 +2007,7 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 				    asoc->peer.prsctp_capable = 1;
 			    break;
 		    case SCTP_CID_AUTH:
-			    /* if the peer reports AUTH, assume that he
+			    /* if the peer reports AUTH, assume that it
 			     * supports AUTH.
 			     */
 			    if (net->sctp.auth_enable)
diff --git a/net/wimax/op-rfkill.c b/net/wimax/op-rfkill.c
index 403078d..e777fca 100644
--- a/net/wimax/op-rfkill.c
+++ b/net/wimax/op-rfkill.c
@@ -290,7 +290,7 @@ static const struct rfkill_ops wimax_rfkill_ops = {
  *
  * Description:
  *
- * Called by the user when he wants to request the WiMAX radio to be
+ * Called by the user when they want to request the WiMAX radio to be
  * switched on (%WIMAX_RF_ON) or off (%WIMAX_RF_OFF). With
  * %WIMAX_RF_QUERY, just the current state is returned.
  *
diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 078fe1d..2feb5db 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -33,9 +33,9 @@
  * which then let make pick up the changes and the files that use
  * the config symbols are rebuilt.
  *
- * So if the user changes his CONFIG_HIS_DRIVER option, only the objects
+ * So if the user changes their CONFIG_HIS_DRIVER option, only the objects
  * which depend on "include/linux/config/his/driver.h" will be rebuilt,
- * so most likely only his driver ;-)
+ * so most likely only their driver ;-)
  *
  * The idea above dates, by the way, back to Michael E Chastain, AFAIK.
  *
diff --git a/sound/core/seq/seq_device.c b/sound/core/seq/seq_device.c
index 040c60e..5093ae1 100644
--- a/sound/core/seq/seq_device.c
+++ b/sound/core/seq/seq_device.c
@@ -21,7 +21,7 @@
  *
  * This device handler separates the card driver module from sequencer
  * stuff (sequencer core, synth drivers, etc), so that user can avoid
- * to spend unnecessary resources e.g. if he needs only listening to
+ * to spend unnecessary resources e.g. if they need only listening to
  * MP3s.
  *
  * The card (or lowlevel) driver creates a sequencer device entry
diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 145e36b..d1a33e5 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -25,7 +25,7 @@
  * 98-05-28: Vladimir Michl <vladimir.michl@upol.cz>
  *          Fixed computation of mixer volumes
  * 04-05-1999: Anthony Barbachan <barbcode@xmen.cis.fordham.edu>
- *          Added code that allows the user to enable his cdrom and/or 
+ *          Added code that allows the user to enable their cdrom and/or
  *          joystick through the module parameters pss_cdrom_port and 
  *          pss_enable_joystick.  pss_cdrom_port takes a port address as its
  *          argument.  pss_enable_joystick takes either a 0 or a non-0 as its
@@ -39,7 +39,7 @@
  *          reset the configured hardware settings for the PSS board through 
  *          the module parameter pss_keep_settings (flag).   This flag will 
  *          allow a user to free up resources in use by this card if needbe, 
- *          furthermore it allows him to use this driver to just enable the 
+ *          furthermore it allows them to use this driver to just enable the
  *          emulations and then be unloaded as it is no longer needed.  Both 
  *          new settings are only available to this driver if compiled as a 
  *          module.  The default settings of all new parameters are set to 
diff --git a/sound/oss/sb_ess.c b/sound/oss/sb_ess.c
index 0e7254b..ffa5da4 100644
--- a/sound/oss/sb_ess.c
+++ b/sound/oss/sb_ess.c
@@ -74,7 +74,7 @@
  *
  * I don't know if the chips all are OK, but the documentation is buggy. 'cause
  * I don't have all the cips myself, there's a lot I cannot verify. I'll try to
- * keep track of my latest insights about his here. If you have additional info,
+ * keep track of my latest insights about this here. If you have additional info,
  * please enlighten me (fokkensr@vertis.nl)!
  *
  * I had the impression that ES1688 also has 6 bit master volume control. The
diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index 05cfe55..449413e 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -914,7 +914,7 @@ static int snd_echo_new_pcm(struct echoaudio *chip)
 
 #ifdef ECHOCARD_HAS_VMIXER
 	/* This card has a Vmixer, that is there is no direct mapping from PCM
-	streams to physical outputs. The user can mix the streams as he wishes
+	streams to physical outputs. The user can mix the streams as they wish
 	via control interface and it's possible to send any stream to any
 	output, thus it makes no sense to keep analog and digital outputs
 	separated */
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index fe79fff..c8819c6 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -4,7 +4,7 @@
  *
  * Based on nm256_audio.c OSS driver in linux kernel.
  * The original author of OSS nm256 driver wishes to remain anonymous,
- * so I just put my acknoledgment to him/her here.
+ * so I just put my acknoledgment to them here.
  * The original author's web page is found at
  *	http://www.uglx.org/sony.html
  *
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index e98dc00..3cd8259 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -1150,7 +1150,7 @@ static inline unsigned int hdspm_read(struct hdspm * hdspm, unsigned int reg)
 }
 
 /* for each output channel (chan) I have an Input (in) and Playback (pb) Fader
-   mixer is write only on hardware so we have to cache him for read
+   mixer is write only on hardware so we have to cache it for read
    each fader is a u32, but uses only the first 16 bit */
 
 static inline int hdspm_read_in_gain(struct hdspm * hdspm, unsigned int chan,
diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
index fb9bb9e..d570f8c 100644
--- a/sound/soc/fsl/fsl_dma.c
+++ b/sound/soc/fsl/fsl_dma.c
@@ -852,7 +852,7 @@ static void fsl_dma_free_dma_buffers(struct snd_pcm *pcm)
 }
 
 /**
- * find_ssi_node -- returns the SSI node that points to his DMA channel node
+ * find_ssi_node -- returns the SSI node that points to its DMA channel node
  *
  * Although this DMA driver attempts to operate independently of the other
  * devices, it still needs to determine some information about the SSI device
diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 54e622a..d6cb9a5 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -50,9 +50,9 @@ static struct mxs_saif *mxs_saif[2];
  * This also means that both SAIFs must operate at the same sample rate.
  *
  * We abstract this as each saif has a master, the master could be
- * himself or other saifs. In the generic saif driver, saif does not need
- * to know the different clkmux. Saif only needs to know who is his master
- * and operating his master to generate the proper clock rate for him.
+ * itself or other saifs. In the generic saif driver, saif does not need
+ * to know the different clkmux. Saif only needs to know who is its master
+ * and operating its master to generate the proper clock rate for it.
  * The master id is provided in mach-specific layer according to different
  * clkmux setting.
  */
@@ -76,7 +76,7 @@ static int mxs_saif_set_dai_sysclk(struct snd_soc_dai *cpu_dai,
  * Since SAIF may work on EXTMASTER mode, IOW, it's working BITCLK&LRCLK
  * is provided by other SAIF, we provide a interface here to get its master
  * from its master_id.
- * Note that the master could be himself.
+ * Note that the master could be itself.
  */
 static inline struct mxs_saif *mxs_saif_get_master(struct mxs_saif * saif)
 {
@@ -516,7 +516,7 @@ static int mxs_saif_trigger(struct snd_pcm_substream *substream, int cmd,
 		}
 
 		/*
-		 * If the saif's master is not himself, we also need to enable
+		 * If the saif's master is not itself, we also need to enable
 		 * itself clk for its internal basic logic to work.
 		 */
 		if (saif != master_saif) {
-- 
1.8.4.2

