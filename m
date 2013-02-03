Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab3BCVkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:40:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43982 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3BCVkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:40:12 -0500
Message-ID: <510ED91F.6050601@oracle.com>
Date: Sun, 03 Feb 2013 16:39:43 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: mingo@redhat.com, peterz@infradead.org, paulus@samba.org,
        acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] perf: integrate liblockdep support into perf
References: <1359738953-28745-1-git-send-email-sasha.levin@oracle.com> <20130203110537.GB11739@gmail.com>
In-Reply-To: <20130203110537.GB11739@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2013 06:05 AM, Ingo Molnar wrote:
> 
> * Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> liblockdep is simply userspace lockdep. We can use that to analyze and
>> verify the locking in perf.
>>
>> Usage is simple, to compile perf with liblockdep all that's needed it:
>>
>> 	make LIBLOCK=[path to liblockdep]
> 
> Nice idea.
> 
> I'd suggest to link it in directly, like we link in 
> libtraceevents.
> 
> Then it could be built via something like:
> 
>    make LOCKDEP=1
> 
> or so.
> 

Sounds good, I'll resend the series.


Thanks,
Sasha

