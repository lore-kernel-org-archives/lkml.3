Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaGWNju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:39:50 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:1801
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751122AbaGWNjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:39:48 -0400
X-WSS-ID: 0N963A5-07-W8Z-02
X-M-MSG: 
From: "Bridgman, John" <John.Bridgman@amd.com>
To: =?iso-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        "Gabbay, Oded" <Oded.Gabbay@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "Daenzer, Michel" <Michel.Daenzer@amd.com>,
        "Goz, Ben" <Ben.Goz@amd.com>,
        "Skidanov, Alexey" <Alexey.Skidanov@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>, "Sellek, Tom" <Tom.Sellek@amd.com>
Subject: RE: [PATCH v2 00/25] AMDKFD kernel driver
Thread-Topic: [PATCH v2 00/25] AMDKFD kernel driver
Thread-Index: AQHPoccPGhea+Gms3Ee6iz2yiCebTpuphK6AgAE7s4CAABFrgIAAHaCAgAAJaQCAABKxAIAABnIAgAAO9oCAAAVWgIAABgyAgADQW4CAAA4yAIAAETEAgAAIz4CAABcQAIABSFQAgAAD6gCAACmwkA==
Date: Wed, 23 Jul 2014 13:39:39 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01066B4D@storexdag02.amd.com>
References: <20140721155851.GB4519@gmail.com>
 <20140721170546.GB15237@phenom.ffwll.local> <53CD4DD2.10906@amd.com>
 <CAKMK7uFhvGtxj_d6X=4OBdVSm6cT1-Z-DiTE-FTWMnFjY2uqMQ@mail.gmail.com>
 <53CD5ED9.2040600@amd.com> <20140721190306.GB5278@gmail.com>
 <20140722072851.GH15237@phenom.ffwll.local> <53CE1E9C.8020105@amd.com>
 <CAKMK7uH+okhn4YGOzrXZ1LM3S2myxdu=_63LGMduwV-WZn06CA@mail.gmail.com>
 <53CE346B.1080601@amd.com> <20140722111515.GJ15237@phenom.ffwll.local>
 <53CF5B30.50209@amd.com> <53CF5E78.8070208@vodafone.de>
In-Reply-To: <53CF5E78.8070208@vodafone.de>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(479174003)(24454002)(377454003)(51704005)(199002)(189002)(13464003)(2656002)(76482001)(2201001)(107046002)(21056001)(97736001)(74662001)(92726001)(81342001)(77982001)(87936001)(107886001)(106466001)(19580395003)(92566001)(4396001)(105586002)(83322001)(50466002)(106116001)(19580405001)(64706001)(54356999)(95666004)(83072002)(84676001)(46102001)(86362001)(23756003)(80022001)(77096002)(93886003)(44976005)(55846006)(31966008)(47776003)(33656002)(85852003)(101416001)(74502001)(81542001)(99396002)(68736004)(79102001)(20776003)(53416004)(85306003)(50986999)(76176999)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Christian König [mailto:deathsimple@vodafone.de]
>Sent: Wednesday, July 23, 2014 3:04 AM
>To: Gabbay, Oded; Jerome Glisse; David Airlie; Alex Deucher; Andrew
>Morton; Bridgman, John; Joerg Roedel; Lewycky, Andrew; Daenzer, Michel;
>Goz, Ben; Skidanov, Alexey; linux-kernel@vger.kernel.org; dri-
>devel@lists.freedesktop.org; linux-mm; Sellek, Tom
>Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
>
>Am 23.07.2014 08:50, schrieb Oded Gabbay:
>> On 22/07/14 14:15, Daniel Vetter wrote:
>>> On Tue, Jul 22, 2014 at 12:52:43PM +0300, Oded Gabbay wrote:
>>>> On 22/07/14 12:21, Daniel Vetter wrote:
>>>>> On Tue, Jul 22, 2014 at 10:19 AM, Oded Gabbay
><oded.gabbay@amd.com>
>>>>> wrote:
>>>>>>> Exactly, just prevent userspace from submitting more. And if you
>>>>>>> have misbehaving userspace that submits too much, reset the gpu
>>>>>>> and tell it that you're sorry but won't schedule any more work.
>>>>>>
>>>>>> I'm not sure how you intend to know if a userspace misbehaves or
>>>>>> not. Can you elaborate ?
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
>>> Essentially yes. But we also have some hw features to kill jobs
>>> quicker, e.g. for media workloads.
>>> -Daniel
>>>
>>
>> Yeah, so this is what I'm talking about when I say that you and Jerome
>> come from a graphics POV and amdkfd come from a compute POV, no
>> offense intended.
>>
>> For compute jobs, we simply can't use this logic to terminate jobs.
>> Graphics are mostly Real-Time while compute jobs can take from a few
>> ms to a few hours!!! And I'm not talking about an entire application
>> runtime but on a single submission of jobs by the userspace app. We
>> have tests with jobs that take between 20-30 minutes to complete. In
>> theory, we can even imagine a compute job which takes 1 or 2 days (on
>> larger APUs).
>>
>> Now, I understand the question of how do we prevent the compute job
>> from monopolizing the GPU, and internally here we have some ideas that
>> we will probably share in the next few days, but my point is that I
>> don't think we can terminate a compute job because it is running for
>> more than x seconds. It is like you would terminate a CPU process
>> which runs more than x seconds.
>
>Yeah that's why one of the first things I've did was making the timeout
>configurable in the radeon module.
>
>But it doesn't necessary needs be a timeout, we should also kill a running job
>submission if the CPU process associated with the job is killed.
>
>> I think this is a *very* important discussion (detecting a misbehaved
>> compute process) and I would like to continue it, but I don't think
>> moving the job submission from userspace control to kernel control
>> will solve this core problem.
>
>We need to get this topic solved, otherwise the driver won't make it
>upstream. Allowing userpsace to monopolizing resources either memory,
>CPU or GPU time or special things like counters etc... is a strict no go for a
>kernel module.
>
>I agree that moving the job submission from userpsace to kernel wouldn't
>solve this problem. As Daniel and I pointed out now multiple times it's rather
>easily possible to prevent further job submissions from userspace, in the
>worst case by unmapping the doorbell page.
>
>Moving it to an IOCTL would just make it a bit less complicated.

Hi Christian;

HSA uses usermode queues so that programs running on GPU can dispatch work to themselves or to other GPUs with a consistent dispatch mechanism for CPU and GPU code. We could potentially use s_msg and trap every GPU dispatch back through CPU code but that gets slow and ugly very quickly. 

>
>Christian.
>
>>
>>     Oded

