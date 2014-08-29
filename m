Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaH2CUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 22:20:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:11339 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaH2CUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 22:20:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="378468930"
From: "Brown, Len" <len.brown@intel.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "Ian Malone" <ibmalone@gmail.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Kernel bug 60770
Thread-Topic: Kernel bug 60770
Thread-Index: AQHPwsNTPULDi7dgpkClMfv/JuEokJvmfqwAgABacbA=
Date: Fri, 29 Aug 2014 02:19:54 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C94845DE6384@fmsmsx115.amr.corp.intel.com>
References: <CA+5PVA4Ld3-VfPN6NWk=uqiuG2p99dL8Ro_X08NFb33_UtnWMA@mail.gmail.com>
	 <CA+5PVA5XxcQe+Coy-OdMRsAxSCH=3B7QdsdXO2GqRkFDcAt0iA@mail.gmail.com>
 <1409234000.5212.7.camel@marge.simpson.net>
In-Reply-To: <1409234000.5212.7.camel@marge.simpson.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7T2KBVj022325

ISTR that I got interrupted when working on that one
and never got back to it.  Also, I think I had a puzzling
power measurement result -- like I had measured a power benefit,
and then i couldn't find a benefit.  (No matter, should be a perf
benefit even if ISO power)

Next week I should have access to a core2 DT and Xeon
and can take another look at this.

thanks,
-Len

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
