Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3HLSOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:14:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1042 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358Ab3HLSOI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:14:08 -0400
From: Dan Williams <djbw@fb.com>
To: Jon Mason <jon.mason@intel.com>, "Koul, Vinod" <vinod.koul@intel.com>
CC: "Jiang, Dave" <dave.jiang@intel.com>, Brice Goglin <Brice.Goglin@inria.fr>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioatdma: add ioat_raid_enabled module parameter
Thread-Topic: ioatdma: add ioat_raid_enabled module parameter
Thread-Index: AQHOjjoiBtjPT49UUk+OZVCSt3LB2pl/z3CAgAE92oCAAAEvgIAA7+UAgAAn/gCAAH1CgP//kKSAgACOpoCAD6RRgP//i6KA
Date: Mon, 12 Aug 2013 18:13:35 +0000
Message-ID: <CE2E73C0.1F076%djbw@fb.com>
In-Reply-To: <20130812181002.GF6385@jonmason-lab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.6.130613
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <ECC861A6E94BEF498BA30A69367E8CB4@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-12_05:2013-08-12,2013-08-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/12/13 11:10 AM, "Jon Mason" <jon.mason@intel.com> wrote:

>On Fri, Aug 02, 2013 at 09:18:03PM +0200, Brice Goglin wrote:
>> Le 02/08/2013 19:47, Dan Williams a écrit :
>> > Yup, but should also fold in the deletions of the other is_xeon_cb32()
>> > alignment fixups further below.
>> >
>> > Actually all the alignment settings can be removed now.
>> >
>> > ...and the PQ_VAL/XOR_VAL fixup for is_xeon_cb32() can go.
>> 
>> Ok, here's another one, but we're close to the limit of my understanding
>> of this driver's internals.
>> 
>> Removed all alignment fixups and all is_xeon_cb32() fixups.
>> 
>> Brice
>
>Dan/Vinod, I would really like for this to get into 3.12.  It
>dovetails very nicely with my patch to use DMA engines in NTB, which I
>am aiming for 3.12 as well (though still waiting for some review,
>hint-hint).  Is this doable?

Yes, look for an update in my tree by this weekend.

--
Dan

