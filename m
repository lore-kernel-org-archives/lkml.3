Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaGHABY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:01:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:56780 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbaGHABW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:01:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,622,1400050800"; 
   d="scan'208";a="558564011"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [UPDATE PATCH v2 0/6] ACPI/EC: Critical race fixes.
Thread-Topic: [UPDATE PATCH v2 0/6] ACPI/EC: Critical race fixes.
Thread-Index: AQHPmdUe9MTqSNhV9EKRHbki9f/Qn5uVS5wA
Date: Tue, 8 Jul 2014 00:00:52 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880263342B@SHSMSX101.ccr.corp.intel.com>
References: <cover.1402792240.git.lv.zheng@intel.com>
 <cover.1404700569.git.lv.zheng@intel.com>
 <39044838.0k25m70bcR@vostro.rjw.lan>
In-Reply-To: <39044838.0k25m70bcR@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6801TEV009578

Hi,

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Monday, July 07, 2014 7:18 PM
> 
> On Monday, July 07, 2014 11:09:49 AM Lv Zheng wrote:
> > History:
> > v1:
> >  The collection of bug-fixes from kernel bugzilla bug 70891.
> > v2:
> >  1. Improves the patch descriptions to make the root cause of the 70891 bug
> >     more correct.
> >  2. Improves a race fix to make it more robust.
> > v2 UPDATE:
> >  Added "Reported-by" and "Tested-by" from kernel bugzilla bug 59911/63931
> >  as a result of EC bug triage. Only patch descriptions are updated.
> 
> OK, I've updated the commits in my tree in accordance with this.
> 
> >  Removed the GPE fix, it is included by another GPE API fix series.
> 
> I've applied it separately already, so please don't resend it.

OK.

Thanks and best regards
-Lv

> 
> Thanks,
> Rafael

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
