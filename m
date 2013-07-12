Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab3GLB7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:59:52 -0400
Received: from intranet.asianux.com ([58.214.24.6]:21426 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab3GLB7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:59:51 -0400
X-Spam-Score: -100.8
Message-ID: <51DF62DB.3010409@asianux.com>
Date: Fri, 12 Jul 2013 09:58:51 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: trace: remove __init from race_selftest_startup_function()
 and trace_selftest_startup_function_graph()
References: <51DDFCF8.2090808@asianux.com>  <1373561279.17876.45.camel@gandalf.local.home>  <51DF44FA.9060000@asianux.com> <1373593261.17876.61.camel@gandalf.local.home>
In-Reply-To: <1373593261.17876.61.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 09:41 AM, Steven Rostedt wrote:
> On Fri, 2013-07-12 at 07:51 +0800, Chen Gang wrote:
> 
>> > Hmm, can all trace_selftest_startup_* (*selftest* in trace_selftest.c)
>> > use '__init', so not waste memory keeping them around ?
> Yeah, they should all be set to __init, but that's pretty low on the
> totem poll, as distros don't enable selftests in their main kernels.

Excuse me, my English is not quite well, I guess your meaning is:

  they should all be set to '__init', although it is minor in real world.

Is it correct ?


For me, I recommend to let all *selftest* as the same: "all add '
__init' or none add '__init'" (if choose add, all report warnings).

Is it suitable to still send new related patch for it ? If so, could
you provide your suggesting choice (all add, or none add) ?


Thanks.
-- 
Chen Gang
