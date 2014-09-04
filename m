Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaIDNAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:00:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:6756 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaIDNAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:00:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,465,1406617200"; 
   d="scan'208";a="597882374"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: RE: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the
 idle cpu
Thread-Topic: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up
 the idle cpu
Thread-Index: AQHPyD8was+e4F1/Ik+g5Oz2p1c8epvw73oA
Date: Thu, 4 Sep 2014 12:59:54 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01E6B3A6@SHSMSX101.ccr.corp.intel.com>
References: <1409815075-4180-1-git-send-email-chuansheng.liu@intel.com>
 <540860AC.3030905@linaro.org>
In-Reply-To: <540860AC.3030905@linaro.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s84D0V0N009780



> -----Original Message-----
> From: Daniel Lezcano [mailto:daniel.lezcano@linaro.org]
> Sent: Thursday, September 04, 2014 8:53 PM
> To: Liu, Chuansheng; peterz@infradead.org; luto@amacapital.net;
> rjw@rjwysocki.net; mingo@redhat.com
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Liu, Changcheng;
> Wang, Xiaoming; Chakravarty, Souvik K
> Subject: Re: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the
> idle cpu
> 
> On 09/04/2014 09:17 AM, Chuansheng Liu wrote:
> > Implementing one new API wake_up_if_idle(), which is used to
> > wake up the idle CPU.
> >
> > Suggested-by: Andy Lutomirski <luto@amacapital.net>
> > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> 
> Hi Chuanseng,
> 
> in the future, please prefix the patches with the version number and a
> changelog.
> 
Thanks your advice, Daniel, will do that next time:)

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
