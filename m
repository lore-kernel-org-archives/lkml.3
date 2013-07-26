Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab3GZQld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:41:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28295 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab3GZQl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:41:28 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=lIv9asz7BPEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Fo3TpyNZN6kA:10 a=VwQbUJbxAAAA:8 a=Q-fNiiVtAAAA:8 a=oCcaPWc0AAAA:8 a=UL2k7pEv8CQRPwfSxDIA:9 a=QEXdDO2ut3YA:10 a=lcTMV_K9oDIA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374856886.6580.39.camel@gandalf.local.home>
Subject: Re: [PATCH 9/9] tracing: Remove locking trace_types_lock from
 tracing_reset_all_online_cpus()
From: Steven Rostedt <rostedt@goodmis.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Z Lam <azl@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, stable@vger.kernel.org
Date: Fri, 26 Jul 2013 12:41:26 -0400
In-Reply-To: <51F2A08B.2090207@broadcom.com>
References: <20130726130327.911599518@goodmis.org>
	 <20130726130513.428993451@goodmis.org> <51F2A08B.2090207@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-26 at 18:15 +0200, Arend van Spriel wrote:

> > Link:http://lkml.kernel.org/r/51EEC646.7070306@broadcom.com
> >
> > Reported-by: Arend van *Spril*<arend@broadcom.com>
> 
> Nasty dutch names, huh. If we ever meet on a summit you may try to 
> pronounce it :-) Way easier than Finnish.

Eek! How did that happen?? You would think cut and paste would work. I
did cut off the quotes that I had from the place that I cut it from. I
must have cropped off the 'e' there somehow too?

Sorry about that.

> 
> Regards,
> Arend
> 
> > Tested-by: Arend van *Spriel*<arend@broadcom.com>

Well, at least I got this part right.

-- Steve

