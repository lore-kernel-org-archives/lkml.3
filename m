Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3DWXPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:15:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57871 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab3DWXPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:15:51 -0400
MIME-Version: 1.0
In-Reply-To: <1366713461.31792.9.camel@kjgkr>
References: <1366388891-18778-1-git-send-email-linkinjeon@gmail.com>
	<1366713461.31792.9.camel@kjgkr>
Date: Wed, 24 Apr 2013 08:15:51 +0900
Message-ID: <CAKYAXd-=xJcoK-awK2XQXO4Xu9d=MjHyuuas=hJUpNOmhN2hXQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] f2fs: Add tracepoints support in f2fs filesystem
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: rostedt@goodmis.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/23, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi, Namjae.
>
> Still I found several inconsistent codes and flaws of information across
> the whole patches.
> I've finished changing them, so please review the subsequent patches.
> Thanks,
Hi Jaegeuk.
First, Thank you for taking the time to fill the gaps :)
I checked all updated patches. Looks good to me ~.
Thanks again.

>
> 2013-04-20 (토), 01:28 +0900, Namjae Jeon:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Add tracepoints in f2fs filesystem for tracing the filesystem
>> operations for information/debugging purpose if needed. All the
>> tracepoints are clubbed with respect to functionalities.
>>
>> Change Log:
>> v4: Modified the tracepoints as per the review comments of
>> Jaegeuk Kim. Following tracepoints are added newly:
>>
>> trace_f2fs_truncate_blocks_enter
>> trace_f2fs_truncate_blocks_exit
>> trace_f2fs_truncate_inode_blocks_enter
>> trace_f2fs_truncate_inode_blocks_exit
>> trace_f2fs_truncate_node
>> trace_f2fs_submit_write_page
>> trace_f2fs_do_submit_bio
>> trace_f2fs_write_checkpoint
>>
>> While some of the tracepoints are modified to add new
>> parameters.
>>
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
>
> --
> Jaegeuk Kim
> Samsung
>
