Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab3GKWZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:25:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:17591 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab3GKWZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:25:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,647,1367996400"; 
   d="scan'208";a="267165287"
From: "Jarzmik, Robert" <robert.jarzmik@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "toralf.foerster@gmx.de" <toralf.foerster@gmx.de>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>,
        "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>
CC: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
Thread-Topic: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
Thread-Index: AQHOfoSrwDNhT7YubkOqxUtqHsgWYZlgDR/Q
Date: Thu, 11 Jul 2013 22:25:35 +0000
Message-ID: <65F5F98566038744B1B43C8FD3B7549F1BED3B7B@IRSMSX104.ger.corp.intel.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6BMPrxF026869

-----Original Message-----
From: Srivatsa S. Bhat [mailto:srivatsa.bhat@linux.vnet.ibm.com] 
Sent: Friday, July 12, 2013 00:15

> Robert, Durgadoss, it would be great if you could try it out and
>  see if it works well for your usecase. I tested it locally and 
> cpufreq related files did retain their permissions across 
> suspend/resume. Let me know if it works fine in your setup too.

Sure,  I'll check for Monday last delay, if that's not too late for you, as I'm a bit in a hurry right now, but I'll give it a try in the WE I think.

Cheers.

--
Robert
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
