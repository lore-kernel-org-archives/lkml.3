Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab3JPCIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:08:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:13491 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755154Ab3JPCIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:08:04 -0400
Date: Tue, 15 Oct 2013 22:07:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "Ingo Molnar (mingo@kernel.org)" <mingo@kernel.org>,
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
Subject: Re: Panic and page fault in loop during handling NMI backtrace
 handler
Message-ID: <20131015220755.5ee861d5@gandalf.local.home>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01B630C1@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A01B60835@SHSMSX101.ccr.corp.intel.com>
	<20131015124028.2221e85d@gandalf.local.home>
	<27240C0AC20F114CBF8149A2696CBE4A01B630C1@SHSMSX101.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013 01:54:51 +0000
"Liu, Chuansheng" <chuansheng.liu@intel.com> wrote:


> > Since the NMI iretq nesting has been fixed, there's no reason that
> I think you patch fix the infinite loop, we will have a test soon.
> BTW, we are using 3.10, could you help to point out which NMI iretq nesting patch?

There were many. You can read about what was done here:

 https://lwn.net/Articles/484932/

The original is here:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ccd49c2391773ffbf52bb80d75c4a92b16972517

But more were added.

But that is back in 3.3, so 3.10 has all the required updates.

-- Steve
