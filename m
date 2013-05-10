Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab3EJAwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 20:52:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42208 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab3EJAvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 20:51:55 -0400
X-AuditID: cbfee691-b7fe56d000004b96-92-518c44a820aa
Date: Fri, 10 May 2013 00:51:52 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130510003819803@eunb.song
Msgkey: 20130510003819803@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130510003819803@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <6719519.5821368147110937.JavaMail.weblogic@epml17>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zpu4Kl55Ag/MHuSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG0buNbAX7jCtePrrN2MA4waiLkZNDSEBFouX/d0YQW0LARGLP
	lCOsELaYxIV769m6GLmAapYxSizvvgVXdOxFGzNEYj6jRMe5aUAJDg4WAVWJ/5OsQWrYBLQl
	3n55ADZIWMBNYsXuJmYQW0RAWWLVzE1MIDazQJ1E3/PfrBBHyEtMPn2ZHcTmFRCUODnzCQvE
	LiWJhht32SDiyhKH9vQyQ8QlJGZNvwB1KK/EjPanUPVyEtO+roGqkZY4P2sDI8wzi78/horz
	Sxy7vYMJ5GSQ3if3g2HG7N78hQ3CFpCYeuYgVKu6xLxpK5kgbD6JNQvfssCM2XVqOTNM7/0t
	c6HeUpSY0v2QHcLWkvjyYx8burd4Bewljs9cxj6BUXkWktQsJO2zkLQjq1nAyLKKUTS1ILmg
	OCm9yFSvODG3uDQvXS85P3cTIyQtTNzBeP+A9SHGZGCMTGSWEk3OB6aVvJJ4Q2MzIwtTE1Nj
	I3NLM9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwBk66mdH1o0IyQufV3tpb
	L59nnvwm/yJ5m+Nuz7MfGIv1jBvvpdy6n/xpc8aR7NPfo7s+qPZdel+Zo9UZtNbp1pmu2sDd
	nz71bu/PKLx4coJcSPKlC1WaDgw9N2cIC7trbV38SbztlBRDyc3Lz9dNvFQYF63r5DmJ/Qz/
	qpB9b6yv+H/YuMrZXImlOCPRUIu5qDgRAHRk0PshAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2TN0VLj2BBi/fs1lc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jKN3G9kK9hlXvHx0m7GBcYJRFyMnh5CAikTL/++MILaEgInEsRdtzBC2mMSFe+vZuhi5gGrm
	M0p0nJsGVMTBwSKgKvF/kjVIDZuAtsTbLw9YQWxhATeJFbubwHpFBJQlVs3cxARiMwvUSfQ9
	/80KsUteYvLpy+wgNq+AoMTJmU9YIHYpSTTcuMsGEVeWOLSnF+oGCYlZ0y+wQti8EjPan0LV
	y0lM+7oGqkZa4vysDYwwNy/+/hgqzi9x7PYOJpCTQXqf3A+GGbN78xc2CFtAYuqZg1Ct6hLz
	pq1kgrD5JNYsfMsCM2bXqeXMML33t8yFektRYkr3Q3YIW0viy499bOje4hWwlzg+cxn7BEa5
	WUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9ApDveLE3OLSvHS95PzcTYzgBPVs4Q7GL+etDzEK
	cDAq8fB67OkOFGJNLCuuzD3EKMHBrCTCu2EDUIg3JbGyKrUoP76oNCe1+BBjMjD+JjJLiSbn
	A5NnXkm8obGBsaGhpbmBqaGRBWnCSuK8T1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw2l95955b
	48ykW0sZj7a6BvA8vVK47LximmNaAfPJ0M8/Mo0O5L0yyDiru++YX4X17v3p3pZR63LT/jzj
	bj1uumnK5HOcfR9UTxTMmuoxvei7Wc/64/5K2udyIvP3f/ixRFhAdZ18zdKlNlUNdxcevZh1
	KdNBoHqBRtXRJe94Pqz69LlscRHnAiWW4oxEQy3mouJEAGbVsOqUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4A0q6qV019811


> Can you give us the full crash message, (i.e., the panic, the BUG,
> WARN, the registers, etc.), and not the stack trace?

>                       - Ted

Hi, Ted
Actually i try to find the crash point. And i confirmed crash point is in __journal_remove_journal_head() function.
I added some debug code and i found  J_ASSERT_JH is failed for jh->b_transaction. 
My source tree has some modifications only for MIPS architecture. I don't think it does not affect to ext4 operation. 
Also I confirmed the problem is not reproduced before merge 149b306089b88e186942a8d6647028ae6683aaf9.

149b306089b88e186942a8d6647028ae6683aaf9 Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4

My full crash messages are as follows.

Iozone: Performance Test of File I/O
                Version $Revision: 3.397 $
                Compiled for 64 bit mode.
                Build: linux-powerpc64

        Contributors:William Norcott, Don Capps, Isom Crawford, Kirby Collins
                     Al Slater, Scott Rhine, Mike Wisner, Ken Goss
                     Steve Landherr, Brad Smith, Mark Kelly, Dr. Alain CYR,
                     Randy Dunlap, Mark Montague, Dan Million, Gavin Brebner,
                     Jean-Marc Zucconi, Jeff Blomberg, Benny Halevy, Dave Boone,
                     Erik Habbinga, Kris Strecker, Walter Wong, Joshua Roo[  233.458766] CPU: 3 PID: 1535 Comm: iozone Not tainted 3.9.0+ #81
t,
                     Fabrice Bacchella, Zhenghua Xue, Qin Li, Darre[  233.470132] Stack :n Sawyer.
                     Ben England.

        Run began: Sun Dec 10  ffffffff8101143808:38:24 2000

        Record Size 64 KB
        File size set to 5120 KB
 a80000008b64b000       SYNC Mode.
        Command line used: iozone -l 20 -u 20 -r 64k -s 5 0000000000000003m -o -F /user/f1 /user/f2 /user/f3 /user/f4 /user/f5 /user/f6 /u ffffffff80292470ser/f7 /user/f8 /user/f9 /user/f10 /user/f11 /user/f12 /user/f13
          /user/f14 /user/f15 /user/f16 /user/f17 /user/f18 /user/f19 /us 0000000000000000er/f20
        Output is in Kbytes/sec
        Time Resolution = 0.000001 se ffffffff80fa0000conds.
        Processor cache size set to 1024 Kbytes.
        Processor ca 000000000000001fche line size set to 32 bytes.
        File stride size set to 17 * re ffffffff80293728cord size.
        Min process = 20
        Max process = 20
        Throughput
         test with 20 processes
        Each process writes a 5120 Kbyte file i 0000000000000000n 64 Kbyte records
 0000000000000000 ffffffff81080000 ffffffff81080000
          ffffffff80e2abf0 ffffffff80f8f9f7 a8000002017a0db8 0000000000000020
          0000000000000003 0000000000000020 a80000020025f968 ffffffff810f0000
          a80000020025f770 ffffffff806ee88c a80000020025f588 ffffffff80290994
          000000007ef10087 ffffffff80293b58 000000000000000a ffffffff80e2abf0
          0000000000000003 a80000020025f4b0 00000002017a10f8 ffffffff805e68b4
          0000000000000000 0000000000000000 0000000000000000 0000000000000000
          0000000000000000 ffffffff80272418 0000000000000000 0000000000000000
          ...
[  233.604041] Call Trace:
[  233.606495] [<ffffffff80272418>] show_stack+0x68/0x80
[  233.611550] [<ffffffff805e68b4>] cdr_event_handler+0x604/0xbf8
[  233.617384] [<ffffffff805e7648>] cdr_event_die+0xd0/0x150
[  233.622784] [<ffffffff802bd42c>] notifier_call_chain+0x5c/0xa8
[  233.628619] [<ffffffff802bdb04>] __atomic_notifier_call_chain+0x3c/0x58
[  233.635233] [<ffffffff802bdb68>] notify_die+0x38/0x48
[  233.640285] [<ffffffff80271c48>] do_trap_or_bp+0x48/0x1a8
[  233.645684] [<ffffffff8026c764>] resume_userspace_check+0x0/0x10
[  233.651695] [<ffffffff80460b64>] jbd2_journal_put_journal_head+0xcc/0x250
[  233.658484] [<ffffffff8045a1b4>] jbd2_journal_get_write_access+0x3c/0x58
[  233.665188] [<ffffffff804348a8>] __ext4_journal_get_write_access+0x58/0xa0
[  233.672064] [<ffffffff80410344>] ext4_reserve_inode_write+0x84/0xb0
[  233.678331] [<ffffffff804103ac>] ext4_mark_inode_dirty+0x3c/0x1e0
[  233.684424] [<ffffffff80410590>] ext4_dirty_inode+0x40/0x70
[  233.689998] [<ffffffff80392258>] __mark_inode_dirty+0x48/0x238
[  233.695832] [<ffffffff803828f4>] update_time+0xb4/0x100
[  233.701058] [<ffffffff803829f0>] file_update_time+0xb0/0x108
[  233.706718] [<ffffffff8031eb98>] __generic_file_aio_write+0x180/0x380
[  233.713158] [<ffffffff8031edf8>] generic_file_aio_write+0x60/0xc0
[  233.719252] [<ffffffff8040af54>] ext4_file_write+0x6c/0x468
[  233.724827] [<ffffffff80366cbc>] do_sync_write+0x84/0xe8
[  233.730139] [<ffffffff80368700>] vfs_write+0xe0/0x1e0
[  233.735191] [<ffffffff803688f8>] SyS_write+0x50/0xc0
[  233.740157] [<ffffffff80274864>] handle_sys64+0x44/0x64

Thanks. ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
