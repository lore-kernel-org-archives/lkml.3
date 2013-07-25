Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab3GYWv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 18:51:26 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:43216 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab3GYWvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 18:51:24 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-50-51f1abead801
From: Daniel Phillips <d.phillips@partner.samsung.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
Thread-topic: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
Thread-index: Ac6FrfBMfsbqYywbRzi3Al0U5EyIiw==
Date: Thu, 25 Jul 2013 22:51:21 +0000
Message-id: <1EC23D2B9975384993D85B5DB93AAE8861C061@sisaex01sj>
References: <20130717144043.GA16513@xanatos>
 <CAMP44s1EGqth8gs+0Fs6-n+OjUjcj9-Gce=aDZ61=9aUr06zvg@mail.gmail.com>
 <20130719120841.GH26716@gmail.com>
 <CAMP44s21fZtw+0LghxpcpQeE5ptcisKRjPv6VUQeE4NbBWa4-w@mail.gmail.com>
 <CAMuHMdUWsppKBNrFSB981MXTeGpb4yPtiL2QW7HiUjUaMej0=g@mail.gmail.com>
 <CAMP44s2J2zESnYYwEtN-Q2_4ft_M8UpdLxZavtK5q2fZcFa=SQ@mail.gmail.com>
 <1EC23D2B9975384993D85B5DB93AAE8861AA8D@sisaex01sj>
 <CAMP44s1w0dfv7peUU3DnHLujf5rtyK6xfCpcWRJhMTMvFHcjug@mail.gmail.com>
 <1EC23D2B9975384993D85B5DB93AAE8861B641@sisaex01sj>
 <CAMP44s1szaS0BVpGfDS66aeox9j0YT5D3pdsjMhz64LW-uVczw@mail.gmail.com>
 <20130725143327.GF2346@1wt.eu>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t9hX93Xqz8GGiy4xGSx/fVGNos7hzUs
	Dj7Os3h2ay+TRfPi9WwWt37MZbK4vGsOm8Xqf6cYLRZsfMRo8fPORUaLR31v2S2Oz5/D6MDj
	cXr6fmaP7U9EPHbOusvusWlVJ5vHoStrGT1OzPjN4nHocAejx7yTgR77565h9/j9YzKjx+dN
	cgHcUVw2Kak5mWWpRfp2CVwZ23Z3Mhb8Z63Y89SrgfEtSxcjJ4eEgInE5Tcf2CFsMYkL99az
	dTFycQgJLGOUmPXpATuE08sksefOBShnPqPEuYXTwFrYBMwklh4/wwRiiwjISDRNnQ42lllg
	OYvExX/SILawgL3EgtbJzBA1DhIHv91igbD1JL79OwA0h4ODRUBV4uD7AhCTF6j87gELiFUd
	rBIPzh8Ea2UEuu77qTVMEOPFJZpbb0J9ICCxZM95ZghbVOLl43+sIHMkBBQltq+2gijXkli/
	8zhUq7bEk3cXWEFsXgFBiR+T77FMYBSbhWTqLCQts5C0zELSsoCRZRWjWGlxckFxUnpqhaFe
	cWJucWleul5yfu4mRkjMV+1gvPPV5hCjAAejEg+vgtPHQCHWxLLiytxDjBIczEoivLd6gUK8
	KYmVValF+fFFpTmpxYcYmTg4pRoYI6vtHxlxiH+ult7xd+5FSZ2uM58f6J76dzbT4is7i2v5
	/wmHv+o0bN1dyqP18vSKU67FazLsfqzhLLhu3vGP+42k8aQ0nev+J1Q3HV4c82LFDVO1Rt5M
	hxbvwJVPez0nbeRibfwdfcZ2d/G/o2ceP76wUMAy+WWvYvv6CU2+nDUN3b3nWbT1lViKMxIN
	tZiLihMBVTXmZtcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 02:34 PM, Willy Tarreau wrote:
> Guys, could we please stop this endless boring thread ?

Willy, I believe we are on the same side of the civility debate, but I 
somehow got the feeling that you just characterized my comment re "open 
and honest" as "endless and boring".

I agree that the attempt to divert the intent of my comment into a 
farcical debate on debating was not worth the internet bytes it was 
printed on. In fact, that nicely demonstrates one class of technique 
commonly used on lkml to silence criticism, and is worth studying from 
that viewpoint. That sort of diverting should end, particularly in 
regards to the topic at hand.

Regards,

Daniel
