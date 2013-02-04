Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3BDWST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:18:19 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61029 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab3BDWSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:18:16 -0500
From: Grant Coady <gcoady.lk@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 3.7.5: Kernel panic on halt
Date: Tue, 05 Feb 2013 09:18:01 +1100
Organization: scattered
Message-ID: <l2c0h896p2of3i8l6ivc6di7n7s72sbve3@4ax.com>
User-Agent: ForteAgent/7.00.32.1200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I was running machine overnight on 12V battery test, with this simple 
kernel compile loop:

  grant@itxmini:~/linux/linux-3.7.5a$ while :; do make clean; make -j5; done

Today it was time to shutdown the box ('halt' command) and recharge the battery.

Snapshot of screen:

  http://bugsplatter.id.au/misc/image/IMG_5627-kernel-panic-itxmini-2013-01-05.jpg

Kernel .config and dmesg:

  http://bugsplatter.id.au/kernel/boxen/itxmini/config-3.7.5a.gz
  http://bugsplatter.id.au/kernel/boxen/itxmini/dmesg-3.7.5a.gz

Box is Intel D510MO mobo with dual core HT Atom CPU with 2GB memory, 2GB 
swap (unused), Intel pro/100 NIC (disconnected), onboard PS/2 keyboard, 
ps/2 mouse, 1Gbps NIC, VGA monitor connected.

What next?  Box rebooted normally.  Ha

Thanks,
Grant.
