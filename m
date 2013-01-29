Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3A2DfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:35:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49222 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab3A2DfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:35:03 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQUDP9x+6CZKyW8CVq7YWy+zQwSTqm67G-AuX0=LYgqf6A@mail.gmail.com>
References: <1358868049-19884-1-git-send-email-trenn@suse.de> <CAE9FiQWJqWQJhoJb2dBn=iAsKjxuf3MJro-jz+6k+WNZor8-xQ@mail.gmail.com> <CAE9FiQWXcwagEb0jdFfdHvNcByNxtaLbvvoRC-jAppQmiGS22w@mail.gmail.com> <6950516.1uefDuthAH@hammer82.arch.suse.de> <510721C6.6080705@zytor.com> <CAE9FiQWDcFR+6L-GiR6rk60TC0zH=xewyH_h1Rx_QB+8PTiU3Q@mail.gmail.com> <51072FEF.50000@zytor.com> <CAE9FiQVG4ShGKSdjzYhQaXNNhS=MVNJg=QqG1yW-mAUscErXMA@mail.gmail.com> <4302d59f-5c87-4b82-af16-9f54625fc9ce@email.android.com> <CAE9FiQUDP9x+6CZKyW8CVq7YWy+zQwSTqm67G-AuX0=LYgqf6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump usage
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jan 2013 19:33:52 -0800
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Renninger <trenn@suse.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, horms@verge.net.au
Message-ID: <5ea70988-10fb-4153-9482-75507efe0b07@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess that very limited use might make sense.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Mon, Jan 28, 2013 at 6:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> To be more clear: the max_pfn stuff seems like a relic of the past,
>and I am wondering what it would take to get rid of it.
>>
>> It clearly has the wrong semantics, except perhaps in the most
>trivial allocator models.
>>
>one thing i think could be : use that decide if we need iommu/swiotlb.
>like in
>arch/x86/kernel/amd_gart_64.c
>arch/x86/kernel/pci-swiotlb.c
>drivers/iommu/amd_iommu.c
>...
>
>Yinghai

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
