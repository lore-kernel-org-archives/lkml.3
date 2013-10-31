Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab3JaAwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 20:52:20 -0400
Received: from intranet.asianux.com ([58.214.24.6]:33099 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3JaAwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 20:52:19 -0400
X-Spam-Score: -100.8
Message-ID: <5271A977.1010609@asianux.com>
Date: Thu, 31 Oct 2013 08:51:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Randy Dunlap <rdunlap@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/wait.h: add ';' for the statement which
 missed it.
References: <52708623.504@asianux.com> <52712293.90808@infradead.org> <20131030154015.GN16117@laptop.programming.kicks-ass.net>
In-Reply-To: <20131030154015.GN16117@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 11:40 PM, Peter Zijlstra wrote:
> On Wed, Oct 30, 2013 at 08:15:31AM -0700, Randy Dunlap wrote:
>> On 10/29/13 21:08, Chen Gang wrote:
>>> Add ';' for the statement, or can not pass compiling. The related error
>>> (for powerpc allmodconfig):
>>>
>>>     CC      block/blk-mq.o
>>>   block/blk-mq.c: In function ¡®blk_mq_queue_enter¡¯:
>>>   block/blk-mq.c:108:8: error: expected ¡®;¡¯ before ¡®__ret¡¯
>>>   block/blk-mq.c:108:6: error: void value not ignored as it ought to be
>>>
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>
>> Acked-by: Randy Dunlap <rdunlap@infradead.org>
>>
>> I have that same patch on my machine but never posted it.
> 
> tip already includes commit 92ec11809565cf6429c75204e99e0f583b5c9d7c
> from the 23th which should fix this.
> 
> 

Thank all of you.
-- 
Chen Gang
