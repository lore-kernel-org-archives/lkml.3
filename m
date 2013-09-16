Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab3IPBoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 21:44:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57683 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3IPBoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 21:44:08 -0400
Message-ID: <523661EA.9040500@huawei.com>
Date: Mon, 16 Sep 2013 09:42:02 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: <benh@kernel.crashing.org>, <rob@landley.net>, <ananth@in.ibm.com>,
        <anil.s.keshavamurthy@intel.com>, <davem@davemloft.net>,
        <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>, <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc: fix some typos
References: <5233DCD1.4010006@huawei.com> <5234938E.7010809@infradead.org>
In-Reply-To: <5234938E.7010809@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/15 0:49, Randy Dunlap wrote:

> On 09/13/13 20:49, Xishi Qiu wrote:
> 
>> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
>> index 0cfb00f..ca278d5 100644
>> --- a/Documentation/kprobes.txt
>> +++ b/Documentation/kprobes.txt
>> @@ -92,7 +92,7 @@ stack contents as the probed function.  When it is done, the handler
>>  calls jprobe_return(), which traps again to restore the original stack
>>  contents and processor state and switch to the probed function.
>>  
>> -By convention, the callee owns its arguments, so gcc may produce code
> 
> Are you sure about that?
> It looks correct to me (before the patch).
>

Hi Randy, you are right, I confused caller and callee.

Thanks,
Xishi Qiu

>> +By convention, the caller owns its arguments, so gcc may produce code
>>  that unexpectedly modifies that portion of the stack.  This is why
>>  Kprobes saves a copy of the stack and restores it after the jprobe
>>  handler has run.  Up to MAX_STACK_SIZE bytes are copied -- e.g.,
>>
> 
> 



