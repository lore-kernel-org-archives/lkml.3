Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269Ab3GaQnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:43:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2238 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab3GaQnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:43:15 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=p_wSJkOgJdAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vMlpsT2et3MA:10 a=CZkpJ56KOrl6hjesbDEA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375288993.5418.1.camel@gandalf.local.home>
Subject: Re: [for-next-3.11][PATCH 0/8] ftrace/tracing: Event file fixes and
 ftrace function hash fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 31 Jul 2013 12:43:13 -0400
In-Reply-To: <20130731142236.GA31073@redhat.com>
References: <20130730112718.273490378@goodmis.org>
	 <20130731114722.GA4416@redhat.com>
	 <1375279617.19999.1.camel@gandalf.local.home>
	 <20130731142236.GA31073@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 16:22 +0200, Oleg Nesterov wrote:

> That patch fixes the buggy debugfs_remove_recursive() and nothing else.

Cool, I just pulled it in, and added your test case as part of my test
suite.

> 
> The test-case from the changelog can trigger the problem with or without
> the recent changes. You can't (I hope) crash the kernel this way after
> these changes, but the undeleted directory is still obviously bad.
> 
> Just I think that "open/delete fixes" is not complete without this fix.

OK, I'll start running it through my tests and I'll be pushing it out
later today. I'm still waiting on a "tested-by" for one of my other
patches.

Thanks!

-- Steve


