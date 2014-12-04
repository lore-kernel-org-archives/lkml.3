Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaLDIMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:12:32 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59105 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaLDIMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:12:30 -0500
Message-ID: <54801768.3050404@hitachi.com>
Date: Thu, 04 Dec 2014 17:12:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH 3/3] ftracetests: Add test to test event filter logic
References: <20141203031334.174087814@goodmis.org> <20141203032106.156623189@goodmis.org> <547ED753.3060508@hitachi.com> <20141203043423.6c7e4524@gandalf.local.home> <20141203112015.19f6ff6c@gandalf.local.home>
In-Reply-To: <20141203112015.19f6ff6c@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/04 1:20), Steven Rostedt wrote:
> On Wed, 3 Dec 2014 04:34:23 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>  
>> OK, I'll hold off on sending this patch then till 3.20.
>>
> 
> BTW, can we add another option that just shows the echo output. The -d
> enables -x which floods the screen with lots of useless information and
> it's hard to see what is going on.

I see, actually -d is not for debugging each test case, but just
for the ftracetest itself.
I'll add --verbose to show echos in testcases.


Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


