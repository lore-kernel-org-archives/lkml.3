Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3HBRrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:47:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39569 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358Ab3HBRri convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:47:38 -0400
From: Dan Williams <djbw@fb.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "Mason, Jon" <jon.mason@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioatdma: add ioat_raid_enabled module parameter
Thread-Topic: ioatdma: add ioat_raid_enabled module parameter
Thread-Index: AQHOjjoiBtjPT49UUk+OZVCSt3LB2pl/z3CAgAE92oCAAAEvgIAA7+UAgAAn/gCAAH1CgP//kKSA
Date: Fri, 2 Aug 2013 17:47:29 +0000
Message-ID: <CE213A73.1D265%djbw@fb.com>
In-Reply-To: <51FBEBAB.9080300@inria.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.5.130515
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="windows-1254"
Content-ID: <14E6E6A5B7C71E44A96A2E27D8DDF348@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-02_06:2013-08-02,2013-08-02,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/2/13 10:26 AM, "Brice Goglin" <Brice.Goglin@inria.fr> wrote:

>Le 02/08/2013 18:57, Dan Williams a écrit :
>> I like Jon¹s suggestion.  Just make raid disabled by default on non-atom
>> platforms.  When if a non-atom platform comes along without the previous
>> restrictions it can add itself to this list.
>>
>> So let¹s drop the module parameter and just cleanup the 3.2 support to
>> reflect the current reality of raid being disabled.
>
>So you want this instead ?

Yup, but should also fold in the deletions of the other is_xeon_cb32()
alignment fixups further below.

Actually all the alignment settings can be removed now.

...and the PQ_VAL/XOR_VAL fixup for is_xeon_cb32() can go.


