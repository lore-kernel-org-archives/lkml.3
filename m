Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaLRRAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:00:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48011 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaLRRAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:00:41 -0500
Message-ID: <54930835.8020009@codeaurora.org>
Date: Thu, 18 Dec 2014 09:00:37 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Gregory Fong <gregory.0xf0@gmail.com>, linux-mm@kvack.org
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] mm: cma: add functions for getting allocation info
References: <1418854236-25140-1-git-send-email-gregory.0xf0@gmail.com>
In-Reply-To: <1418854236-25140-1-git-send-email-gregory.0xf0@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 2:10 PM, Gregory Fong wrote:
> These functions allow for retrieval of information on what is allocated from
> within a given CMA region.  It can be useful to know the number of distinct
> contiguous allocations and where in the region those allocations are located.
>
> Based on an initial version by Marc Carino <marc.ceeeee@gmail.com> in a driver
> that used the CMA bitmap directly; this instead moves the logic into the core
> CMA API.
>
> Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
> ---
> This has been really useful for us to determine allocation information for a
> CMA region.  We have had a separate driver that might not be appropriate for
> upstream, but allowed using a user program to run CMA unit tests to verify that
> allocations end up where they we would expect.  This addition would allow for
> that without needing to expose the CMA bitmap.  Wanted to put this out there to
> see if anyone else would be interested, comments and suggestions welcome.
>

Information is definitely useful but I'm not sure how it's intended to
be used. Do you have a sample usage of these APIs? Another option might
be to just add regular debugfs support for each of the regions instead
of just calling out to a separate driver.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
