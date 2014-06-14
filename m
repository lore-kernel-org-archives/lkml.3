Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaFNUnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:43:50 -0400
Received: from 1wt.eu ([62.212.114.60]:42855 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbaFNUnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:43:49 -0400
Message-Id: <20140614191250.106515056@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sat, 14 Jun 2014 21:12:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 0/9] 2.6.32.63-longterm review
Message-ID: <57d1129d02f4fc14423dd66474950cb7@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ sorry for those who receive this series twice, I had an issue with
  the first attempt that prevented it from reaches the mailing lists ]

This is the start of the longterm review cycle for the 2.6.32.63 release.
All patches will be posted as a response to this one. If anyone has any
issue with these being applied, please let me know. If anyone is a
maintainer of the proper subsystem, and wants to add a Signed-off-by: line
to the patch, please respond with it.

Responses should be made within 72 hours. Anything received after that time
might be too late. If someone wants a bit more time for a deeper review,
please let me know.

The whole patch series can be found in one patch at :
     kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.63-rc1.gz

The shortlog and diffstat are appended below.

Thanks,
Willy

 include/linux/ethtool.h    |   4 +-
 kernel/auditsc.c           |  25 +++--
 kernel/futex.c             | 243 +++++++++++++++++++++++++++++++++++----------
 net/core/ethtool.c         |  17 +++-
 net/core/sysctl_net_core.c |   3 +-
 net/ipv4/sysctl_net_ipv4.c |   3 +-
 6 files changed, 228 insertions(+), 67 deletions(-)


