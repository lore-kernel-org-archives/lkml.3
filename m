Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab3IKRyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:54:19 -0400
Received: from snt0-omc1-s8.snt0.hotmail.com ([65.55.90.19]:5297 "EHLO
	snt0-omc1-s8.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363Ab3IKRyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:54:18 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Sep 2013 13:54:18 EDT
X-TMN: [InNlMWYxf34uwc1Lx+OUHiwC3GnbzeLD]
X-Originating-Email: [shiro.itou@outlook.com]
Message-ID: <SNT149-W781B1B34AEC0458F8ED9B39A390@phx.gbl>
From: =?utf-8?B?U2hpcm8gSXRvdSDkvIrmnbE=?= <shiro.itou@outlook.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Error message from kernel
Date: Wed, 11 Sep 2013 10:47:49 -0700
Importance: Normal
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 11 Sep 2013 17:47:49.0209 (UTC) FILETIME=[07E83490:01CEAF17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8BHsSKF006826

Hi All,

I try to do pcie hotplug testing. I create ext4 file system on disk and mount, then I do surprise hotplug. When I insert disk I see below error messagee. I am new to Linux kernel, Please let me know any clue for below error. Thank you for your help.

[I convert error from image to text, error message not perfect. All function names correct.]


[Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 186 is 53003c)
[<ffffffff8111c495>] ? mempool_alloc_s1ab+0x15/0x20
[<ffffffff8125d02d>] submit_bio+0x8d/0x120
[<ffffffff1311b4c36>] submit_bh+exf6/x150
[<fffiffff811173434>] block_read_full_page+0x274/0x3d0
[tdfffffiffilibbZ1101] blkdev_get_block+.8bdiax713
[laffilfff8113b47e>]? __inc_zone_page_state+ENZe/Eix39
[lialfilibff13112fc361>] ? __lru_cache_add+8x40/8x99
[Riffffrffelibc438>]blkdev_readpage+9x113/13x28Â 
[<Iffrifff13112e134a>]__do_page_cache_readahead+ex28a/8x218
[<tdffff1118112e9f1>] force_page_cache_readahead.13x71/exaeÂ 
[<1ff1ffif13112ef13] page_cache_sync_readahead +ex113.11x58
[<ffffffff13222211 ] generic_file_aio_readilx558/9x798
[<ffffffff1111893>] blkdev_aio_read+8x53/8xce
[<lffffff81144311>] ?handle_mm_fault+0x23a/0x310
[<ffffffff811213123>] do_sync_read
[<ffffffff811212333>] ? autoremove_wake_function
[<ffffffff811212333>] ? cp_new_stat
[<ffffffff8112235423>] ? selinux_file_permission
[<ffffffff8112134534>]? security_file_permission
[<ffffffff8112235467>] vfs_read
[<ffffffff8112436423>] sys_read
[<ffffffff8112546788>] ? do_device_not_available
[<ffffffff8112123566>] system_call_fastpath


Thank You,
Shiro 		 	   		  ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
