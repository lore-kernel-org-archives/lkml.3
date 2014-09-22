Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaIVBhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 21:37:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:47926 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbaIVBhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 21:37:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,568,1406617200"; 
   d="scan'208";a="479063522"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, atull <atull@opensource.altera.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Subject: RE: [PATCH 3/3 v2] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Topic: [PATCH 3/3 v2] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Index: AQHP1DBbVfH5SFqD50WpIXESvmDM4JwMYn9g
Date: Mon, 22 Sep 2014 01:37:05 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E994914@SHSMSX101.ccr.corp.intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
	<1409928798-31895-4-git-send-email-alvin.chen@intel.com>
 <CACRpkdZOZu4aj7aWnkVaQXLND6Cf7k-LNZikQr7DcKkp2cgwRg@mail.gmail.com>
In-Reply-To: <CACRpkdZOZu4aj7aWnkVaQXLND6Cf7k-LNZikQr7DcKkp2cgwRg@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8M1bR5s025487

> 
> > +/* Store GPIO context across system-wide suspend/resume transitions
> > +*/ static struct dwapb_context {
> > +       u32 data[DWAPB_MAX_PORTS];
> > +       u32 dir[DWAPB_MAX_PORTS];
> > +       u32 ext[DWAPB_MAX_PORTS];
> > +       u32 int_en;
> > +       u32 int_mask;
> > +       u32 int_type;
> > +       u32 int_pol;
> > +       u32 int_deb;
> > +} dwapb_context;
> 
> NAK, this should STILL be part of the device state container. Not a local
> variable.
> 
> I've said this before. Please fix this, thanks.
> 
Linus, please review Version 5 that I sent on Sep.17th. I have fixed it in the v5.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
