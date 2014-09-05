Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbaIEJgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:36:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:56959 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbaIEJgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:36:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,471,1406617200"; 
   d="scan'208";a="595022273"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
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
Subject: RE: [PATCH 3/3 v2] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Topic: [PATCH 3/3 v2] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Index: AQHPyNcp/ZRAVyzApUOJPkFrjH7HF5vyNAAAgAATyFA=
Date: Fri, 5 Sep 2014 09:35:55 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E98299F@SHSMSX101.ccr.corp.intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
	 <1409928798-31895-4-git-send-email-alvin.chen@intel.com>
 <1409909082.30155.86.camel@intel.com>
In-Reply-To: <1409909082.30155.86.camel@intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s859aHH0016111

> 
> On Fri, 2014-09-05 at 07:53 -0700, Weike Chen wrote:
> > This patch enables suspend and resume mode for the power management,
> > and it is based on Josef Ahmad's previous work.
> >
> > Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
> > Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
> 
> I have to recall my reviwed-by tag since patch is quite changed and as I
> understood Linus is continuing to be changed.
OK.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
