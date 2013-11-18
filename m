Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3KRTXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:23:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:56188 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab3KRTXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:23:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="410734901"
From: "Jiang, Dave" <dave.jiang@intel.com>
To: Dave Hansen <dave@sr71.net>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dhillf@gmail.com" <dhillf@gmail.com>,
        "Naoya Horiguchi" <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [v3][PATCH 0/2] v3: fix hugetlb vs. anon-thp copy page
Thread-Topic: [v3][PATCH 0/2] v3: fix hugetlb vs. anon-thp copy page
Thread-Index: AQHO4lduiyigOBgxfkeUrVKgzunzi5or6J6A
Date: Mon, 18 Nov 2013 19:23:01 +0000
Message-ID: <1384802581.72241.7.camel@djiang5-linux2.ch.intel.com>
References: <20131115225550.737E5C33@viggo.jf.intel.com>
In-Reply-To: <20131115225550.737E5C33@viggo.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.2.105.54]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA603B6EF9F7DB48B446D24202C376D2@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAIJNKr3030323

On Fri, 2013-11-15 at 14:55 -0800, Dave Hansen wrote:
> This took some of Mel's comments in to consideration.  Dave
> Jiang, could you retest this if you get a chance?  These have
> only been lightly compile-tested.
> 

Everything looks good. 

Tested-by: Dave Jiang <dave.jiang@intel.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
