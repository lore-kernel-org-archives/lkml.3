Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945964Ab3FUTs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:48:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945935Ab3FUTsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:48:55 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-73m4Y_UfV4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=cSPiyFweRl4A:10 a=QyXUC8HyAAAA:8 a=3nbZYyFuAAAA:8 a=ChXW62wMgd525DT4j2YA:9 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=EvKJbDF4Ut8A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371844134.18733.124.camel@gandalf.local.home>
Subject: Re: [PATCH 02/11] tracing: add missing syscall_metadata comment
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@intel.com>
Date: Fri, 21 Jun 2013 15:48:54 -0400
In-Reply-To: <51C3FB5D.5080408@hitachi.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
	 <f151e7e82a9a0723cdd50ae04ab30fd49b1e51ce.1371751701.git.tom.zanussi@linux.intel.com>
	 <51C3FB5D.5080408@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 16:06 +0900, Masami Hiramatsu wrote:
> (2013/06/21 3:31), Tom Zanussi wrote:
> > From: Tom Zanussi <tom.zanussi@intel.com>
> > 
> > Add the missing syscall_metadata description for the enter_fields
> > struct member.
> > 
> > Signed-off-by: Tom Zanussi <tom.zanussi@intel.com>
> 
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Steven, I think the first two patches may better be merged separately
> as cleanups.
> 

Yeah, I'll probably pull these in today, as part of my 3.11 queue.

-- Steve

