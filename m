Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254Ab3CZTzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:55:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29697 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760230Ab3CZTzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:55:40 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=gPDFDwPFkwsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=T1ZKc6cXkYkA:10 a=cr9bPvsT3_gPWFB4skIA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1364327738.6345.198.camel@gandalf.local.home>
Subject: Re: [PATCH] ftrace: Consistently restore trace function on sysctl
 enabling
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Tue, 26 Mar 2013 15:55:38 -0400
In-Reply-To: <1364325014.6345.195.camel@gandalf.local.home>
References: <5151D26F.1070702@siemens.com>
	 <1364325014.6345.195.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 15:10 -0400, Steven Rostedt wrote:

> I remember there was a reason why I didn't update this, but I can't
> remember why. Looking at it now, it doesn't look like there is a reason.

I remember now. I didn't add it because the update_ftrace_function was
too much at the time. It was still doing the basic updates, but it was
also doing a bit more too. But this was before I added the extra checks.
I didn't call it because it seemed to be an overkill. But that doesn't
apply today.


> 
> I'll have to think about this one more. Another score for not
> commenting :-p

OK, I'll add it and it looks like it needs to go immediately, as well as
way back to 3.0 stable.

Thanks!

-- Steve


