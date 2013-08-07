Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab3HGUY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:24:26 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:55805 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab3HGUYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:24:25 -0400
Message-ID: <5202ACF7.3020400@gmail.com>
Date: Wed, 07 Aug 2013 16:24:23 -0400
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] perf kvm: option to print events that exceed a threshold
References: <1375753297-69645-1-git-send-email-dsahern@gmail.com> <1375753297-69645-5-git-send-email-dsahern@gmail.com> <20130807192725.GD2665@ghostprotocols.net>
In-Reply-To: <20130807192725.GD2665@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/13 3:27 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 05, 2013 at 09:41:36PM -0400, David Ahern escreveu:
>> This is useful to spot high latency blips. It is normal for HLT
>> reasons to have long exit times, so strip those from the threshold
>> check.
>
> So 'perf trace' has a similar option:
>
> [acme@zoo linux]$ perf trace --help
> <SNIP>
>          --duration <float>
>                            show only events with duration > N.M ms
> <SNIP>
>
> While you used:
>
>> +		OPT_U64('T', "threshold", &kvm->threshold,
>> +		    "show events other than HALT that take longer than threshold usecs"),
>
> I prefer 'duration', and haven't assigned a single letter to it, they
> are scarce and we have shell long option completion, what do you think?
>
> The term was chosen, for 'perf trace' on the original patchset:
>
> http://lwn.net/Articles/415728/
>
> - Arnaldo
>

No preference really. I need to send out an update to the man page. I 
can update this patch as well and re-send.

David
