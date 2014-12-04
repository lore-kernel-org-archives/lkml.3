Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaLDJio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:38:44 -0500
Received: from out4133-146.mail.aliyun.com ([42.120.133.146]:57369 "EHLO
	out4133-146.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbaLDJim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:38:42 -0500
X-Greylist: delayed 91520 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Dec 2014 04:38:37 EST
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g08145;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=7;RT=7;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Zhang, Jun'" <jun.zhang@intel.com>
Cc: "'Ingo Molnar'" <mingo@redhat.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Liu, Chuansheng'" <chuansheng.liu@intel.com>,
        "'Liu, Changcheng'" <changcheng.liu@intel.com>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>
References: <007f01d00fa1$68bf6770$3a3e3650$@alibaba-inc.com> <88DC34334CA3444C85D647DBFA962C271171F94A@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <88DC34334CA3444C85D647DBFA962C271171F94A@SHSMSX104.ccr.corp.intel.com>
Subject: RE: [PATCH] sched/fair: fix select_task_rq_fair return -1
Date: Thu, 04 Dec 2014 17:32:17 +0800
Message-ID: <008201d00fa5$32acf2c0$9806d840$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJSp9NksmY1Oxbhvzcu8e1IGpYcmAKvyeqcm2R6oqA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This issue happened in 3.14.25.
> Do you know which patch to fix it in 3.18-rc7?
>
I see no fix needed by 3.18-rc7, but a tiny cleanup of -1

If 3.14 concerned, it is the work, I guess, of those maintainers like Greg KH.

Hillf

