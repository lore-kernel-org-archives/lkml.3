Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaDGBXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 21:23:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23503 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaDGBWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 21:22:40 -0400
X-AuditID: cbfee690-b7f266d00000287c-6a-5341fdde46c6
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1396833642.12401.12.camel@kjgkr>
Subject: Re: f2fs: kernel BUG at fs/f2fs/segment.h:543
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-f2fs-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Date: Mon, 07 Apr 2014 10:20:42 +0900
In-reply-to: <53401D4A.1020203@oracle.com>
References: <53401D4A.1020203@oracle.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zI917fx2DDf6dErXYcr2JyeLSIneL
	y7vmsFksPnKb2YHFY/eCz0weH5/eYvF4v+8qm8fnTXIBLFFcNimpOZllqUX6dglcGY37FrEX
	HJOv2LjqIlsDY690FyMnh4SAicSWDV2MELaYxIV769m6GLk4hASWMUp0X33KClO0ZsVdFojE
	IkaJzovr2EESvAKCEj8m32MBsZkF1CUmzVvEDGGLSFz8384KYWtLLFv4mhmi+RWjxKeGT0wQ
	zboSnydeAlrNwSEsYCaxag47iMkGVL95vwFIhZCAosTb/XfBxogIaEicmnWQDWJkgcTB9jtg
	U1gEVCWWvTsBdg6ngJbEm3/3mSB6NSVerpsLZvMLiEocXridGeIXJYnd7Z3sIOdICBxjl3j8
	ZRcLxCABiW+TD7GA3CAhICux6QBUvaTEwRU3WCYwSs5C8vEsJB/PQvLxLCQfL2BkWcUomlqQ
	XFCclF5kolecmFtcmpeul5yfu4kREqsTdjDeO2B9iDEZaP1EZinR5HxgrOeVxBsamxlZmJqY
	GhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+Pia/6nrs3Otp6z9sQv
	oTkZr/JLJx1oO7Tg0C7DC7/OlLtIlj80nrvOaUpGoOh7jwXu02reWKdIGV+PmMxmqZ3t8TLF
	41FHOb/p7Nmf7K7MXW6aYXRxx+55zz/tUc/LSFk7XfAEB+8f69UmR72+t3A/FedS3ZLS8F2w
	sqViNn9gXpal1rfdK14osRRnJBpqMRcVJwIAQmDMQusCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAd17fx2DDQ5tFLTYcr2JyeLSIneL
	y7vmsFksPnKb2YHFY/eCz0weH5/eYvF4v+8qm8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCuVFMoSc0qBQgGJxcVK+naYJoSGuOla
	wDRG6PqGBMH1GBmggYR1jBl72+8xFqySr5hwR76B8aNUFyMnh4SAicSaFXdZIGwxiQv31rN1
	MXJxCAksYpTovLiOHSTBKyAo8WPyPaAiDg5mAXmJI5eyQcLMAuoSk+YtYoaof8Uo8anhExNE
	va7E54mXGEHqhQXMJFbNYQcx2QS0JTbvNwCpEBJQlHi7/y4riC0ioCFxatZBNoiRBRIH2++A
	TWERUJVY9u4E2AWcAloSb/7dZ4Lo1ZR4uW4umM0vICpxeOF2ZojzlSR2t3eyT2AUmoXk6FkI
	R89CcvQCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEx/Ux6B+OqBotDjAIcjEo8vIEH
	HIOFWBPLiitzDzFKcDArifAeuAEU4k1JrKxKLcqPLyrNSS0+xJgMdPhEZinR5HxguskriTc0
	NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsYJ3nwhz9ncPb2T1v31
	eRM9Zfdq6/WbL35+pv1Xb+P6oBi1z1wyL7zmql9jikhetZ1XhO1PlNL3sp8ctgtSTL//4Q9O
	n3ZKOifom9ULXuuck49szjF+TnJpOhKV3hKvYx2Q9X5fSOZbI55KmRWXu96VLmC/sTSId18Q
	uyurpGLOutCayxPFupVYijMSDbWYi4oTAfKv39gtAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for the report.

If possible, could you share fsck.f2fs or dump.f2fs on the corrupted
partition?

Otherwise, how about this?
# fdisk /dev/sdx
> p

Thank you,

2014-04-05 (토), 11:12 -0400, Sasha Levin:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest
> -next kernel I've stumbled on the following:
> 
> [ 1789.220942] kernel BUG at fs/f2fs/segment.h:543!
> [ 1789.220942] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 1789.220942] Dumping ftrace buffer:
> [ 1789.220942]    (ftrace buffer empty)
> [ 1789.220942] Modules linked in:
> [ 1789.220942] CPU: 0 PID: 28161 Comm: trinity-c0 Not tainted 3.14.0-next-20140403-sasha-00019-g7474aa9-dirty #376
> [ 1789.220942] task: ffff88032a598000 ti: ffff880329c3e000 task.ti: ffff880329c3e000
> [ 1789.220942] RIP: f2fs_submit_page_mbio (fs/f2fs/segment.h:543 fs/f2fs/data.c:181)
> [ 1789.220942] RSP: 0018:ffff880329c3fc08  EFLAGS: 00010287
> [ 1789.220942] RAX: 000000000000ffff RBX: ffff88012ac66a00 RCX: 0000000000000009
> [ 1789.220942] RDX: 0000000000000200 RSI: ffffea0001dd92c0 RDI: ffff88012ac667b0
> [ 1789.220942] RBP: ffff880329c3fc58 R08: 00000000000ba28e R09: ffff88032a598d98
> [ 1789.220942] R10: 0000000000000000 R11: 0000000000000000 R12: ffffea0001dd92c0
> [ 1789.220942] R13: ffff88012ac667b0 R14: 0000000000000000 R15: ffff880329c3fc70
> [ 1789.220942] FS:  00007f3599003700(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
> [ 1789.220942] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1789.220942] CR2: 00007faf4246a018 CR3: 0000000329b6f000 CR4: 00000000000006b0
> [ 1789.220942] DR0: 0000000000696000 DR1: 0000000000696000 DR2: 0000000000000000
> [ 1789.261947] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [ 1789.261947] Stack:
> [ 1789.261947]  ffff88032a598000 ffff880d2a478278 0000000000000006 0000000000000082
> [ 1789.261947]  ffffffffaa289475 ffffea0001dd92c0 ffff88012ac667b0 ffff880329c3fd30
> [ 1789.261947]  0000000000000000 ffffea0001dd92c0 ffff880329c3fc88 ffffffffaa9da033
> [ 1789.278327] Call Trace:
> [ 1789.278327] ? clear_page_dirty_for_io (arch/x86/include/asm/paravirt.h:809 include/linux/backing-dev.h:176 mm/page-writeback.c:2355)
> [ 1789.278327] write_meta_page (fs/f2fs/segment.c:922)
> [ 1789.278327] f2fs_write_meta_page (arch/x86/include/asm/atomic.h:103 fs/f2fs/f2fs.h:692 fs/f2fs/checkpoint.c:172)
> [ 1789.288220] trinity-c32: vm86 mode not supported on 64 bit kernel
> [ 1789.278327] sync_meta_pages (fs/f2fs/checkpoint.c:247)
> [ 1789.278327] ? get_parent_ip (kernel/sched/core.c:2472)
> [ 1789.278327] ? preempt_count_sub (kernel/sched/core.c:2527)
> [ 1789.278327] ? _raw_spin_unlock_irqrestore (arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:161 kernel/locking/spinlock.c:191)
> [ 1789.278327] write_checkpoint (fs/f2fs/checkpoint.c:875 fs/f2fs/checkpoint.c:913)
> [ 1789.310911] waiting module removal not supported: please upgrade
> [ 1789.278327] ? SyS_tee (fs/sync.c:77)
> [ 1789.278327] ? mutex_lock_nested (arch/x86/include/asm/paravirt.h:809 kernel/locking/mutex.c:569 kernel/locking/mutex.c:587)
> [ 1789.278327] ? get_parent_ip (kernel/sched/core.c:2472)
> [ 1789.278327] ? bit_waitqueue (kernel/sched/wait.c:291)
> [ 1789.278327] ? SyS_tee (fs/sync.c:77)
> [ 1789.278327] f2fs_sync_fs (fs/f2fs/super.c:456)
> [ 1789.278327] sync_fs_one_sb (fs/sync.c:80)
> [ 1789.278327] iterate_supers (fs/super.c:512)
> [ 1789.278327] sys_sync (fs/sync.c:110)
> [ 1789.278327] tracesys (arch/x86/kernel/entry_64.S:749)
> [ 1789.278327] Code: 48 c1 e0 04 48 8d 9c 07 f0 00 00 00 49 8b 45 38 41 8b 8d d0 06 00 00 8b 50 78 8b 80 84 00 00 00 d3 e0 41 39 d6 8d 44 02 ff 73 09 <0f> 0b 0f 1f 80 00 00 00 00 41 39 c6 76 03 0f 0b 90 48 8d 43 20
> [ 1789.278327] RIP f2fs_submit_page_mbio (fs/f2fs/segment.h:543 fs/f2fs/data.c:181)
> [ 1789.278327]  RSP <ffff880329c3fc08>
> 
> 
> Thanks,
> Sasha

-- 
Jaegeuk Kim
Samsung

