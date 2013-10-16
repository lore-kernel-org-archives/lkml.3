Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab3JPCJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:09:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:47006 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760075Ab3JPCJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:09:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,504,1378882800"; 
   d="scan'208";a="419748868"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Ingo Molnar (mingo@kernel.org)" <mingo@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "Peter Zijlstra (peterz@infradead.org)" <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: RE: Panic and page fault in loop during handling NMI backtrace
 handler
Thread-Topic: Panic and page fault in loop during handling NMI backtrace
 handler
Thread-Index: AQHOyhSKvzDzl3mukEuq8VRwxg0wupn2lUBQ
Date: Wed, 16 Oct 2013 02:09:47 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01B63136@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A01B60835@SHSMSX101.ccr.corp.intel.com>
	<20131015124028.2221e85d@gandalf.local.home>
	<27240C0AC20F114CBF8149A2696CBE4A01B630C1@SHSMSX101.ccr.corp.intel.com>
 <20131015220755.5ee861d5@gandalf.local.home>
In-Reply-To: <20131015220755.5ee861d5@gandalf.local.home>
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

Hello Steven,

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Wednesday, October 16, 2013 10:08 AM
> To: Liu, Chuansheng
> Cc: Ingo Molnar (mingo@kernel.org); hpa@zytor.com; fweisbec@gmail.com;
> akpm@linux-foundation.org; paulmck@linux.vnet.ibm.com; Peter Zijlstra
> (peterz@infradead.org); x86@kernel.org; 'linux-kernel@vger.kernel.org'
> (linux-kernel@vger.kernel.org); Wang, Xiaoming; Li, Zhuangzhi
> Subject: Re: Panic and page fault in loop during handling NMI backtrace handler
> 
> On Wed, 16 Oct 2013 01:54:51 +0000
> "Liu, Chuansheng" <chuansheng.liu@intel.com> wrote:
> 
> 
> > > Since the NMI iretq nesting has been fixed, there's no reason that
> > I think you patch fix the infinite loop, we will have a test soon.
> > BTW, we are using 3.10, could you help to point out which NMI iretq nesting
> patch?
> 
> There were many. You can read about what was done here:
> 
>  https://lwn.net/Articles/484932/
> 
> The original is here:
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ccd49c
> 2391773ffbf52bb80d75c4a92b16972517
> 
> But more were added.
> 
> But that is back in 3.3, so 3.10 has all the required updates.
Thanks your info, is trying your patch now.

> 
> -- Steve
