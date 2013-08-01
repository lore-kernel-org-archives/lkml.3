Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab3HAC1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:27:48 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62175 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3HAC1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:27:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130729052930.GC29095@intel.com>
References: <1371536519-7837-1-git-send-email-wangxfdu@gmail.com>
	<20130705064549.GD10947@intel.com>
	<CACDNBm1jTTWLi3Prk+s_fk_BxNdzra4fG690sSMrKvwWXVW5oQ@mail.gmail.com>
	<20130729052930.GC29095@intel.com>
Date: Thu, 1 Aug 2013 10:27:47 +0800
Message-ID: <CACDNBm03v0KB_2XhUzKmi7c9BpfG1tSOUUNa549ETs=3FbZAvA@mail.gmail.com>
Subject: Re: [PATCH v2] dma: mmp_pdma: fix a memory alloc error
From: Xiang Wang <wangxfdu@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/29 Vinod Koul <vinod.koul@intel.com>:
> On Thu, Jul 25, 2013 at 10:22:50AM +0800, Xiang Wang wrote:
>
> Btw its generally a good idea to remove the parts not required for further
> discussion
>
>> Would you please explain a little more about why we should use
>> GFP_NOWAIT here? This memory is not dedicated for DMA controller. Do
>> we have special reasons to use GFP_NOWAIT? Thanks!
> There are few reasons
> - the dma requests can be triggered from atomic context
> - so for above you can argue to use the GFP_ATOMIC and the guideline for dma
>   drivers [1] was discussed briefly
>
> ~Vinod
> [1]: http://lkml.indiana.edu/hypermail/linux/kernel/0911.1/02316.html
>
> --
Hi, Vinod
Thanks for your explanation. But want to double confirm with you that
the memory alloc in my patch is in probe function, still need to use
GFP_NOWAIT? Thanks!

-- 
Regards,
Xiang
