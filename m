Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3LKBqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:46:21 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42165 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3LKBqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:46:19 -0500
Message-ID: <52A7C3E7.301@gmail.com>
Date: Tue, 10 Dec 2013 18:46:15 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>
CC: Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] tools/: Convert to new topic libraries
References: <1386605664-24041-1-git-send-email-bp@alien8.de> <1386605664-24041-2-git-send-email-bp@alien8.de>
In-Reply-To: <1386605664-24041-2-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/9/13, 9:14 AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
>
> Move debugfs.* to api/fs/. We have a common tools/lib/api/ place
> where the Makefile lives and then we place the headers in subdirs.
> For example, all the fs-related stuff goes to tools/lib/api/fs/ from
> which we get libapikfs.a (acme got almost the naming he wanted :-))
> and we link it into the tools which need it - in this case perf and
> tools/vm/page-types.
>
> acme:
>
> "Looking at the implementation, I think some tools can even link
> directly to the .o files, avoiding the .a file altogether.
>
> But that is just an optimization/finer granularity tools/lib/
> cherrypicking that toolers can make use of."
>
> Fixup documentation cleaning target while at it.
>

no longer applies to the moving target that is acme's tree.

David

