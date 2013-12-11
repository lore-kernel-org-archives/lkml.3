Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab3LKTlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:41:22 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33050 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3LKTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:41:20 -0500
Message-ID: <52A8BFDC.1090205@gmail.com>
Date: Wed, 11 Dec 2013 12:41:16 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 54/71] perf script: Always allow fields 'addr' and
 'cpu' for itrace
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-55-git-send-email-alexander.shishkin@linux.intel.com>
In-Reply-To: <1386765443-26966-55-git-send-email-alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13, 5:37 AM, Alexander Shishkin wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
>
> If a file contains Instruction Tracing data then always allow
> fields 'addr' and 'cpu' to be selected as options for perf
> script.  This is necessary because Instruction Trace decoding
> may synthesize events with that information.

Why hardcode it? If it is present and the user opts for it then it will 
be printed. Why is the itrace check needed?

David
