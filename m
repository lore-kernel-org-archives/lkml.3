Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbaGPCIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:08:41 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48640 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaGPCIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:08:38 -0400
Message-ID: <53C5DEA1.4020108@gmail.com>
Date: Tue, 15 Jul 2014 20:08:33 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 15/41] perf script: Improve srcline display for BTS
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-16-git-send-email-adrian.hunter@intel.com> <20140715141635.GA3301@kernel.org>
In-Reply-To: <20140715141635.GA3301@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/15/2014 08:16 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 14, 2014 at 01:02:39PM +0300, Adrian Hunter escreveu:
>> Change the order of the output to put the srcline last.
>> e.g. old format:
>>
>>            4028fc main+0x2c (/bin/ls)
>>    /build/buildd/coreutils-8.20/src/ls.c:1269 =>           40d8a0 set_program_name+0x0 (/bin/ls)
>>
>> new format:
>>
>>            4028fc main+0x2c (/bin/ls) =>           40d8a0 set_program_name+0x0 (/bin/ls)
>>    /build/buildd/coreutils-8.20/src/ls.c:1269
>
> David,
>
> 	Can I have your acked-by?

I believe Stephane is the one who wrote print_sample_bts and bts 
analysis pieces.

David
