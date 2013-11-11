Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3KKUjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:39:05 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56561 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3KKUjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:39:00 -0500
Message-ID: <52814060.9000104@gmail.com>
Date: Mon, 11 Nov 2013 13:38:56 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Bill Gray <bgray@redhat.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>,
        Stephane Eranian <eranian@google.com>, vincent.weaver@maine.edu
Subject: Re: [PATCH 03/10] perf record: Synthesize non-exec MMAP records when
 --data used
References: <1384201353-23863-1-git-send-email-acme@infradead.org> <1384201353-23863-4-git-send-email-acme@infradead.org>
In-Reply-To: <1384201353-23863-4-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Vince]

On 11/11/13, 1:22 PM, Arnaldo Carvalho de Melo wrote:
> When perf_event_attr.mmap_data is set the kernel will generate
> PERF_RECORD_MMAP events when non-exec (data, SysV mem) mmaps are
> created, so we need to synthesize from /proc/pid/maps for existing
> threads

Seems like that should be documented in the man pages:

[dsa@MacBook perf]$ egrep -r mmap_data Documentation/
[dsa@MacBook perf]$

Vince: where are you keeping the man page you are putting together?

David
