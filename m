Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab3LJBcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:32:46 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56948 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3LJBco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:32:44 -0500
X-AuditID: 9c930197-b7bdbae000000e78-4a-52a66f3a5f35
From: Namhyung Kim <namhyung@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] tools/: Convert to new topic libraries
References: <1386605664-24041-1-git-send-email-bp@alien8.de>
	<1386605664-24041-2-git-send-email-bp@alien8.de>
Date: Tue, 10 Dec 2013 10:32:42 +0900
In-Reply-To: <1386605664-24041-2-git-send-email-bp@alien8.de> (Borislav
	Petkov's message of "Mon, 9 Dec 2013 17:14:23 +0100")
Message-ID: <87zjo9jxs5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Mon,  9 Dec 2013 17:14:23 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
>
> Move debugfs.* to api/fs/. We have a common tools/lib/api/ place
> where the Makefile lives and then we place the headers in subdirs.
> For example, all the fs-related stuff goes to tools/lib/api/fs/ from
> which we get libapikfs.a (acme got almost the naming he wanted :-))
> and we link it into the tools which need it - in this case perf and
> tools/vm/page-types.

I'm sorry to raise a naming issue again.  But why the lib has 'k' and
the directory doesn't?  Isn't it more natural to prepend 'k' to 'api' as
the name "api" looks too general?

  - libkapifs.{a,so}
  - lib/kapi/fs/fs.c

(Please ignore if it's already discussed..)

Thanks,
Namhyung
