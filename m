Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968132AbaLLQNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:13:30 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:45915 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792AbaLLQN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:13:29 -0500
Message-ID: <548B1425.7090500@gmail.com>
Date: Fri, 12 Dec 2014 09:13:25 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 00/22] perf tools: Introduce an abstraction for Instruction
 Tracing
References: <1418392089-5568-1-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1418392089-5568-1-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian:

On 12/12/14 6:47 AM, Adrian Hunter wrote:
> Hi
>
> Here is V3 of some more preparatory patches for Intel PT
> that introduce an abstraction for Instruction tracing.
>

This is an x86-Intel only feature correct? If that is the case then the 
code should be not compiled for other architectures.

David

