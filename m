Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab3GOQU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:20:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3GOQU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:20:57 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=TyVgHLz5XD0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=oLtpoGhtZv4A:10 a=UeIhxjOg6hr-157farYA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373905251.17876.150.camel@gandalf.local.home>
Subject: Re: [PATCH] kernel: trace: remove __init from
 race_selftest_startup_function() and trace_selftest_startup_function_graph()
From: Steven Rostedt <rostedt@goodmis.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Jul 2013 12:20:51 -0400
In-Reply-To: <51E35A7D.8000008@asianux.com>
References: <51DDFCF8.2090808@asianux.com>
	   <1373561279.17876.45.camel@gandalf.local.home>
	   <51DF44FA.9060000@asianux.com>
	  <1373593261.17876.61.camel@gandalf.local.home>
	  <51DF62DB.3010409@asianux.com>
	 <1373596735.17876.84.camel@gandalf.local.home>
	 <51DF7250.9020209@asianux.com> <51DFAE5A.2060005@asianux.com>
	 <51E35A7D.8000008@asianux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 10:12 +0800, Chen Gang wrote:

> Hello Frederic and Ingo:

Are you trying to go around me? I wrote this code and I'm one of the
maintainers for it. Your issue is very minor, and can wait till other
things get done first.

You said my previous patch fixed your problem, right? Then I'll add your
tested by and push it in due course.

I'll also get around to adding __init's to other functions too. But it
is *very* low on the totem pole of importance.

> 
> Could you provide your suggestions or completions for it ?
> 
> The trace_selftest_startup_* funcitons are mostly added by you without
> '__init', do you have additional considerations about it (intend to have
> no '__init') ?
> 
> If no reply, I recommend to keep no '__init': apply this patch or
> regress part of the patch "f1ed7c7 ftrace: Do not run selftest if
> command line parameter is set" (at least, it can avoid related warnings
> and treat all *selftest* fair).

It's a compile time warning that's a false positive. Not a run time
crash or other issue of importance. It can wait, relax. Otherwise you
are starting to become annoying.

-- Steve


