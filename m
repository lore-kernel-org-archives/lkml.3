Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbaIRCie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:38:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:50623 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbaIRCid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:38:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,543,1406617200"; 
   d="scan'208";a="593023302"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Kevin Easton <kevin@guarana.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Thread-Topic: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Thread-Index: AQHPzZ3/3LbWETWFOEu3f3vsawDskpwC5FKAgAB7e3CAAl61AIAAeCwA
Date: Thu, 18 Sep 2014 02:37:50 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE017B3436@shsmsx102.ccr.corp.intel.com>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
 <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com>
 <20140916075007.GA22076@chicago.guarana.org>
 <9E0BE1322F2F2246BD820DA9FC397ADE017B32C6@shsmsx102.ccr.corp.intel.com>
 <20140918032334.GA26560@chicago.guarana.org>
In-Reply-To: <20140918032334.GA26560@chicago.guarana.org>
Accept-Language: zh-CN, en-US
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



On 2014-09-18, Kevin Easton wrote:
> On Thu, Sep 18, 2014 at 12:40:29AM +0000, Ren, Qiaowei wrote:
>>> Would it be prudent to use an error code other than EINVAL for the
>>> "hardware doesn't support it" case?
>>> 
>> Seems like no specific error code for this case.
> 
> ENXIO would probably be OK.  It's not too important as long as it's
> documented.
> 
Yes. Looks like that ENXIO will be better.

Thanks,
Qiaowei
