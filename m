Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774Ab3LHRcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 12:32:24 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36857 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab3LHRcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 12:32:23 -0500
Message-ID: <52A4AD20.1090906@gmail.com>
Date: Sun, 08 Dec 2013 10:32:16 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH V2 1/3] perf script: Fix symoff printing in callchains
References: <1386315778-11633-1-git-send-email-adrian.hunter@intel.com> <1386315778-11633-2-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1386315778-11633-2-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/6/13, 12:42 AM, Adrian Hunter wrote:
> The address being used to calculate the offset was
> the memory address but the address needed is the
> address mapped to the dso. i.e. the 'addr' member
> of 'struct addr_location'
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   tools/perf/util/session.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>

Acked-by: David Ahern <dsahern@gmail.com>


