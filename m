Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbaCMXOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:14:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:36237 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbaCMXOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:14:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,650,1389772800"; 
   d="scan'208";a="498118548"
From: "Luck, Tony" <tony.luck@intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 4/6] fs/proc/page.c: introduce /proc/kpagecache interface
Thread-Topic: [PATCH 4/6] fs/proc/page.c: introduce /proc/kpagecache
 interface
Thread-Index: AQHPPwTg47yS17PebkS/j9UAuYa1nZrfo6pA
Date: Thu, 13 Mar 2014 23:09:10 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31E04DD3@ORSMSX106.amr.corp.intel.com>
References: <1394746786-6397-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1394746786-6397-5-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1394746786-6397-5-git-send-email-n-horiguchi@ah.jp.nec.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Usage is simple: 1) write a file path to be scanned into the interface,
> and 2) read 64-bit entries, each of which is associated with the page on
> each page index.

Do we have other interfaces that work like that?  I suppose this is file is only open
to "root", so it may be safe to assume that applications using this won't stomp on
each other.

-Tony
