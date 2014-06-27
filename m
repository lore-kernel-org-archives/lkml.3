Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaF0MLC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:11:02 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58848 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaF0MLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:11:00 -0400
Date: Fri, 27 Jun 2014 14:10:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
Message-ID: <20140627121053.GD23153@pd.tnic>
References: <20140625153227.GA13845@pd.tnic>
 <20140625202650.GC13845@pd.tnic>
 <20140627101831.GB23153@pd.tnic>
 <53AD586A.40900@redhat.com>
 <20140627115545.GC23153@pd.tnic>
 <53AD5D27.2090505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53AD5D27.2090505@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 02:01:43PM +0200, Paolo Bonzini wrote:
> Can you try gathering a trace? (and since those things get huge, you
> can send it to me offlist) Also try without ept and see what happens.

Yeah, Joerg just sent me a diff on how to intercept #DF. I'll add a
tracepoint so that it all goes into the trace together.

> Also, perhaps you can bisect between Linus's tree and tip?

Yep, that's next if we don't get smart from the #DF trace.

> And finally, what is the host kernel?

3.16-rc2+ - "+" is tip/master from the last weekend with a couple of
patches to arch/x86/ from me which should be unrelated (yeah, we've
heard that before :-)).

Thanks for the suggestions, I'm going for a run now but after I get
back, debugging session starts with host and guest rebuilt afresh. :-)

Stay tuned.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
