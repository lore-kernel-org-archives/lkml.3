Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbbALNHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:07:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43637 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbALNHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:07:41 -0500
Message-ID: <54B3C70C.4070009@arm.com>
Date: Mon, 12 Jan 2015 13:07:24 +0000
From: Robin Murphy <robin.murphy@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Will Deacon <Will.Deacon@arm.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RESEND] dma-mapping: tidy up dma_parms default handling
References: <ffdc5455d698d2525f2d126d0adabf9418fd76b1.1418990609.git.robin.murphy@arm.com> <2031542.TLqIP3YVGc@wuerfel>
In-Reply-To: <2031542.TLqIP3YVGc@wuerfel>
X-OriginalArrivalTime: 12 Jan 2015 13:07:36.0892 (UTC) FILETIME=[BC9237C0:01D02E68]
X-MC-Unique: 115011213073903701
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/15 19:45, Arnd Bergmann wrote:
> On Friday 09 January 2015 16:56:03 Robin Murphy wrote:
>>
>> This one's a bit tricky to find a home for - I think technically it's
>> probably an IOMMU patch, but then the long-underlying problem doesn't
>> seem to have blown up anything until arm64, and my motivation is to
>> make bits of Juno work, which seems to nudge it towards arm64/arm-soc
>> territory. Could anyone suggest which tree is most appropriate?
>
> I have a set of patches touching various dma-mapping.h related bits
> across architectures and in ARM in particular. Your patch fits into
> that series, and I guess we could either have it in my asm-generic
> tree or in Andrew Morton's mm tree. Possibly also arm-soc for practical
> reasons, although it really doesn't belong in there.
>

Thanks Arnd, I'd agree asm-generic or mm sound the most sensible - If 
you're happy to carry this patch with your series that'd be really helpful.

Robin.


