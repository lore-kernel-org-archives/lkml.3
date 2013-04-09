Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936469Ab3DIBFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:05:03 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40385 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934986Ab3DIBFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:05:00 -0400
MIME-Version: 1.0
In-Reply-To: <1365467115.25498.35.camel@gandalf.local.home>
References: <1365227126-15355-1-git-send-email-linkinjeon@gmail.com>
	<1365467115.25498.35.camel@gandalf.local.home>
Date: Tue, 9 Apr 2013 10:04:58 +0900
Message-ID: <CAKYAXd-xpJW=W8UHA=3+Jm-x5y81e__QsLJ0pw4H80SuS+SYSg@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] f2fs: add tracepoints support in f2fs filesystem
From: Namjae Jeon <linkinjeon@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/9, Steven Rostedt <rostedt@goodmis.org>:
> On Sat, 2013-04-06 at 14:45 +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Add tracepoints in f2fs filesystem for tracing the filesystem
>> operations for information/debugging purpose if needed. All the
>> tracepoints are clubbed with respect to functionalities.
>>
>> Change Log:
>> v3: Introduced TRACE_EVENT_CONDITION() macro for checking the
>> condition page->mapping inside the trace point function call as
>> per Steve's review comment for the patch
>>
>> v2: Added DECLARE_EVENT_CLASS() macro for combining the similar
>> type of trace function calls which has same type of arguments.
>>
>> v1: Introduced the tracepoint functions in f2fs filesystem.
>>
>> Namjae Jeon (7):
>>   f2fs: add tracepoints for sync & Inode operations
>>   f2fs: add tracepoints for truncate operation
>>   f2fs: add tracepoint for tracing the page i/o operations
>>   f2fs: add tracepoints for GC threads
>>   f2fs: add tracepoints to debug the block allocation & fallocate
>>   f2fs: add tracepoints for write page operations
>>   f2fs: add tracepoints to debug checkpoint request
>>
>
Hi. Steve.
> I have nothing more to add about the tracepoint processing. Looks good.
> Now if the tracepoints give you sufficient data? That's up to the
> maintainers to decide.
Until now, yes. but I will continously try to update trace point more
if finding additional  needed points after.
Thanks for review and your ack.

>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
> -- Steve
>
>
>
