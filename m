Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3GXI6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:58:02 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:39412 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3GXI56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:57:58 -0400
X-AuditID: cbfec37b-b7f306d0000047de-05-51ef9714d3aa
From: Daniel Phillips <d.phillips@partner.samsung.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, stable <stable@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
Thread-topic: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
Thread-index: Ac6FrfBMfsbqYywbRzi3Al0U5EyIiw==
Date: Wed, 24 Jul 2013 08:57:55 +0000
Message-id: <1EC23D2B9975384993D85B5DB93AAE8861B641@sisaex01sj>
References: <1373944014.17876.255.camel@gandalf.local.home>
 <51E4BFA9.1030600@zytor.com>
 <alpine.DEB.2.02.1307161230080.4618@kaball.uk.xensource.com>
 <1373991399.6458.6.camel@gandalf.local.home>
 <alpine.DEB.2.02.1307161731210.8258@kaball.uk.xensource.com>
 <51E59F79.1040903@zytor.com>
 <alpine.DEB.2.02.1307171005570.8258@kaball.uk.xensource.com>
 <CAMP44s3DrAMgE3fphw9A8N8NzBz5wwENa4AY4yw-VkuPdqv4=w@mail.gmail.com>
 <20130717144043.GA16513@xanatos>
 <CAMP44s1EGqth8gs+0Fs6-n+OjUjcj9-Gce=aDZ61=9aUr06zvg@mail.gmail.com>
 <20130719120841.GH26716@gmail.com>
 <CAMP44s21fZtw+0LghxpcpQeE5ptcisKRjPv6VUQeE4NbBWa4-w@mail.gmail.com>
 <CAMuHMdUWsppKBNrFSB981MXTeGpb4yPtiL2QW7HiUjUaMej0=g@mail.gmail.com>
 <CAMP44s2J2zESnYYwEtN-Q2_4ft_M8UpdLxZavtK5q2fZcFa=SQ@mail.gmail.com>
 <1EC23D2B9975384993D85B5DB93AAE8861AA8D@sisaex01sj>
 <CAMP44s1w0dfv7peUU3DnHLujf5rtyK6xfCpcWRJhMTMvFHcjug@mail.gmail.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t9hX12R6e8DDa6sN7DY/nojm8WdwxoW
	Bx/nWTy7tZfJonnxejaLWz/mMllc3jWHzWL1v1OMFgs2PmK0+HnnIqPFo7637BbH589hdODx
	OD19P7PH9iciHjtn3WX32LSqk83j0JW1jB4nZvxm8Th0uIPRY97JQI/9c9ewe/z+MZnR4/Mm
	uQDuKC6blNSczLLUIn27BK6MvYvbWAqOMVec/PaNvYHxOVMXIyeHhICJxPLXu9ggbDGJC/fW
	A9lcHEICyxglPuyawQiSEBLoZZK4PTcXwp7PKLFpuwWIzSZgJrH0+BmwQSIChhJ726eygNjM
	ApNYJF59lQOxhQXsJRa0TmaGqHGQOPjtFguErSfx7d8BdhCbRUBVYsuM1awgNi9Q/a41P5kg
	juhllzh0/B9YMyPQdd9PrWGCWCAu0dx6kwXiagGJJXvOM0PYohIvH/8DGsQBZCtKbF9tBVGu
	JbF+53GoVm2JJ+8uQO0SlPgx+R7LBEaxWUimzkLSMgtJyywkLQsYWVYxipUWJxcUJ6WnVhjp
	FSfmFpfmpesl5+duYoREffUOxrtfbQ4xCnAwKvHwFsx6FyjEmlhWXJl7iFGCg1lJhHdx8/tA
	Id6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwe71aHzYyeVHN7TtDmj5OrfQ8Ge+z84cRa8PjLrIMt
	Qs1vxPSlFqjaaH//6bXEt+t4UIx92VE+lpkJ/0L/rH0TzOs1g0V9x7uPK679abvr89Xr896O
	bQ03Chouuq4I4Aias6IzRNMt8XTybH+hNeveHvrRMF80wtJhd4rhGxYfv0un3NX0/4QqsRRn
	JBpqMRcVJwIAJN6Pl9gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 12:51 AM, Felipe Contreras wrote:
> Your mistaken fallacy seems to be that you think one can *always* be
> both A (open and honest), and B (polite)...

You are are right, I do think that you can *always* be both open and 
honest, and polite. I do not believe that I am mistaken. And I hope that 
you will come to agree with me in the not too distant future.

Regards,

Daniel

