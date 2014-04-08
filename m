Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbaDHB3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 21:29:32 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:54765 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbaDHB33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 21:29:29 -0400
Message-ID: <534350F6.9050604@gmail.com>
Date: Tue, 08 Apr 2014 03:29:26 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: WARNING ... drivers/gpu/drm/ttm/ttm_bo_vm.c...
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...
Command line: initrd=initrd.img
inst.stage2=hd:LABEL=Fedora\x20rawhide\x20x86_64  xdriver=modesetting
BOOT_IMAGE=vmlinuz
Kernel command line: initrd=initrd.img
inst.stage2=hd:LABEL=Fedora\x20rawhide\x20x86_64  xdriver=modesetting
BOOT_IMAGE=vmlinuz
...
------------[ cut here ]------------
WARNING: CPU: 1 PID: 1230 at drivers/gpu/drm/ttm/ttm_bo_vm.c:269
ttm_bo_vm_open+0x52/0x80 [ttm]()
CPU: 1 PID: 1230 Comm: Xorg Not tainted 3.15.0-0.rc0.git9.1.fc21.x86_64 #1
Call Trace:
 [<ffffffff817db690>] dump_stack+0x4d/0x66
 [<ffffffff81096b9d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81096cca>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa0250452>] ttm_bo_vm_open+0x52/0x80 [ttm]
 [<ffffffff810956fe>] copy_process.part.23+0x1b9e/0x1e90
 [<ffffffff81095bb6>] do_fork+0xc6/0x4b0
 [<ffffffff811de68f>] ? might_fault+0x5f/0xb0
 [<ffffffff817ef695>] ? sysret_check+0x22/0x5d
 [<ffffffff81096026>] SyS_clone+0x16/0x20
 [<ffffffff817efa49>] stub_clone+0x69/0x90
 [<ffffffff817ef669>] ? system_call_fastpath+0x16/0x1b
---[ end trace bc31de8c9c4c4d52 ]---
...

https://bugzilla.redhat.com/show_bug.cgi?id=1085145
https://bugzilla.redhat.com/attachment.cgi?id=883813


poma

