Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaGWNdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:33:35 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:28425
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751774AbaGWNdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:33:33 -0400
X-WSS-ID: 0N962ZQ-07-VV2-02
X-M-MSG: 
From: "Bridgman, John" <John.Bridgman@amd.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Gabbay, Oded" <Oded.Gabbay@amd.com>
CC: Jerome Glisse <j.glisse@gmail.com>,
        =?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Joerg Roedel" <joro@8bytes.org>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "Daenzer, Michel" <Michel.Daenzer@amd.com>,
        "Goz, Ben" <Ben.Goz@amd.com>,
        "Skidanov, Alexey" <Alexey.Skidanov@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>, "Sellek, Tom" <Tom.Sellek@amd.com>
Subject: RE: [PATCH v2 00/25] AMDKFD kernel driver
Thread-Topic: [PATCH v2 00/25] AMDKFD kernel driver
Thread-Index: AQHPoccPGhea+Gms3Ee6iz2yiCebTpuphK6AgAE7s4CAABFrgIAAHaCAgAAJaQCAABKxAIAABnIAgAAO9oCAAAVWgIAABgyAgADQW4CAAA4yAIAAETEAgAAIz4CAABcQAIABSFQAgAAEUACAACZx8A==
Date: Wed, 23 Jul 2014 13:33:24 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01066B1B@storexdag02.amd.com>
References: <20140721155851.GB4519@gmail.com>
	<20140721170546.GB15237@phenom.ffwll.local>	<53CD4DD2.10906@amd.com>
	<CAKMK7uFhvGtxj_d6X=4OBdVSm6cT1-Z-DiTE-FTWMnFjY2uqMQ@mail.gmail.com>
	<53CD5ED9.2040600@amd.com>	<20140721190306.GB5278@gmail.com>
	<20140722072851.GH15237@phenom.ffwll.local>	<53CE1E9C.8020105@amd.com>
	<CAKMK7uH+okhn4YGOzrXZ1LM3S2myxdu=_63LGMduwV-WZn06CA@mail.gmail.com>
	<53CE346B.1080601@amd.com>	<20140722111515.GJ15237@phenom.ffwll.local>
	<53CF5B30.50209@amd.com>
 <CAKMK7uFtSStEewVivbXAT1VC4t2Y+suTaEmQA4=UptK1UBLSmg@mail.gmail.com>
In-Reply-To: <CAKMK7uFtSStEewVivbXAT1VC4t2Y+suTaEmQA4=UptK1UBLSmg@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(479174003)(24454002)(377454003)(51704005)(199002)(189002)(13464003)(2656002)(76482001)(107046002)(21056001)(97736001)(74662001)(92726001)(81342001)(77982001)(87936001)(106466001)(19580395003)(92566001)(15202345003)(23676002)(4396001)(105586002)(83322001)(50466002)(106116001)(19580405001)(64706001)(54356999)(95666004)(83072002)(84676001)(46102001)(86362001)(80022001)(77096002)(93886003)(44976005)(55846006)(31966008)(47776003)(33656002)(85852003)(101416001)(74502001)(81542001)(99396002)(15975445006)(68736004)(79102001)(20776003)(53416004)(85306003)(50986999)(76176999);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6NDXh3f016225



>-----Original Message-----
>From: Daniel Vetter [mailto:daniel.vetter@ffwll.ch]
>Sent: Wednesday, July 23, 2014 3:06 AM
>To: Gabbay, Oded
>Cc: Jerome Glisse; Christian KÃ¶nig; David Airlie; Alex Deucher; Andrew
>Morton; Bridgman, John; Joerg Roedel; Lewycky, Andrew; Daenzer, Michel;
>Goz, Ben; Skidanov, Alexey; linux-kernel@vger.kernel.org; dri-
>devel@lists.freedesktop.org; linux-mm; Sellek, Tom
>Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
>
>On Wed, Jul 23, 2014 at 8:50 AM, Oded Gabbay <oded.gabbay@amd.com>
>wrote:
>> On 22/07/14 14:15, Daniel Vetter wrote:
>>>
>>> On Tue, Jul 22, 2014 at 12:52:43PM +0300, Oded Gabbay wrote:
>>>>
>>>> On 22/07/14 12:21, Daniel Vetter wrote:
>>>>>
>>>>> On Tue, Jul 22, 2014 at 10:19 AM, Oded Gabbay
><oded.gabbay@amd.com>
>>>>> wrote:
>>>>>>>
>>>>>>> Exactly, just prevent userspace from submitting more. And if you
>>>>>>> have misbehaving userspace that submits too much, reset the gpu
>>>>>>> and tell it that you're sorry but won't schedule any more work.
>>>>>>
>>>>>>
>>>>>> I'm not sure how you intend to know if a userspace misbehaves or not.
>>>>>> Can
>>>>>> you elaborate ?
>>>>>
>>>>>
>>>>> Well that's mostly policy, currently in i915 we only have a check
>>>>> for hangs, and if userspace hangs a bit too often then we stop it.
>>>>> I guess you can do that with the queue unmapping you've describe in
>>>>> reply to Jerome's mail.
>>>>> -Daniel
>>>>>
>>>> What do you mean by hang ? Like the tdr mechanism in Windows (checks
>>>> if a gpu job takes more than 2 seconds, I think, and if so,
>>>> terminates the job).
>>>
>>>
>>> Essentially yes. But we also have some hw features to kill jobs
>>> quicker, e.g. for media workloads.
>>> -Daniel
>>>
>>
>> Yeah, so this is what I'm talking about when I say that you and Jerome
>> come from a graphics POV and amdkfd come from a compute POV, no
>offense intended.
>>
>> For compute jobs, we simply can't use this logic to terminate jobs.
>> Graphics are mostly Real-Time while compute jobs can take from a few
>> ms to a few hours!!! And I'm not talking about an entire application
>> runtime but on a single submission of jobs by the userspace app. We
>> have tests with jobs that take between 20-30 minutes to complete. In
>> theory, we can even imagine a compute job which takes 1 or 2 days (on
>larger APUs).
>>
>> Now, I understand the question of how do we prevent the compute job
>> from monopolizing the GPU, and internally here we have some ideas that
>> we will probably share in the next few days, but my point is that I
>> don't think we can terminate a compute job because it is running for more
>than x seconds.
>> It is like you would terminate a CPU process which runs more than x
>seconds.
>>
>> I think this is a *very* important discussion (detecting a misbehaved
>> compute process) and I would like to continue it, but I don't think
>> moving the job submission from userspace control to kernel control
>> will solve this core problem.
>
>Well graphics gets away with cooperative scheduling since usually people
>want to see stuff within a few frames, so we can legitimately kill jobs after a
>fairly short timeout. Imo if you want to allow userspace to submit compute
>jobs that are atomic and take a few minutes to hours with no break-up in
>between and no hw means to preempt then that design is screwed up. We
>really can't tell the core vm that "sorry we will hold onto these gobloads of
>memory you really need now for another few hours". Pinning memory like
>that essentially without a time limit is restricted to root.

Hi Daniel;

I don't really understand the reference to "gobloads of memory". Unlike radeon graphics, the userspace data for HSA applications is maintained in pageable system memory and accessed via the IOMMUv2 (ATC/PRI). The IOMMUv2 driver and mm subsystem takes care of faulting in memory pages as needed, nothing is long-term pinned.

The only pinned memory we are talking about here is per-queue and per-process data structures in the driver, which are tiny by comparison. Oded provided the "hardware limits" (ie an insane number of process & threads) for context, but real-world limits will be one or two orders of magnitude lower. Agree we should have included those limits in the initial code, that would have made the "real world" memory footprint much more visible. 

Make sense ?

>-Daniel
>--
>Daniel Vetter
>Software Engineer, Intel Corporation
>+41 (0) 79 365 57 48 - http://blog.ffwll.ch
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
