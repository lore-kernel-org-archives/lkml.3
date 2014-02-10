Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaBJIhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:37:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:17179 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaBJIhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:37:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="478869913"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: RE: [PATCH 0/5] Enabling the asynchronous threads for other phases
Thread-Topic: [PATCH 0/5] Enabling the asynchronous threads for other phases
Thread-Index: AQHPIrqi2B4BtmO4kEuaEAU6Gs+OZ5quMCrg
Date: Mon, 10 Feb 2014 08:36:57 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01C1AF9E@SHSMSX101.ccr.corp.intel.com>
References: <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
 <2360514.bLFmJYMItS@vostro.rjw.lan>
In-Reply-To: <2360514.bLFmJYMItS@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1A8bMD7028199

Hello Rafael,

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Thursday, February 06, 2014 5:53 AM
> To: Liu, Chuansheng
> Cc: gregkh@linuxfoundation.org; pavel@ucw.cz; Brown, Len;
> linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Zhuangzhi
> Subject: Re: [PATCH 0/5] Enabling the asynchronous threads for other phases
> 
> On Monday, January 20, 2014 04:44:34 PM Liu, Chuansheng wrote:
> > Hello,
> >
> > This patch series are for enabling the asynchronous threads for the phases
> > resume_noirq, resume_early, suspend_noirq and suspend_late.
> >
> > Just like commit 5af84b82701a and 97df8c12995, with async threads it will
> > reduce the system suspending and resuming time significantly.
> >
> > With these patches, in my test platform, it saved 80% time in resume_noirq
> > phase.
> >
> > Has done the suspend-resume stress test for a long time, please help to
> > review.
> >
> > Best Regards,
> >
> > [PATCH 1/5] PM: Adding two flags for async suspend_noirq and
> > [PATCH 2/5] PM: Enabling the asynchronous threads for resume_noirq
> > [PATCH 3/5] PM: Enabling the asyncronous threads for resume_early
> > [PATCH 4/5] PM: Enabling the asyncronous threads for suspend_noirq
> > [PATCH 5/5] PM: Enabling the asyncronous threads for suspend_late
> 
> I've applied this to the bleeding-edge branch of the linux-pm.git tree, with
> minor changes related to coding style, white space etc.
Thanks your help.

> 
> Can you please verify that the bleeding-edge branch works for you as
> expected?
I have picked them from your bleeding-edge branch and has done the
suspend-resume stress test for about 200 times and 3 hours,
It is still working well.

Best Regards
Chuansheng Liu
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
