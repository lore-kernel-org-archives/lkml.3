Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab3GAULw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:11:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3GAUK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 0/8] 3.0.85-stable review
Date: Mon,  1 Jul 2013 13:10:32 -0700
Message-Id: <20130701200232.909858308@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.85 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jul  3 19:59:07 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.85-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.85-rc1

Liang Li <liang.li@windriver.com>
    pch_uart: fix a deadlock when pch_uart as console

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: fix a horrid bug

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: prepare to fix a horrid bug

Stephane Eranian <eranian@google.com>
    perf: Disable monitoring on setuid processes for regular users

Zefan Li <lizefan@huawei.com>
    dlci: validate the net device in dlci_del()

Zefan Li <lizefan@huawei.com>
    dlci: acquire rtnl_lock before calling __dev_get_by_name()

Oleg Nesterov <oleg@redhat.com>
    hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

Anderson Lizardo <anderson.lizardo@openbossa.org>
    Bluetooth: Fix crash in l2cap_build_cmd() with small MTU


-------------

Diffstat:

 Makefile                      |  4 ++--
 drivers/net/wan/dlci.c        | 26 +++++++++++++++++----
 drivers/tty/serial/pch_uart.c | 29 +++++++++++++++++------
 fs/exec.c                     | 16 +++++++------
 fs/ubifs/dir.c                | 54 +++++++++++++++++++++++++++++++------------
 kernel/events/hw_breakpoint.c |  4 ++--
 net/bluetooth/l2cap_core.c    |  3 +++
 7 files changed, 98 insertions(+), 38 deletions(-)


