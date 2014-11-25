Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaKYNLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:11:23 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29501 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaKYNLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:11:21 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-c5-54747ff5cfe4
Message-id: <54747FF2.4050207@samsung.com>
Date: Tue, 25 Nov 2014 16:11:14 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Dmitry Chernenkov <dmitryc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v7 07/12] mm: slub: introduce
 metadata_access_enable()/metadata_access_disable()
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-8-git-send-email-a.ryabinin@samsung.com>
 <CAA6XgkFPvHQE7LpZ=Q19e8sGAwOtWiVBXzjZA+7HXmNWL_genA@mail.gmail.com>
In-reply-to: <CAA6XgkFPvHQE7LpZ=Q19e8sGAwOtWiVBXzjZA+7HXmNWL_genA@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t/xK7pf60tCDCY+krX4vXcmq8Wc9WvY
	LI5c+85ucf3bG0aLTy8fMFpsud7EZPH84UN2iwkP29gtpm0Ut1jZ3cxmsf3ZWyaLlZ0PWC0u
	75rDZnFvzX9Wi7bP/4DEko1MFouP3Ga2ePdsMrPF1VUH2S1+bHjM6iDiMX/nR0aPnbPusnss
	2FTqsXjPSyaPTas62Tw2fZrE7tH19gqTx4kZv1k8nlyZzuTx8ektFo/3+66yeXzeJOdxouUL
	awBvFJdNSmpOZllqkb5dAldGx/FbrAUnGCv6jl1gamCcydjFyMkhIWAi0dk+hRXCFpO4cG89
	WxcjF4eQwFJGic6lR5hAEkICzUwSsyfIgti8AloS1x4uZgexWQRUJd4f+cMCYrMJ6En8m7Wd
	DcQWFYiQuLJmDiNEvaDEj8n3wGpEgHrPf3jACrKAWeAOq8SpXzPBNgsLpEksvN7LCLG5hUli
	8cXVYN2cAsESvccvM3cxcgB1qEtMmZILEmYWkJfYvOYt8wRGgVlIdsxCqJqFpGoBI/MqRtHU
	0uSC4qT0XEO94sTc4tK8dL3k/NxNjJCY/bKDcfExq0OMAhyMSjy8BoklIUKsiWXFlbmHGCU4
	mJVEeHOrgUK8KYmVValF+fFFpTmpxYcYmTg4pRoYg//73JlwfcP2PfPmi10PSN2uwGYaULjH
	+8AX7hWpUx4px1fPsLnUtVdtTrLB0UzWlQ0nHdon5clmCBzNYA69s+niH91V/T6RZ3i0/qht
	CuMKvNwglTGT67mcufbCVpMfHHo/zvL4dwrLlfV9nzdb4OY01h2pvm9dph7veNo7JyXxv9XB
	G7tLlFiKMxINtZiLihMBUL1hb7cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 03:22 PM, Dmitry Chernenkov wrote:
> LGTM
> 
> Does this mean we're going to sanitize the slub code itself?)
> 

Nope, to sanitize slub itself we need much more than just this.

