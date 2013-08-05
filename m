Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3HETQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:16:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3HETQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:16:40 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=p3s9Fhg7NB6hhRqR250A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375730199.22073.135.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Mon, 05 Aug 2013 15:16:39 -0400
In-Reply-To: <87siyo3qna.fsf@tassilo.jf.intel.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	 <87siyo3qna.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 12:04 -0700, Andi Kleen wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> Can't you just use -freorder-blocks-and-partition?

Yeah, I'm familiar with this option.

> 
> This should already partition unlikely blocks into a
> different section. Just a single one of course.
> 
> FWIW the disadvantage is that multiple code sections tends
> to break various older dwarf unwinders, as it needs
> dwarf3 latest'n'greatest.

If the option was so good, I would expect everyone would be using it ;-)


I'm mainly only concerned with the tracepoints. I'm asking to be able to
do this with just the tracepoint code, and affect nobody else.

-- Steve


