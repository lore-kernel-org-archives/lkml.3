Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab3LWJQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 04:16:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34418 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033Ab3LWJQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 04:16:43 -0500
Message-ID: <52B7FF61.2090908@fb.com>
Date: Mon, 23 Dec 2013 14:46:17 +0530
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [RFC/PATCHSET 00/18] perf report: Add support to accumulate hist
 periods (v3)
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>  <20131218094622.GA19240@gmail.com>  <52B17B14.5030101@fb.com> <1387377549.1717.14.camel@leonhard>
In-Reply-To: <1387377549.1717.14.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2013-12-22_03:2013-12-20,2013-12-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/13 8:09 PM, Namhyung Kim wrote:
> Hi Arun,
>
> 2013-12-18 (수), 16:08 +0530, Arun Sharma:
>> On 12/18/13 3:16 PM, Ingo Molnar wrote:
>>
>>> My main complaint that any variation of 'cumulative' or 'cumulate' is
>>> a tongue-twister to users. I certainly won't be able to remember it
>>> and will have to call up the manpage every time I use it - which will
>>> be very annoying. I'd probably not use the feature much.
>>
>> I can remember it, mainly because it's such an unusual word :)
>> Agree that we could use something simpler/easier to remember.
>>
>> My other user space projects have been keeping me busy. But still very
>> interested in this feature. Will test this patch series over the holidays.
>
> Thanks in advance for your test and feedback! :)

Looks great! One of the features I'm missing compared to my earlier 
--sort inclusive series of patches is that, in the --children mode, I'd 
still like to see callchains (at least in --tui). Looks like --children 
and -G -s pid can't be used together in this implementation.

  -Arun

