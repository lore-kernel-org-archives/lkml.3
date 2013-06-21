Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945955Ab3FUTpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:45:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26890 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945926Ab3FUTpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:45:52 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=g4V23dsyigAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=xhkg8RvMu9gA:10 a=OchezDLsiJLe3Qa_55oA:9 a=QEXdDO2ut3YA:10 a=WKy2Kq3thNsA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371843950.18733.123.camel@gandalf.local.home>
Subject: Re: [PATCH 00/11] tracing: trace event triggers
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Fri, 21 Jun 2013 15:45:50 -0400
In-Reply-To: <cover.1371751701.git.tom.zanussi@linux.intel.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 13:31 -0500, Tom Zanussi wrote:
> Hi,
> 
> This patchset implements 'trace event triggers', which are similar to
> the function triggers implemented for 'ftrace filter commands' (see
> 'Filter commands' in Documentation/trace/ftrace.txt), but instead of
> being invoked from function calls are invoked by trace events.
> Basically the patchset allows 'commands' to be triggered whenever a
> given trace event is hit.  The set of commands implemented by this
> patchset are:
> 

Hi Tom!

Thanks for doing this. I'll try to get some time to review the patch set
either today or next week.

-- Steve


