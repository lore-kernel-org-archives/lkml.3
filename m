Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3LLTQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:16:28 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52019 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3LLTQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:16:24 -0500
Message-ID: <52AA0B80.5060509@gmail.com>
Date: Thu, 12 Dec 2013 12:16:16 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 07/71] perf tools: Record whether a dso is 64-bit
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-8-git-send-email-alexander.shishkin@linux.intel.com> <52A8BC5D.2030603@gmail.com> <52A9A672.9050509@intel.com> <52A9E826.1020909@gmail.com> <20131212190525.GA11191@ghostprotocols.net>
In-Reply-To: <20131212190525.GA11191@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/13, 12:05 PM, Arnaldo Carvalho de Melo wrote:

> Well, if we can pass somehow the magic number of an executable mmap
> in the PERF_RECORD_MMAP2 record, we would be able, together with the
> data we already have in the perf.data header (uname in a live session),
> to figure that out, no?

Sure, but any kernel-side only solution will be extremely limited in 
user base for years.

David
