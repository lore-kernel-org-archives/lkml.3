Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab3LKNZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:25:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:56319 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3LKNZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:25:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450516133"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 00/71] perf: Add support for Intel Processor Trace
In-Reply-To: <20131211130448.GA2480@gmail.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <20131211130448.GA2480@gmail.com>
User-Agent: Notmuch/0.15.2+182~gd0bd88f (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 11 Dec 2013 15:14:20 +0200
Message-ID: <87r49jttqr.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:

> * Alexander Shishkin <alexander.shishkin@linux.intel.com> wrote:
>
>> Hi,
>> 
>> This patchset adds support for Intel Processor Trace (PT) extension 
>> [1] of Intel Architecture that allows the capture of information 
>> about software execution flow, to the perf kernel and userspace 
>> infrastructure. We provide an abstraction for it called "itrace" for 
>> "instruction trace" ([2]).
>
> Ok, this feature looks rather interesting.
>
> On the hardware side this is essentially BTS (Branch Trace Store) on 
> steroids (with many extensions), right?

Yes, you get timestamps and all sorts of other useful data in the trace
and the performance intrusion is much less than that of BTS.

Regards,
--
Alex
