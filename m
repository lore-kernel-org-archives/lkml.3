Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab3KLMIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:08:38 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52217 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581Ab3KLMIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:08:35 -0500
X-Sasl-enc: ziAE5EYb/6wtx3k2UMhChneyu1ZWrI6X3SlSCH/p/a2j 1384258114
Message-ID: <52821A3F.6000002@iki.fi>
Date: Tue, 12 Nov 2013 14:08:31 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
CC: Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
References: <20131101075502.GA25547@gmail.com> <874n7w4gtm.fsf@sejong.aot.lge.com> <20131101092759.GC27063@gmail.com> <87bo1zz4mu.fsf@sejong.aot.lge.com> <20131105074650.GA2855@gmail.com> <87txfrxlq8.fsf@sejong.aot.lge.com> <20131105115802.GA12045@gmail.com> <87ppqex8tj.fsf@sejong.aot.lge.com> <20131106083046.GA4655@gmail.com> <87r4atx51i.fsf@sejong.aot.lge.com> <20131106114701.GA20249@gmail.com> <527A613A.20404@gmail.com>
In-Reply-To: <527A613A.20404@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 05:33 PM, David Ahern wrote:
> On 11/6/13, 4:47 AM, Ingo Molnar wrote:
>> I'm not too worried about call-graph 'legacies': it generates such huge
>> perf.data files which is parsed so slowly at the moment that there's 
>> very
>> little user base ... Anyone who absolutely needs call-graph profiling 
>> uses
>> SysProf which performs well.
>
> Actually, perf with callchains is used quite heavily on my products. 
> One of the selling points of perf.

I use perf with callchains all the time as well.

                     Pekka
