Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab3FYIBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:01:50 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54270 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3FYIBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:01:49 -0400
X-AuditID: 9c93017e-b7cd1ae000002371-14-51c94e6b7dd7
Message-ID: <51C94E6B.6000802@lge.com>
Date: Tue, 25 Jun 2013 17:01:47 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Greg Price <price@MIT.EDU>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf report: Add option to collapse undesired parts of
 call graph
References: <20121207072726.GY22203@biohazard-cafe.mit.edu> <20130111052736.GG3054@ghostprotocols.net> <20130623031720.GW22203@biohazard-cafe.mit.edu> <20130623215327.GA995@krava.redhat.com> <20130624083253.GA28025@gmail.com> <20130624231426.GY22203@biohazard-cafe.mit.edu> <20130625074734.GD11420@gmail.com>
In-Reply-To: <20130625074734.GD11420@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-06-25 PM 4:47, Ingo Molnar wrote:
>
> * Greg Price <price@MIT.EDU> wrote:
>
>>> It would also be nice if all these visualization variants were available
>>> in the GTK front-end.
>>
>> TBH I'm not really familiar with the GTK front-end, as I mainly use
>> the TUI.  At a quick trial, it looks like --blackbox has the expected
>> effect on the display there; though with or without --blackbox I can't
>> seem to get the entries to expand to show me a call-graph profile, so
>> it's hard to demonstrate it fully.  Not sure what I may have done
>> wrong in building or running perf to make that not work (or is that
>> expected?)

Currently perf GTK front-end does not support callchains at all. 
There's a floating patchset to enable it though.

https://lkml.org/lkml/2013/6/4/181

>>
>> What changes do you have in mind to make these available in the GTK
>> front-end?
>
> I was thinking of something obvious like right-clicking it to make that
> function back boxed away or so? Have no firm ideas - maybe the GTK gents
> on Cc: know how to best integrate such features.

We don't support context menu yet.  Frankly, perf GTK code is still 
premature and needs some love.  Any contribution should be welcomed!

Thanks,
Namhyung

