Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaFFQab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:30:31 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:41664
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751854AbaFFQaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:30:30 -0400
X-WSS-ID: 0N6R9UN-07-NRS-02
X-M-MSG: 
Message-ID: <5391EC92.8040500@amd.com>
Date: Fri, 6 Jun 2014 11:30:10 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.w.shin@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>
Subject: Re: [PATCH 2/4] perf tools: allow user to specify hardware breakpoint
 bp_len
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
 <1401377213-24551-3-git-send-email-fweisbec@gmail.com>
 <20140530133906.GC7427@krava.brq.redhat.com>
 <87mwduepux.fsf@sejong.aot.lge.com>
 <20140603115503.GA2864@krava.brq.redhat.com>
In-Reply-To: <20140603115503.GA2864@krava.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(479174003)(377454003)(189002)(199002)(51704005)(24454002)(164054003)(101416001)(84676001)(36756003)(46102001)(64126003)(20776003)(65956001)(50466002)(83072002)(85852003)(4396001)(65806001)(79102001)(64706001)(83506001)(81342001)(65816999)(47776003)(99396002)(68736004)(102836001)(80022001)(81542001)(86362001)(76482001)(92566001)(92726001)(87936001)(97736001)(93886002)(59896001)(77982001)(21056001)(23756003)(33656002)(74502001)(44976005)(80316001)(54356999)(76176999)(31966008)(74662001)(77096999)(87266999)(50986999)(19580405001)(83322001)(19580395003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB202;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 023495660C
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/2014 6:55 AM, Jiri Olsa wrote:
> On Tue, Jun 03, 2014 at 10:36:22AM +0900, Namhyung Kim wrote:
>> Hi Jiri,
>>
>> On Fri, 30 May 2014 15:39:06 +0200, Jiri Olsa wrote:
>>> On Thu, May 29, 2014 at 05:26:51PM +0200, Frederic Weisbecker wrote:
>>>> From: Jacob Shin <jacob.w.shin@gmail.com>
>>>>
>>>> Currently bp_len is given a default value of 4. Allow user to override it:
>>>>
>>>>    $ perf stat -e mem:0x1000/8
>>>>                              ^
>>>>                              bp_len
>>>>
>>>> If no value is given, it will default to 4 as it did before.
>>>
>>> Namhyung,
>>> both perf tols patches from this patchset mess up with hists
>>> tests..  I havent found any connection yet.. any idea? ;-)
>>
>> So you already found the problem in the hpp->elide change and that's the
>> reason of the failure, right? :)
>
> I haven't got a chance to test it yet.. but it looks like
> thats the case.. I'll retest soon ;-)
>
> jirka
>
Anything I can do to help here?

Thanks,

Suravee

