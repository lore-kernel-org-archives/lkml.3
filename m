Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaAVSFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:05:12 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1058 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523AbaAVSFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:05:08 -0500
Message-ID: <52E00800.90305@fb.com>
Date: Wed, 22 Jan 2014 10:03:44 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 00/24] perf tools: Add support to accumulate hist periods
 (v6)
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org> <20140122132018.GC1132@krava.brq.redhat.com>
In-Reply-To: <20140122132018.GC1132@krava.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-22_06:2014-01-22,2014-01-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/14 5:20 AM, Jiri Olsa wrote:

> I have changes on top of this patchset and all looks great, I was
> just going throught this again and wanted to send my ack, but it
> no longer merges to the acme's perf/core.
>
> Could you please send updated version, and I'll finish the
> review.. I promise ;-)

We've been testing v5 of this patch series and haven't found any major 
problems on our end.

Tested-By: Arun Sharma <asharma@fb.com>

  -Arun
