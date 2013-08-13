Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab3HMOwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:52:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28894 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3HMOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:52:09 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=QyXUC8HyAAAA:8 a=ZnGWsrNFZn5mrUgem24A:9 a=CjuIK1q_8ugA:10 a=68DXFLj2n9IA:10 a=sS9Nkm3LX24A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 13 Aug 2013 10:52:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
Message-ID: <20130813105207.42b3915d@gandalf.local.home>
In-Reply-To: <520A46D6.90005@linux.intel.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	<20130812091707.GB27162@twins.programming.kicks-ass.net>
	<5208F78A.3000708@linux.intel.com>
	<20130812160950.GT3008@twins.programming.kicks-ass.net>
	<52091FB9.4080805@linux.intel.com>
	<20130813075048.GR27162@twins.programming.kicks-ass.net>
	<520A46D6.90005@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 07:46:46 -0700
"H. Peter Anvin" <hpa@linux.intel.com> wrote:

> > On Mon, Aug 12, 2013 at 10:47:37AM -0700, H. Peter Anvin wrote:
> >> Since we really doesn't want to...
> 
> Ow.  Can't believe I wrote that.
> 

All your base are belong to us!

-- Steve
