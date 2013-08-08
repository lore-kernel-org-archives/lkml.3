Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966055Ab3HHRjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:39:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28231 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965827Ab3HHRjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:39:31 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pR7EoCbdL7wA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=paP5AUKnsW4A:10 a=PBO-1Un9AAAA:8 a=AlhCKQ9lAAAA:8 a=7i8-QOkN47LI_lbzaQEA:9 a=QEXdDO2ut3YA:10 a=5h3qf2VynvwA:10 a=Z9L4AXzk_iwA:10 a=QxGHxB5dFfcA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375983568.6848.76.camel@gandalf.local.home>
Subject: Re: [PATCH] Revert "slub: do not put a slab to cpu partial list
 when cpu_partial is 0"
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameeter <cl@linux.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Date: Thu, 08 Aug 2013 13:39:28 -0400
In-Reply-To: <1375970270.6848.60.camel@gandalf.local.home>
References: <1375967992.6848.55.camel@gandalf.local.home>
	 <1375970270.6848.60.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 09:57 -0400, Steven Rostedt wrote:

> I'm using Debian testing, XFCE desktop, and Evolution 3.4.4.

I'm starting to play with claws-mail. This may become my new default
mailer :-)

-- Steve


