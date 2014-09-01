Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaIADDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:03:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:45748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaIADDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:03:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,439,1406617200"; 
   d="scan'208";a="584376171"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "atull@opensource.altera.com" <atull@opensource.altera.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>
Subject: RE: [PATCH 2/3] GPIO: gpio-dwapb: Support Debounce
Thread-Topic: [PATCH 2/3] GPIO: gpio-dwapb: Support Debounce
Thread-Index: AQHPwdzzhIk9fR+A30KFU3thSnN/apvmEFIAgAEThYCABHq6wA==
Date: Mon, 1 Sep 2014 03:03:05 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E981925@SHSMSX101.ccr.corp.intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
	 <1409161588-19417-3-git-send-email-alvin.chen@intel.com>
	 <alpine.DEB.2.02.1408281007290.26299@atx-linux-37>
 <1409297883.30155.29.camel@intel.com>
In-Reply-To: <1409297883.30155.29.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8133dc7002363

> >
> > I don't understand the reason for adding dwapb_read and dwapb_write here.
> > The rest of the driver is using readl and writel.  I'd rather not see
> > two different methods being used in the same driver for register access.
> > Maybe I'm missing something, but if we need to add dwapb_read/write,
> > then it should be used for all register access.
> 
> Alan, it was my proposal. I rather agree that is better to convert all accesses to
> that.
OK, I will convert all readl&writel to dwapb_read&dwapb_write.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
