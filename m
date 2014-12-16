Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaLPWOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:14:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLPWOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:14:30 -0500
Date: Tue, 16 Dec 2014 14:14:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.18.1
Message-ID: <20141216221429.GA6100@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.18.1 kernel.

All users of the 3.18 kernel series must upgrade.

The updated 3.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.18.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/mips/net/bpf_jit.c                         |    4 -
 arch/powerpc/platforms/cell/spufs/inode.c       |    2=20
 drivers/net/ethernet/marvell/mvneta.c           |    5 -
 drivers/net/vxlan.c                             |   10 ---
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c     |    3=20
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c     |    3=20
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c    |   24 ++++++-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h    |    2=20
 drivers/net/xen-netfront.c                      |    3=20
 drivers/staging/lustre/lustre/llite/dcache.c    |    2=20
 drivers/staging/lustre/lustre/llite/llite_lib.c |    2=20
 drivers/staging/lustre/lustre/llite/namei.c     |    8 +-
 fs/affs/amigaffs.c                              |    2=20
 fs/autofs4/expire.c                             |   12 +--
 fs/autofs4/root.c                               |    2=20
 fs/ceph/dir.c                                   |    8 +-
 fs/ceph/inode.c                                 |    2=20
 fs/cifs/inode.c                                 |    2=20
 fs/coda/cache.c                                 |    2=20
 fs/dcache.c                                     |   80 ++++++++++++-------=
-----
 fs/debugfs/inode.c                              |    2=20
 fs/exportfs/expfs.c                             |    2=20
 fs/libfs.c                                      |   12 +--
 fs/ncpfs/dir.c                                  |    2=20
 fs/ncpfs/ncplib_kernel.h                        |    4 -
 fs/nfs/getroot.c                                |    2=20
 fs/notify/fsnotify.c                            |    4 -
 fs/ocfs2/dcache.c                               |    2=20
 include/linux/dcache.h                          |    8 +-
 kernel/trace/trace.c                            |    4 -
 kernel/trace/trace_events.c                     |    2=20
 net/ipv4/gre_offload.c                          |    3=20
 net/ipv4/tcp_ipv4.c                             |    4 -
 net/ipv6/tcp_ipv6.c                             |   28 ++++----
 net/netlink/af_netlink.c                        |    2=20
 net/openvswitch/flow_netlink.c                  |    4 -
 net/sched/sch_fq_codel.c                        |    2=20
 net/sctp/output.c                               |    4 -
 security/selinux/selinuxfs.c                    |    6 -
 sound/pci/hda/patch_analog.c                    |    1=20
 sound/pci/hda/patch_realtek.c                   |    1=20
 sound/usb/midi.c                                |    2=20
 43 files changed, 155 insertions(+), 126 deletions(-)

Al Viro (2):
      move d_rcu from overlapping d_child to overlapping d_alias
      deal with deadlock in d_walk()

Daniel Borkmann (2):
      net: sctp: use MAX_HEADER for headroom reserve in output path
      netlink: use jhash as hashfn for rhashtable

David Vrabel (1):
      xen-netfront: use correct linear area after linearizing an skb

Denis Kirjanov (1):
      mips: bpf: Fix broken BPF_MOD

Eric Dumazet (2):
      net: mvneta: fix race condition in mvneta_tx()
      tcp: fix more NULL deref after prequeue changes

Greg Kroah-Hartman (1):
      Linux 3.18.1

Larry Finger (3):
      rtlwifi: rtl8192ce: Fix editing error that causes silent memory corru=
ption
      rtlwifi: rtl8192ce: Fix kernel crashes due to missing callback entry
      rtlwifi: rtl8192ce: Fix missing interrupt ready flag

Marcelo Leitner (1):
      Fix race condition between vxlan_sock_add and vxlan_sock_release

Pravin B Shelar (1):
      openvswitch: Fix flow mask validation.

Takashi Iwai (3):
      ALSA: hda - Add EAPD fixup for ASUS Z99He laptop
      ALSA: hda - Fix built-in mic at resume on Lenovo Ideapad S210
      ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery

Tom Herbert (1):
      gre: Set inner mac header in gro complete

Valdis Kletnieks (1):
      net: fix suspicious rcu_dereference_check in net/sched/sch_fq_codel.c

willy tarreau (1):
      net: mvneta: fix Tx interrupt delay


--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUkK7FAAoJEDjbvchgkmk+sQ4QAIBisC5utZ37Oflgx7q6vKNB
4ToTLw1MFke07YBC8wPfzJkEU86AJ/XIuZ2s4dvRqKeHH/OsG69goi8kmxnfXf05
A3XxDLsWwhGXYHz+NZAB/vki1aW9bXBA/5hY/4Xz0Mj6WoTbi9AbS62SgwVGZ64t
SWkhvvGZdBBfsJnNvnmTgiuIXrxhsq31SDGo/HPxIivN+0D62q1YA9EJhh117ubh
0psB4gPGQvI24CCX5XZ3qe00MKhe3mrBQjdxeIgafcK+Hy8RAd7DGRpuILcBcb2Y
AGJL9VPyPfpUv0phO+9rSLVl8bIoFXu0JkT+de37xn61QhXQNK02lgp9Cqmbxi+9
peFG9wP3kteBuu7ZJeDsff59NUae4kI3KePYlJ1jzUjMxkyOeeSFGjsg8s3Wanlg
KLYu0q79rJPq5nfmBNKD/484yO0yzNatSo1SdHnqgUO6K+1w/pxRAlDvhRCKSfqf
jjA568YdKyO6yZ26/WJ96b3tTQDB/zjAo4A73E2+Ej8HZS7i1mTgXH/2BA1ZUtGo
q+7u5jADGWDGqBP3wRushcxKSRj0/ovBYL6jTvEWP9P6XGObGEwvYS3NNgLwu8Xq
oNygXE67Gp19aqQA1VFxgoHavzBcW/V2lVJTRpOzw0EwsYesOSJgX82eblq+hjUO
aI3Hd8TV0FgYO/sV1CAt
=XKqI
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
