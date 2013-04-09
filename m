Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965053Ab3DIAZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 20:25:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964940Ab3DIAZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 20:25:16 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YgeI0MWe24MA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=TsWA6E0LE9UA:10 a=hD80L64hAAAA:8 a=DPlLgeu23dhGE_848FcA:9 a=QEXdDO2ut3YA:10 a=v3rLFGiuRE8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365467115.25498.35.camel@gandalf.local.home>
Subject: Re: [PATCH v3 0/7] f2fs: add tracepoints support in f2fs filesystem
From: Steven Rostedt <rostedt@goodmis.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Date: Mon, 08 Apr 2013 20:25:15 -0400
In-Reply-To: <1365227126-15355-1-git-send-email-linkinjeon@gmail.com>
References: <1365227126-15355-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-06 at 14:45 +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Add tracepoints in f2fs filesystem for tracing the filesystem
> operations for information/debugging purpose if needed. All the
> tracepoints are clubbed with respect to functionalities.
> 
> Change Log:
> v3: Introduced TRACE_EVENT_CONDITION() macro for checking the
> condition page->mapping inside the trace point function call as
> per Steve's review comment for the patch
> 
> v2: Added DECLARE_EVENT_CLASS() macro for combining the similar
> type of trace function calls which has same type of arguments.
> 
> v1: Introduced the tracepoint functions in f2fs filesystem.
> 
> Namjae Jeon (7):
>   f2fs: add tracepoints for sync & Inode operations
>   f2fs: add tracepoints for truncate operation
>   f2fs: add tracepoint for tracing the page i/o operations
>   f2fs: add tracepoints for GC threads
>   f2fs: add tracepoints to debug the block allocation & fallocate
>   f2fs: add tracepoints for write page operations
>   f2fs: add tracepoints to debug checkpoint request
> 

I have nothing more to add about the tracepoint processing. Looks good.
Now if the tracepoints give you sufficient data? That's up to the
maintainers to decide.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


