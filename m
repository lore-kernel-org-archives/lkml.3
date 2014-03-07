Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaCGW2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:28:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbaCGW2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:28:33 -0500
Date: Fri, 7 Mar 2014 17:27:43 -0500
From: Dave Jones <davej@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at
 arch/x86/kernel/cpu/amd.c:220 init_amd()
Message-ID: <20140307222743.GC580@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
References: <20140307015833.GA10048@localhost>
 <53195336.9080606@linux.intel.com>
 <20140307055035.GA5230@localhost>
 <531A164B.8040402@linux.intel.com>
 <20140307191050.GA10961@redhat.com>
 <531A33A2.5030706@linux.intel.com>
 <20140307213856.GF5255@pd.tnic>
 <20140307220655.GA580@redhat.com>
 <20140307222018.GG5255@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307222018.GG5255@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 11:20:18PM +0100, Borislav Petkov wrote:
 
 > Yeah, I think the test in the kernel is open above as a precaution in
 > case newer models appeared:
 > 
 >         if (((c->x86_model == 6) && (c->x86_mask >= 2)) ||
 > 
 > I hardly can imagine, though, if anyone is actually booting recent
 > kernels on a K7. We might just as well kill this code and not even miss
 > it.

When I wrote it 10 years or so back it made more sense than it probably
does now, so I'd be ok with just dropping it all too tbh.
Machines of that vintage probably have bigger problems now anyway.
I don't recall seeing a report of the taint flag being set ever in
a Red Hat bug report, but we've seen countless problems from machines
of that era with dying ram or motherboard capacitors or..

 > Btw, and sometimes when digging around, one can get lucky:
 > http://support.amd.com/TechDocs/23542a.pdf
 > 
 > K6. Ancient history stuff - I feel like I'm in a museum :-P

I still have NexGen docs somewhere ;)

	Dave

