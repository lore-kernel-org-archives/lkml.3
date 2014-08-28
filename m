Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965009AbaH1BJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:09:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:5917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbaH1BJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:09:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,414,1406617200"; 
   d="scan'208";a="564481200"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: atull <atull@opensource.altera.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>
Subject: RE: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Topic: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Index: AQHPwdz1dx1k2oxDc0a94LlHeTA5dpvkGkgAgAEXMtA=
Date: Thu, 28 Aug 2014 01:09:14 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E980AF7@SHSMSX101.ccr.corp.intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
 <1409161588-19417-4-git-send-email-alvin.chen@intel.com>
 <alpine.DEB.2.02.1408271103120.11131@atx-linux-37>
In-Reply-To: <alpine.DEB.2.02.1408271103120.11131@atx-linux-37>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hi Weike,
> 
> I tried out these patches on the current master branch (v3.17-rc2-9-g68e3702)
> with a socfpga cyclone5 board.
> 
> If I apply all 3 patches, the kernel doesn't boot.
> 
> If I rebuild with only the first patch, I get only one gpio block showing up (should
> have 3 for this board) and these messages:
> 
> 
> How are you testing this?
The patches try to not change the current OF flow, and from the log message, the other two GPIO registered failed due to duplicate name.
Let me check the code to see what happen.


> 
> Alan
