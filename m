Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3ENVey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:34:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61124 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758212Ab3ENVex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:34:53 -0400
Date: Tue, 14 May 2013 22:34:40 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: majianpeng <majianpeng@gmail.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] module: Add section ".ref.data" into kmemleak-scan-area.
Message-ID: <20130514213440.GA4963@MacBook-Pro.local>
References: <518DAA1A.3010407@gmail.com>
 <87bo8f39di.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo8f39di.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty,

On Mon, May 13, 2013 at 03:24:09AM +0100, Rusty Russell wrote:
> majianpeng <majianpeng@gmail.com> writes:
> 
> > In commit 523c81135,it used "__refdata" on event_class_ftrace_##call.
> > It will cause kmemleak to misjudge because when loading module it did
> > not add '.ref.data' into kmemleak-scan-area.
> > 
> > Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> > ---
> >  kernel/module.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Catalin?
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

I forgot to ask - are you picking up this patch or would like me to push
upstream? The patch got some more testing on a separate thread:

Tested-by: Steven Rostedt <rostedt@goodmis.org>

Thanks.

-- 
Catalin
