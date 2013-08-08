Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab3HHNVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:21:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32266 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221Ab3HHNVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:21:04 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=48llYAvPBHsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=r-PqRJr4KhwA:10 a=7NC6DI7Wmgfcf6NknTMA:9 a=QEXdDO2ut3YA:10 a=zlrGdX7v4sEA:10 a=QvK5AWxnUaoA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375968063.6848.56.camel@gandalf.local.home>
Subject: Re: [BUG] hackbench locks up with perf in 3.11-rc1 and beyond
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameeter <cl@linux.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Date: Thu, 08 Aug 2013 09:21:03 -0400
In-Reply-To: <1375934936.6848.41.camel@gandalf.local.home>
References: <1375934936.6848.41.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 00:08 -0400, Steven Rostedt wrote:
> I went to do some benchmarks on the jump label code, and ran:
> 
> 
> perf stat -r 100 ./hackbench 50
> 

Note, perf doesn't even need to be involved. Running hackbench manually
three times causes the bug too.

-- Steve


