Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3IPVuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:50:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:14001 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab3IPVuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:50:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,918,1371106800"; 
   d="scan'208";a="361375935"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andi Kleen <andi@firstfloor.org>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH v2 1/4] mm/hwpoison: fix traverse hugetlbfs page
 to avoid printk flood
Thread-Topic: [RESEND PATCH v2 1/4] mm/hwpoison: fix traverse hugetlbfs page
 to avoid printk flood
Thread-Index: AQHOsaXFJmJWUCUhwUmKHzq/SE5I2JnGYvcAgAKGf9A=
Date: Mon, 16 Sep 2013 21:50:06 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CFD2D6@ORSMSX106.amr.corp.intel.com>
References: <1379202839-23939-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130915001352.GQ18242@two.firstfloor.org>
In-Reply-To: <20130915001352.GQ18242@two.firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is good - but the real solution is to stop poisoning entire huge pages ... they should
be broken into 4K pages and just one 4K page should be poisoned.

Naoya Horiguchi: I thought that you were looking at this problem some months ago. Any progress?

-Tony
