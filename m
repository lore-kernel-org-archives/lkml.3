Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab3ICMuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:50:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50086 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3ICMuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:50:11 -0400
Message-ID: <5225DAFB.1070406@gmail.com>
Date: Tue, 03 Sep 2013 06:50:03 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: latest perf code fails to parse existing data file
References: <5225051C.3030608@gmail.com> <5225844E.3090700@intel.com>
In-Reply-To: <5225844E.3090700@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/13 12:40 AM, Adrian Hunter wrote:
> On 03/09/13 00:37, David Ahern wrote:
>> Arnaldo/Adrian:
>>
>> Latest acme core tree fails to parse an existing data file:
>>
>> $ perf trace -i perf.data
>> 0x16b8 [0x40]: failed to process type: 1
>> Failed to process events, error -22
>
> I can't reproduce this.  The following works:
>
> 	$ perf --version
> 	perf version 3.9.10-100.fc17.x86_64
> 	$ sudo perf record -e raw_syscalls:* ls
> 	...
> 	$ tools/perf/perf --version
> 	perf version 3.11.rc4.g31cd38
> 	$ sudo tools/perf/perf script
> 	...
> 	$ sudo tools/perf/perf trace -i perf.data
> 	...

Kernel version? Is your kernel side support there?

For me data was collected on 2.6.34 about a week ago. Processed fine up 
to the point of this patch getting added.

David

