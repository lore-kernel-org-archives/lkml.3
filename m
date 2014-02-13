Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbaBMNCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:02:47 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:55316 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaBMNCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:02:45 -0500
MIME-Version: 1.0
Date: Thu, 13 Feb 2014 21:02:44 +0800
Message-ID: <CAAJw_ZvX2AfS8COiNdN9gi_1xJ4L_vL=ROCzcLL3u0h51kuX3Q@mail.gmail.com>
Subject: Lenovo X240 (haswell) suspend-to-ram hangs on 3-14.0-rc2
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can't suspend to ram/disk on the Lenovo X240 with Intel i7-4600.

kernel 3.14.0-rc2

The same kernel works find on Lenovo X230 with Intel i7-3520M.

Here's the trace ..


[<ffffffff81034ba6>] ? do_exit+0x852/0x89d
[<ffffffff8158e5d8>] ? prinfk+0x4f/0x54
[<iiffffff81005060>] ? oops_end+0x78/0x7d
[<ffffffff8158dc00>] ? no_context+0x1e6/0x1f5
[<ffffffff810274f8>] ? __do_page_fault+0x348/0x3c7
[<ffffffff8159376a>] ? __schedule+0x6Z3/0x775
[<ffffffff81596562>] ? page_fault+0x2Z/8x30
[<ffffffff814e76e4>] ? azx_enter_link_reset.isra.26+0x9/0x51
[<ffffffff814e68ac>] ? azx_clear_irq_pending+0x12/0x3e
[<ffffffff814e7821>1 ? azx_suspend+0xa1/0x105
[<ffffffff8128f543>] ? pci_pm_suspend+0x6e/0xee
[<ffffffff8128f4d5>] ? pci_pm_poweroff+0xb4/0xb4
[<ffffffff81333479>] ? dpm_run_callback.isra.8+0x24/8x52
[<ffffffff813335df>] ? __device_suspend+8x138/0x19b
[<ffffffff81333658>] ? async_suspend+0x16/0x7d
[<ffffffff8104d743>] ? async_run_entry_fn+0x55/0x10b
[<ffffffff81044abf>] ? process_one_work+0x1be/0x2ef
[<ffffffff8104503d>] ? worker_thread+0x1cb/0x2c4
[<ffffffff81044e72>] ? rescuer_thread+0x25d/0x25d
[<ffffffff81049a93>] ? kthread+0xc5/0xcd
[<ffffffff81040000>] ? SyS_setpriority+0x179/0x233
[<ffffffff810499ce>l ? kthread_freezable_should_stop+0x3b/0x3b
[<ffffffff8159697c>] ? rat_from_fork+0x7c/0xb0
[<ffffffff810499ce>l ? kthread_freezable_should_stop+0x3b/0x3b


Thanks,
Jeff
