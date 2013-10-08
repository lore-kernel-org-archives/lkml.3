Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab3JHQWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:22:35 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48006 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab3JHQW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:22:28 -0400
Message-ID: <5254313F.4030409@gmail.com>
Date: Tue, 08 Oct 2013 10:22:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org> <1380922788-23112-7-git-send-email-andi@firstfloor.org> <20131006164934.GA15167@gmail.com> <20131008065938.GA4333@gmail.com> <20131008155131.GA31975@redhat.com>
In-Reply-To: <20131008155131.GA31975@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/13 9:51 AM, Dave Jones wrote:
> On Tue, Oct 08, 2013 at 08:59:38AM +0200, Ingo Molnar wrote:
>
>   > You might want to concentrate your efforts from fighting perf
>   > functionality towards decreasing per tracepoint overhead instead,
>   > without hurting kernel functionality and maintainability.
>
> Making it easier to disable perf entirely would be desirable for one use case.
> I can't do a trinity run for more than a few hours for the last few months
> without hitting perf/ftrace bugs that no-one seems to be able to get their
> heads around.

Looks like trinity has an exclude syscall option. Seems like that option 
can be used to avoid perf_event_open (haven't tried though).

David

