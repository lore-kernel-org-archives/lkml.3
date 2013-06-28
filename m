Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3F1M7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:59:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:37733 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab3F1M7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:59:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,958,1363158000"; 
   d="scan'208";a="362016618"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH net-next 0/2] net: lls cleanup patches
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        HPA <hpa@zytor.com>, Cody P Schafer <devel-lists@codyps.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Fri, 28 Jun 2013 15:59:18 +0300
Message-ID: <20130628125918.14419.36214.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Here are two cleanup patches.

1. fix warning from debug_smp_processor_id().
- reported by Cody P Schafer.

2. avoid calling sched_clock() in select and poll when lls is disabled.
- reported by Andi Kleen.

Thanks to everyone for their comments.

-Eliezer
