Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaBFGEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 01:04:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14638 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaBFGEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 01:04:14 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7efc6d0000039d3-76-52f325db5f69
Content-transfer-encoding: 8BIT
Message-id: <1391666564.25542.78.camel@kjgkr>
Subject: Re: f2fs: f2fs unmount hangs if f2fs_init_acl() fails during mkdir
 syscall
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Andrey Tsyvarev <tsyvarev@ispras.ru>
Cc: linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 06 Feb 2014 15:02:44 +0900
In-reply-to: <52F320FC.50803@ispras.ru>
References: <52F320FC.50803@ispras.ru>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zfd07qp+DDJrNLC4tcre4vGsOm8Xy
	y3EOzB4z/k1l9Ni94DOTx+dNcgHMUVw2Kak5mWWpRfp2CVwZF649Zi745VTx+2J9A+Nh0y5G
	Tg4JAROJ0/+mMULYYhIX7q1n62Lk4hASWMYosf/VczaYotenprBCJKYzSjT+uMQEkuAVEJT4
	MfkeSxcjBwezgLzEkUvZIGFmAXWJSfMWMUPUv2SU2Hd3CzNEva7Ehnk9rCC2sECoRMOSq+wg
	vWwC2hKb9xuAhIUEFCXe7r8LViIioCGxeuZPJoiZkRL9UxaC2SwCqhIHP78CszmBdr15t4AV
	oldNonX3D7Cb+QVEJQ4v3M4Mcb+SxO72TnaQeyQEdrFLHL3cyAwxSEDi2+RDYPdLCMhKbDoA
	VS8pcXDFDZYJjBKzkHw5C+HLWUi+XMDIvIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJL4m
	7mC8f8D6EGMy0MaJzFKiyfnA+MwriTc0NjOyMDUxNTYytzQjTVhJnDf9UVKQkEB6Yklqdmpq
	QWpRfFFpTmrxIUYmDk6pBsbib06rpGsO+06QmvQ7fkvZGuZraxJf7n/aVad091fviWff7V4J
	rPj5rUe1pOats3J7y4UcG16ZZp+VmuaaFypWJ3xb9/+WqMOEh5tv7uv+UvpKx/GIcPilkg3L
	2dPc/tX8vDvt0aHnxtf2W8y8z1/unbqi9OcU16Dl8/10H/JvDUjzDriyKeeREktxRqKhFnNR
	cSIA2/ZuKcUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd3bqp+DDF5vtbC4tMjd4vKuOWwW
	yy/HOTB7zPg3ldFj94LPTB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoa
	WlqYKynkJeam2iq5+AToumXmAO1RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SA
	BhLWMWZcuPaYueCXU8Xvi/UNjIdNuxg5OSQETCRen5rCCmGLSVy4t56ti5GLQ0hgOqNE449L
	TCAJXgFBiR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxEzRP1LRol9d7cwQ9TrSmyY1wM2VFgg
	VKJhyVV2kF42AW2JzfsNQMJCAooSb/ffBSsREdCQWD3zJxPEzEiJ/ikLwWwWAVWJg59fgdmc
	QLvevFvACtGrJtG6+wcbiM0vICpxeOF2Zoj7lSR2t3eyT2AUmoXk6lkIV89CcvUCRuZVjKKp
	BckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHx+0x6B+OqBotDjAIcjEo8vBvWfwoSYk0sK67MPcQo
	wcGsJMJ78TlQiDclsbIqtSg/vqg0J7X4EGMy0OETmaVEk/OBqSWvJN7Q2MTMyNLIzMLIxNyc
	NGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhhtP0z3WXsujU/a7+2XCY8eub1P+Wzx7OCx
	+YV/XK+zsew6OSdt/+qkueYsDll7lj/K92QPW8+80i9frOj1Ia6SkPtbT828cNYhMfFm/P/I
	LXMUbFdcqX8mctPUWkrj2aXuzrobDe5d7To+JyTj/1ZvsXQRVNHuOzt923LLrTaOJzzlGzUV
	TiYosRRnJBpqMRcVJwIAeEZdtyMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for the test and valuable report.

This bug was fixed recently by:

commit 03dea3129d558bf5293a6e9f12777176619ac876
Author: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date:   Wed Feb 5 11:16:39 2014 +0900

    f2fs: fix to truncate dentry pages in the error case

You can find that from the tree:
git://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs.git/log/?h=dev

Thanks,

2014-02-06 (목), 09:43 +0400, Andrey Tsyvarev:
> Hello,
> 
> Testing f2fs (of linux-3.13) under fault simulation, we detected 
> umount() hangs up after
> mkdir()->
>    f2fs_add_link()->
>      init_inode_metadata()->
>        f2fs_init_acl()->
>          f2fs_get_acl()->
>            f2fs_getxattr()->
>              read_all_xattrs() fails.
> 
> Also there was a BUG_ON triggered after the fault in
> mkdir()->
>    f2fs_add_link()->
>      init_inode_metadata()->
>        remove_inode_page() ->
>          f2fs_bug_on(inode->i_blocks != 0 && inode->i_blocks != 1);
> 
> In this case there are 2 blocks allocated, which are counted with 
> inode->i_blocks field:
> 
> static struct page *init_inode_metadata(struct inode *inode,
>          struct inode *dir, const struct qstr *name)
> {
>      struct page *page;
>      int err;
> 
>      if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE)) {
>          page = new_inode_page(inode, name); <----- First block is 
> allocated for the inode
>          if (IS_ERR(page))
>              return page;
> 
>          if (S_ISDIR(inode->i_mode)) {
>              err = make_empty_dir(inode, dir, page); <----- Second block 
> is allocated for the inode
>              if (err)
>                  goto error;
>          }
> 
>          err = f2fs_init_acl(inode, dir, page); <----- This call returns 
> error
>          if (err)
>              goto error;
>          ...
>      } else {
>          ...
>      }
> 
>      init_dent_inode(name, page);
> 
>      /*
>       * This file should be checkpointed during fsync.
>       * We lost i_pino from now on.
>       */
>      if (is_inode_flag_set(F2FS_I(inode), FI_INC_LINK)) {
>          file_lost_pino(inode);
>          inc_nlink(inode);
>      }
>      return page;
> 
> error:
>      f2fs_put_page(page, 1);
>      remove_inode_page(inode); <----- Expects at most one block 
> allocated for inode
>      return ERR_PTR(err);
> }
> 
> Found by Linux File System Verification project (linuxtesting.org).
> 
> 
> Here are some additional details.
> 
> F2fs-related kernel configuration is:
> CONFIG_F2FS_FS=m
> CONFIG_F2FS_STAT_FS=y
> CONFIG_F2FS_FS_XATTR=y
> CONFIG_F2FS_FS_POSIX_ACL=y
> CONFIG_F2FS_FS_SECURITY=y
> CONFIG_F2FS_CHECK_FS=y
> 
> 
> BUG_ON log:
> [  117.863869] kernel BUG at fs/f2fs/node.c:825!
> [  117.863870] invalid opcode: 0000 [#1] SMP
> [  117.863872] Modules linked in: f2fs kedr_fsim_indicator_common(OF) 
> kedr_fsim_indicator_capable(OF)
> kedr_fsim_indicator_kmalloc(OF) kedr_fsim_vmm(OF) kedr_fsim_mem_util(OF) 
> kedr_fsim_capable(OF)
> kedr_fsim_uaccess(OF) kedr_fsim_cmm(OF) kedr_fault_simulation(OF) 
> kedr(OF) fuse nf_conntrack_netbios_ns
> nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack 
> ebtable_nat ebtable_broute bridge stp llc
> ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 
> nf_nat_ipv6 ip6table_mangle
> ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat 
> nf_conntrack_ipv4 nf_defrag_ipv4
> nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security 
> iptable_raw microcode i2c_piix4 parport_pc
> e1000 i2c_core parport ata_generic pata_acpi [last unloaded: kedr]
> [  117.863894] CPU: 0 PID: 2766 Comm: fs-driver-tests Tainted: 
> GF          O 3.13.0fs #2
> [  117.863895] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
> VirtualBox 12/01/2006
> [  117.863896] task: ffff8800001b6420 ti: ffff8800111ac000 task.ti: 
> ffff8800111ac000
> [  117.863897] RIP: 0010:[<ffffffffa01e03bf>] [<ffffffffa01e03bf>] 
> remove_inode_page+0xbf/0xd0 [f2fs]
> [  117.863901] RSP: 0018:ffff8800111ade08  EFLAGS: 00010202
> [  117.863902] RAX: 0000000000000000 RBX: ffff8800125a0c30 RCX: 
> ffff8800001b6a78
> [  117.863903] RDX: ffff880000000000 RSI: ffffea00004b9780 RDI: 
> ffff8800125a0c30
> [  117.863903] RBP: ffff8800111ade50 R08: 0000000000000001 R09: 
> 0000000000000000
> [  117.863904] R10: 0000000000000006 R11: 000000000000000f R12: 
> ffffea00004b9780
> [  117.863905] R13: 0000000000000004 R14: ffffea00004b9780 R15: 
> ffffea00004b97c0
> [  117.863907] FS:  00007ff92dc9f740(0000) GS:ffff88003fc00000(0000) 
> knlGS:0000000000000000
> [  117.863908] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  117.863909] CR2: 00007f6673415000 CR3: 000000003c628000 CR4: 
> 00000000000006f0
> [  117.863913] Stack:
> [  117.863913]  00000000000041ff ffffea00004b97c0 ffff8800111ade50 
> ffffffffa01e9ffa
> [  117.863915]  ffffea00004b9780 ffff880000000000 ffff880012e5d000 
> 0000000000000003
> [  117.863917]  ffffea00004b9740 ffff8800111adec0 ffffffffa01d0d20 
> ffff880012532948
> [  117.863919] Call Trace:
> [  117.863922]  [<ffffffffa01e9ffa>] ? f2fs_init_acl+0x10a/0x180 [f2fs]
> [  117.863925]  [<ffffffffa01d0d20>] __f2fs_add_link+0x560/0x7c0 [f2fs]
> [  117.863928]  [<ffffffffa01d3b8b>] f2fs_mkdir+0xbb/0x150 [f2fs]
> [  117.863929]  [<ffffffff811cf4c7>] vfs_mkdir+0xb7/0x160
> [  117.863931]  [<ffffffff811d010f>] SyS_mkdir+0x5f/0xc0
> [  117.863933]  [<ffffffff8165bf29>] system_call_fastpath+0x16/0x1b
> [  117.863934] Code: e6 49 8b 14 24 83 e2 01 74 23 4c 89 e7 89 45 bc e8 
> f7 f9 f6 e0 4c 89 e7 e8 ff d1 f7
> e0 8b 45 bc 48 83 c4 30 5b 41 5c 41 5d 5d c3 <0f> 0b e8 c8 9d 00 00 66 
> 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
> [  117.863953] RIP  [<ffffffffa01e03bf>] remove_inode_page+0xbf/0xd0 [f2fs]
> [  117.863956]  RSP <ffff8800111ade08>
> 
> There are several ways for simulate faults in kernel function calls, 
> e.g. manual faults insertion,
> fault injection kernel infrustructure.
> In my tests I use KEDR framework (http://forge.ispras.ru/projects/kedr) 
> for that purpose,
> that is why kedr* modules are in the log above.
> Call stack of the fault simulated is:
> 
> [  117.863789] KEDR FAULT SIMULATION: forcing a failure
> [  117.863792] CPU: 0 PID: 2766 Comm: fs-driver-tests Tainted: 
> GF          O 3.13.0fs #2
> [  117.863794] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
> VirtualBox 12/01/2006
> [  117.863795]  ffff8800111adce8 ffff8800111adcb0 ffffffff8164bd96 
> 0000000000000001
> [  117.863797]  ffff8800111adcd8 ffffffffa018ace2 ffffffffa018ac45 
> ffffffffa01e8b54
> [  117.863799]  0000000000001000 ffff8800111add18 ffffffffa0194816 
> ffffffffa01e8b54
> [  117.863801] Call Trace:
> [  117.863806]  [<ffffffff8164bd96>] dump_stack+0x45/0x56
> [  117.863810]  [<ffffffffa018ace2>] kedr_fsim_point_simulate+0xa2/0xb0 
> [kedr_fault_simulation]
> [  117.863812]  [<ffffffffa018ac45>] ? kedr_fsim_point_simulate+0x5/0xb0 
> [kedr_fault_simulation]
> [  117.863816]  [<ffffffffa01e8b54>] ? read_all_xattrs+0x3c4/0x3e0 [f2fs]
> [  117.863819]  [<ffffffffa0194816>] kedr_repl___kmalloc+0x36/0x80 
> [kedr_fsim_cmm]
> [  117.863822]  [<ffffffffa01e8b54>] ? read_all_xattrs+0x3c4/0x3e0 [f2fs]
> [  117.863824]  [<ffffffffa01955d2>] 
> kedr_intermediate_func___kmalloc+0x72/0xd0 [kedr_fsim_cmm]
> [  117.863826]  [<ffffffffa01e8b54>] ? read_all_xattrs+0x3c4/0x3e0 [f2fs]
> [  117.863829]  [<ffffffffa01e8b54>] read_all_xattrs+0x3c4/0x3e0 [f2fs]
> [  117.863832]  [<ffffffffa01e91d4>] f2fs_getxattr+0x44/0xf0 [f2fs]
> [  117.863835]  [<ffffffffa01e9ba9>] f2fs_get_acl+0xe9/0x390 [f2fs]
> [  117.863838]  [<ffffffffa01d99c9>] ? set_dirty_dir_page+0xb9/0xe0 [f2fs]
> [  117.863841]  [<ffffffffa01e9ffa>] f2fs_init_acl+0x10a/0x180 [f2fs]
> [  117.863843]  [<ffffffffa01d0ccc>] __f2fs_add_link+0x50c/0x7c0 [f2fs]
> [  117.863846]  [<ffffffffa01d3b8b>] f2fs_mkdir+0xbb/0x150 [f2fs]
> [  117.863849]  [<ffffffff811cf4c7>] vfs_mkdir+0xb7/0x160
> [  117.863851]  [<ffffffff811d010f>] SyS_mkdir+0x5f/0xc0
> [  117.863854]  [<ffffffff8165bf29>] system_call_fastpath+0x16/0x1b
> 
> --
> Best regards,
> Andrey Tsyvarev
> Linux Verification Center, ISPRAS
> web: http://linuxtesting.org
> 
> ---
> Это сообщение свободно от вирусов и вредоносного ПО благодаря защите от вирусов avast!
> http://www.avast.com
> 

-- 
Jaegeuk Kim
Samsung

