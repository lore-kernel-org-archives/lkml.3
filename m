Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965569Ab3HHN5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:57:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab3HHN5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:57:52 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pR7EoCbdL7wA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=paP5AUKnsW4A:10 a=VwQbUJbxAAAA:8 a=dSN7wDdwjuLQdvHoveIA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375970270.6848.60.camel@gandalf.local.home>
Subject: Re: [PATCH] Revert "slub: do not put a slab to cpu partial list
 when cpu_partial is 0"
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameeter <cl@linux.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Date: Thu, 08 Aug 2013 09:57:50 -0400
In-Reply-To: <1375967992.6848.55.camel@gandalf.local.home>
References: <1375967992.6848.55.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 09:19 -0400, Steven Rostedt wrote:

> Link:
> https://lkml.kernel.org/r/1375934936.6848.41.camel@gandalf.local.home
> 

Evolution is really pissing me off. The wrapping that is used when I
compose a message is not the same as what is sent. This looked fine when
I hit send, but it should have been (/me switches to Preformatted mode):

Link: https://lkml.kernel.org/r/1375934936.6848.41.camel@gandalf.local.home

Anyone know how to fix Evolution to have the same wrap in the composer
as what is sent?

I'm using Debian testing, XFCE desktop, and Evolution 3.4.4.

Thanks,

-- Steve


