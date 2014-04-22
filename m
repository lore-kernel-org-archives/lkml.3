Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaDVK2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:28:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:7400 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbaDVK22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:28:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="525277179"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Robin Gong <b38343@freescale.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1] dma: imx-sdma: add support for sdma memory copy
Thread-Topic: [PATCH v1] dma: imx-sdma: add support for sdma memory copy
Thread-Index: AQHPWumN/LAsmiPIT02DhZWBo3zgk5sdZH8A
Date: Tue, 22 Apr 2014 10:28:05 +0000
Message-ID: <1398162484.11914.234.camel@smile.fi.intel.com>
References: <1397728870-22086-1-git-send-email-b38343@freescale.com>
	 <1397730289.11914.225.camel@smile.fi.intel.com>
	 <20140418094057.GA11496@Robin-OptiPlex-780>
In-Reply-To: <20140418094057.GA11496@Robin-OptiPlex-780>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <16A495714F092949AF8755D7098A086A@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3MASYxU005991

On Fri, 2014-04-18 at 17:41 +0800, Robin Gong wrote:
> On Thu, Apr 17, 2014 at 10:24:50AM +0000, Shevchenko, Andriy wrote:
> > On Thu, 2014-04-17 at 18:01 +0800, Robin Gong wrote:

[]

> > > +	dev_dbg(sdma->dev, "memcpy: %x->%x, len=%d, channel=%d.\n",
> > 
> > %pad for dma_addr_t variables.
> >
> Yes, %x here is not proper, will be %#llx here to align with others similar
> code in this file.

Why %#llx? You don't need the specific casting since kernel has special
specifiers for phys_addr_t and dma_addr_t and their derivatives (see
Documentation/printk-formats.txt)

> > > +		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
> > > +				i, count, sg_src->dma_address,
> > 
> > %pad for dma_addr_t.
> > 
> Accept the idea, same as the above.

Same as above.

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
