Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaLZQwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 11:52:06 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50672 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaLZQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 11:52:04 -0500
Message-ID: <549D922F.3020101@gmail.com>
Date: Fri, 26 Dec 2014 09:51:59 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 05/37] perf tools: Create separate mmap for dummy tracking
 event
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <1419405333-27952-6-git-send-email-namhyung@kernel.org>
In-Reply-To: <1419405333-27952-6-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/14 12:15 AM, Namhyung Kim wrote:
> When multi file support is enabled, a dummy tracking event will be
> used to track metadata (like task, comm and mmap events) for a session
> and actual samples will be recorded in separate files.
>
> Provide separate mmap to the dummy tracking event.  The size is fixed
> to 128KiB (+ 1 page) as the event rate will be lower than samples.  I

Have you tried stress tests like a kernel compile with -j Ncpus (Ncpus = 
16 or higher)?

David
