Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaBGAvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 19:51:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42014 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaBGAvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 19:51:16 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f266d00000287c-fd-52f42e01f167
Content-transfer-encoding: 8BIT
Message-id: <1391734185.25542.80.camel@kjgkr>
Subject: Re: f2fs: f2fs unmount hangs if f2fs_init_acl() fails during mkdir
 syscall
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Andrey Tsyvarev <tsyvarev@ispras.ru>
Cc: linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 07 Feb 2014 09:49:45 +0900
In-reply-to: <52F37D67.208@ispras.ru>
References: <52F320FC.50803@ispras.ru> <1391666564.25542.78.camel@kjgkr>
 <52F37D67.208@ispras.ru>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zfV1GvS9BBmffaFtcWuRucXnXHDaL
	5ZfjHJg9Zvybyuixe8FnJo/Pm+QCmKO4bFJSczLLUov07RK4Mvo//Gcp6Fet+L/qAGMD40W5
	LkZODgkBE4lPbZ1MELaYxIV769m6GLk4hASWMUrs6doC5HCAFe3bJgERX8QocfpvJzNIA6+A
	oMSPyfdYQGqYBeQljlzKBgkzC6hLTJq3iBmi/iWjxMxpz8BqeAV0JeZ1R4DUCAuESjQsucoO
	EmYT0JbYvN8AJCwkoCjxdv9dVhBbREBDYvXMn0wQIyMl+qcsBLNZBFQl3nStZgexOYHspiXX
	WCF6kyUaH5wEq+EXEJU4vHA7M8RbShK72zvZQc6RENjHLrGgax4zxCABiW+TD7FAvCgrsekA
	VL2kxMEVN1gmMErMQvLkLIQnZyF5cgEj8ypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MkPia
	sIPx3gHrQ4zJQBsnMkuJJucD4zOvJN7Q2MzIwtTE1NjI3NKMNGElcV61R0lBQgLpiSWp2amp
	BalF8UWlOanFhxiZODilGhhVe/qCTkx48nj34ZMLtv/SsnzZpvtM3vm4/W2LpKce2p4e5e7B
	zrKaRzbU1U95z3qg5M8MU685gQsZDuaWBKvd/yUp8z+pxvrrlbopfmFtIm/3zUw58eXp9qOh
	7/Onr8xkzsgqitu2b/r5NN8PDrMj3h8onvpm3aTYvPW8+75aqi44/GvHZp0aJZbijERDLeai
	4kQAh+q2bMUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgC6j3pcgg/vz1S0uLXK3uLxrDpvF
	8stxDsweM/5NZfTYveAzk8fnTXIBzFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqG
	lhbmSgp5ibmptkouPgG6bpk5QHuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmg
	gYR1jBn9H/6zFPSrVvxfdYCxgfGiXBcjB4eEgInEvm0SXYycQKaYxIV769m6GLk4hAQWMUqc
	/tvJDJLgFRCU+DH5HgtIPbOAvMSRS9kgYWYBdYlJ8xYxQ9S/ZJSYOe0ZWA2vgK7EvO4IkBph
	gVCJhiVX2UHCbALaEpv3G4CEhQQUJd7uv8sKYosIaEisnvmTCWJkpET/lIVgNouAqsSbrtXs
	IDYnkN205BorRG+yROODk2A1/AKiEocXbmeGOF9JYnd7J/sERqFZSI6ehXD0LCRHL2BkXsUo
	mlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHL3PpHcwrmqwOMQowMGoxMN7YunnICHWxLLiytxD
	jBIczEoivL5yX4KEeFMSK6tSi/Lji0pzUosPMSYDHT6RWUo0OR+YWPJK4g2NTcyMLI3MLIxM
	zM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgXGGcO3BZ1mOvn8mF51ekf723qXp17a1
	Ts+99+Drmo5bq2RXXNw0MfTHs3fTZxkHza+bndQw8+ZBO4bW+2tqXpf5uVZdEDx3yW77pl+a
	xz7zb37faP+F59diVnHBs/8WfKiWmS7PuYLjS47sGeMygZaEb8/jzKt2bN4xqeT+j7DqvKA0
	tRcZc2ZWKLEUZyQaajEXFScCANDRkkciAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-02-06 (목), 16:17 +0400, Andrey Tsyvarev:
> Hi,
> 
> 06.02.2014 10:02, Jaegeuk Kim пишет:
> > Hi,
> >
> > Thank you for the test and valuable report.
> >
> > This bug was fixed recently by:
> >
> > commit 03dea3129d558bf5293a6e9f12777176619ac876
> > Author: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > Date:   Wed Feb 5 11:16:39 2014 +0900
> >
> >      f2fs: fix to truncate dentry pages in the error case
> Now remove_inode_page() succeed, but another assertion failed (tested on 
> revision e964751c):
> 
> [ 1272.747011] kernel BUG at fs/f2fs/inode.c:274!
> [ 1272.747011] invalid opcode: 0000 [#1] SMP
> [ 1272.747011] Modules linked in: f2fs kedr_fsim_indicator_common(OF) 
> kedr_fsim_indicator_capable(OF)
> kedr_fsim_indicator_kmalloc(OF) kedr_fsim_vmm(OF) kedr_fsim_mem_util(OF) 
> kedr_fsim_capable(OF)
> kedr_fsim_uaccess(OF) kedr_fsim_cmm(OF) kedr_fault_simulation(OF) 
> kedr(OF) fuse nf_conntrack_netbios_ns
> nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack 
> ebtable_nat ebtable_broute bridge stp
> llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 
> nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
> ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat 
> nf_conntrack_ipv4 nf_defrag_ipv4
> nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security 
> iptable_raw parport_pc i2c_piix4 e1000
> i2c_core microcode parport ata_generic pata_acpi [last unloaded: kedr]
> [ 1272.747011] CPU: 0 PID: 14613 Comm: fs-driver-tests Tainted: GF       
> W  O 3.14.0-rc1fs #1
> [ 1272.747011] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
> VirtualBox 12/01/2006
> [ 1272.747011] task: ffff88001e939190 ti: ffff88000d7ec000 task.ti: 
> ffff88000d7ec000
> [ 1272.747011] RIP: 0010:[<ffffffffa01c74a8>] [<ffffffffa01c74a8>] 
> f2fs_evict_inode+0x178/0x180 [f2fs]
> [ 1272.747011] RSP: 0018:ffff88000d7ede50  EFLAGS: 00010202
> [ 1272.747011] RAX: 0000000000000001 RBX: ffff88000475cc30 RCX: 
> ffff88001e9398a0
> [ 1272.747011] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 
> ffff88000475ce10
> [ 1272.747011] RBP: ffff88000d7ede68 R08: 00000000ffffffff R09: 
> 0000000000000000
> [ 1272.747011] R10: 0000000000000000 R11: 0000000000000001 R12: 
> ffff88000475cc30
> [ 1272.747011] R13: ffff88000f147800 R14: ffffffffa01e7080 R15: 
> ffff88000f147b80
> [ 1272.747011] FS:  00007f1795424740(0000) GS:ffff88003fc00000(0000) 
> knlGS:0000000000000000
> [ 1272.747011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1272.747011] CR2: 00007fc33bfa9000 CR3: 000000000f14e000 CR4: 
> 00000000000006f0
> [ 1272.747011] Stack:
> [ 1272.747011]  ffff88000475cc30 ffff88000475cdc8 ffffffffa01e7080 
> ffff88000d7ede90
> [ 1272.747011]  ffffffff811fde03 ffff88000475cc30 ffff88000475ccb8 
> ffff88000f147000
> [ 1272.747011]  ffff88000d7edec0 ffffffff811fe615 ffff88000475cc30 
> ffff88000f147800
> [ 1272.747011] Call Trace:
> [ 1272.747011]  [<ffffffff811fde03>] evict+0xa3/0x1a0
> [ 1272.747011]  [<ffffffff811fe615>] iput+0xf5/0x180
> [ 1272.747011]  [<ffffffffa01c7f63>] f2fs_mkdir+0xf3/0x150 [f2fs]
> [ 1272.747011]  [<ffffffff811f2a77>] vfs_mkdir+0xb7/0x160
> [ 1272.747011]  [<ffffffff811f36bf>] SyS_mkdir+0x5f/0xc0
> [ 1272.747011]  [<ffffffff81680769>] system_call_fastpath+0x16/0x1b
> [ 1272.747011] Code: 01 e1 4c 89 e7 e8 39 59 03 e1 5b 41 5c 41 5d 5d c3 
> 31 c0 49 83 bc 24 c8 00 00 00 01 0f 97 c0
> eb 8f 4c 89 e7 e8 fa ec ff ff eb 89 <0f> 0b 66 0f 1f 44 00 00 0f 1f 44 
> 00 00 55 48 c7 c0 dc ff ff ff
> [ 1272.747011] RIP  [<ffffffffa01c74a8>] f2fs_evict_inode+0x178/0x180 [f2fs]
> [ 1272.747011]  RSP <ffff88000d7ede50>
> 
> Failed assertion claims that dirty dentries counter should be zero when 
> inode is deleted.
> This counter is incremented by
> mkdir()->
>    f2fs_add_link()->
>      init_inode_metadata()->
>        make_empty_dir()->
>          set_page_dirty();
> 
> but no one decrement it.
> May be, this should be done along with truncating directory inode in 
> error-path of init_inode_metadata() ?

It's weird, since original intention was that pages should be
invalidated by:
f2fs_evict_inode
 - truncate_inode_pages
   - f2fs_invalidate_page
      - decrement dirty_dents

I'll see what happened a little bit more.
Thanks,

> 
> 
> --
> Best regards,
> Andrey Tsyvarev
> Linux Verification Center, ISPRAS
> web: http://linuxtesting.org
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

