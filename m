Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3LBJKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:10:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:50653 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab3LBJKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:10:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,809,1378882800"; 
   d="scan'208";a="445177076"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Joe Perches <joe@perches.com>
CC: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Laurent Pinchart" <laurent.pinchart+renesas@ideasonboard.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] lib/vsprintf.c: add %paD format specifier for
 dma_addr_t types
Thread-Topic: [PATCH] lib/vsprintf.c: add %paD format specifier for
 dma_addr_t types
Thread-Index: AQHO7z4ZQsNkhUSUp0WGLWVWhc/TdQ==
Date: Mon, 2 Dec 2013 09:08:43 +0000
Message-ID: <1385975297.1871.39.camel@smile>
References: <1385638084-10719-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1385663555.12210.19.camel@joe-AO722> <1385729760.1871.23.camel@smile>
	 <1385763040.12210.34.camel@joe-AO722> <1385975219.1871.38.camel@smile>
In-Reply-To: <1385975219.1871.38.camel@smile>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E699EA77F2121A489593914815CE7DD5@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB29AOGh011617

On Mon, 2013-12-02 at 11:06 +0200, Andy Shevchenko wrote:


> > Anyway, if you think you're going to do a lot of
> > transforms of printk("%x", dma_addr_t) with or without
> > (unsigned long long) or (u64) casts, I'll submit a signed
> > patch to Andrew.
> 
> I think it worse to submit even if we have no more such casting in the
> future (which is the case I don't believe in).

s/worse/worth/

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
