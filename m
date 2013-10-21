Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3JUOux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:50:53 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:1766 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3JUOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:50:52 -0400
Message-ID: <52653F3E.7030207@hp.com>
Date: Mon, 21 Oct 2013 10:50:38 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 2/4] perf: streamline append_chain() function
References: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com> <1382107129-2010-3-git-send-email-Waiman.Long@hp.com> <87ppr0u6n5.fsf@tassilo.jf.intel.com>
In-Reply-To: <87ppr0u6n5.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2013 08:29 PM, Andi Kleen wrote:
> Waiman Long<Waiman.Long@hp.com>  writes:
>
>> as well as
>> using ?: statement which can be more efficient than the regular if
>> statement in some architectures.
> I don't think that's true, the compiler does if conversion anyways for both.
>
> But change seems reasonable.
>
> -Andi
>
>

That may be true for a simple if statement. However, the condition was 
checked as the last of 3 tests. I doubt if the compiler is able to 
optimize that effectively.

-Longman
