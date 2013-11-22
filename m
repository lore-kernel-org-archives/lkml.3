Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3KVPB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:01:57 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46162 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3KVPBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:01:55 -0500
Message-ID: <528F71DB.30603@gmail.com>
Date: Fri, 22 Nov 2013 08:01:47 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 0/3] perf tools: Add data file write interface
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/13, 7:24 AM, Jiri Olsa wrote:
> David,
> patch 2 could colide with your mmap changes, not sure
> what's your plan with that in near future, let me know
> and I can rebase if needed.

The day job requires some focus for a few days. I was hoping to revisit 
the mmap output end of next week during the holidays here. Make mmap 
optional -- default to write with an option for mmap. Add some builtin 
detection to do the right thing if the user did not specify a preference 
-- system wide tracing should flip to mmap, system wide faults should 
write. Log a warning to the user if the requested option goes against 
that. If Peter or Ingo have other thoughts or ideas to the contrary I'd 
love to hear them before the next iteration.

David
