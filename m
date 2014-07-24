Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbaGXS5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:57:32 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:4586
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758964AbaGXS5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:57:31 -0400
X-WSS-ID: 0N98CNM-07-SNQ-02
X-M-MSG: 
Message-ID: <53D1570C.5000704@amd.com>
Date: Thu, 24 Jul 2014 21:57:16 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>, Alex Deucher <alexdeucher@gmail.com>
CC: "Bridgman, John" <John.Bridgman@amd.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "David Airlie" <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
References: <53CD0961.4070505@amd.com> <53CD17FD.3000908@vodafone.de>
 <20140721152511.GW15237@phenom.ffwll.local> <20140721155851.GB4519@gmail.com>
 <20140721170546.GB15237@phenom.ffwll.local>
 <20140723135931.79541a86@jbarnes-desktop>
 <D89D60253BB73A4E8C62F9FD18A939CA01067410@storexdag02.amd.com>
 <53D030C5.3030207@amd.com> <20140724154443.GA2951@gmail.com>
 <CADnq5_OhE-U8DTB49ab3CNx+tnwXKcZh6USrpJZCR+p4fe9Fiw@mail.gmail.com>
 <20140724184739.GA6177@gmail.com>
In-Reply-To: <20140724184739.GA6177@gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Originating-IP: [10.224.155.208]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(377454003)(189002)(199002)(479174003)(51704005)(24454002)(13464003)(19580395003)(23676002)(74662001)(92566001)(83322001)(79102001)(65816999)(36756003)(76176999)(85852003)(80316001)(87266999)(77982001)(50986999)(74502001)(68736004)(93886003)(19580405001)(50466002)(21056001)(83072002)(92726001)(65956001)(33656002)(46102001)(83506001)(65806001)(80022001)(54356999)(20776003)(85306003)(47776003)(64706001)(81342001)(106466001)(86362001)(102836001)(81542001)(105586002)(107046002)(101416001)(87936001)(31966008)(97736001)(99396002)(76482001)(4396001)(84676001)(64126003)(95666004)(44976005);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/14 21:47, Jerome Glisse wrote:
> On Thu, Jul 24, 2014 at 01:35:53PM -0400, Alex Deucher wrote:
>> On Thu, Jul 24, 2014 at 11:44 AM, Jerome Glisse <j.glisse@gmail.com> wrote:
>>> On Thu, Jul 24, 2014 at 01:01:41AM +0300, Oded Gabbay wrote:
>>>> On 24/07/14 00:46, Bridgman, John wrote:
>>>>>
>>>>>> -----Original Message----- From: dri-devel
>>>>>> [mailto:dri-devel-bounces@lists.freedesktop.org] On Behalf Of Jesse
>>>>>> Barnes Sent: Wednesday, July 23, 2014 5:00 PM To:
>>>>>> dri-devel@lists.freedesktop.org Subject: Re: [PATCH v2 00/25]
>>>>>> AMDKFD kernel driver
>>>>>>
>>>>>> On Mon, 21 Jul 2014 19:05:46 +0200 daniel at ffwll.ch (Daniel
>>>>>> Vetter) wrote:
>>>>>>
>>>>>>> On Mon, Jul 21, 2014 at 11:58:52AM -0400, Jerome Glisse wrote:
>>>>>>>> On Mon, Jul 21, 2014 at 05:25:11PM +0200, Daniel Vetter wrote:
>>>>>>>>> On Mon, Jul 21, 2014 at 03:39:09PM +0200, Christian K?nig
>>>>>>>>> wrote:
>>>>>>>>>> Am 21.07.2014 14:36, schrieb Oded Gabbay:
>>>>>>>>>>> On 20/07/14 20:46, Jerome Glisse wrote:
>>>>>>
>>>>>> [snip!!]
>>>>> My BlackBerry thumb thanks you ;)
>>>>>>
>>>>>>>>>>
>>>>>>>>>> The main questions here are if it's avoid able to pin down
>>>>>>>>>> the memory and if the memory is pinned down at driver load,
>>>>>>>>>> by request from userspace or by anything else.
>>>>>>>>>>
>>>>>>>>>> As far as I can see only the "mqd per userspace queue"
>>>>>>>>>> might be a bit questionable, everything else sounds
>>>>>>>>>> reasonable.
>>>>>>>>>
>>>>>>>>> Aside, i915 perspective again (i.e. how we solved this):
>>>>>>>>> When scheduling away from contexts we unpin them and put them
>>>>>>>>> into the lru. And in the shrinker we have a last-ditch
>>>>>>>>> callback to switch to a default context (since you can't ever
>>>>>>>>> have no context once you've started) which means we can evict
>>>>>>>>> any context object if it's
>>>>>> getting in the way.
>>>>>>>>
>>>>>>>> So Intel hardware report through some interrupt or some channel
>>>>>>>> when it is not using a context ? ie kernel side get
>>>>>>>> notification when some user context is done executing ?
>>>>>>>
>>>>>>> Yes, as long as we do the scheduling with the cpu we get
>>>>>>> interrupts for context switches. The mechanic is already
>>>>>>> published in the execlist patches currently floating around. We
>>>>>>> get a special context switch interrupt.
>>>>>>>
>>>>>>> But we have this unpin logic already on the current code where
>>>>>>> we switch contexts through in-line cs commands from the kernel.
>>>>>>> There we obviously use the normal batch completion events.
>>>>>>
>>>>>> Yeah and we can continue that going forward.  And of course if your
>>>>>> hw can do page faulting, you don't need to pin the normal data
>>>>>> buffers.
>>>>>>
>>>>>> Usually there are some special buffers that need to be pinned for
>>>>>> longer periods though, anytime the context could be active.  Sounds
>>>>>> like in this case the userland queues, which makes some sense.  But
>>>>>> maybe for smaller systems the size limit could be clamped to
>>>>>> something smaller than 128M.  Or tie it into the rlimit somehow,
>>>>>> just like we do for mlock() stuff.
>>>>>>
>>>>> Yeah, even the queues are in pageable memory, it's just a ~256 byte
>>>>> structure per queue (the Memory Queue Descriptor) that describes the
>>>>> queue to hardware, plus a couple of pages for each process using HSA
>>>>> to hold things like doorbells. Current thinking is to limit #
>>>>> processes using HSA to ~256 and #queues per process to ~1024 by
>>>>> default in the initial code, although my guess is that we could take
>>>>> the #queues per process default limit even lower.
>>>>>
>>>>
>>>> So my mistake. struct cik_mqd is actually 604 bytes, and it is allocated
>>>> on 256 boundary.
>>>> I had in mind to reserve 64MB of gart by default, which translates to
>>>> 512 queues per process, with 128 processes. Add 2 kernel module
>>>> parameters, # of max-queues-per-process and # of max-processes (default
>>>> is, as I said, 512 and 128) for better control of system admin.
>>>>
>>>
>>> So as i said somewhere else in this thread, this should not be reserved
>>> but use a special allocation. Any HSA GPU use virtual address space for
>>> userspace so only issue is for kernel side GTT.
>>>
>>> What i would like is seeing radeon pinned GTT allocation at bottom of
>>> GTT space (ie all ring buffer and the ib pool buffer). Then have an
>>> allocator that allocate new queue from top of GTT address space and
>>> grow to the bottom.
>>>
>>> It should not staticly reserved 64M or anything. When doing allocation
>>> it should move any ttm buffer that are in the region it want to allocate
>>> to a different location.
>>>
>>>
>>> As this needs some work, i am not against reserving some small amount
>>> (couple MB) as a first stage but anything more would need a proper solution
>>> like the one i just described.
>>
>> It's still a trade off.  Even if we reserve a couple of megs it'll be
>> wasted if we are not running HSA apps. And even today if we run a
>> compute job using the current interfaces we could end up in the same
>> case.  So while I think it's definitely a good goal to come up with
>> some solution for fragmentation, I don't think it should be a
>> show-stopper right now.
>>
> 
> Seems i am having a hard time to express myself. I am not saying it is a
> showstopper i am saying until proper solution is implemented KFD should
> limit its number of queue to consume at most couple MB ie not 64MB or more
> but 2MB, 4MB something in that water.
So we thought internally about limiting ourselves through two kernel
module parameters, # of queues per process and # of processes. Default
values will be 128 queues per process and 32 processes. mqd takes 768
bytes at most, so that gives us a maximum of 3MB.

For absolute maximum, I think using H/W limits which are 1024 queues per
process and 512 processes. That gives us 384MB.

Would that be acceptable ?
> 
>> A better solution to deal with fragmentation of GTT and provide a
>> better way to allocate larger buffers in vram would be to break up
>> vram <-> system pool transfers into multiple transfers depending on
>> the available GTT size.  Or use GPUVM dynamically for  vram <-> system
>> transfers.
> 
> Isn't the UVD engine still using the main GTT ? I have not look much at
> UVD in a while.
> 
> Yes there is way to fix buffer migration but i would also like to see
> address space fragmentation to a minimum which is the main reason i
> uterly hate any design that forbid kernel to take over and do its thing.
> 
> Buffer pining should really be only for front buffer and thing like ring
> ie buffer that have a lifetime bound to the driver lifetime.
> 
> Cheers,
> Jérôme
> 
>>
>> Alex

