Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaCLTBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:01:14 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30473 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaCLTBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:01:12 -0400
Message-ID: <5320AEE0.7070600@hp.com>
Date: Wed, 12 Mar 2014 15:00:48 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, arnd@arndb.de, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com
Subject: Re: [RFC][PATCH 0/7] locking: qspinlock
References: <20140310154236.038181843@infradead.org> <20140311104503.GA10916@gmail.com> <531FD1DA.5010006@hp.com> <20140312062436.GI30956@twins.programming.kicks-ass.net>
In-Reply-To: <20140312062436.GI30956@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 02:24 AM, Peter Zijlstra wrote:
> On Tue, Mar 11, 2014 at 11:17:46PM -0400, Waiman Long wrote:
>> Except that I do a single atomic short integer write to switch the bits
>> instead of 2 byte write.
> D'0h why didn't I think of that. A single short write is much better
> than the 2 byte writes.
>
> In any case; can you try and keep the structure in this patch-set if you
> post another version? It takes a lot of effort to unravel your
> all-in-one patch.

I didn't have time to fully review and test your changes yet. So I just 
post a new series of what I currently have right now. I will certainly 
do the testing on your patches.

-Longman
