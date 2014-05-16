Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaEPWwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:52:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaEPWwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:52:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 0/9] 3.4.91-stable review
Date: Fri, 16 May 2014 15:55:23 -0700
Message-Id: <20140516225458.512693003@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.91 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun May 18 22:54:50 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.91-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.91-rc1

Mikulas Patocka <mpatocka@redhat.com>
    tgafb: fix mode setting with fbset

Andreas Schwab <schwab@linux-m68k.org>
    powerpc: Add vr save/restore functions

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracepoint: Do not waste memory on mods with no tracepoints

Thomas Graf <tgraf@suug.ch>
    netfilter: Can't fail and free after table replacement

Joe Perches <joe@perches.com>
    net: Add net_ratelimited_function and net_<level>_ratelimited macros

Andrey Vagin <avagin@openvz.org>
    netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len

Roman Pen <r.peniaev@gmail.com>
    blktrace: fix accounting of partially completed requests

Peter Hurley <peter@hurleysoftware.com>
    n_tty: Fix n_tty_write crash when echoing in raw mode

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: megaraid: missing bounds check in mimd_to_kioc()


-------------

Diffstat:

 Makefile                                    |   4 +-
 arch/powerpc/lib/crtsavres.S                | 186 ++++++++++++++++++++++++++++
 block/blk-core.c                            |   2 +-
 drivers/scsi/megaraid/megaraid_mm.c         |   2 +
 drivers/tty/n_tty.c                         |   2 +
 drivers/video/tgafb.c                       |  15 ++-
 include/linux/net.h                         |  23 ++++
 include/net/netfilter/nf_conntrack_extend.h |   4 +-
 include/trace/events/block.h                |  33 ++++-
 kernel/trace/blktrace.c                     |  20 +--
 kernel/tracepoint.c                         |   6 +
 net/bridge/netfilter/ebtables.c             |   5 +-
 net/ipv4/netfilter/arp_tables.c             |   6 +-
 net/ipv4/netfilter/ip_tables.c              |   6 +-
 net/ipv6/netfilter/ip6_tables.c             |   6 +-
 scripts/mod/modpost.c                       |   8 +-
 16 files changed, 297 insertions(+), 31 deletions(-)


