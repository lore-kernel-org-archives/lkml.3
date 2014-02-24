Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaBXOJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:09:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43905 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaBXOJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:09:47 -0500
X-IronPort-AV: E=Sophos;i="4.97,535,1389715200"; 
   d="scan'208";a="9593904"
Message-ID: <530B5249.5020505@cn.fujitsu.com>
Date: Mon, 24 Feb 2014 22:08:09 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 9/9] trace: Replace hardcoding of 19 with MAX_NICE.
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com> <eeb2a85d74c71e0d50c88789f99ad857a6b4b7b4.1392103744.git.yangds.fnst@cn.fujitsu.com> <53086860.2010209@cn.fujitsu.com> <20140224104658.GY9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140224104658.GY9987@twins.programming.kicks-ass.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/24 22:07:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/24 22:07:25,
	Serialize complete at 2014/02/24 22:07:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 06:46 PM, Peter Zijlstra wrote:
> On Sat, Feb 22, 2014 at 05:05:36PM +0800, Dongsheng Yang wrote:
>> Hi Peter.
>>      It seems the all other patches in this set were all applied to tip
>> except this one.
>> What is the problem with the [9/9]? Is there any thing I can do?
> The problem is that it never actually made it to my inbox; could you
> verify that I was indeed on the recipient list? And if not resend it.

Oh, yes. Sorry for that. I will resend it soon with ccing you.
>
> In case I was actually on the recipient list I need to go figure out
> where it went.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

