Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbbAAOHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 09:07:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46544 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbbAAOHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 09:07:11 -0500
Message-ID: <1420121213.5686.45.camel@decadent.org.uk>
Subject: Linux 3.2.66
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Thu, 01 Jan 2015 14:06:53 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mpb4RIBvogullTO+cvL2"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mpb4RIBvogullTO+cvL2
Content-Type: multipart/mixed; boundary="=-HaVq1u//mYP1ofBQdeIw"


--=-HaVq1u//mYP1ofBQdeIw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.66 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.65 is attached to this message.

Ben.

------------

 Makefile                                   |   2 +-
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
 fs/dcache.c                                | 179 ++++++++++++++++---------=
----
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
 59 files changed, 384 insertions(+), 361 deletions(-)

Al Viro (2):
      move d_rcu from overlapping d_child to overlapping d_alias
      deal with deadlock in d_walk()

Anatol Pomozov (1):
      ext4: make orphan functions be no-op in no-journal mode

Andy Lutomirski (2):
      x86/tls: Validate TLS entries to protect espfix
      x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit

Ard Biesheuvel (1):
      crypto: ghash-clmulni-intel - use C implementation for setkey()

Ben Hutchings (3):
      drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
      drivers/net: macvtap and tun depend on INET
      Linux 3.2.66

Dan Carpenter (1):
      ttusb-dec: buffer overflow in ioctl

Daniel Borkmann (3):
      net: sctp: fix NULL pointer dereference in af->from_addr_param on mal=
formed packet
      net: sctp: fix memory leak in auth key management
      net: sctp: use MAX_HEADER for headroom reserve in output path

Daniel Vetter (1):
      drm/i915: Unlock panel even when LVDS is disabled

David Herrmann (1):
      drm: fix DRM_IOCTL_MODE_GETFB handle-leak

Devin Ryles (1):
      AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller

Dmitry Torokhov (1):
      sata_fsl: fix error handling of irq_of_parse_and_map

Eric Dumazet (2):
      tcp: md5: remove spinlock usage in fast path
      tcp: md5: do not use alloc_percpu()

Grygorii Strashko (1):
      i2c: davinci: generate STP always when NACK is received

Hugh Dickins (1):
      mm: fix swapoff hang after page migration and fork

Jan Kara (1):
      udf: Avoid infinite loop when processing indirect ICBs

Jiri Pirko (1):
      ipv4: fix nexthop attlen check in fib_nh_match

Martin Schwidefsky (1):
      s390,time: revert direct ktime path for s390 clockevent device

Nadav Amit (1):
      KVM: x86: Don't report guest userspace emulation error to userspace

Paolo Bonzini (1):
      x86: kvm: use alternatives for VMCALL vs. VMMCALL if kernel text is r=
ead-only

Tejun Heo (1):
      ahci: disable MSI on SAMSUNG 0xa800 SSD

Vasily Averin (1):
      ipv4: dst_entry leak in ip_send_unicast_reply()


--=20
Ben Hutchings
It is easier to write an incorrect program than to understand a correct one=
.

--=-HaVq1u//mYP1ofBQdeIw
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.66.patch"
Content-Disposition: attachment; filename="linux-3.2.66.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 1433109..f08f8bf 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 65
+SUBLEVEL =3D 66
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platf=
orms/cell/spufs/inode.c
index 70ec4e9..941d5cb 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -165,7 +165,7 @@ static void spufs_prune_dir(struct dentry *dir)
 	struct dentry *dentry, *tmp;
=20
 	mutex_lock(&dir->d_inode->i_mutex);
-	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_u.d_child) {
+	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_child) {
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry)) && dentry->d_inode) {
 			dget_dlock(dentry);
@@ -223,7 +223,7 @@ out:
 	 * - free child's inode if possible
 	 * - free child
 	 */
-	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_u.d_child) {
+	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_child) {
 		dput(dentry);
 	}
=20
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index b2f44de..fd65e5e2 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -110,20 +110,10 @@ static void fixup_clock_comparator(unsigned long long=
 delta)
 	set_clock_comparator(S390_lowcore.clock_comparator);
 }
=20
-static int s390_next_ktime(ktime_t expires,
+static int s390_next_event(unsigned long delta,
 			   struct clock_event_device *evt)
 {
-	struct timespec ts;
-	u64 nsecs;
-
-	ts.tv_sec =3D ts.tv_nsec =3D 0;
-	monotonic_to_bootbased(&ts);
-	nsecs =3D ktime_to_ns(ktime_add(timespec_to_ktime(ts), expires));
-	do_div(nsecs, 125);
-	S390_lowcore.clock_comparator =3D sched_clock_base_cc + (nsecs << 9);
-	/* Program the maximum value if we have an overflow (=3D=3D year 2042) */
-	if (unlikely(S390_lowcore.clock_comparator < sched_clock_base_cc))
-		S390_lowcore.clock_comparator =3D -1ULL;
+	S390_lowcore.clock_comparator =3D get_clock() + delta;
 	set_clock_comparator(S390_lowcore.clock_comparator);
 	return 0;
 }
@@ -148,15 +138,14 @@ void init_cpu_timer(void)
 	cpu =3D smp_processor_id();
 	cd =3D &per_cpu(comparators, cpu);
 	cd->name		=3D "comparator";
-	cd->features		=3D CLOCK_EVT_FEAT_ONESHOT |
-				  CLOCK_EVT_FEAT_KTIME;
+	cd->features		=3D CLOCK_EVT_FEAT_ONESHOT;
 	cd->mult		=3D 16777;
 	cd->shift		=3D 12;
 	cd->min_delta_ns	=3D 1;
 	cd->max_delta_ns	=3D LONG_MAX;
 	cd->rating		=3D 400;
 	cd->cpumask		=3D cpumask_of(cpu);
-	cd->set_next_ktime	=3D s390_next_ktime;
+	cd->set_next_event	=3D s390_next_event;
 	cd->set_mode		=3D s390_set_mode;
=20
 	clockevents_register_device(cd);
diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/gh=
ash-clmulni-intel_asm.S
index 1eb7f90..eb4d2a2 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -24,10 +24,6 @@
 .align 16
 .Lbswap_mask:
 	.octa 0x000102030405060708090a0b0c0d0e0f
-.Lpoly:
-	.octa 0xc2000000000000000000000000000001
-.Ltwo_one:
-	.octa 0x00000001000000000000000000000001
=20
 #define DATA	%xmm0
 #define SHASH	%xmm1
@@ -131,27 +127,3 @@ ENTRY(clmul_ghash_update)
 	movups DATA, (%rdi)
 .Lupdate_just_ret:
 	ret
-
-/*
- * void clmul_ghash_setkey(be128 *shash, const u8 *key);
- *
- * Calculate hash_key << 1 mod poly
- */
-ENTRY(clmul_ghash_setkey)
-	movaps .Lbswap_mask, BSWAP
-	movups (%rsi), %xmm0
-	PSHUFB_XMM BSWAP %xmm0
-	movaps %xmm0, %xmm1
-	psllq $1, %xmm0
-	psrlq $63, %xmm1
-	movaps %xmm1, %xmm2
-	pslldq $8, %xmm1
-	psrldq $8, %xmm2
-	por %xmm1, %xmm0
-	# reduction
-	pshufd $0b00100100, %xmm2, %xmm1
-	pcmpeqd .Ltwo_one, %xmm1
-	pand .Lpoly, %xmm1
-	pxor %xmm1, %xmm0
-	movups %xmm0, (%rdi)
-	ret
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/g=
hash-clmulni-intel_glue.c
index 976aa64..294a264 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -29,8 +29,6 @@ void clmul_ghash_mul(char *dst, const be128 *shash);
 void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
 			const be128 *shash);
=20
-void clmul_ghash_setkey(be128 *shash, const u8 *key);
-
 struct ghash_async_ctx {
 	struct cryptd_ahash *cryptd_tfm;
 };
@@ -57,13 +55,23 @@ static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
 	struct ghash_ctx *ctx =3D crypto_shash_ctx(tfm);
+	be128 *x =3D (be128 *)key;
+	u64 a, b;
=20
 	if (keylen !=3D GHASH_BLOCK_SIZE) {
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
=20
-	clmul_ghash_setkey(&ctx->shash, key);
+	/* perform multiplication by 'x' in GF(2^128) */
+	a =3D be64_to_cpu(x->a);
+	b =3D be64_to_cpu(x->b);
+
+	ctx->shash.a =3D (__be64)((b << 1) | (a >> 63));
+	ctx->shash.b =3D (__be64)((a << 1) | (b >> 63));
+
+	if (a >> 63)
+		ctx->shash.b ^=3D cpu_to_be64(0xc2);
=20
 	return 0;
 }
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufe=
ature.h
index a315f1c..b8a5fe5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -193,6 +193,7 @@
 #define X86_FEATURE_DECODEASSISTS (8*32+12) /* AMD Decode Assists support =
*/
 #define X86_FEATURE_PAUSEFILTER (8*32+13) /* AMD filtered pause intercept =
*/
 #define X86_FEATURE_PFTHRESHOLD (8*32+14) /* AMD pause filter threshold */
+#define X86_FEATURE_VMMCALL     ( 8*32+15) /* Prefer vmmcall to vmcall */
=20
=20
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_par=
a.h
index 734c376..9f0a680 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -91,15 +91,21 @@ struct kvm_vcpu_pv_apf_data {
=20
 #ifdef __KERNEL__
 #include <asm/processor.h>
+#include <asm/alternative.h>
=20
 extern void kvmclock_init(void);
 extern int kvm_register_clock(char *txt);
=20
=20
-/* This instruction is vmcall.  On non-VT architectures, it will generate =
a
- * trap that we will then rewrite to the appropriate instruction.
+#ifdef CONFIG_DEBUG_RODATA
+#define KVM_HYPERCALL \
+        ALTERNATIVE(".byte 0x0f,0x01,0xc1", ".byte 0x0f,0x01,0xd9", X86_FE=
ATURE_VMMCALL)
+#else
+/* On AMD processors, vmcall will generate a trap that we will
+ * then rewrite to the appropriate instruction.
  */
 #define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
+#endif
=20
 /* For KVM hypercalls, a three-byte sequence of either the vmrun or the vm=
mrun
  * instruction.  The hypervisor may replace it with something else but onl=
y the
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f07becc..2d44a28 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -469,6 +469,13 @@ static void __cpuinit early_init_amd(struct cpuinfo_x8=
6 *c)
 			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
 	}
 #endif
+
+	/*
+	 * This is only needed to tell the kernel whether to use VMCALL
+	 * and VMMCALL.  VMMCALL is never executed except under virt, so
+	 * we can set it unconditionally.
+	 */
+	set_cpu_cap(c, X86_FEATURE_VMMCALL);
 }
=20
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a9c2116..4b6701e 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -419,7 +419,14 @@ static void kvm_leave_lazy_mmu(void)
 static void __init paravirt_ops_setup(void)
 {
 	pv_info.name =3D "KVM";
-	pv_info.paravirt_enabled =3D 1;
+
+	/*
+	 * KVM isn't paravirt in the sense of paravirt_enabled.  A KVM
+	 * guest kernel works like a bare metal kernel with additional
+	 * features, and paravirt_enabled is about features that are
+	 * missing.
+	 */
+	pv_info.paravirt_enabled =3D 0;
=20
 	if (kvm_para_has_feature(KVM_FEATURE_NOP_IO_DELAY))
 		pv_cpu_ops.io_delay =3D kvm_io_delay;
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 44842d7..e90eca0 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -203,7 +203,6 @@ void __init kvmclock_init(void)
 #endif
 	kvm_get_preset_lpj();
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
-	pv_info.paravirt_enabled =3D 1;
 	pv_info.name =3D "KVM";
=20
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index bcfec2d..7af7338 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -28,6 +28,21 @@ static int get_free_idx(void)
 	return -ESRCH;
 }
=20
+static bool tls_desc_okay(const struct user_desc *info)
+{
+	if (LDT_empty(info))
+		return true;
+
+	/*
+	 * espfix is required for 16-bit data segments, but espfix
+	 * only works for LDT segments.
+	 */
+	if (!info->seg_32bit)
+		return false;
+
+	return true;
+}
+
 static void set_tls_desc(struct task_struct *p, int idx,
 			 const struct user_desc *info, int n)
 {
@@ -67,6 +82,9 @@ int do_set_thread_area(struct task_struct *p, int idx,
 	if (copy_from_user(&info, u_info, sizeof(info)))
 		return -EFAULT;
=20
+	if (!tls_desc_okay(&info))
+		return -EINVAL;
+
 	if (idx =3D=3D -1)
 		idx =3D info.entry_number;
=20
@@ -197,6 +215,7 @@ int regset_tls_set(struct task_struct *target, const st=
ruct user_regset *regset,
 {
 	struct user_desc infobuf[GDT_ENTRY_TLS_ENTRIES];
 	const struct user_desc *info;
+	int i;
=20
 	if (pos >=3D GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) !=3D 0 ||
@@ -210,6 +229,10 @@ int regset_tls_set(struct task_struct *target, const s=
truct user_regset *regset,
 	else
 		info =3D infobuf;
=20
+	for (i =3D 0; i < count / sizeof(struct user_desc); i++)
+		if (!tls_desc_okay(info + i))
+			return -EINVAL;
+
 	set_tls_desc(target,
 		     GDT_ENTRY_TLS_MIN + (pos / sizeof(struct user_desc)),
 		     info, count / sizeof(struct user_desc));
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d7d0df..bb179cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4846,7 +4846,7 @@ static int handle_emulation_failure(struct kvm_vcpu *=
vcpu)
=20
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
-	if (!is_guest_mode(vcpu)) {
+	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) =3D=3D 0) {
 		vcpu->run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror =3D KVM_INTERNAL_ERROR_EMULATION;
 		vcpu->run->internal.ndata =3D 0;
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 923ac15..81f32e5 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -331,6 +331,9 @@ static const struct pci_device_id ahci_pci_tbl[] =3D {
 	{ PCI_VDEVICE(INTEL, 0x8c87), board_ahci }, /* 9 Series RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c8e), board_ahci }, /* 9 Series RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c8f), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x9d03), board_ahci }, /* Sunrise Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9d05), board_ahci }, /* Sunrise Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9d07), board_ahci }, /* Sunrise Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0xa103), board_ahci }, /* Sunrise Point-H AHCI */
 	{ PCI_VDEVICE(INTEL, 0xa103), board_ahci }, /* Sunrise Point-H RAID */
 	{ PCI_VDEVICE(INTEL, 0xa105), board_ahci }, /* Sunrise Point-H RAID */
@@ -499,6 +502,7 @@ static const struct pci_device_id ahci_pci_tbl[] =3D {
 	 * enabled.  https://bugzilla.kernel.org/show_bug.cgi?id=3D60731
 	 */
 	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_nomsi },
+	{ PCI_VDEVICE(SAMSUNG, 0xa800), board_ahci_nomsi },
=20
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 78ae7b6..54702f8 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1338,7 +1338,7 @@ static int sata_fsl_probe(struct platform_device *ofd=
ev)
 	host_priv->csr_base =3D csr_base;
=20
 	irq =3D irq_of_parse_and_map(ofdev->dev.of_node, 0);
-	if (irq < 0) {
+	if (!irq) {
 		dev_err(&ofdev->dev, "invalid irq from platform\n");
 		goto error_exit_with_cleanup;
 	}
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 3f1799b..09851ce 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1815,7 +1815,17 @@ int drm_mode_getfb(struct drm_device *dev,
 	r->depth =3D fb->depth;
 	r->bpp =3D fb->bits_per_pixel;
 	r->pitch =3D fb->pitch;
-	fb->funcs->create_handle(fb, file_priv, &r->handle);
+	if (file_priv->is_master || capable(CAP_SYS_ADMIN)) {
+		ret =3D fb->funcs->create_handle(fb, file_priv, &r->handle);
+	} else {
+		/* GET_FB() is an unprivileged ioctl so we must not
+		 * return a buffer-handle to non-master processes! For
+		 * backwards-compatibility reasons, we cannot make
+		 * GET_FB() privileged, so just return an invalid handle
+		 * for non-masters. */
+		r->handle =3D 0;
+		ret =3D 0;
+	}
=20
 out:
 	mutex_unlock(&dev->mode_config.mutex);
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel=
_lvds.c
index fadd021..4da8182 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -914,6 +914,18 @@ bool intel_lvds_init(struct drm_device *dev)
 	int pipe;
 	u8 pin;
=20
+	/*
+	 * Unlock registers and just leave them unlocked. Do this before
+	 * checking quirk lists to avoid bogus WARNINGs.
+	 */
+	if (HAS_PCH_SPLIT(dev)) {
+		I915_WRITE(PCH_PP_CONTROL,
+			   I915_READ(PCH_PP_CONTROL) | PANEL_UNLOCK_REGS);
+	} else {
+		I915_WRITE(PP_CONTROL,
+			   I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS);
+	}
+
 	/* Skip init on machines we know falsely report LVDS */
 	if (dmi_check_system(intel_no_lvds))
 		return false;
@@ -1088,19 +1100,6 @@ out:
 		pwm =3D I915_READ(BLC_PWM_PCH_CTL1);
 		pwm |=3D PWM_PCH_ENABLE;
 		I915_WRITE(BLC_PWM_PCH_CTL1, pwm);
-		/*
-		 * Unlock registers and just
-		 * leave them unlocked
-		 */
-		I915_WRITE(PCH_PP_CONTROL,
-			   I915_READ(PCH_PP_CONTROL) | PANEL_UNLOCK_REGS);
-	} else {
-		/*
-		 * Unlock registers and just
-		 * leave them unlocked
-		 */
-		I915_WRITE(PP_CONTROL,
-			   I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS);
 	}
 	dev_priv->lid_notifier.notifier_call =3D intel_lid_notify;
 	if (acpi_lid_notifier_register(&dev_priv->lid_notifier)) {
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davi=
nci.c
index 79b4bcb..1837fe6 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -416,11 +416,9 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct =
i2c_msg *msg, int stop)
 	if (dev->cmd_err & DAVINCI_I2C_STR_NACK) {
 		if (msg->flags & I2C_M_IGNORE_NAK)
 			return msg->len;
-		if (stop) {
-			w =3D davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
-			w |=3D DAVINCI_I2C_MDR_STP;
-			davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
-		}
+		w =3D davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
+		w |=3D DAVINCI_I2C_MDR_STP;
+		davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
 		return -EREMOTEIO;
 	}
 	return -EIO;
diff --git a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c b/drivers/media/dvb/t=
tusb-dec/ttusbdecfe.c
index 21260aa..852870b 100644
--- a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
@@ -154,6 +154,9 @@ static int ttusbdecfe_dvbs_diseqc_send_master_cmd(struc=
t dvb_frontend* fe, struc
 		   0x00, 0x00, 0x00, 0x00,
 		   0x00, 0x00 };
=20
+	if (cmd->msg_len > sizeof(b) - 4)
+		return -EINVAL;
+
 	memcpy(&b[4], cmd->msg, cmd->msg_len);
=20
 	state->config->send_command(fe, 0x72,
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 654a5e9..61d3d1f 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -143,6 +143,7 @@ config MACVLAN
 config MACVTAP
 	tristate "MAC-VLAN based tap driver (EXPERIMENTAL)"
 	depends on MACVLAN
+	depends on INET
 	help
 	  This adds a specialized tap character device driver that is based
 	  on the MAC-VLAN network interface, called macvtap. A macvtap device
@@ -195,6 +196,7 @@ config RIONET_RX_SIZE
=20
 config TUN
 	tristate "Universal TUN/TAP device driver support"
+	depends on INET
 	select CRC32
 	---help---
 	  TUN/TAP provides packet reception and transmission for user space
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index b0f9015..0e6e57e 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -15,6 +15,7 @@
 #include <linux/cdev.h>
 #include <linux/fs.h>
=20
+#include <net/ipv6.h>
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
@@ -577,6 +578,8 @@ static int macvtap_skb_from_vnet_hdr(struct sk_buff *sk=
b,
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			gso_type =3D SKB_GSO_UDP;
+			if (skb->protocol =3D=3D htons(ETH_P_IPV6))
+				ipv6_proxy_select_ident(skb);
 			break;
 		default:
 			return -EINVAL;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ee1aab0..2fbbca6 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -64,6 +64,7 @@
 #include <linux/nsproxy.h>
 #include <linux/virtio_net.h>
 #include <linux/rcupdate.h>
+#include <net/ipv6.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <net/rtnetlink.h>
@@ -695,6 +696,8 @@ static ssize_t tun_get_user(struct tun_struct *tun,
 		break;
 	}
=20
+	skb_reset_network_header(skb);
+
 	if (gso.gso_type !=3D VIRTIO_NET_HDR_GSO_NONE) {
 		pr_debug("GSO!\n");
 		switch (gso.gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
@@ -706,6 +709,8 @@ static ssize_t tun_get_user(struct tun_struct *tun,
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			skb_shinfo(skb)->gso_type =3D SKB_GSO_UDP;
+			if (skb->protocol =3D=3D htons(ETH_P_IPV6))
+				ipv6_proxy_select_ident(skb);
 			break;
 		default:
 			tun->dev->stats.rx_frame_errors++;
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 2278dad..5babd94 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -212,7 +212,7 @@ static void update_bus(struct dentry *bus)
=20
 	mutex_lock(&bus->d_inode->i_mutex);
=20
-	list_for_each_entry(dev, &bus->d_subdirs, d_u.d_child)
+	list_for_each_entry(dev, &bus->d_subdirs, d_child)
 		if (dev->d_inode)
 			update_dev(dev);
=20
@@ -229,7 +229,7 @@ static void update_sb(struct super_block *sb)
=20
 	mutex_lock_nested(&root->d_inode->i_mutex, I_MUTEX_PARENT);
=20
-	list_for_each_entry(bus, &root->d_subdirs, d_u.d_child) {
+	list_for_each_entry(bus, &root->d_subdirs, d_child) {
 		if (bus->d_inode) {
 			switch (S_IFMT & bus->d_inode->i_mode) {
 			case S_IFDIR:
@@ -345,7 +345,7 @@ static int usbfs_empty (struct dentry *dentry)
=20
 	spin_lock(&dentry->d_lock);
 	list_for_each(list, &dentry->d_subdirs) {
-		struct dentry *de =3D list_entry(list, struct dentry, d_u.d_child);
+		struct dentry *de =3D list_entry(list, struct dentry, d_child);
=20
 		spin_lock_nested(&de->d_lock, DENTRY_D_LOCK_NESTED);
 		if (usbfs_positive(de)) {
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 0b5745e..30d4fa8 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -81,7 +81,7 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct i=
node *inode)
 	spin_lock(&inode->i_lock);
 	/* Directory should have only one entry. */
 	BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
-	dentry =3D list_entry(inode->i_dentry.next, struct dentry, d_alias);
+	dentry =3D list_entry(inode->i_dentry.next, struct dentry, d_u.d_alias);
 	spin_unlock(&inode->i_lock);
 	return dentry;
 }
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index de37ec8..43c05d8 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -132,7 +132,7 @@ affs_fix_dcache(struct dentry *dentry, u32 entry_ino)
 	head =3D &inode->i_dentry;
 	next =3D head->next;
 	while (next !=3D head) {
-		dentry =3D list_entry(next, struct dentry, d_alias);
+		dentry =3D list_entry(next, struct dentry, d_u.d_alias);
 		if (entry_ino =3D=3D (u32)(long)dentry->d_fsdata) {
 			dentry->d_fsdata =3D data;
 			break;
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 2c69d12..7fc0371 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -100,7 +100,7 @@ static struct dentry *get_next_positive_subdir(struct d=
entry *prev,
 	p =3D prev;
 	spin_lock(&p->d_lock);
 again:
-	next =3D p->d_u.d_child.next;
+	next =3D p->d_child.next;
 start:
 	if (next =3D=3D &root->d_subdirs) {
 		spin_unlock(&p->d_lock);
@@ -109,7 +109,7 @@ start:
 		return NULL;
 	}
=20
-	q =3D list_entry(next, struct dentry, d_u.d_child);
+	q =3D list_entry(next, struct dentry, d_child);
=20
 	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Negative dentry - try next */
@@ -165,13 +165,13 @@ again:
 				goto relock;
 			}
 			spin_unlock(&p->d_lock);
-			next =3D p->d_u.d_child.next;
+			next =3D p->d_child.next;
 			p =3D parent;
 			if (next !=3D &parent->d_subdirs)
 				break;
 		}
 	}
-	ret =3D list_entry(next, struct dentry, d_u.d_child);
+	ret =3D list_entry(next, struct dentry, d_child);
=20
 	spin_lock_nested(&ret->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Negative dentry - try next */
@@ -455,7 +455,7 @@ found:
 	spin_lock(&sbi->lookup_lock);
 	spin_lock(&expired->d_parent->d_lock);
 	spin_lock_nested(&expired->d_lock, DENTRY_D_LOCK_NESTED);
-	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
+	list_move(&expired->d_parent->d_subdirs, &expired->d_child);
 	spin_unlock(&expired->d_lock);
 	spin_unlock(&expired->d_parent->d_lock);
 	spin_unlock(&sbi->lookup_lock);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 790fa63..2e936c6 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -651,7 +651,7 @@ static void autofs_clear_leaf_automount_flags(struct de=
ntry *dentry)
 	/* only consider parents below dentrys in the root */
 	if (IS_ROOT(parent->d_parent))
 		return;
-	d_child =3D &dentry->d_u.d_child;
+	d_child =3D &dentry->d_child;
 	/* Set parent managed if it's becoming empty */
 	if (d_child->next =3D=3D &parent->d_subdirs &&
 	    d_child->prev =3D=3D &parent->d_subdirs)
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 9895400..7903e62 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -104,7 +104,7 @@ static unsigned fpos_off(loff_t p)
 /*
  * When possible, we try to satisfy a readdir by peeking at the
  * dcache.  We make this work by carefully ordering dentries on
- * d_u.d_child when we initially get results back from the MDS, and
+ * d_child when we initially get results back from the MDS, and
  * falling back to a "normal" sync readdir if any dentries in the dir
  * are dropped.
  *
@@ -140,11 +140,11 @@ static int __dcache_readdir(struct file *filp,
 		p =3D parent->d_subdirs.prev;
 		dout(" initial p %p/%p\n", p->prev, p->next);
 	} else {
-		p =3D last->d_u.d_child.prev;
+		p =3D last->d_child.prev;
 	}
=20
 more:
-	dentry =3D list_entry(p, struct dentry, d_u.d_child);
+	dentry =3D list_entry(p, struct dentry, d_child);
 	di =3D ceph_dentry(dentry);
 	while (1) {
 		dout(" p %p/%p %s d_subdirs %p/%p\n", p->prev, p->next,
@@ -166,7 +166,7 @@ more:
 		     !dentry->d_inode ? " null" : "");
 		spin_unlock(&dentry->d_lock);
 		p =3D p->prev;
-		dentry =3D list_entry(p, struct dentry, d_u.d_child);
+		dentry =3D list_entry(p, struct dentry, d_child);
 		di =3D ceph_dentry(dentry);
 	}
=20
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 87fb132..8e889b7 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -868,9 +868,9 @@ static void ceph_set_dentry_offset(struct dentry *dn)
=20
 	spin_lock(&dir->d_lock);
 	spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
-	list_move(&dn->d_u.d_child, &dir->d_subdirs);
+	list_move(&dn->d_child, &dir->d_subdirs);
 	dout("set_dentry_offset %p %lld (%p %p)\n", dn, di->offset,
-	     dn->d_u.d_child.prev, dn->d_u.d_child.next);
+	     dn->d_child.prev, dn->d_child.next);
 	spin_unlock(&dn->d_lock);
 	spin_unlock(&dir->d_lock);
 }
@@ -1256,7 +1256,7 @@ retry_lookup:
 			/* reorder parent's d_subdirs */
 			spin_lock(&parent->d_lock);
 			spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
-			list_move(&dn->d_u.d_child, &parent->d_subdirs);
+			list_move(&dn->d_child, &parent->d_subdirs);
 			spin_unlock(&dn->d_lock);
 			spin_unlock(&parent->d_lock);
 		}
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index c0c51e1..710dd05 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -823,7 +823,7 @@ inode_has_hashed_dentries(struct inode *inode)
 	struct dentry *dentry;
=20
 	spin_lock(&inode->i_lock);
-	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+	list_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias) {
 		if (!d_unhashed(dentry) || IS_ROOT(dentry)) {
 			spin_unlock(&inode->i_lock);
 			return true;
diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 6901578..4b2e5cb 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -95,7 +95,7 @@ static void coda_flag_children(struct dentry *parent, int=
 flag)
 	spin_lock(&parent->d_lock);
 	list_for_each(child, &parent->d_subdirs)
 	{
-		de =3D list_entry(child, struct dentry, d_u.d_child);
+		de =3D list_entry(child, struct dentry, d_child);
 		/* don't know what to do with negative dentries */
 		if ( ! de->d_inode )=20
 			continue;
diff --git a/fs/dcache.c b/fs/dcache.c
index d322929..3f65742 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -42,7 +42,7 @@
 /*
  * Usage:
  * dcache->d_inode->i_lock protects:
- *   - i_dentry, d_alias, d_inode of aliases
+ *   - i_dentry, d_u.d_alias, d_inode of aliases
  * dcache_hash_bucket lock protects:
  *   - the dcache hash table
  * s_anon bl list spinlock protects:
@@ -57,7 +57,7 @@
  *   - d_unhashed()
  *   - d_parent and d_subdirs
  *   - childrens' d_child and d_parent
- *   - d_alias, d_inode
+ *   - d_u.d_alias, d_inode
  *
  * Ordering:
  * dentry->d_inode->i_lock
@@ -140,7 +140,6 @@ static void __d_free(struct rcu_head *head)
 {
 	struct dentry *dentry =3D container_of(head, struct dentry, d_u.d_rcu);
=20
-	WARN_ON(!list_empty(&dentry->d_alias));
 	if (dname_external(dentry))
 		kfree(dentry->d_name.name);
 	kmem_cache_free(dentry_cache, dentry);=20
@@ -151,6 +150,7 @@ static void __d_free(struct rcu_head *head)
  */
 static void d_free(struct dentry *dentry)
 {
+	WARN_ON(!list_empty(&dentry->d_u.d_alias));
 	BUG_ON(dentry->d_count);
 	this_cpu_dec(nr_dentry);
 	if (dentry->d_op && dentry->d_op->d_release)
@@ -189,7 +189,7 @@ static void dentry_iput(struct dentry * dentry)
 	struct inode *inode =3D dentry->d_inode;
 	if (inode) {
 		dentry->d_inode =3D NULL;
-		list_del_init(&dentry->d_alias);
+		list_del_init(&dentry->d_u.d_alias);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&inode->i_lock);
 		if (!inode->i_nlink)
@@ -213,7 +213,7 @@ static void dentry_unlink_inode(struct dentry * dentry)
 {
 	struct inode *inode =3D dentry->d_inode;
 	dentry->d_inode =3D NULL;
-	list_del_init(&dentry->d_alias);
+	list_del_init(&dentry->d_u.d_alias);
 	dentry_rcuwalk_barrier(dentry);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&inode->i_lock);
@@ -306,9 +306,9 @@ static struct dentry *d_kill(struct dentry *dentry, str=
uct dentry *parent)
 	__releases(parent->d_lock)
 	__releases(dentry->d_inode->i_lock)
 {
-	list_del(&dentry->d_u.d_child);
+	__list_del_entry(&dentry->d_child);
 	/*
-	 * Inform try_to_ascend() that we are no longer attached to the
+	 * Inform ascending readers that we are no longer attached to the
 	 * dentry tree
 	 */
 	dentry->d_flags |=3D DCACHE_DENTRY_KILLED;
@@ -624,7 +624,7 @@ static struct dentry *__d_find_alias(struct inode *inod=
e, int want_discon)
=20
 again:
 	discon_alias =3D NULL;
-	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
+	list_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
 		spin_lock(&alias->d_lock);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
@@ -677,7 +677,7 @@ void d_prune_aliases(struct inode *inode)
 	struct dentry *dentry;
 restart:
 	spin_lock(&inode->i_lock);
-	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+	list_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
 			__dget_dlock(dentry);
@@ -857,7 +857,7 @@ static void shrink_dcache_for_umount_subtree(struct den=
try *dentry)
 		/* descend to the first leaf in the current subtree */
 		while (!list_empty(&dentry->d_subdirs))
 			dentry =3D list_entry(dentry->d_subdirs.next,
-					    struct dentry, d_u.d_child);
+					    struct dentry, d_child);
=20
 		/* consume the dentries from this leaf up through its parents
 		 * until we find one with children or run out altogether */
@@ -889,17 +889,17 @@ static void shrink_dcache_for_umount_subtree(struct d=
entry *dentry)
=20
 			if (IS_ROOT(dentry)) {
 				parent =3D NULL;
-				list_del(&dentry->d_u.d_child);
+				list_del(&dentry->d_child);
 			} else {
 				parent =3D dentry->d_parent;
 				parent->d_count--;
-				list_del(&dentry->d_u.d_child);
+				list_del(&dentry->d_child);
 			}
=20
 			inode =3D dentry->d_inode;
 			if (inode) {
 				dentry->d_inode =3D NULL;
-				list_del_init(&dentry->d_alias);
+				list_del_init(&dentry->d_u.d_alias);
 				if (dentry->d_op && dentry->d_op->d_iput)
 					dentry->d_op->d_iput(dentry, inode);
 				else
@@ -917,7 +917,7 @@ static void shrink_dcache_for_umount_subtree(struct den=
try *dentry)
 		} while (list_empty(&dentry->d_subdirs));
=20
 		dentry =3D list_entry(dentry->d_subdirs.next,
-				    struct dentry, d_u.d_child);
+				    struct dentry, d_child);
 	}
 }
=20
@@ -949,34 +949,6 @@ void shrink_dcache_for_umount(struct super_block *sb)
 	}
 }
=20
-/*
- * This tries to ascend one level of parenthood, but
- * we can race with renaming, so we need to re-check
- * the parenthood after dropping the lock and check
- * that the sequence number still matches.
- */
-static struct dentry *try_to_ascend(struct dentry *old, int locked, unsign=
ed seq)
-{
-	struct dentry *new =3D old->d_parent;
-
-	rcu_read_lock();
-	spin_unlock(&old->d_lock);
-	spin_lock(&new->d_lock);
-
-	/*
-	 * might go back up the wrong parent if we have had a rename
-	 * or deletion
-	 */
-	if (new !=3D old->d_parent ||
-		 (old->d_flags & DCACHE_DENTRY_KILLED) ||
-		 (!locked && read_seqretry(&rename_lock, seq))) {
-		spin_unlock(&new->d_lock);
-		new =3D NULL;
-	}
-	rcu_read_unlock();
-	return new;
-}
-
=20
 /*
  * Search for at least 1 mount point in the dentry's subdirs.
@@ -1010,7 +982,7 @@ repeat:
 resume:
 	while (next !=3D &this_parent->d_subdirs) {
 		struct list_head *tmp =3D next;
-		struct dentry *dentry =3D list_entry(tmp, struct dentry, d_u.d_child);
+		struct dentry *dentry =3D list_entry(tmp, struct dentry, d_child);
 		next =3D tmp->next;
=20
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
@@ -1032,17 +1004,32 @@ resume:
 	/*
 	 * All done at this level ... ascend and resume the search.
 	 */
+	rcu_read_lock();
+ascend:
 	if (this_parent !=3D parent) {
 		struct dentry *child =3D this_parent;
-		this_parent =3D try_to_ascend(this_parent, locked, seq);
-		if (!this_parent)
+		this_parent =3D child->d_parent;
+
+		spin_unlock(&child->d_lock);
+		spin_lock(&this_parent->d_lock);
+
+		/* might go back up the wrong parent if we have had a rename */
+		if (!locked && read_seqretry(&rename_lock, seq))
 			goto rename_retry;
-		next =3D child->d_u.d_child.next;
+		next =3D child->d_child.next;
+		while (unlikely(child->d_flags & DCACHE_DENTRY_KILLED)) {
+			if (next =3D=3D &this_parent->d_subdirs)
+				goto ascend;
+			child =3D list_entry(next, struct dentry, d_child);
+			next =3D next->next;
+		}
+		rcu_read_unlock();
 		goto resume;
 	}
-	spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (locked)
 		write_sequnlock(&rename_lock);
 	return 0; /* No mount points found in tree */
@@ -1054,6 +1041,8 @@ positive:
 	return 1;
=20
 rename_retry:
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (locked)
 		goto again;
 	locked =3D 1;
@@ -1093,7 +1082,7 @@ repeat:
 resume:
 	while (next !=3D &this_parent->d_subdirs) {
 		struct list_head *tmp =3D next;
-		struct dentry *dentry =3D list_entry(tmp, struct dentry, d_u.d_child);
+		struct dentry *dentry =3D list_entry(tmp, struct dentry, d_child);
 		next =3D tmp->next;
=20
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
@@ -1139,23 +1128,40 @@ resume:
 	/*
 	 * All done at this level ... ascend and resume the search.
 	 */
+	rcu_read_lock();
+ascend:
 	if (this_parent !=3D parent) {
 		struct dentry *child =3D this_parent;
-		this_parent =3D try_to_ascend(this_parent, locked, seq);
-		if (!this_parent)
+		this_parent =3D child->d_parent;
+
+		spin_unlock(&child->d_lock);
+		spin_lock(&this_parent->d_lock);
+
+		/* might go back up the wrong parent if we have had a rename */
+		if (!locked && read_seqretry(&rename_lock, seq))
 			goto rename_retry;
-		next =3D child->d_u.d_child.next;
+		next =3D child->d_child.next;
+		while (unlikely(child->d_flags & DCACHE_DENTRY_KILLED)) {
+			if (next =3D=3D &this_parent->d_subdirs)
+				goto ascend;
+			child =3D list_entry(next, struct dentry, d_child);
+			next =3D next->next;
+		}
+		rcu_read_unlock();
 		goto resume;
 	}
 out:
-	spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (locked)
 		write_sequnlock(&rename_lock);
 	return found;
=20
 rename_retry:
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (found)
 		return found;
 	if (locked)
@@ -1230,8 +1236,8 @@ struct dentry *__d_alloc(struct super_block *sb, cons=
t struct qstr *name)
 	INIT_HLIST_BL_NODE(&dentry->d_hash);
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
-	INIT_LIST_HEAD(&dentry->d_alias);
-	INIT_LIST_HEAD(&dentry->d_u.d_child);
+	INIT_LIST_HEAD(&dentry->d_u.d_alias);
+	INIT_LIST_HEAD(&dentry->d_child);
 	d_set_d_op(dentry, dentry->d_sb->s_d_op);
=20
 	this_cpu_inc(nr_dentry);
@@ -1261,7 +1267,7 @@ struct dentry *d_alloc(struct dentry * parent, const =
struct qstr *name)
 	 */
 	__dget_dlock(parent);
 	dentry->d_parent =3D parent;
-	list_add(&dentry->d_u.d_child, &parent->d_subdirs);
+	list_add(&dentry->d_child, &parent->d_subdirs);
 	spin_unlock(&parent->d_lock);
=20
 	return dentry;
@@ -1318,7 +1324,7 @@ static void __d_instantiate(struct dentry *dentry, st=
ruct inode *inode)
 	if (inode) {
 		if (unlikely(IS_AUTOMOUNT(inode)))
 			dentry->d_flags |=3D DCACHE_NEED_AUTOMOUNT;
-		list_add(&dentry->d_alias, &inode->i_dentry);
+		list_add(&dentry->d_u.d_alias, &inode->i_dentry);
 	}
 	dentry->d_inode =3D inode;
 	dentry_rcuwalk_barrier(dentry);
@@ -1343,7 +1349,7 @@ static void __d_instantiate(struct dentry *dentry, st=
ruct inode *inode)
 =20
 void d_instantiate(struct dentry *entry, struct inode * inode)
 {
-	BUG_ON(!list_empty(&entry->d_alias));
+	BUG_ON(!list_empty(&entry->d_u.d_alias));
 	if (inode)
 		spin_lock(&inode->i_lock);
 	__d_instantiate(entry, inode);
@@ -1382,7 +1388,7 @@ static struct dentry *__d_instantiate_unique(struct d=
entry *entry,
 		return NULL;
 	}
=20
-	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
+	list_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
 		struct qstr *qstr =3D &alias->d_name;
=20
 		/*
@@ -1408,7 +1414,7 @@ struct dentry *d_instantiate_unique(struct dentry *en=
try, struct inode *inode)
 {
 	struct dentry *result;
=20
-	BUG_ON(!list_empty(&entry->d_alias));
+	BUG_ON(!list_empty(&entry->d_u.d_alias));
=20
 	if (inode)
 		spin_lock(&inode->i_lock);
@@ -1458,7 +1464,7 @@ static struct dentry * __d_find_any_alias(struct inod=
e *inode)
=20
 	if (list_empty(&inode->i_dentry))
 		return NULL;
-	alias =3D list_first_entry(&inode->i_dentry, struct dentry, d_alias);
+	alias =3D list_first_entry(&inode->i_dentry, struct dentry, d_u.d_alias);
 	__dget(alias);
 	return alias;
 }
@@ -1525,7 +1531,7 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	spin_lock(&tmp->d_lock);
 	tmp->d_inode =3D inode;
 	tmp->d_flags |=3D DCACHE_DISCONNECTED;
-	list_add(&tmp->d_alias, &inode->i_dentry);
+	list_add(&tmp->d_u.d_alias, &inode->i_dentry);
 	hlist_bl_lock(&tmp->d_sb->s_anon);
 	hlist_bl_add_head(&tmp->d_hash, &tmp->d_sb->s_anon);
 	hlist_bl_unlock(&tmp->d_sb->s_anon);
@@ -1931,7 +1937,7 @@ int d_validate(struct dentry *dentry, struct dentry *=
dparent)
 	struct dentry *child;
=20
 	spin_lock(&dparent->d_lock);
-	list_for_each_entry(child, &dparent->d_subdirs, d_u.d_child) {
+	list_for_each_entry(child, &dparent->d_subdirs, d_child) {
 		if (dentry =3D=3D child) {
 			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 			__dget_dlock(dentry);
@@ -2178,8 +2184,8 @@ static void __d_move(struct dentry * dentry, struct d=
entry * target)
 	/* Unhash the target: dput() will then get rid of it */
 	__d_drop(target);
=20
-	list_del(&dentry->d_u.d_child);
-	list_del(&target->d_u.d_child);
+	list_del(&dentry->d_child);
+	list_del(&target->d_child);
=20
 	/* Switch the names.. */
 	switch_names(dentry, target);
@@ -2189,15 +2195,15 @@ static void __d_move(struct dentry * dentry, struct=
 dentry * target)
 	if (IS_ROOT(dentry)) {
 		dentry->d_parent =3D target->d_parent;
 		target->d_parent =3D target;
-		INIT_LIST_HEAD(&target->d_u.d_child);
+		INIT_LIST_HEAD(&target->d_child);
 	} else {
 		swap(dentry->d_parent, target->d_parent);
=20
 		/* And add them back to the (new) parent lists */
-		list_add(&target->d_u.d_child, &target->d_parent->d_subdirs);
+		list_add(&target->d_child, &target->d_parent->d_subdirs);
 	}
=20
-	list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
+	list_add(&dentry->d_child, &dentry->d_parent->d_subdirs);
=20
 	write_seqcount_end(&target->d_seq);
 	write_seqcount_end(&dentry->d_seq);
@@ -2304,18 +2310,18 @@ static void __d_materialise_dentry(struct dentry *d=
entry, struct dentry *anon)
 	swap(dentry->d_name.hash, anon->d_name.hash);
=20
 	dentry->d_parent =3D (aparent =3D=3D anon) ? dentry : aparent;
-	list_del(&dentry->d_u.d_child);
+	list_del(&dentry->d_child);
 	if (!IS_ROOT(dentry))
-		list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
+		list_add(&dentry->d_child, &dentry->d_parent->d_subdirs);
 	else
-		INIT_LIST_HEAD(&dentry->d_u.d_child);
+		INIT_LIST_HEAD(&dentry->d_child);
=20
 	anon->d_parent =3D (dparent =3D=3D dentry) ? anon : dparent;
-	list_del(&anon->d_u.d_child);
+	list_del(&anon->d_child);
 	if (!IS_ROOT(anon))
-		list_add(&anon->d_u.d_child, &anon->d_parent->d_subdirs);
+		list_add(&anon->d_child, &anon->d_parent->d_subdirs);
 	else
-		INIT_LIST_HEAD(&anon->d_u.d_child);
+		INIT_LIST_HEAD(&anon->d_child);
=20
 	write_seqcount_end(&dentry->d_seq);
 	write_seqcount_end(&anon->d_seq);
@@ -2893,7 +2899,7 @@ repeat:
 resume:
 	while (next !=3D &this_parent->d_subdirs) {
 		struct list_head *tmp =3D next;
-		struct dentry *dentry =3D list_entry(tmp, struct dentry, d_u.d_child);
+		struct dentry *dentry =3D list_entry(tmp, struct dentry, d_child);
 		next =3D tmp->next;
=20
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
@@ -2914,26 +2920,43 @@ resume:
 		}
 		spin_unlock(&dentry->d_lock);
 	}
+	rcu_read_lock();
+ascend:
 	if (this_parent !=3D root) {
 		struct dentry *child =3D this_parent;
 		if (!(this_parent->d_flags & DCACHE_GENOCIDE)) {
 			this_parent->d_flags |=3D DCACHE_GENOCIDE;
 			this_parent->d_count--;
 		}
-		this_parent =3D try_to_ascend(this_parent, locked, seq);
-		if (!this_parent)
+		this_parent =3D child->d_parent;
+
+		spin_unlock(&child->d_lock);
+		spin_lock(&this_parent->d_lock);
+
+		/* might go back up the wrong parent if we have had a rename */
+		if (!locked && read_seqretry(&rename_lock, seq))
 			goto rename_retry;
-		next =3D child->d_u.d_child.next;
+		next =3D child->d_child.next;
+		while (unlikely(child->d_flags & DCACHE_DENTRY_KILLED)) {
+			if (next =3D=3D &this_parent->d_subdirs)
+				goto ascend;
+			child =3D list_entry(next, struct dentry, d_child);
+			next =3D next->next;
+		}
+		rcu_read_unlock();
 		goto resume;
 	}
-	spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (locked)
 		write_sequnlock(&rename_lock);
 	return;
=20
 rename_retry:
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (locked)
 		goto again;
 	locked =3D 1;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 01951c6b..6ac0893 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -399,7 +399,7 @@ void debugfs_remove_recursive(struct dentry *dentry)
 	 * use the d_u.d_child as the rcu head and corrupt this list.
 	 */
 	spin_lock(&parent->d_lock);
-	list_for_each_entry(child, &parent->d_subdirs, d_u.d_child) {
+	list_for_each_entry(child, &parent->d_subdirs, d_child) {
 		if (!debugfs_positive(child))
 			continue;
=20
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index b05acb7..3bbf5e7 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -50,7 +50,7 @@ find_acceptable_alias(struct dentry *result,
=20
 	inode =3D result->d_inode;
 	spin_lock(&inode->i_lock);
-	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+	list_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias) {
 		dget(dentry);
 		spin_unlock(&inode->i_lock);
 		if (toput)
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index a8d03a4..019c29c 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -139,7 +139,7 @@ static int ext4_sync_parent(struct inode *inode)
 		spin_lock(&inode->i_lock);
 		if (!list_empty(&inode->i_dentry)) {
 			dentry =3D list_first_entry(&inode->i_dentry,
-						  struct dentry, d_alias);
+						  struct dentry, d_u.d_alias);
 			dget(dentry);
 		}
 		spin_unlock(&inode->i_lock);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cd39fa7..c9f2e3d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1986,7 +1986,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *i=
node)
 	struct ext4_iloc iloc;
 	int err =3D 0, rc;
=20
-	if (!ext4_handle_valid(handle) || is_bad_inode(inode))
+	if (!EXT4_SB(sb)->s_journal || is_bad_inode(inode))
 		return 0;
=20
 	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
@@ -2060,8 +2060,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *i=
node)
 	struct ext4_iloc iloc;
 	int err =3D 0;
=20
-	/* ext4_handle_valid() assumes a valid handle_t pointer */
-	if (handle && !ext4_handle_valid(handle) &&
+	if (!EXT4_SB(inode->i_sb)->s_journal &&
 	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
=20
@@ -2081,7 +2080,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *i=
node)
 	 * transaction handle with which to update the orphan list on
 	 * disk, but we still need to remove the inode from the linked
 	 * list in memory. */
-	if (sbi->s_journal && !handle)
+	if (!handle)
 		goto out;
=20
 	err =3D ext4_reserve_inode_write(handle, inode, &iloc);
diff --git a/fs/libfs.c b/fs/libfs.c
index f6d411e..ce85edf 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -104,18 +104,18 @@ loff_t dcache_dir_lseek(struct file *file, loff_t off=
set, int origin)
=20
 			spin_lock(&dentry->d_lock);
 			/* d_lock not required for cursor */
-			list_del(&cursor->d_u.d_child);
+			list_del(&cursor->d_child);
 			p =3D dentry->d_subdirs.next;
 			while (n && p !=3D &dentry->d_subdirs) {
 				struct dentry *next;
-				next =3D list_entry(p, struct dentry, d_u.d_child);
+				next =3D list_entry(p, struct dentry, d_child);
 				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				if (simple_positive(next))
 					n--;
 				spin_unlock(&next->d_lock);
 				p =3D p->next;
 			}
-			list_add_tail(&cursor->d_u.d_child, p);
+			list_add_tail(&cursor->d_child, p);
 			spin_unlock(&dentry->d_lock);
 		}
 	}
@@ -139,7 +139,7 @@ int dcache_readdir(struct file * filp, void * dirent, f=
illdir_t filldir)
 {
 	struct dentry *dentry =3D filp->f_path.dentry;
 	struct dentry *cursor =3D filp->private_data;
-	struct list_head *p, *q =3D &cursor->d_u.d_child;
+	struct list_head *p, *q =3D &cursor->d_child;
 	ino_t ino;
 	int i =3D filp->f_pos;
=20
@@ -165,7 +165,7 @@ int dcache_readdir(struct file * filp, void * dirent, f=
illdir_t filldir)
=20
 			for (p=3Dq->next; p !=3D &dentry->d_subdirs; p=3Dp->next) {
 				struct dentry *next;
-				next =3D list_entry(p, struct dentry, d_u.d_child);
+				next =3D list_entry(p, struct dentry, d_child);
 				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				if (!simple_positive(next)) {
 					spin_unlock(&next->d_lock);
@@ -282,7 +282,7 @@ int simple_empty(struct dentry *dentry)
 	int ret =3D 0;
=20
 	spin_lock(&dentry->d_lock);
-	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
+	list_for_each_entry(child, &dentry->d_subdirs, d_child) {
 		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 		if (simple_positive(child)) {
 			spin_unlock(&child->d_lock);
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 844bd64..efa38a9 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -391,7 +391,7 @@ ncp_dget_fpos(struct dentry *dentry, struct dentry *par=
ent, unsigned long fpos)
 	spin_lock(&parent->d_lock);
 	next =3D parent->d_subdirs.next;
 	while (next !=3D &parent->d_subdirs) {
-		dent =3D list_entry(next, struct dentry, d_u.d_child);
+		dent =3D list_entry(next, struct dentry, d_child);
 		if ((unsigned long)dent->d_fsdata =3D=3D fpos) {
 			if (dent->d_inode)
 				dget(dent);
diff --git a/fs/ncpfs/ncplib_kernel.h b/fs/ncpfs/ncplib_kernel.h
index 09881e6..64a817a 100644
--- a/fs/ncpfs/ncplib_kernel.h
+++ b/fs/ncpfs/ncplib_kernel.h
@@ -194,7 +194,7 @@ ncp_renew_dentries(struct dentry *parent)
 	spin_lock(&parent->d_lock);
 	next =3D parent->d_subdirs.next;
 	while (next !=3D &parent->d_subdirs) {
-		dentry =3D list_entry(next, struct dentry, d_u.d_child);
+		dentry =3D list_entry(next, struct dentry, d_child);
=20
 		if (dentry->d_fsdata =3D=3D NULL)
 			ncp_age_dentry(server, dentry);
@@ -216,7 +216,7 @@ ncp_invalidate_dircache_entries(struct dentry *parent)
 	spin_lock(&parent->d_lock);
 	next =3D parent->d_subdirs.next;
 	while (next !=3D &parent->d_subdirs) {
-		dentry =3D list_entry(next, struct dentry, d_u.d_child);
+		dentry =3D list_entry(next, struct dentry, d_child);
 		dentry->d_fsdata =3D NULL;
 		ncp_age_dentry(server, dentry);
 		next =3D next->next;
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index dcb6154..d7abf9e 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -65,7 +65,7 @@ static int nfs_superblock_set_dummy_root(struct super_blo=
ck *sb, struct inode *i
 		 */
 		spin_lock(&sb->s_root->d_inode->i_lock);
 		spin_lock(&sb->s_root->d_lock);
-		list_del_init(&sb->s_root->d_alias);
+		list_del_init(&sb->s_root->d_u.d_alias);
 		spin_unlock(&sb->s_root->d_lock);
 		spin_unlock(&sb->s_root->d_inode->i_lock);
 	}
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 79b47cb..f8ea28f 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -62,14 +62,14 @@ void __fsnotify_update_child_dentry_flags(struct inode =
*inode)
 	spin_lock(&inode->i_lock);
 	/* run all of the dentries associated with this inode.  Since this is a
 	 * directory, there damn well better only be one item on this list */
-	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
+	list_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
 		struct dentry *child;
=20
 		/* run all of the children of the original inode and fix their
 		 * d_flags to indicate parental interest (their parent is the
 		 * original inode) */
 		spin_lock(&alias->d_lock);
-		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
+		list_for_each_entry(child, &alias->d_subdirs, d_child) {
 			if (!child->d_inode)
 				continue;
=20
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index e5ba348..26977cc 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -175,7 +175,7 @@ struct dentry *ocfs2_find_local_alias(struct inode *ino=
de,
=20
 	spin_lock(&inode->i_lock);
 	list_for_each(p, &inode->i_dentry) {
-		dentry =3D list_entry(p, struct dentry, d_alias);
+		dentry =3D list_entry(p, struct dentry, d_u.d_alias);
=20
 		spin_lock(&dentry->d_lock);
 		if (ocfs2_match_dentry(dentry, parent_blkno, skip_unhashed)) {
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index af37ce3..a0f6ded 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1176,13 +1176,22 @@ update_time:
 	return 0;
 }
=20
+/*
+ * Maximum length of linked list formed by ICB hierarchy. The chosen numbe=
r is
+ * arbitrary - just that we hopefully don't limit any real use of rewritte=
n
+ * inode on write-once media but avoid looping for too long on corrupted m=
edia.
+ */
+#define UDF_MAX_ICB_NESTING 1024
+
 static void __udf_read_inode(struct inode *inode)
 {
 	struct buffer_head *bh =3D NULL;
 	struct fileEntry *fe;
 	uint16_t ident;
 	struct udf_inode_info *iinfo =3D UDF_I(inode);
+	unsigned int indirections =3D 0;
=20
+reread:
 	/*
 	 * Set defaults, but the inode is still incomplete!
 	 * Note: get_new_inode() sets the following on a new inode:
@@ -1219,28 +1228,26 @@ static void __udf_read_inode(struct inode *inode)
 		ibh =3D udf_read_ptagged(inode->i_sb, &iinfo->i_location, 1,
 					&ident);
 		if (ident =3D=3D TAG_IDENT_IE && ibh) {
-			struct buffer_head *nbh =3D NULL;
 			struct kernel_lb_addr loc;
 			struct indirectEntry *ie;
=20
 			ie =3D (struct indirectEntry *)ibh->b_data;
 			loc =3D lelb_to_cpu(ie->indirectICB.extLocation);
=20
-			if (ie->indirectICB.extLength &&
-				(nbh =3D udf_read_ptagged(inode->i_sb, &loc, 0,
-							&ident))) {
-				if (ident =3D=3D TAG_IDENT_FE ||
-					ident =3D=3D TAG_IDENT_EFE) {
-					memcpy(&iinfo->i_location,
-						&loc,
-						sizeof(struct kernel_lb_addr));
-					brelse(bh);
-					brelse(ibh);
-					brelse(nbh);
-					__udf_read_inode(inode);
+			if (ie->indirectICB.extLength) {
+				brelse(bh);
+				brelse(ibh);
+				memcpy(&iinfo->i_location, &loc,
+				       sizeof(struct kernel_lb_addr));
+				if (++indirections > UDF_MAX_ICB_NESTING) {
+					udf_err(inode->i_sb,
+						"too many ICBs in ICB hierarchy"
+						" (max %d supported)\n",
+						UDF_MAX_ICB_NESTING);
+					make_bad_inode(inode);
 					return;
 				}
-				brelse(nbh);
+				goto reread;
 			}
 		}
 		brelse(ibh);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 1dfe974..99374de 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -133,15 +133,15 @@ struct dentry {
 	void *d_fsdata;			/* fs-specific data */
=20
 	struct list_head d_lru;		/* LRU list */
+	struct list_head d_child;	/* child of parent list */
+	struct list_head d_subdirs;	/* our children */
 	/*
-	 * d_child and d_rcu can share memory
+	 * d_alias and d_rcu can share memory
 	 */
 	union {
-		struct list_head d_child;	/* child of parent list */
+		struct list_head d_alias;	/* inode alias list */
 	 	struct rcu_head d_rcu;
 	} d_u;
-	struct list_head d_subdirs;	/* our children */
-	struct list_head d_alias;	/* inode alias list */
 };
=20
 /*
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 00a2eb6..ab2e6d7 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -481,6 +481,7 @@ static inline int ipv6_addr_diff(const struct in6_addr =
*a1, const struct in6_add
 }
=20
 extern void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt);
+void ipv6_proxy_select_ident(struct sk_buff *skb);
=20
 /*
  *	Prototypes exported by ipv6
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 238255b..e90235f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1214,11 +1214,13 @@ extern int tcp_v4_md5_do_del(struct sock *sk, __be3=
2 addr);
 #define tcp_twsk_md5_key(twsk)	NULL
 #endif
=20
-extern struct tcp_md5sig_pool __percpu *tcp_alloc_md5sig_pool(struct sock =
*);
-extern void tcp_free_md5sig_pool(void);
+extern bool tcp_alloc_md5sig_pool(void);
=20
 extern struct tcp_md5sig_pool	*tcp_get_md5sig_pool(void);
-extern void tcp_put_md5sig_pool(void);
+static inline void tcp_put_md5sig_pool(void)
+{
+	local_bh_enable();
+}
=20
 extern int tcp_md5_hash_header(struct tcp_md5sig_pool *, const struct tcph=
dr *);
 extern int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *, const struct sk=
_buff *,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ffcf896..eafb6dd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -881,7 +881,7 @@ static void cgroup_clear_directory(struct dentry *dentr=
y)
 	spin_lock(&dentry->d_lock);
 	node =3D dentry->d_subdirs.next;
 	while (node !=3D &dentry->d_subdirs) {
-		struct dentry *d =3D list_entry(node, struct dentry, d_u.d_child);
+		struct dentry *d =3D list_entry(node, struct dentry, d_child);
=20
 		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
 		list_del_init(node);
@@ -915,7 +915,7 @@ static void cgroup_d_remove_dir(struct dentry *dentry)
 	parent =3D dentry->d_parent;
 	spin_lock(&parent->d_lock);
 	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
-	list_del_init(&dentry->d_u.d_child);
+	list_del_init(&dentry->d_child);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&parent->d_lock);
 	remove_dir(dentry);
diff --git a/mm/memory.c b/mm/memory.c
index 5a7f314..628cadc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -870,20 +870,20 @@ copy_one_pte(struct mm_struct *dst_mm, struct mm_stru=
ct *src_mm,
 		if (!pte_file(pte)) {
 			swp_entry_t entry =3D pte_to_swp_entry(pte);
=20
-			if (swap_duplicate(entry) < 0)
-				return entry.val;
-
-			/* make sure dst_mm is on swapoff's mmlist. */
-			if (unlikely(list_empty(&dst_mm->mmlist))) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&dst_mm->mmlist))
-					list_add(&dst_mm->mmlist,
-						 &src_mm->mmlist);
-				spin_unlock(&mmlist_lock);
-			}
-			if (likely(!non_swap_entry(entry)))
+			if (likely(!non_swap_entry(entry))) {
+				if (swap_duplicate(entry) < 0)
+					return entry.val;
+
+				/* make sure dst_mm is on swapoff's mmlist. */
+				if (unlikely(list_empty(&dst_mm->mmlist))) {
+					spin_lock(&mmlist_lock);
+					if (list_empty(&dst_mm->mmlist))
+						list_add(&dst_mm->mmlist,
+							 &src_mm->mmlist);
+					spin_unlock(&mmlist_lock);
+				}
 				rss[MM_SWAPENTS]++;
-			else if (is_write_migration_entry(entry) &&
+			} else if (is_write_migration_entry(entry) &&
 					is_cow_mapping(vm_flags)) {
 				/*
 				 * COW mappings require pages in both parent
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 76da979..1cdb4a9 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -467,7 +467,7 @@ int fib_nh_match(struct fib_config *cfg, struct fib_inf=
o *fi)
 			return 1;
=20
 		attrlen =3D rtnh_attrlen(rtnh);
-		if (attrlen < 0) {
+		if (attrlen > 0) {
 			struct nlattr *nla, *attrs =3D rtnh_attrs(rtnh);
=20
 			nla =3D nla_find(attrs, attrlen, RTA_GATEWAY);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 115157b..bf2e54b 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1472,6 +1472,7 @@ void ip_send_reply(struct sock *sk, struct sk_buff *s=
kb, __be32 daddr,
 	struct ipcm_cookie ipc;
 	struct flowi4 fl4;
 	struct rtable *rt =3D skb_rtable(skb);
+	int err;
=20
 	if (ip_options_echo(&replyopts.opt.opt, skb))
 		return;
@@ -1509,8 +1510,13 @@ void ip_send_reply(struct sock *sk, struct sk_buff *=
skb, __be32 daddr,
 	sk->sk_priority =3D skb->priority;
 	sk->sk_protocol =3D ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if =3D arg->bound_dev_if;
-	ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base, len, 0,
-		       &ipc, &rt, MSG_DONTWAIT);
+	err =3D ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
+			     len, 0, &ipc, &rt, MSG_DONTWAIT);
+	if (unlikely(err)) {
+		ip_flush_pending_frames(sk);
+		goto out;
+	}
+
 	if ((skb =3D skb_peek(&sk->sk_write_queue)) !=3D NULL) {
 		if (arg->csumoffset >=3D 0)
 			*((__sum16 *)skb_transport_header(skb) +
@@ -1519,7 +1525,7 @@ void ip_send_reply(struct sock *sk, struct sk_buff *s=
kb, __be32 daddr,
 		skb->ip_summed =3D CHECKSUM_NONE;
 		ip_push_pending_frames(sk, &fl4);
 	}
-
+out:
 	bh_unlock_sock(sk);
=20
 	ip_rt_put(rt);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ec8b4b7e..32c9e83 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2863,104 +2863,42 @@ int tcp_gro_complete(struct sk_buff *skb)
 EXPORT_SYMBOL(tcp_gro_complete);
=20
 #ifdef CONFIG_TCP_MD5SIG
-static unsigned long tcp_md5sig_users;
-static struct tcp_md5sig_pool __percpu *tcp_md5sig_pool;
-static DEFINE_SPINLOCK(tcp_md5sig_pool_lock);
+static DEFINE_PER_CPU(struct tcp_md5sig_pool, tcp_md5sig_pool);
+static DEFINE_MUTEX(tcp_md5sig_mutex);
+static bool tcp_md5sig_pool_populated =3D false;
=20
-static void __tcp_free_md5sig_pool(struct tcp_md5sig_pool __percpu *pool)
+static void __tcp_alloc_md5sig_pool(void)
 {
 	int cpu;
=20
 	for_each_possible_cpu(cpu) {
-		struct tcp_md5sig_pool *p =3D per_cpu_ptr(pool, cpu);
+		if (!per_cpu(tcp_md5sig_pool, cpu).md5_desc.tfm) {
+			struct crypto_hash *hash;
=20
-		if (p->md5_desc.tfm)
-			crypto_free_hash(p->md5_desc.tfm);
-	}
-	free_percpu(pool);
-}
-
-void tcp_free_md5sig_pool(void)
-{
-	struct tcp_md5sig_pool __percpu *pool =3D NULL;
-
-	spin_lock_bh(&tcp_md5sig_pool_lock);
-	if (--tcp_md5sig_users =3D=3D 0) {
-		pool =3D tcp_md5sig_pool;
-		tcp_md5sig_pool =3D NULL;
+			hash =3D crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
+			if (IS_ERR_OR_NULL(hash))
+				return;
+			per_cpu(tcp_md5sig_pool, cpu).md5_desc.tfm =3D hash;
+		}
 	}
-	spin_unlock_bh(&tcp_md5sig_pool_lock);
-	if (pool)
-		__tcp_free_md5sig_pool(pool);
+	/* before setting tcp_md5sig_pool_populated, we must commit all writes
+	 * to memory. See smp_rmb() in tcp_get_md5sig_pool()
+	 */
+	smp_wmb();
+	tcp_md5sig_pool_populated =3D true;
 }
-EXPORT_SYMBOL(tcp_free_md5sig_pool);
=20
-static struct tcp_md5sig_pool __percpu *
-__tcp_alloc_md5sig_pool(struct sock *sk)
+bool tcp_alloc_md5sig_pool(void)
 {
-	int cpu;
-	struct tcp_md5sig_pool __percpu *pool;
-
-	pool =3D alloc_percpu(struct tcp_md5sig_pool);
-	if (!pool)
-		return NULL;
-
-	for_each_possible_cpu(cpu) {
-		struct crypto_hash *hash;
+	if (unlikely(!tcp_md5sig_pool_populated)) {
+		mutex_lock(&tcp_md5sig_mutex);
=20
-		hash =3D crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
-		if (!hash || IS_ERR(hash))
-			goto out_free;
+		if (!tcp_md5sig_pool_populated)
+			__tcp_alloc_md5sig_pool();
=20
-		per_cpu_ptr(pool, cpu)->md5_desc.tfm =3D hash;
+		mutex_unlock(&tcp_md5sig_mutex);
 	}
-	return pool;
-out_free:
-	__tcp_free_md5sig_pool(pool);
-	return NULL;
-}
-
-struct tcp_md5sig_pool __percpu *tcp_alloc_md5sig_pool(struct sock *sk)
-{
-	struct tcp_md5sig_pool __percpu *pool;
-	int alloc =3D 0;
-
-retry:
-	spin_lock_bh(&tcp_md5sig_pool_lock);
-	pool =3D tcp_md5sig_pool;
-	if (tcp_md5sig_users++ =3D=3D 0) {
-		alloc =3D 1;
-		spin_unlock_bh(&tcp_md5sig_pool_lock);
-	} else if (!pool) {
-		tcp_md5sig_users--;
-		spin_unlock_bh(&tcp_md5sig_pool_lock);
-		cpu_relax();
-		goto retry;
-	} else
-		spin_unlock_bh(&tcp_md5sig_pool_lock);
-
-	if (alloc) {
-		/* we cannot hold spinlock here because this may sleep. */
-		struct tcp_md5sig_pool __percpu *p;
-
-		p =3D __tcp_alloc_md5sig_pool(sk);
-		spin_lock_bh(&tcp_md5sig_pool_lock);
-		if (!p) {
-			tcp_md5sig_users--;
-			spin_unlock_bh(&tcp_md5sig_pool_lock);
-			return NULL;
-		}
-		pool =3D tcp_md5sig_pool;
-		if (pool) {
-			/* oops, it has already been assigned. */
-			spin_unlock_bh(&tcp_md5sig_pool_lock);
-			__tcp_free_md5sig_pool(p);
-		} else {
-			tcp_md5sig_pool =3D pool =3D p;
-			spin_unlock_bh(&tcp_md5sig_pool_lock);
-		}
-	}
-	return pool;
+	return tcp_md5sig_pool_populated;
 }
 EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
=20
@@ -2974,31 +2912,18 @@ EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
  */
 struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
 {
-	struct tcp_md5sig_pool __percpu *p;
-
 	local_bh_disable();
=20
-	spin_lock(&tcp_md5sig_pool_lock);
-	p =3D tcp_md5sig_pool;
-	if (p)
-		tcp_md5sig_users++;
-	spin_unlock(&tcp_md5sig_pool_lock);
-
-	if (p)
-		return this_cpu_ptr(p);
-
+	if (tcp_md5sig_pool_populated) {
+		/* coupled with smp_wmb() in __tcp_alloc_md5sig_pool() */
+		smp_rmb();
+		return this_cpu_ptr(&tcp_md5sig_pool);
+	}
 	local_bh_enable();
 	return NULL;
 }
 EXPORT_SYMBOL(tcp_get_md5sig_pool);
=20
-void tcp_put_md5sig_pool(void)
-{
-	local_bh_enable();
-	tcp_free_md5sig_pool();
-}
-EXPORT_SYMBOL(tcp_put_md5sig_pool);
-
 int tcp_md5_hash_header(struct tcp_md5sig_pool *hp,
 			const struct tcphdr *th)
 {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 26eb8e2..b4e0eb4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -938,8 +938,7 @@ int tcp_v4_md5_do_add(struct sock *sk, __be32 addr,
 		}
=20
 		md5sig =3D tp->md5sig_info;
-		if (md5sig->entries4 =3D=3D 0 &&
-		    tcp_alloc_md5sig_pool(sk) =3D=3D NULL) {
+		if (md5sig->entries4 =3D=3D 0 && !tcp_alloc_md5sig_pool()) {
 			kfree(newkey);
 			return -ENOMEM;
 		}
@@ -949,8 +948,6 @@ int tcp_v4_md5_do_add(struct sock *sk, __be32 addr,
 					(md5sig->entries4 + 1)), GFP_ATOMIC);
 			if (!keys) {
 				kfree(newkey);
-				if (md5sig->entries4 =3D=3D 0)
-					tcp_free_md5sig_pool();
 				return -ENOMEM;
 			}
=20
@@ -994,7 +991,6 @@ int tcp_v4_md5_do_del(struct sock *sk, __be32 addr)
 				kfree(tp->md5sig_info->keys4);
 				tp->md5sig_info->keys4 =3D NULL;
 				tp->md5sig_info->alloced4 =3D 0;
-				tcp_free_md5sig_pool();
 			} else if (tp->md5sig_info->entries4 !=3D i) {
 				/* Need to do some manipulation */
 				memmove(&tp->md5sig_info->keys4[i],
@@ -1022,7 +1018,6 @@ static void tcp_v4_clear_md5_list(struct sock *sk)
 		for (i =3D 0; i < tp->md5sig_info->entries4; i++)
 			kfree(tp->md5sig_info->keys4[i].base.key);
 		tp->md5sig_info->entries4 =3D 0;
-		tcp_free_md5sig_pool();
 	}
 	if (tp->md5sig_info->keys4) {
 		kfree(tp->md5sig_info->keys4);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 66363b6..00e1530 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -365,7 +365,7 @@ void tcp_time_wait(struct sock *sk, int state, int time=
o)
 			if (key !=3D NULL) {
 				memcpy(&tcptw->tw_md5_key, key->key, key->keylen);
 				tcptw->tw_md5_keylen =3D key->keylen;
-				if (tcp_alloc_md5sig_pool(sk) =3D=3D NULL)
+				if (!tcp_alloc_md5sig_pool())
 					BUG();
 			}
 		} while (0);
@@ -403,11 +403,6 @@ void tcp_time_wait(struct sock *sk, int state, int tim=
eo)
=20
 void tcp_twsk_destructor(struct sock *sk)
 {
-#ifdef CONFIG_TCP_MD5SIG
-	struct tcp_timewait_sock *twsk =3D tcp_twsk(sk);
-	if (twsk->tw_md5_keylen)
-		tcp_free_md5sig_pool();
-#endif
 }
 EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
=20
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 686934a..4b20d56 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -37,6 +37,6 @@ obj-$(CONFIG_NETFILTER)	+=3D netfilter/
 obj-$(CONFIG_IPV6_SIT) +=3D sit.o
 obj-$(CONFIG_IPV6_TUNNEL) +=3D ip6_tunnel.o
=20
-obj-y +=3D addrconf_core.o exthdrs_core.o
+obj-y +=3D addrconf_core.o exthdrs_core.o output_core.o
=20
 obj-$(subst m,y,$(CONFIG_IPV6)) +=3D inet6_hashtables.o
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
new file mode 100644
index 0000000..a6126c6
--- /dev/null
+++ b/net/ipv6/output_core.c
@@ -0,0 +1,38 @@
+#include <linux/export.h>
+#include <linux/skbuff.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
+
+/* This function exists only for tap drivers that must support broken
+ * clients requesting UFO without specifying an IPv6 fragment ID.
+ *
+ * This is similar to ipv6_select_ident() but we use an independent hash
+ * seed to limit information leakage.
+ */
+void ipv6_proxy_select_ident(struct sk_buff *skb)
+{
+	static u32 ip6_proxy_idents_hashrnd __read_mostly;
+	static bool hashrnd_initialized =3D false;
+	struct in6_addr buf[2];
+	struct in6_addr *addrs;
+	u32 hash, id;
+
+	addrs =3D skb_header_pointer(skb,
+				   skb_network_offset(skb) +
+				   offsetof(struct ipv6hdr, saddr),
+				   sizeof(buf), buf);
+	if (!addrs)
+		return;
+
+	if (unlikely(!hashrnd_initialized)) {
+		hashrnd_initialized =3D true;
+		get_random_bytes(&ip6_proxy_idents_hashrnd,
+				 sizeof(ip6_proxy_idents_hashrnd));
+	}
+	hash =3D __ipv6_addr_jhash(&addrs[1], ip6_proxy_idents_hashrnd);
+	hash =3D __ipv6_addr_jhash(&addrs[0], hash);
+
+	id =3D ip_idents_reserve(hash, 1);
+	skb_shinfo(skb)->ip6_frag_id =3D htonl(id);
+}
+EXPORT_SYMBOL_GPL(ipv6_proxy_select_ident);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 057a9d2..655cc60 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -592,7 +592,7 @@ static int tcp_v6_md5_do_add(struct sock *sk, const str=
uct in6_addr *peer,
 			sk_nocaps_add(sk, NETIF_F_GSO_MASK);
 		}
 		if (tp->md5sig_info->entries6 =3D=3D 0 &&
-			tcp_alloc_md5sig_pool(sk) =3D=3D NULL) {
+		    !tcp_alloc_md5sig_pool()) {
 			kfree(newkey);
 			return -ENOMEM;
 		}
@@ -602,8 +602,6 @@ static int tcp_v6_md5_do_add(struct sock *sk, const str=
uct in6_addr *peer,
=20
 			if (!keys) {
 				kfree(newkey);
-				if (tp->md5sig_info->entries6 =3D=3D 0)
-					tcp_free_md5sig_pool();
 				return -ENOMEM;
 			}
=20
@@ -649,7 +647,6 @@ static int tcp_v6_md5_do_del(struct sock *sk, const str=
uct in6_addr *peer)
 				kfree(tp->md5sig_info->keys6);
 				tp->md5sig_info->keys6 =3D NULL;
 				tp->md5sig_info->alloced6 =3D 0;
-				tcp_free_md5sig_pool();
 			} else {
 				/* shrink the database */
 				if (tp->md5sig_info->entries6 !=3D i)
@@ -673,7 +670,6 @@ static void tcp_v6_clear_md5_list (struct sock *sk)
 		for (i =3D 0; i < tp->md5sig_info->entries6; i++)
 			kfree(tp->md5sig_info->keys6[i].base.key);
 		tp->md5sig_info->entries6 =3D 0;
-		tcp_free_md5sig_pool();
 	}
=20
 	kfree(tp->md5sig_info->keys6);
@@ -684,7 +680,6 @@ static void tcp_v6_clear_md5_list (struct sock *sk)
 		for (i =3D 0; i < tp->md5sig_info->entries4; i++)
 			kfree(tp->md5sig_info->keys4[i].base.key);
 		tp->md5sig_info->entries4 =3D 0;
-		tcp_free_md5sig_pool();
 	}
=20
 	kfree(tp->md5sig_info->keys4);
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 333926d..53d455c 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -866,8 +866,6 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 		list_add(&cur_key->key_list, sh_keys);
=20
 	cur_key->key =3D key;
-	sctp_auth_key_hold(key);
-
 	return 0;
 nomem:
 	if (!replace)
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 5bd9aa9..c3b8549 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -384,12 +384,12 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	sk =3D chunk->skb->sk;
=20
 	/* Allocate the new skb.  */
-	nskb =3D alloc_skb(packet->size + LL_MAX_HEADER, GFP_ATOMIC);
+	nskb =3D alloc_skb(packet->size + MAX_HEADER, GFP_ATOMIC);
 	if (!nskb)
 		goto nomem;
=20
 	/* Make sure the outbound skb has enough header room reserved. */
-	skb_reserve(nskb, packet->overhead + LL_MAX_HEADER);
+	skb_reserve(nskb, packet->overhead + MAX_HEADER);
=20
 	/* Set the owning socket so that we know where to get the
 	 * destination IP address.
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index d8d4704..c40952c 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2570,6 +2570,9 @@ do_addr_param:
 		addr_param =3D param.v + sizeof(sctp_addip_param_t);
=20
 		af =3D sctp_get_af_specific(param_type2af(param.p->type));
+		if (af =3D=3D NULL)
+			break;
+
 		af->from_addr_param(&addr, addr_param,
 				    htons(asoc->peer.port), 0);
=20
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index b4f802d..4dd8dcf 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1197,7 +1197,7 @@ static void sel_remove_entries(struct dentry *de)
 	spin_lock(&de->d_lock);
 	node =3D de->d_subdirs.next;
 	while (node !=3D &de->d_subdirs) {
-		struct dentry *d =3D list_entry(node, struct dentry, d_u.d_child);
+		struct dentry *d =3D list_entry(node, struct dentry, d_child);
=20
 		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
 		list_del_init(node);
@@ -1704,12 +1704,12 @@ static void sel_remove_classes(void)
=20
 	list_for_each(class_node, &class_dir->d_subdirs) {
 		struct dentry *class_subdir =3D list_entry(class_node,
-					struct dentry, d_u.d_child);
+					struct dentry, d_child);
 		struct list_head *class_subdir_node;
=20
 		list_for_each(class_subdir_node, &class_subdir->d_subdirs) {
 			struct dentry *d =3D list_entry(class_subdir_node,
-						struct dentry, d_u.d_child);
+						struct dentry, d_child);
=20
 			if (d->d_inode)
 				if (d->d_inode->i_mode & S_IFDIR)
=0D
--=-HaVq1u//mYP1ofBQdeIw--

--=-mpb4RIBvogullTO+cvL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVKVUgue/yOyVhhEJAQqxmw/9FRjluEbI3SWt98aS/bEn8ZxXbouh2tEU
SPDygtFRbgBixcTnBTPEpBFU0ycdY9x0hyzu5pryH68XWg+1PdUOPthgUELp900M
j+f/NzRFj1H7a6iknWDoH/h1CIVYx416sDzvCRAWlQjjIWuO+6cOhyR1mUj1cGNC
Sg0lLH3WAuypMMIh/6y4DJ09SNoAR9BxJG1oTUvFnPG8KKisJpDoY8ZNNkgp8nJZ
Us6QSfCM+KM/ZGQJtwsm9FBo8ptF6zZGbLRIFHvj8p1ZpUUnwPC2gxThkp9F9+0p
BToN+fppL5vApW4TbkVIrcXEHHnZleMxSAXQWfPkdLaPFHYDXLiDEEnkWdcOUuty
XeNIy3xsKUal90IkGofrYw9ioM+rHYpsjRiq+6vxwrq1eMEv5bC+uxLemoeXh78W
gEnP1OzhpmtVeiQ5O4SwNjSTQYvI4/O954JsbEWaOcPp2W63S82NCkRAMphf90SM
43ODQ042K3jvdDNO16rom35hl+C5qvFAfgCcXhY1G8CaBPnvTG79U4jJfIlZnWbi
bjxIey3KDqbCxUjXkxn5L4IkFeQ0+HkB1s73DljDy8OWs/o7AIQgfrWBTLbm19kK
IHLZQpt+/fj+VH4llxMMZAF4vwqJved18AWIZ0WAIjeST51NnGKzVi53wLL+yRJ9
BvcttQxOeMQ=
=HSAy
-----END PGP SIGNATURE-----

--=-mpb4RIBvogullTO+cvL2--
