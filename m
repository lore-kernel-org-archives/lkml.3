Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab3ICNqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:46:01 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50174 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab3ICNqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:46:00 -0400
Message-ID: <5225E815.4010705@gmail.com>
Date: Tue, 03 Sep 2013 07:45:57 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: latest perf code fails to parse existing data file
References: <5225051C.3030608@gmail.com> <5225844E.3090700@intel.com> <5225DAFB.1070406@gmail.com> <5225E320.8090307@intel.com>
In-Reply-To: <5225E320.8090307@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/13 7:24 AM, Adrian Hunter wrote:
> On 03/09/13 15:50, David Ahern wrote:
>> Kernel version? Is your kernel side support there?
>
> The kernel version is the same as the perf version i.e. 3.9
>
>>
>> For me data was collected on 2.6.34 about a week ago. Processed fine up to
>> the point of this patch getting added.
>
> Is it only "perf trace" that fails or does "perf script" fail too?

Both throw the same error. Command line used to create the file:
   perf record -e raw_syscalls:* -e sched:* -p 2271 -g -- sleep 5

David
