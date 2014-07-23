Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbaGWPMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:12:15 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:45273
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932509AbaGWPMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:12:13 -0400
X-WSS-ID: 0N967K6-08-8R0-02
X-M-MSG: 
From: "Bridgman, John" <John.Bridgman@amd.com>
To: Daniel Vetter <daniel@ffwll.ch>
CC: "Lewycky, Andrew" <Andrew.Lewycky@amd.com>, linux-mm <linux-mm@kvack.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Daenzer, Michel" <Michel.Daenzer@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sellek, Tom" <Tom.Sellek@amd.com>,
        "Skidanov, Alexey" <Alexey.Skidanov@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: RE: [PATCH v2 00/25] AMDKFD kernel driver
Thread-Topic: [PATCH v2 00/25] AMDKFD kernel driver
Thread-Index: AQHPoccPGhea+Gms3Ee6iz2yiCebTpuphK6AgAE7s4CAABFrgIAAHaCAgAAJaQCAABKxAIAABnIAgAAO9oCAAAVWgIAABgyAgADQW4CAAA4yAIAAETEAgAAIz4CAABcQAIABSFQAgAAEUACAACZx8IAAWOCA///CPWCAAAI70A==
Date: Wed, 23 Jul 2014 15:12:07 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01066DA5@storexdag02.amd.com>
References: <53CD5ED9.2040600@amd.com> <20140721190306.GB5278@gmail.com>
 <20140722072851.GH15237@phenom.ffwll.local> <53CE1E9C.8020105@amd.com>
 <CAKMK7uH+okhn4YGOzrXZ1LM3S2myxdu=_63LGMduwV-WZn06CA@mail.gmail.com>
 <53CE346B.1080601@amd.com> <20140722111515.GJ15237@phenom.ffwll.local>
 <53CF5B30.50209@amd.com>
 <CAKMK7uFtSStEewVivbXAT1VC4t2Y+suTaEmQA4=UptK1UBLSmg@mail.gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01066B1B@storexdag02.amd.com>
 <20140723144130.GV15237@phenom.ffwll.local>
 <D89D60253BB73A4E8C62F9FD18A939CA01066D77@storexdag02.amd.com>
In-Reply-To: <D89D60253BB73A4E8C62F9FD18A939CA01066D77@storexdag02.amd.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(377454003)(479174003)(199002)(51704005)(189002)(24454002)(13464003)(2656002)(33656002)(87936001)(85852003)(74502001)(95666004)(77096002)(47776003)(21056001)(92726001)(84676001)(110136001)(106116001)(93886003)(20776003)(31966008)(79102001)(77982001)(55846006)(16601075003)(19580405001)(68736004)(15202345003)(107046002)(64706001)(4396001)(83322001)(74662001)(15975445006)(97736001)(83072002)(50466002)(53416004)(23756003)(54356999)(46102001)(44976005)(81342001)(92566001)(99396002)(81542001)(80022001)(76482001)(19580395003)(85306003)(106466001)(101416001)(105586002)(50986999)(86362001)(76176999);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB043;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: dri-devel [mailto:dri-devel-bounces@lists.freedesktop.org] On Behalf
>Of Bridgman, John
>Sent: Wednesday, July 23, 2014 11:07 AM
>To: Daniel Vetter
>Cc: Lewycky, Andrew; linux-mm; Daniel Vetter; Daenzer, Michel; linux-
>kernel@vger.kernel.org; Sellek, Tom; Skidanov, Alexey; dri-
>devel@lists.freedesktop.org; Andrew Morton
>Subject: RE: [PATCH v2 00/25] AMDKFD kernel driver
>
>
>
>>-----Original Message-----
>>From: Daniel Vetter [mailto:daniel.vetter@ffwll.ch] On Behalf Of Daniel
>>Vetter
>>Sent: Wednesday, July 23, 2014 10:42 AM
>>To: Bridgman, John
>>Cc: Daniel Vetter; Gabbay, Oded; Jerome Glisse; Christian König; David
>>Airlie; Alex Deucher; Andrew Morton; Joerg Roedel; Lewycky, Andrew;
>>Daenzer, Michel; Goz, Ben; Skidanov, Alexey;
>>linux-kernel@vger.kernel.org; dri- devel@lists.freedesktop.org;
>>linux-mm; Sellek, Tom
>>Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
>>
>>On Wed, Jul 23, 2014 at 01:33:24PM +0000, Bridgman, John wrote:
>>>
>>>
>>> >-----Original Message-----
>>> >From: Daniel Vetter [mailto:daniel.vetter@ffwll.ch]
>>> >Sent: Wednesday, July 23, 2014 3:06 AM
>>> >To: Gabbay, Oded
>>> >Cc: Jerome Glisse; Christian König; David Airlie; Alex Deucher;
>>> >Andrew Morton; Bridgman, John; Joerg Roedel; Lewycky, Andrew;
>>> >Daenzer, Michel; Goz, Ben; Skidanov, Alexey;
>>> >linux-kernel@vger.kernel.org; dri- devel@lists.freedesktop.org;
>>> >linux-mm; Sellek, Tom
>>> >Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
>>> >
>>> >On Wed, Jul 23, 2014 at 8:50 AM, Oded Gabbay <oded.gabbay@amd.com>
>>> >wrote:
>>> >> On 22/07/14 14:15, Daniel Vetter wrote:
>>> >>>
>>> >>> On Tue, Jul 22, 2014 at 12:52:43PM +0300, Oded Gabbay wrote:
>>> >>>>
>>> >>>> On 22/07/14 12:21, Daniel Vetter wrote:
>>> >>>>>
>>> >>>>> On Tue, Jul 22, 2014 at 10:19 AM, Oded Gabbay
>>> ><oded.gabbay@amd.com>
>>> >>>>> wrote:
>>> >>>>>>>
>>> >>>>>>> Exactly, just prevent userspace from submitting more. And if
>>> >>>>>>> you have misbehaving userspace that submits too much, reset
>>> >>>>>>> the gpu and tell it that you're sorry but won't schedule any
>>> >>>>>>> more
>>work.
>>> >>>>>>
>>> >>>>>>
>>> >>>>>> I'm not sure how you intend to know if a userspace misbehaves
>>> >>>>>> or
>>not.
>>> >>>>>> Can
>>> >>>>>> you elaborate ?
>>> >>>>>
>>> >>>>>
>>> >>>>> Well that's mostly policy, currently in i915 we only have a
>>> >>>>> check for hangs, and if userspace hangs a bit too often then we
>>> >>>>> stop
>>it.
>>> >>>>> I guess you can do that with the queue unmapping you've
>>> >>>>> describe in reply to Jerome's mail.
>>> >>>>> -Daniel
>>> >>>>>
>>> >>>> What do you mean by hang ? Like the tdr mechanism in Windows
>>> >>>> (checks if a gpu job takes more than 2 seconds, I think, and if
>>> >>>> so, terminates the job).
>>> >>>
>>> >>>
>>> >>> Essentially yes. But we also have some hw features to kill jobs
>>> >>> quicker, e.g. for media workloads.
>>> >>> -Daniel
>>> >>>
>>> >>
>>> >> Yeah, so this is what I'm talking about when I say that you and
>>> >> Jerome come from a graphics POV and amdkfd come from a compute
>>POV,
>>> >> no
>>> >offense intended.
>>> >>
>>> >> For compute jobs, we simply can't use this logic to terminate jobs.
>>> >> Graphics are mostly Real-Time while compute jobs can take from a
>>> >> few ms to a few hours!!! And I'm not talking about an entire
>>> >> application runtime but on a single submission of jobs by the
>>> >> userspace app. We have tests with jobs that take between 20-30
>>> >> minutes to complete. In theory, we can even imagine a compute job
>>> >> which takes 1 or 2 days (on
>>> >larger APUs).
>>> >>
>>> >> Now, I understand the question of how do we prevent the compute
>>> >> job from monopolizing the GPU, and internally here we have some
>>> >> ideas that we will probably share in the next few days, but my
>>> >> point is that I don't think we can terminate a compute job because
>>> >> it is running for more
>>> >than x seconds.
>>> >> It is like you would terminate a CPU process which runs more than
>>> >> x
>>> >seconds.
>>> >>
>>> >> I think this is a *very* important discussion (detecting a
>>> >> misbehaved compute process) and I would like to continue it, but I
>>> >> don't think moving the job submission from userspace control to
>>> >> kernel control will solve this core problem.
>>> >
>>> >Well graphics gets away with cooperative scheduling since usually
>>> >people want to see stuff within a few frames, so we can legitimately
>>> >kill jobs after a fairly short timeout. Imo if you want to allow
>>> >userspace to submit compute jobs that are atomic and take a few
>>> >minutes to hours with no break-up in between and no hw means to
>>> >preempt then that design is screwed up. We really can't tell the
>>> >core vm that "sorry we will hold onto these gobloads of memory you
>>> >really need now for another few hours". Pinning memory like that
>>> >essentially
>>without a time limit is restricted to root.
>>>
>>> Hi Daniel;
>>>
>>> I don't really understand the reference to "gobloads of memory".
>>> Unlike radeon graphics, the userspace data for HSA applications is
>>> maintained in pageable system memory and accessed via the IOMMUv2
>>> (ATC/PRI). The
>>> IOMMUv2 driver and mm subsystem takes care of faulting in memory
>>> pages as needed, nothing is long-term pinned.
>>
>>Yeah I've lost that part of the equation a bit since I've always
>>thought that proper faulting support without preemption is not really
>>possible. I guess those platforms completely stall on a fault until the ptes
>are all set up?
>
>Correct. The GPU thread accessing the faulted page definitely stalls but
>processing can continue on other GPU threads.

Sorry, this may be oversimplified -- I'll double-check that internally. We may stall the CU for the duration of the fault processing. Stay tuned.
 
>
>I don't remember offhand how much of the GPU=>ATC=>IOMMUv2=>system
>RAM path gets stalled (ie whether other HSA apps get blocked) but AFAIK
>graphics processing (assuming it is not using ATC path to system memory) is
>not affected. I will double-check that though, haven't asked internally for a
>couple of years but I do remember concluding something along the lines of
>"OK, that'll do" ;)
>
>>-Daniel
>>--
>>Daniel Vetter
>>Software Engineer, Intel Corporation
>>+41 (0) 79 365 57 48 - http://blog.ffwll.ch
>_______________________________________________
>dri-devel mailing list
>dri-devel@lists.freedesktop.org
>http://lists.freedesktop.org/mailman/listinfo/dri-devel
