Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3LRKjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:39:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1840 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751539Ab3LRKjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:39:39 -0500
Message-ID: <52B17B14.5030101@fb.com>
Date: Wed, 18 Dec 2013 16:08:12 +0530
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [RFC/PATCHSET 00/18] perf report: Add support to accumulate hist
 periods (v3)
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org> <20131218094622.GA19240@gmail.com>
In-Reply-To: <20131218094622.GA19240@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2013-12-18_03:2013-12-17,2013-12-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/13 3:16 PM, Ingo Molnar wrote:

> My main complaint that any variation of 'cumulative' or 'cumulate' is
> a tongue-twister to users. I certainly won't be able to remember it
> and will have to call up the manpage every time I use it - which will
> be very annoying. I'd probably not use the feature much.

I can remember it, mainly because it's such an unusual word :)
Agree that we could use something simpler/easier to remember.

My other user space projects have been keeping me busy. But still very 
interested in this feature. Will test this patch series over the holidays.

  -Arun
