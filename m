Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaDNSsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:48:15 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:55133 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbaDNSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:48:13 -0400
Date: Mon, 14 Apr 2014 21:43:53 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
Message-ID: <20140414184353.GA5630@drone.musicnaut.iki.fi>
References: <20130617055839.GB3073@blackmetal.musicnaut.iki.fi>
 <20130803.134042.2228681844349448961.davem@davemloft.net>
 <20131022174612.GC24448@blackmetal.musicnaut.iki.fi>
 <20131022.135442.1072093301788210177.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022.135442.1072093301788210177.davem@davemloft.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just for the archives, I got one of these again with 3.14:

[68674.536190] ------------[ cut here ]------------
[68674.590467] WARNING: CPU: 0 PID: 14600 at /home/aaro/los/work/shared/linux-v3.14/mm/mmap.c:2738 exit_mmap+0x138/0x160()
[68674.719635] Modules linked in:
[68674.756022] CPU: 0 PID: 14600 Comm: rm Not tainted 3.14.0-ultra-los_0a2b #1
[68674.839349] Call Trace:
[68674.868507]  [00000000004b9c78] exit_mmap+0x138/0x160
[68674.928931]  [00000000004503cc] mmput+0x2c/0xc0
[68674.983103]  [0000000000452e98] do_exit+0x1b8/0x800
[68675.041409]  [000000000045406c] do_group_exit+0x2c/0xa0
[68675.103897]  [00000000004540f4] SyS_exit_group+0x14/0x20
[68675.167439]  [0000000000406074] linux_sparc_syscall32+0x34/0x60
[68675.238258] ---[ end trace 8a52741fbdb89d8e ]---
[68675.293470] BUG: Bad rss-counter state mm:ffffff001df3d900 idx:1 val:1

A.
