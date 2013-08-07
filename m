Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab3HGQLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:11:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29742 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab3HGQLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:11:38 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=xEhx641PCuwcu81QBx4A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375891895.6848.9.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: =?UTF-8?Q?Ond=C5=99ej_B=C3=ADlka?= <neleai@seznam.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Wed, 07 Aug 2013 12:11:35 -0400
In-Reply-To: <20130807160336.GA1336@Krystal>
References: <CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com>
	 <1375798783.25420.30.camel@gandalf.local.home>
	 <CA+55aFwKYSwytooG50fyryWpVdGEk_v=vdB=L-kAyLmmSW=bkQ@mail.gmail.com>
	 <1375811885.25420.44.camel@gandalf.local.home>
	 <20130806203319.GA16170@Krystal>
	 <1375821817.25420.50.camel@gandalf.local.home>
	 <1375836304.25420.76.camel@gandalf.local.home>
	 <1375836960.25420.80.camel@gandalf.local.home>
	 <20130807050601.GA5385@domone.kolej.mff.cuni.cz>
	 <1375887730.6848.7.camel@gandalf.local.home>
	 <20130807160336.GA1336@Krystal>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 12:03 -0400, Mathieu Desnoyers wrote:

> You might want to try creating a global array of counters (accessible
> both from C for printout and assembly for update).
> 
> Index the array from assembly using:   (2f - 1f)
> 
> 1:
>         jmp ...;
> 2:
> 
> And put an atomic increment of the counter. This increment instruction
> should be located prior to the jmp for obvious reasons.
> 
> You'll end up with the sums you're looking for at indexes 2 and 5 of the
> array.

After I post the patches, feel free to knock yourself out.

-- Steve


