Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaCKHAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:00:33 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49046 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaCKHAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:00:32 -0400
Message-ID: <531EB484.5070204@converseincode.com>
Date: Tue, 11 Mar 2014 00:00:20 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, khali@linux-fr.org,
        rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] module: LLVMLinux: Remove unused function warning from
 __param_check macro
References: <1394219327-5591-1-git-send-email-behanw@converseincode.com> <87y50hw9go.fsf@rustcorp.com.au>
In-Reply-To: <87y50hw9go.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/14 23:11, Rusty Russell wrote:
> behanw@converseincode.com writes:
>> From: Mark Charlebois <charlebm@gmail.com>
>>
>> This code makes a compile time type check that is optimized away. Clang
>> complains that it generates an unused function.
>>
>> I believe GCC won't complain for a static inline fuction but would if it
>> was just a static function.
>>
>> Adding the unused attribute to the function declaration removes the warning.
>>
>> This code works for both gcc and clang.
>>
>> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Please include the actual warning clang spits out.  That helps because
> (1) I know what you're referring to, and
> (2) it helps others if they are later googling for the error.
Nice! Will fix.

> I don't have any huge objections to this patch (__always_unused) though.
Already in the posted v2 patch.

However I will post a v3 with your other suggested changes to the commit 
message.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

