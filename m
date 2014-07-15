Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbaGORxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:53:46 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:45963
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752469AbaGORxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:53:42 -0400
X-WSS-ID: 0N8RLP9-08-0O2-02
X-M-MSG: 
From: "Bridgman, John" <John.Bridgman@amd.com>
To: Jerome Glisse <j.glisse@gmail.com>
CC: Dave Airlie <airlied@gmail.com>,
        =?iso-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: RE: [PATCH 00/83] AMD HSA kernel driver
Thread-Topic: [PATCH 00/83] AMD HSA kernel driver
Thread-Index: AQHPnIhRgu4cBSEvqEGszfo01ez7ZpuaJWaAgAAHkICAAXhzgIABnKmAgABkh4CAAHT6oIAAYx0AgAEJCoCAAU6ggIAAixtAgABPUwD//7+6gA==
Date: Tue, 15 Jul 2014 17:53:32 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01050211@storexdag02.amd.com>
References: <20140710222423.GA14219@gmail.com>
 <019CCE693E457142B37B791721487FD91809E4C2@storexdag01.amd.com>
 <20140711211850.GU1870@gmail.com>
 <019CCE693E457142B37B791721487FD9180A193B@storexdag01.amd.com>
 <20140713035535.GB5301@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA0103C0EB@storexdag02.amd.com>
 <20140713164901.GB10624@gmail.com> <53C396D3.9000600@vodafone.de>
 <CAPM=9txM=0Rd8sP56X1v2sXhAYiRJDoz-j8+N0wXpam-+kYJ8Q@mail.gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01050131@storexdag02.amd.com>
 <20140715173704.GA3421@gmail.com>
In-Reply-To: <20140715173704.GA3421@gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(13464003)(24454002)(199002)(377454003)(51704005)(83072002)(77096002)(87936001)(74662001)(50986999)(77982001)(64706001)(54356999)(93886003)(50466002)(110136001)(2656002)(76176999)(85306003)(105586002)(76482001)(95666004)(31966008)(81342001)(79102001)(33656002)(19580395003)(84676001)(92726001)(47776003)(23756003)(20776003)(86362001)(85852003)(81542001)(83322001)(97736001)(55846006)(99396002)(68736004)(21056001)(106116001)(53416004)(19580405001)(46102001)(106466001)(74502001)(4396001)(80022001)(107046002)(92566001)(101416001)(44976005)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Jerome Glisse [mailto:j.glisse@gmail.com]
>Sent: Tuesday, July 15, 2014 1:37 PM
>To: Bridgman, John
>Cc: Dave Airlie; Christian König; Lewycky, Andrew; linux-
>kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; Deucher,
>Alexander; akpm@linux-foundation.org
>Subject: Re: [PATCH 00/83] AMD HSA kernel driver
>
>On Tue, Jul 15, 2014 at 05:06:56PM +0000, Bridgman, John wrote:
>> >From: Dave Airlie [mailto:airlied@gmail.com]
>> >Sent: Tuesday, July 15, 2014 12:35 AM
>> >To: Christian König
>> >Cc: Jerome Glisse; Bridgman, John; Lewycky, Andrew; linux-
>> >kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; Deucher,
>> >Alexander; akpm@linux-foundation.org
>> >Subject: Re: [PATCH 00/83] AMD HSA kernel driver
>> >
>> >On 14 July 2014 18:37, Christian König <deathsimple@vodafone.de> wrote:
>> >>> I vote for HSA module that expose ioctl and is an intermediary
>> >>> with the kernel driver that handle the hardware. This gives a
>> >>> single point for HSA hardware and yes this enforce things for any
>> >>> hardware
>> >manufacturer.
>> >>> I am more than happy to tell them that this is it and nothing else
>> >>> if they want to get upstream.
>> >>
>> >> I think we should still discuss this single point of entry a bit more.
>> >>
>> >> Just to make it clear the plan is to expose all physical HSA
>> >> capable devices through a single /dev/hsa device node to userspace.
>> >
>> >This is why we don't design kernel interfaces in secret foundations,
>> >and expect anyone to like them.
>>
>> Understood and agree. In this case though this isn't a cross-vendor
>> interface designed by a secret committee, it's supposed to be more of
>> an inoffensive little single-vendor interface designed *for* a secret
>> committee. I'm hoping that's better ;)
>>
>> >
>> >So before we go any further, how is this stuff planned to work for
>> >multiple GPUs/accelerators?
>>
>> Three classes of "multiple" :
>>
>> 1. Single CPU with IOMMUv2 and multiple GPUs:
>>
>> - all devices accessible via /dev/kfd
>> - topology information identifies CPU + GPUs, each has "node ID" at
>> top of userspace API, "global ID" at user/kernel interface  (don't
>> think we've implemented CPU part yet though)
>> - userspace builds snapshot from sysfs info & exposes to HSAIL
>> runtime, which in turn exposes the "standard" API
>
>This is why i do not like the sysfs approach, it would be lot nicer to have
>device file per provider and thus hsail can listen on device file event and
>discover if hardware is vanishing or appearing. Periodicaly going over sysfs
>files is not the right way to do that.

Agree that wouldn't be good. There's an event mechanism still to come - mostly for communicating fences and shader interrupts back to userspace, but also used for "device change" notifications, so no polling of sysfs.

>
>> - kfd sets up ATC aperture so GPUs can access system RAM via IOMMUv2
>> (fast for APU, relatively less so for dGPU over PCIE)
>> - to-be-added memory operations allow allocation & residency control
>> (within existing gfx driver limits) of buffers in VRAM & carved-out
>> system RAM
>> - queue operations specify a node ID to userspace library, which
>> translates to "global ID" before calling kfd
>>
>> 2. Multiple CPUs connected via fabric (eg HyperTransport) each with 0 or
>more GPUs:
>>
>> - topology information exposes CPUs & GPUs, along with affinity info
>> showing what is connected to what
>> - everything else works as in (1) above
>>
>
>This is suppose to be part of HSA ? This is lot broader than i thought.

Yes although it can be skipped on most systems. We figured that topology needed to cover everything that would be handled by a single OS image, so in a NUMA system it would need to cover all the CPUs. I think that is still the right scope, do you agree ?

>
>> 3. Multiple CPUs not connected via fabric (eg a blade server) each
>> with 0 or more GPUs
>>
>> - no attempt to cover this with HSA topology, each CPU and associated
>> GPUs is accessed independently via separate /dev/kfd instances
>>
>> >
>> >Do we have a userspace to exercise this interface so we can see how
>> >such a thing would look?
>>
>> Yes -- initial IP review done, legal stuff done, sanitizing WIP,
>> hoping for final approval this week
>>
>> There's a separate test harness to exercise the userspace lib calls,
>> haven't started IP review or sanitizing for that but legal stuff is
>> done
>>
>> >
>> >Dave.
