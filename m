Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935072Ab3DHRbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:31:20 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:33693 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934599Ab3DHRbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:31:19 -0400
MIME-Version: 1.0
From: Andrew Brooks <arb@sat.dundee.ac.uk>
Date: Mon, 8 Apr 2013 18:30:55 +0100
Message-ID: <CAHOfOo26SFsqRyH2mNV9cV1gt01ct7v11EpYN0yx3ic-HKoOyQ@mail.gmail.com>
Subject: niu lock-up (Transmit timed out, resetting) and NETDEV WATCHDOG
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Using niu driver for this card: Oracle/SUN Multithreaded 10-Gigabit
Ethernet Network Controller
after a period (often less than 24 hours) the interface will hang with
errors every 5 seconds
"niu: xxx: eth2: Transmit timed out, resetting"

Sometimes also in syslog are messages
WARNING: at sch_generic:255 dev_watchdog
NETDEV WATCHDOG: eth2 (niu): transmit queue 10 timed out

Does anyone know which driver revision has fixed this problem or if
it's still buggy?

Thanks!

Andrew

P.S. My guess is the commit on 2012-10-02 ??

2013-02-04	ethernet: Remove unnecessary alloc/OOM messages, alloc
cleanups	Joe Perches	1	-1/+1
2013-01-09	remove init of dev->perm_addr in drivers	Jiri Pirko	1	-26/+20
2012-12-07	drivers/net: fix up function prototypes after __dev*
removals	Greg Kroah-Hartman	1	-26/+17
2012-12-03	net/sun: remove __dev* attributes	Bill Pemberton	1	-45/+45
2012-10-07	drivers/net/ethernet/sun/niu.c: fix error return code	Peter
Senna Tschudin	1	-0/+1
2012-10-02	Merge branch 'for-3.7' of
git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq	Linus
Torvalds	1	-1/+1 [flush_work_sync is now flush_work]
2012-08-23	niu: Use PCI Express Capability accessors	Jiang Liu	1	-12/+7
2012-08-20	workqueue: deprecate flush[_delayed]_work_sync()	Tejun Heo	1	-1/+1
2012-07-23	niu: Change niu_rbr_fill() to use unlikely() to check
niu_rbr_add_page() return value	Shuah Khan	1	-1/+1
2012-07-23	niu: Fix to check for dma mapping errors.

2012-06-08	Revert "niu: Add support for byte queue limits."	David S.
Miller	1	-11/+1
2012-05-03	net/niu: remove one superfluous dma mask check	Sebastian
Andrzej Siewior	1	-1/+1
2012-02-23	ethernet: unify return value of .ndo_set_mac_address if
address is invalid	Danny Kukawka	1	-1/+1
2012-01-31	drivers/net: Remove alloc_etherdev error messages	Joe Perches	1	-3/+1
2011-12-02	niu: Fix typo in comment.	David S. Miller	1	-1/+1
2011-12-02	niu: Add support for byte queue limits.	David S. Miller	1	-1/+11
2011-12-02	niu: Remove redundant PHY ID test.	David S. Miller	1	-2/+4
2011-11-21	net: Change mii to ethtool advertisement function
names	Matt Carlson	1	-2/+2
2011-11-16	net: Add ethtool to mii advertisment conversion
helpers	Matt Carlson	1	-13/+2
2011-11-14	Sweep additional floors of strcpy in .get_drvinfo routines

2011-10-19	net: add skb frag size accessors	Eric Dumazet	1	-3/+3
2011-10-14	niu: fix skb truesize underestimation	Eric Dumazet	1	-8/+4
2011-09-16	ethtool: Update ethtool_rxnfc::rule_cnt on return from
ETHTOOL_GRXCLSRLALL	Ben Hutchings	1	-0/+2
2011-09-16	ethtool: Clean up definitions of rule location arrays in RX
NFC	Ben Hutchings	1	-2/+2
2011-09-15	niu: convert to SKB paged frag API.	Ian Campbell	1	-5/+2
2011-08-18	net: introduce IFF_UNICAST_FLT private flag	Jiri Pirko	1	-1/+4
2011-08-11	cassini/niu/sun*: Move the Sun drivers
