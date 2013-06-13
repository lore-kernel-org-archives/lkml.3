Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab3FMPYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:24:18 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:48712 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab3FMPYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:24:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130613151546.GA30062@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
	<20130601194526.GA27149@redhat.com>
	<20130613140112.GB16339@somewhere>
	<20130613151546.GA30062@redhat.com>
Date: Thu, 13 Jun 2013 17:24:15 +0200
Message-ID: <CAFTL4hxQ94mq16ZnF1g8h0ug1rMLmKia_wC4yt01Ra4KWkgsSA@mail.gmail.com>
Subject: Re: [PATCH 0/3] hw_breakpoint: cleanups
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/13 Oleg Nesterov <oleg@redhat.com>:
> On 06/13, Frederic Weisbecker wrote:
>>
>> On Sat, Jun 01, 2013 at 09:45:26PM +0200, Oleg Nesterov wrote:
>> > Hello.
>> >
>> > Cleanups, on top of
>> >
>> >     [PATCH 0/2]: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c
>>
>> So this series doesn't have the fix for the warning?
>
> I don't understand the question ;)
>
> The previous series
>
>         [PATCH 1/2] hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
>         [PATCH 2/2] hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()
>
> tried to fix the bugs which lead to this (correct) warning.
>
> This and the next one try to cleanup the code.

Ah ok, there is two series (/me confused as usual :)
