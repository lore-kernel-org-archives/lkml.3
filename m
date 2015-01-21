Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbbAUEKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 23:10:21 -0500
Received: from ozlabs.org ([103.22.144.67]:56347 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbbAUEKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 23:10:18 -0500
Date: Wed, 21 Jan 2015 15:10:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: tidy up of trees
Message-ID: <20150121151009.0cb88a21@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/049JUzqsR+tEC6nh5fa6big"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/049JUzqsR+tEC6nh5fa6big
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

[affected tree contacts are bcc'd on this email]

I have decided to do a bit of a tidy up of the trees in linux-next and
my first pass is to remove any tree that has not been updated on over a
year (since next-20140120).  The following 29 trees have been removed
today (of these, 13 have not been updated for more than 2 years).  If
you want a tree restored, just drop me a line - it is easy to do.

Most if the trees are empty, but for the others I have included a
diffstat.

configfs
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/configfs.git#l=
inux-next

cpupowerutils
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/brodo/cpupowerutils.=
git#master

dwmw2
Git URL: git://git.infradead.org/users/dwmw2/random-2.6.git#master

embedded
Git URL: git://git.infradead.org/embedded-2.6.git#master

ep93xx
Git URL: git://github.com/RyanMallon/linux-ep93xx.git#ep93xx-for-next
 arch/arm/mach-ep93xx/Kconfig                 |   1 +
 arch/arm/mach-ep93xx/core.c                  | 110 +++++++++++++++++++++++=
+++-
 arch/arm/mach-ep93xx/include/mach/platform.h |   3 +-
 3 files changed, 111 insertions(+), 3 deletions(-)

fbdev
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/plagnioj/linux-fbdev=
.git#for-next

firmware
Git URL: git://git.infradead.org/users/dwmw2/firmware-2.6.git#master

fsnotify
Git URL: git://git.infradead.org/users/eparis/notify.git#for-next

fw-nohz
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynti=
cks.git#nohz/next

hwspinlock
Git URL: git://github.com/ohadbc/hwspinlock-next.git#linux-next

input-mt
Git URL: git://github.com/rydberg/linux.git#for-next

ixp4xx
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux.git#next

kconfig
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kconfi=
g.git#for-next

logfs
Git URL: git://github.com/prasad-joshi/logfs_upstream.git#master
 fs/logfs/dev_mtd.c | 2 +-
 fs/logfs/super.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

lzo-update
Git URL: git://github.com/markus-oberhumer/linux.git#lzo-update
 lib/lzo/lzo1x_decompress_safe.c | 4 ++++
 lib/lzo/lzodefs.h               | 6 ++++++
 2 files changed, 10 insertions(+)

md-current
Git URL: git://neil.brown.name/md#for-linus

msm
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git=
#for-next

omfs
Git URL: git://github.com/bcopeland/omfs.git#for-next

openrisc
Git URL: git://openrisc.net/jonas/linux#for-upstream

oprofile
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git#fo=
r-next

parisc
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git#=
for-next

pcmcia
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia.git#mas=
ter

signal
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git#for-=
next

sysctl
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/sysctl.git#=
master

uclinux
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/gerg/uclinux.git#for=
-next

uml
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git#next
 arch/um/include/asm/Kbuild                  |   1 +
 arch/um/include/asm/processor-generic.h     |   3 -
 arch/um/include/shared/os.h                 |   2 -
 arch/um/include/shared/skas/proc_mm.h       |  44 ------
 arch/um/include/shared/skas/skas.h          |   3 -
 arch/um/include/shared/skas_ptrace.h        |  14 --
 arch/um/kernel/ptrace.c                     |  32 ----
 arch/um/kernel/reboot.c                     |  35 ++---
 arch/um/kernel/skas/mmu.c                   |  68 +++------
 arch/um/kernel/skas/process.c               |  27 ----
 arch/um/kernel/trap.c                       |   2 +-
 arch/um/kernel/um_arch.c                    |  10 --
 arch/um/os-Linux/process.c                  |  16 --
 arch/um/os-Linux/skas/mem.c                 | 100 ++----------
 arch/um/os-Linux/skas/process.c             | 200 ++++++------------------
 arch/um/os-Linux/start_up.c                 | 154 -------------------
 arch/um/sys-ia64/sysdep/skas_ptrace.h       |  22 ---
 arch/um/sys-ppc/shared/sysdep/skas_ptrace.h |  22 ---
 arch/x86/um/ldt.c                           | 227 ++++++------------------=
----
 arch/x86/um/shared/sysdep/faultinfo_32.h    |   3 -
 arch/x86/um/shared/sysdep/faultinfo_64.h    |   3 -
 arch/x86/um/shared/sysdep/skas_ptrace.h     |  22 ---
 22 files changed, 149 insertions(+), 861 deletions(-)

uprobes
Git URL: git://github.com/srikard/linux.git#for-next

viafb
Git URL: git://github.com/schandinat/linux-2.6.git#viafb-next

writeback
Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git#writeb=
ack-for-next

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/049JUzqsR+tEC6nh5fa6big
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvyanAAoJEMDTa8Ir7ZwV+SsP/2i0QOH0OPg3WVJlWwOx/XO7
MxdXxyKkNoMSaSrY0RcAaPwbYM8pem8utLds7sBTc6wQIvshZ+qXH6i0QaxC97h6
NkZT+/PF5i1PcI5P/DFV1tO7lWDDK3JSjpnFicftEjZFXPsBH1mDIZJVjn27B620
FtJBJPNR5wpXUXJSy/Qz7vIvSO2PDMk7DQN4OwVDw2nBig6Uzlubw228/cxxKR4k
tDCxD1h+PfQKhfI0AepsHoDmx5cru3vIG5kOfZ6QklkoXXry98RGAalrKN9OBh9W
i5JOFSSCEvHF9UwrO4j6u05h3QIQi+EeTO7T95Np++y+kkgQ43prdqXXl3JLse3/
uEbsnZ7K7Qx7gNIp155WHzo0C5h5ZKTX5FoLXA3ruSdO9W9JbTH6bQnwZw2Gczmv
2kyCLN3zs6DO+zzjxwlVDktum0umiEqM1oZBIOPbrTip0cZ0w3Dxwn708KP5/AXM
gWND1Me9jfucnHqu2bEwHDOJIcsFTilM13tkqa9icC1g5McTeWA9S+MKcozgnk2h
Nw68hi3mewzG5UynFNHwLUKZfphzSZlpmuHWcR09aLduKb/Yhu4GyTFSfA7MMpRM
R0G1IewnqtODXFbvlKis8ZL2c3D9TwhFmcTEOPIwUv1MWJ4fqqrNxgJBJfC3nKMU
4M0WPDEL4MLHNoFh52sc
=Z2Vy
-----END PGP SIGNATURE-----

--Sig_/049JUzqsR+tEC6nh5fa6big--
