Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3IPXog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:44:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:65441 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3IPXod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:44:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,919,1371106800"; 
   d="scan'208";a="379191615"
From: "Luck, Tony" <tony.luck@intel.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH v2 1/4] mm/hwpoison: fix traverse hugetlbfs page
 to avoid printk flood
Thread-Topic: [RESEND PATCH v2 1/4] mm/hwpoison: fix traverse hugetlbfs page
 to avoid printk flood
Thread-Index: AQHOsaXFJmJWUCUhwUmKHzq/SE5I2JnGYvcAgAKGf9CAAHuMgIAAFJ6A//+PnLA=
Date: Mon, 16 Sep 2013 23:44:32 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CFD50B@ORSMSX106.amr.corp.intel.com>
References: <1379202839-23939-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130915001352.GQ18242@two.firstfloor.org>
 <3908561D78D1C84285E8C5FCA982C28F31CFD2D6@ORSMSX106.amr.corp.intel.com>
 <1379369397-ld8lbcn-mutt-n-horiguchi@ah.jp.nec.com>
 <20130916232345.GA3241@hacker.(null)>
In-Reply-To: <20130916232345.GA3241@hacker.(null)>
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

>>Sorry, I have no meaningful progress on this. Splitting hugepages is not
>>a trivial operation, and introduce more complexity on hugetlbfs code.
>>I don't hit on any usecase of it rather than memory failure, so I'm not
>>sure that it's worth doing now.
>
> Agreed. ;-)

Agreed that huge pages should be split - or that it is not worth splitting them?

Actually I wonder how useful huge pages still are - transparent huge pages may
give most of the benefits without having to modify applications to use them.
Plus the kernel does know how to split them when an error occurs (which I care
about more than most people).

-Tony
