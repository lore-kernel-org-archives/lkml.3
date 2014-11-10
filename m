Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaKJOUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:20:30 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40392 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaKJOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:20:29 -0500
Message-ID: <5460C9B3.4060705@gmail.com>
Date: Mon, 10 Nov 2014 07:20:35 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms
 on NO_LIBELF=1
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>	<545CE36C.7040906@gmail.com> <87a93zv6yi.fsf@sejong.aot.lge.com>
In-Reply-To: <87a93zv6yi.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/14, 12:40 AM, Namhyung Kim wrote:
> Hi David,
>
> On Fri, 07 Nov 2014 08:21:16 -0700, David Ahern wrote:
>> On 11/6/14, 10:20 PM, Namhyung Kim wrote:
>>> It worked w/o libelf, but recent change to use vmlinux for kernel
>>> symbols break it.
>>
>> Do you know the recent change (commit id) that broke it?
>
> Nope.  I tried to find it but failed - older versions seems also have
> the problem and some of them could not run perf record.  Anyway it looks
> like depending some external condition and broken for a while. :(

OK. I have a segfault issue when analyzing a mips file offbox and it is 
related to kernel symbol processing. I was not able to find past version 
of perf that worked - though limited by the file version checks added 
around v3.6.

David

