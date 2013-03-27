Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3C0Po7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:44:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:62697 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab3C0Po6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:44:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,920,1355126400"; 
   d="scan'208";a="309237930"
Date: Wed, 27 Mar 2013 23:44:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: sparclinux@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: usr/include/linux/types.h:27:1: error: unknown type name '__u16'
Message-ID: <20130327154453.GA27576@localhost>
References: <5152d3ed.vW9X0QzDTVkW7Gck%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5152d3ed.vW9X0QzDTVkW7Gck%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

The below errors show up in both upstream and linux-next.

   make ARCH=sparc allyesconfig
   make ARCH=sparc

   In file included from usr/include/linux/genetlink.h:4:0,
                    from Documentation/accounting/getdelays.c:27:
>> usr/include/linux/types.h:27:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:28:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:29:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:30:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:31:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:32:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:34:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:35:1: error: unknown type name '__u32'
   In file included from usr/include/linux/genetlink.h:5:0,
                    from Documentation/accounting/getdelays.c:27:
>> usr/include/linux/netlink.h:37:2: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:38:9: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:42:2: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:43:2: error: unknown type name '__u16'
>> usr/include/linux/netlink.h:44:2: error: unknown type name '__u16'
>> usr/include/linux/netlink.h:45:2: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:46:2: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:110:2: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:130:2: error: unknown type name '__u16'
>> usr/include/linux/netlink.h:131:2: error: unknown type name '__u16'
   In file included from Documentation/accounting/getdelays.c:27:0:
>> usr/include/linux/genetlink.h:13:2: error: unknown type name '__u8'
>> usr/include/linux/genetlink.h:14:2: error: unknown type name '__u8'
--
   In file included from usr/include/linux/netlink.h:5:0,
                    from Documentation/connector/ucon.c:28:
>> usr/include/linux/types.h:27:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:28:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:29:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:30:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:31:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:32:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:34:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:35:1: error: unknown type name '__u32'
   In file included from Documentation/connector/ucon.c:28:0:
>> usr/include/linux/netlink.h:37:2: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:38:9: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:42:2: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:43:2: error: unknown type name '__u16'
>> usr/include/linux/netlink.h:44:2: error: unknown type name '__u16'
>> usr/include/linux/netlink.h:45:2: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:46:2: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:110:2: error: unknown type name '__u32'
>> usr/include/linux/netlink.h:130:2: error: unknown type name '__u16'
>> usr/include/linux/netlink.h:131:2: error: unknown type name '__u16'
   In file included from usr/include/linux/rtnetlink.h:6:0,
                    from Documentation/connector/ucon.c:29:
>> usr/include/linux/if_link.h:9:2: error: unknown type name '__u32'
>> usr/include/linux/if_link.h:10:2: error: unknown type name '__u32'
--
   In file included from usr/include/linux/uuid.h:24:0,
                    from usr/include/linux/mei.h:70,
                    from Documentation/misc-devices/mei/mei-amt-version.c:77:
>> usr/include/linux/types.h:27:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:28:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:29:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:30:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:31:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:32:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:34:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:35:1: error: unknown type name '__u32'
   In file included from usr/include/linux/mei.h:70:0,
                    from Documentation/misc-devices/mei/mei-amt-version.c:77:
>> usr/include/linux/uuid.h:28:2: error: unknown type name '__u8'
>> usr/include/linux/uuid.h:32:2: error: unknown type name '__u8'
   In file included from Documentation/misc-devices/mei/mei-amt-version.c:77:0:
>> usr/include/linux/mei.h:95:2: error: unknown type name '__u32'
>> usr/include/linux/mei.h:96:2: error: unknown type name '__u8'
>> usr/include/linux/mei.h:97:2: error: unknown type name '__u8'
--
   In file included from usr/include/linux/if.h:22:0,
                    from Documentation/networking/ifenslave.c:161:
>> usr/include/linux/types.h:27:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:28:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:29:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:30:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:31:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:32:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:34:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:35:1: error: unknown type name '__u32'
   In file included from Documentation/networking/ifenslave.c:164:0:
>> usr/include/linux/if_bonding.h:96:2: error: unknown type name '__s32'
>> usr/include/linux/if_bonding.h:97:2: error: unknown type name '__s32'
>> usr/include/linux/if_bonding.h:98:2: error: unknown type name '__s32'
>> usr/include/linux/if_bonding.h:102:2: error: unknown type name '__s32'
>> usr/include/linux/if_bonding.h:104:2: error: unknown type name '__s8'
>> usr/include/linux/if_bonding.h:105:2: error: unknown type name '__s8'
>> usr/include/linux/if_bonding.h:106:2: error: unknown type name '__u32'
>> usr/include/linux/if_bonding.h:110:2: error: unknown type name '__u16'
>> usr/include/linux/if_bonding.h:111:2: error: unknown type name '__u16'
>> usr/include/linux/if_bonding.h:112:2: error: unknown type name '__u16'
>> usr/include/linux/if_bonding.h:113:2: error: unknown type name '__u16'
>> usr/include/linux/if_bonding.h:114:2: error: unknown type name '__u8'
   In file included from Documentation/networking/ifenslave.c:171:0:
--
   In file included from Documentation/spi/spidev_test.c:21:0:
>> usr/include/linux/types.h:27:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:28:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:29:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:30:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:31:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:32:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:34:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:35:1: error: unknown type name '__u32'
   In file included from Documentation/spi/spidev_test.c:22:0:
>> usr/include/linux/spi/spidev.h:86:2: error: unknown type name '__u64'
>> usr/include/linux/spi/spidev.h:87:2: error: unknown type name '__u64'
>> usr/include/linux/spi/spidev.h:89:2: error: unknown type name '__u32'
>> usr/include/linux/spi/spidev.h:90:2: error: unknown type name '__u32'
>> usr/include/linux/spi/spidev.h:92:2: error: unknown type name '__u16'
>> usr/include/linux/spi/spidev.h:93:2: error: unknown type name '__u8'
>> usr/include/linux/spi/spidev.h:94:2: error: unknown type name '__u8'
>> usr/include/linux/spi/spidev.h:95:2: error: unknown type name '__u32'
   Documentation/spi/spidev_test.c: In function 'main':
>> Documentation/spi/spidev_test.c:171:18: error: '__u8' undeclared (first use in this function)
   Documentation/spi/spidev_test.c:171:18: note: each undeclared identifier is reported only once for each function it appears in
>> Documentation/spi/spidev_test.c:193:18: error: '__u32' undeclared (first use in this function)
--
   In file included from Documentation/spi/spidev_fdx.c:11:0:
>> usr/include/linux/types.h:27:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:28:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:29:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:30:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:31:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:32:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:34:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:35:1: error: unknown type name '__u32'
   In file included from Documentation/spi/spidev_fdx.c:12:0:
>> usr/include/linux/spi/spidev.h:86:2: error: unknown type name '__u64'
>> usr/include/linux/spi/spidev.h:87:2: error: unknown type name '__u64'
>> usr/include/linux/spi/spidev.h:89:2: error: unknown type name '__u32'
>> usr/include/linux/spi/spidev.h:90:2: error: unknown type name '__u32'
>> usr/include/linux/spi/spidev.h:92:2: error: unknown type name '__u16'
>> usr/include/linux/spi/spidev.h:93:2: error: unknown type name '__u8'
>> usr/include/linux/spi/spidev.h:94:2: error: unknown type name '__u8'
>> usr/include/linux/spi/spidev.h:95:2: error: unknown type name '__u32'
   Documentation/spi/spidev_fdx.c: In function 'dumpstat':
>> Documentation/spi/spidev_fdx.c:81:2: error: unknown type name '__u8'
>> Documentation/spi/spidev_fdx.c:82:2: error: unknown type name '__u32'
>> Documentation/spi/spidev_fdx.c:84:16: error: '__u8' undeclared (first use in this function)
   Documentation/spi/spidev_fdx.c:84:16: note: each undeclared identifier is reported only once for each function it appears in
>> Documentation/spi/spidev_fdx.c:96:16: error: '__u32' undeclared (first use in this function)
--
   In file included from usr/include/linux/errqueue.h:4:0,
                    from Documentation/networking/timestamping/timestamping.c:46:
>> usr/include/linux/types.h:27:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:28:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:29:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:30:1: error: unknown type name '__u32'
>> usr/include/linux/types.h:31:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:32:1: error: unknown type name '__u64'
>> usr/include/linux/types.h:34:1: error: unknown type name '__u16'
>> usr/include/linux/types.h:35:1: error: unknown type name '__u32'
   In file included from Documentation/networking/timestamping/timestamping.c:46:0:
>> usr/include/linux/errqueue.h:7:2: error: unknown type name '__u32'
>> usr/include/linux/errqueue.h:8:2: error: unknown type name '__u8'
>> usr/include/linux/errqueue.h:9:2: error: unknown type name '__u8'
>> usr/include/linux/errqueue.h:10:2: error: unknown type name '__u8'
>> usr/include/linux/errqueue.h:11:2: error: unknown type name '__u8'
>> usr/include/linux/errqueue.h:12:2: error: unknown type name '__u32'
>> usr/include/linux/errqueue.h:13:2: error: unknown type name '__u32'

It's bisected down to upstream commit b87fc3e6e2e ("Merge tag 'staging-3.8-rc3' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging). However
it's possibly a wrong bisect because there are other build errors in
the parent commits and they may hide these errors.

Thanks,
Fengguang
---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
