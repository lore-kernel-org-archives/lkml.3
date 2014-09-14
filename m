Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaINJ6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:58:07 -0400
Received: from forward7l.mail.yandex.net ([84.201.143.140]:47326 "EHLO
	forward7l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaINJ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:58:05 -0400
X-Yandex-Uniq: 73c75655-b6b4-429f-9b41-1f3c51ada1ff
Authentication-Results: smtp19.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <541566A2.5010008@yandex.ru>
Date: Sun, 14 Sep 2014 13:57:54 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched: Do not stop cpu in set_cpus_allowed_ptr() if task
 is not running
References: <1410519814.3569.7.camel@tkhai> <20140914091338.GN346@worktop.programming.kicks-ass.net> <54155DE0.7040606@yandex.ru> <20140914095528.GU346@worktop.programming.kicks-ass.net>
In-Reply-To: <20140914095528.GU346@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.09.2014 13:55, Peter Zijlstra wrote:
> On Sun, Sep 14, 2014 at 01:20:32PM +0400, Kirill Tkhai wrote:
>> On 14.09.2014 13:13, Peter Zijlstra wrote:
>> Peter, haven't I moved the sequence from __migrate_task??
>>
>> Rechecked again; yes, patch makes __migrate_task using new move_queued_task.
> 
> Yes you have ... urgh.. that's what you get for traveling 9 timezones
> and trying to do 'work' at 3 am which is really noon.
> 
> Lemme try and get my head on straight and have another look.
> 

Oh, no problem :) Happy Programmers Day!!!
