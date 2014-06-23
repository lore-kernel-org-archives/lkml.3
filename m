Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaFWNMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:12:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbaFWNMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:12:03 -0400
From: Daniel Borkmann <dborkman@redhat.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux@horizon.com, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] crc32 combine improvements
Date: Mon, 23 Jun 2014 15:11:53 +0200
Message-Id: <1403529116-18385-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So almost a month passed, and I don't want this to get lost
somewhere. I have applied the feedback given at that time to
this set, rebased plus tested it against latest net-next. I
decided to route this via netdev as it improves performance
upon library code that provides library bits for SCTP, i.e.
for non-linear skb csum handling in IPVS. Thus, resending
this for George before it gets lost.

Thanks!

George Spelvin (3):
  lib: crc32: Greatly shrink CRC combining code
  lib: crc32: Mark test data __initconst
  lib: crc32: Add some additional __pure annotations

 include/linux/crc32.h |  20 +++++--
 lib/crc32.c           | 153 ++++++++++++++++++++++++--------------------------
 2 files changed, 88 insertions(+), 85 deletions(-)

-- 
1.7.11.7

