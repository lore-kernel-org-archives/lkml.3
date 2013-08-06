Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab3HFR6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:58:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27039 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab3HFR6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:58:07 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=2pTKvNz8ocyA7Tma9CcA:9 a=QEXdDO2ut3YA:10 a=Xau-knwm0hUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375811885.25420.44.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Tue, 06 Aug 2013 13:58:05 -0400
In-Reply-To: <CA+55aFwKYSwytooG50fyryWpVdGEk_v=vdB=L-kAyLmmSW=bkQ@mail.gmail.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	 <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	 <1375725328.22073.101.camel@gandalf.local.home>
	 <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
	 <1375727977.22073.112.camel@gandalf.local.home>
	 <CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com>
	 <1375798783.25420.30.camel@gandalf.local.home>
	 <CA+55aFwKYSwytooG50fyryWpVdGEk_v=vdB=L-kAyLmmSW=bkQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 10:48 -0700, Linus Torvalds wrote:

> So I wonder if this is a "ok, let's not bother, it's not worth the
> pain" issue. 128 bytes of offset is very small, so there probably
> aren't all that many cases that would use it.

OK, I'll forward port the original patches for the hell of it anyway,
and post it as an RFC. Let people play with it if they want, and if it
seems like it would benefit the kernel perhaps we can reconsider.

It shouldn't be too hard to do the forward port, and if we don't ever
take it, it would be a fun exercise regardless ;-)

Actually, the first three patches should be added as they are clean ups
and safety checks. Nothing to do with the actual 2-5 byte jumps. They
were lost due to their association with the complex patches. :-/

-- Steve


