Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab3GVV33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:29:29 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:15939 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab3GVV3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:29:24 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-e0-51eda432a9b4
From: Daniel Phillips <d.phillips@partner.samsung.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, CAI Qian <caiqian@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>,
        stable <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] Maybe it's time to shut this thread down
 (Was: Re: [ 00/19] 3.10.1-stable review)
Thread-topic: [Ksummit-2013-discuss] Maybe it's time to shut this thread down
 (Was: Re: [ 00/19] 3.10.1-stable review)
Thread-index: Ac6FkRCisDb5r2eeQr+ZSZ5Wfl77ZQ==
Date: Mon, 22 Jul 2013 21:29:21 +0000
Message-id: <1EC23D2B9975384993D85B5DB93AAE8861B407@sisaex01sj>
References: <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <alpine.DEB.2.02.1307172336410.4089@ionos.tec.linutronix.de>
 <1368728064.2419741.1374117402465.JavaMail.root@redhat.com>
 <1374119254.6458.220.camel@gandalf.local.home>
 <305037674.2433057.1374120078349.JavaMail.root@redhat.com>
 <20130718132327.GB30405@thunk.org> <20130718133008.GC30405@thunk.org>
 <20130718155428.GB5440@xanatos>
 <1EC23D2B9975384993D85B5DB93AAE8861AA4D@sisaex01sj>
 <3908561D78D1C84285E8C5FCA982C28F31C98E12@ORSMSX106.amr.corp.intel.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9hX12jJW8DDboXmlp07jrKanHnsIZF
	8+L1bBazJ8xjtbi8aw6bxep/pxgtmk+cYrZYsPERo8XmTVOZLd5cuMdi8ajvLbsDt8fiPS+Z
	PDat6mTzeHfuHLvHiRm/WTzmnQz02D93DbvH5BvLGT3e77vK5vF5k1wAZxSXTUpqTmZZapG+
	XQJXxo4tfSwFs9kr5jQdYm1gfMraxcjJISFgIvF45n42CFtM4sK99UA2F4eQwDJGiZVXjoEV
	CQn0Mkl8vpAOkZjPKHHi/GF2kASbgJnE0uNnmEBsEQE1iUuLHzCDFDELvGSWOLfvFTNIQlig
	XGLKvS5GiKIKiRXXfrNB2HoSDx9tBdvAIqAqcXHadDCbV8Be4vy+81BnbGGV+HhkEgtIghHo
	vu+n1oBtYxYQl2huvckCcbeAxJI955khbFGJl4//AQ3iALIVJbavtoIo15JYv/M4VKu2xJN3
	F6B2CUr8mHyPZQKj2CwkU2chaZmFpGUWkpYFjCyrGMVKi5MLipPSUyuM9YoTc4tL89L1kvNz
	NzFC4rtmB+O9rzaHGAU4GJV4eBf4vg0UYk0sK67MPcQowcGsJMK7UQ8oxJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgVEpXtWtTPMB94qbnF8Dkx0FUk2X3H0cvN6SUdRm2zSBnmWOGn8vWWptec2y
	9vGiz55e80y+/7T/HTB1e8eHFdPe3eqYKGzX/Tnv86GrsxlDZY+6qXs0lzsdT3iQlK3098NZ
	ta5EhdlOcx8u3/p13hSN/czPQxsXyib6v1cU/6AeuWSFzFfu29+VWIozEg21mIuKEwEjJRLU
	zQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 09:02 PM, Luck, Tony wrote:
> Some thoughts on the format of the discussion at KS:
>
> ...
>

5) Volunteers are under-represented at Kernel Summit

Volunteers are the "dark matter" of Linux Kernel contribution. They are 
not the "usual suspects" who nearly all have full time jobs now, 
allowing them the time investment to raise their profile sufficiently to 
gain a place at the KS round table. They may not be very vocal. They are 
most probably the first to depart for more pleasant pastures when the 
interaction becomes less than fun. In part because they do not have an 
employer who requires them to stay engaged no matter what.

How do we represent the viewpoint of volunteers? Which for many of us is 
a former life, the memory of which may be starting to fade.

Regards,

Daniel
