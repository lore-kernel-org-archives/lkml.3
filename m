Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3JJDyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 23:54:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:20016 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751269Ab3JJDyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 23:54:46 -0400
Date: Wed, 9 Oct 2013 23:54:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, hpa@linux.intel.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@kernel.org,
        peterz@infradead.org, williams@redhat.com, bp@alien8.de,
        akpm@linux-foundation.org, andi.kleen@intel.com
Subject: Re: [RFC][PATCH] x86: Lazy disabling of interrupts
Message-ID: <20131009235443.4158520f@gandalf.local.home>
In-Reply-To: <20131009.233928.1664631911260282195.davem@davemloft.net>
References: <5255C07E.70805@linux.intel.com>
	<878uy2ytd8.fsf@tassilo.jf.intel.com>
	<20131009203627.27166b20@gandalf.local.home>
	<20131009.233928.1664631911260282195.davem@davemloft.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Oct 2013 23:39:28 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Wed, 9 Oct 2013 20:36:27 -0400
> 
> > I don't know why my email never reached LKML, was there something about
> > it that prevented it from going? The total character length was 46,972,
> > well below the 100,000 limit. Also the Cc list wasn't that big. Did my
> > ISP get flagged as a spam bot or something?
> > 
> > I can bounce it to you to see what was wrong with it.
> 
> That's odd, can you try sending it to the list again?  I'll watch
> very carefully for a bounce.
> 

I just sent it as a redirect to LKML. Hopefully that worked.

Thanks,

-- Steve
