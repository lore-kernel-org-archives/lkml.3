Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaDADQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:16:32 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:42401 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaDADQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:16:30 -0400
Message-ID: <533A2F3D.7070502@huawei.com>
Date: Tue, 1 Apr 2014 11:15:09 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Zhangwei <jovi.zhangwei@huawei.com>
Subject: Re: [BUGREPORT] Tasklet scheduled issue in Linux 3.4.x-rt
References: <53144A57.4040204@huawei.com> <alpine.DEB.2.02.1403312230340.14882@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403312230340.14882@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
   Thanks for your reply!


>>  nf_defrag_ipv4 xt_state nf_conntrack usr_cache(O) acpi_cpufreq mperf processor thermal_sys sg hwmon iptable_filter ip_tables x_tables ixgbe(O) igb(O) bonding(O) tg(O) netmgmt(O) drvinstall(PO) dal(PO) dca usb_storage(O) uhci_hcd ehci_hcd usbcore(O) usb_common sata_mml(O) ahci(O) libata(O) satahp(O) drvframe(PO) sd_mod crc_t10dif scsi_mod agetty_interface(PO) ext3 jbd mbcache nvram_printk(PO) os_feeddog(PO) os_debug(O) osp_proc(PO) os_rnvramdev(PO) vos(O) bsp(PO) os_die_handler(O) os_oom_handler(O) os_panic_handler(O) biosnvramdriver(O) kbox(O)
>> [2012-03-26 18:55:43][  929.252460] Pid: 17495, comm: 3th SioT Tainted: P           O 3.4.24.15-0.11-default #1
> 
> You have loaded a gazillion of proprietary and out of tree modules and
> your kernel is tainted 'P'.
> 
> None of our problems. See:
> 
>  http://lwn.net/1999/0211/a/lt-binary.html
> 
>  https://lwn.net/Articles/287056/
> 
> I'm in a good mood today and give you some hints:
> 
> - Ingos patch is correct and always has been for RT.
> 
> - We had not a single bug report against this in almost 10 years.
> 
> - File your bugs to those who abuse our work and violate our license.

Actually, we applied the RT stable patch above the Greg 3.4 stable tree.
No other changes in schedule filed.

I will try to find out what codes cause this issue.

Thanks!
Yijing.

> 
> Case closed.
> 
>      tglx
> 
> .
> 


-- 
Thanks!
Yijing

