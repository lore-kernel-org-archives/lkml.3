Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab3DZIo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:44:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:65041 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab3DZIo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:44:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,557,1363158000"; 
   d="scan'208";a="327828511"
From: "Li, Fei" <fei.li@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "tomoki.sekiyama.qu@hitachi.com" <tomoki.sekiyama.qu@hitachi.com>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86: eliminate irq_mis_count counted in arch_irq_stat
Thread-Topic: [PATCH] x86: eliminate irq_mis_count counted in arch_irq_stat
Thread-Index: AQHOQlPHE9uJdxUuwUKi/1oc1Vk2RpjnoraAgACK23A=
Date: Fri, 26 Apr 2013 08:44:52 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE3634433D23@SHSMSX102.ccr.corp.intel.com>
References: <1366962971.32469.4.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <20130426081915.GA1450@gmail.com>
In-Reply-To: <20130426081915.GA1450@gmail.com>
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

> > Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
> > Signed-off-by: Li Fei <fei.li@intel.com>
> 
> The patch looks good, but this is not a valid signoff sequence. If Liu
> Chuansheng wrote this patch then his From: line should be included. If he
> acked it, then it should be added as Acked-by.
> 
Hello Ingo,
   Thanks for your quick feedback. 

   I add Chuansheng's signature basing on:
   1> Chuansheng found such hole in code;
   2> After discussion with Chuansheng, I wrote the patch;
   3> Chuansheng also acked it.
   
   Do you think it's OK to add Chuansheng's signature in such case?
   Or better suggestion?

Thanks in advance!
Fei

> Thanks,
> 
> 	Ingo
