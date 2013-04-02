Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762402Ab3DBU6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:58:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:12914 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762296Ab3DBU6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:58:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,394,1363158000"; 
   d="scan'208";a="315900653"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@kernel.org>, Chen Gong <gong.chen@linux.intel.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "tony.luck@gmail.com" <tony.luck@gmail.com>
Subject: RE: [PATCH] x86/mce: Rework cmci_rediscover() to play well with CPU
 hotplug
Thread-Topic: [PATCH] x86/mce: Rework cmci_rediscover() to play well with
 CPU hotplug
Thread-Index: AQHOL6zgE3eEptPfu06NMEOUcaWDfJjDahQA
Date: Tue, 2 Apr 2013 20:58:31 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E096E45@ORSMSX108.amr.corp.intel.com>
References: <20130319224408.GB18152@redhat.com>
 <20130320031647.GA13311@gchen.bj.intel.com>
 <514988F9.2000005@linux.vnet.ibm.com> <515AE64B.7080804@linux.vnet.ibm.com>
 <20130402141732.GA4391@pd.tnic>
In-Reply-To: <20130402141732.GA4391@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r32KwZsC021276

>> Tony mentioned that this patch worked fine for him. So could you
>> kindly pick up this patch?
>
> Normally, Tony picks up the Intel side of MCE. Tony, want me to do it?

I'll pick it up. Thanks.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
