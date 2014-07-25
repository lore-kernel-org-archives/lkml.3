Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbaGYPcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:32:22 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34578 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaGYPcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:32:20 -0400
Message-ID: <53D27882.8020605@gmail.com>
Date: Fri, 25 Jul 2014 09:32:18 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 28/52] perf script: Allow callchains if any event samples
 them
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com> <1406035081-14301-29-git-send-email-adrian.hunter@intel.com> <20140725132705.GJ7831@kernel.org>
In-Reply-To: <20140725132705.GJ7831@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/14, 7:27 AM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jul 22, 2014 at 04:17:37PM +0300, Adrian Hunter escreveu:
>> perf script was not displaying callchains if any selected
>> event did not have PERF_SAMPLE_CALLCHAIN.  Change this to
>> disable callchains only if all selected events do not have
>> PERF_SAMPLE_CALLCHAIN.
>
> I wonder if some other tool gets this wrong as well, report maybe?
>

perf only handles 1 sample_type so if callchains are enabled for 1 event 
they are enabled for all.

Perhaps Adrian's patch set changes that -- prior patch sets attempted 
to. I have not had time to go through the list.

David

