Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3HFQaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:30:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:62600 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab3HFQaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:30:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,827,1367996400"; 
   d="scan'208";a="358463077"
Message-ID: <52012481.2050207@linux.intel.com>
Date: Tue, 06 Aug 2013 09:29:53 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>   <1375725328.22073.101.camel@gandalf.local.home>   <51FFEC56.6040206@linux.intel.com>   <1375727010.22073.110.camel@gandalf.local.home>   <51FFEEEC.5060902@linux.intel.com>   <1375728583.22073.118.camel@gandalf.local.home>   <51FFF430.1060701@linux.intel.com>   <CA+55aFwz6cpsaWZ-19h91_CNGB5C3d1bNOv7woxetXOTyJ_CRw@mail.gmail.com>   <20130805195446.GA22359@Krystal>   <CA+55aFwrxRr4+kN8t8HCRnnVQyur5EGzQ_bRdYK3T-KW9Zp0aw@mail.gmail.com>   <20130805212855.GA23044@Krystal> <52001C92.3070209@linux.intel.com>  <1375805711.25420.34.camel@gandalf.local.home>  <52012229.2020707@linux.intel.com> <1375806413.25420.36.camel@gandalf.local.home>
In-Reply-To: <1375806413.25420.36.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 09:26 AM, Steven Rostedt wrote:
>>
>> No, but if we ever end up doing MPX in the kernel, for example, we would
>> have to put an MPX prefix on the jmp.
> 
> Well then we just have to update the rest of the jump label code :-)
> 

For MPX in the kernel, this would be a small part of the work...!

	-hpa

