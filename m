Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3FKOYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 10:24:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:13276 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab3FKOY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 10:24:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,845,1363158000"; 
   d="scan'208";a="351722422"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH net-next 0/2] net: low latency sockets follow ups
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 11 Jun 2013 17:24:15 +0300
Message-ID: <20130611142415.17879.75569.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Here are two more patches.

Patch 1 removes the config menu for NET_LL_RX_POLL and defaults to y.
Patch 2 adds an SO_LL socket option to allow per-socket control of busy polling.

The patches do not depend on each other.
If one of them needs more work, please consider applying the other.

I will reply to this thread with a patch to sockperf that enables using
the socket option.

Thanks,
Eliezer

