Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaIEMDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:03:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:41830 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856AbaIEMDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:03:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="381881472"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "Chen, Alvin" <alvin.chen@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "atull@opensource.altera.com" <atull@opensource.altera.com>
Subject: Re: [PATCH 2/3 v2] GPIO: gpio-dwapb: Support Debounce
Thread-Topic: [PATCH 2/3 v2] GPIO: gpio-dwapb: Support Debounce
Thread-Index: AQHPyNcp8n6awOMU40SWtvGXv+WZgZvyM52AgAAS5sCAABnogA==
Date: Fri, 5 Sep 2014 12:03:41 +0000
Message-ID: <1409918621.30155.90.camel@intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
	 <1409928798-31895-3-git-send-email-alvin.chen@intel.com>
	 <1409908999.30155.85.camel@intel.com>
	 <4656BEB6164FC34F8171C6538F1A595B2E98298B@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E98298B@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.168]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D13CE650961014F84335F080D1C19F3@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s85C414Y017065

On Fri, 2014-09-05 at 09:35 +0000, Chen, Alvin wrote:
> > Subject: Re: [PATCH 2/3 v2] GPIO: gpio-dwapb: Support Debounce
> > 
> > On Fri, 2014-09-05 at 07:53 -0700, Weike Chen wrote:
> > > This patch enables 'debounce' for the designware GPIO, and it is based
> > > on Josef Ahmad's previous work.
> > 
> > Can we split dwapb_read/write introducing and changing from this patch to a
> > separate one?
> > 
> Since the 'debounce' feature also needs read/write, if we splite this patch, then for 'debounce',
> One patch use readl/writel, and another patch change to dwapb_read/write. It seems duplicate since
> the previous patch use readl/writel and the fllowing one change it immediately.
> Since this patch is small, could we just make them together? How do you think?

Make the dwapb_writel/readl patch goes first in the series.

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
