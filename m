Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbbABQ3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 11:29:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34729 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbbABQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 11:29:07 -0500
Message-ID: <54A6C74E.1070006@gmail.com>
Date: Fri, 02 Jan 2015 09:29:02 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 30/30] perf tools: Disable test code
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org> <1420212972-21595-31-git-send-email-jolsa@kernel.org>
In-Reply-To: <1420212972-21595-31-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/2/15 8:36 AM, Jiri Olsa wrote:
> NOTE: hack
>
> Forcing test objects not to be compiled into perf code.
> This saves almost 1MB of perf binary size on my setup:
>
>    # standard perf binary
>    $ ls -l perf
>    -rwxrwxr-x 1 jolsa jolsa 10283684 Jan  1 15:52 perf
>
>    # current perf binary
>    $ ls -l perf
>    -rwxrwxr-x 1 jolsa jolsa 9303174 Jan  1 15:58 perf

nice. I had done the same locally; never got around to pushing that 
patch upstream.

https://github.com/dsahern/linux/commit/20b85d1cbf5c46a5d9966bfcb7c0dbcb8f0cc8d0

David
