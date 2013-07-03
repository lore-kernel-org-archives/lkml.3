Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab3GCH6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 03:58:45 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58756 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3GCH6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 03:58:44 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-08-51d3d9b12ff7
Message-id: <51D3D9AD.9070800@samsung.com>
Date: Wed, 03 Jul 2013 09:58:37 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620
 Thunderbird/17.0.7
MIME-version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] DMA-mapping updates for v3.11
References: <1372754108-21075-1-git-send-email-m.szyprowski@samsung.com>
 <20130703100903.81ab08c6db864c20498b558d@canb.auug.org.au>
In-reply-to: <20130703100903.81ab08c6db864c20498b558d@canb.auug.org.au>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xK7obb14ONPh3wcji8q45bBZb915l
	t3jU95bdgdmj8cYNNo8TM36zeHzeJBfAHMVlk5Kak1mWWqRvl8CVcWTCesaCXRwVZy4/Y21g
	vMvWxcjJISFgIjG98QAzhC0mceHeeqA4F4eQwFJGie1fzrNCOM1MEn3nfrODVPEKaEk8+H+a
	sYuRg4NFQFVizrVSkDCbgKFE19susKGiAqES05YsYIQoF5T4MfkeC0i5iIC2xIHfAiBhZoEA
	ieav98DKhQVMJU6f28gMsaqVUWLPxh1MIAlOAXeJ9zsPMUI0mEk8alnHDGHLS2xe85Z5AqPA
	LCQrZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkED9uoNx6TGrQ4wCHIxK
	PLyOzy4FCrEmlhVX5h5ilOBgVhLhXbLocqAQb0piZVVqUX58UWlOavEhRiYOTqkGxq79iyfF
	V149dzioJ+TK+r8vKphzVBdGb1ZJUPrB/zvg818/5yVHPyQ1cJ5X1L6x+avU4l9dMwtsL+rP
	l5JorV4w713r5li5D594ji3In/Um103ZfZpFVMXV0vaajJmMSb9/3n9kE12ydX8D1y6v6Ta5
	Szfatiapmfa2XLhdpS/oYcN122DSZiWW4oxEQy3mouJEANPjEvwyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 7/3/2013 2:09 AM, Stephen Rothwell wrote:
> Hi Marek,
>
> On Tue, 02 Jul 2013 10:35:08 +0200 Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> >
> > I would like to ask You for pulling some fixes for ARM dma-mapping subsystem
> > for v3.11.
> >
> >
> > The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:
> >
> >   Linux 3.10 (2013-06-30 15:13:29 -0700)
> >
> > are available in the git repository at:
> >
> >   git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.11
> >
> > for you to fetch changes up to 1e3d09b223f349a5f6cc14d62b4df66c0798d762:
> >
> >   ARM: dma: Drop __GFP_COMP for iommu dma memory allocations (2013-07-02 10:30:59 +0200)
>
> This was rebased yesterday onto v3.10 for some reason (one commit was
> dropped in the rebase).

Right, I dropped one commit, which I found in other 'for_next' kernel 
tree (the
one from Russell King) before sending the pull request. What's wrong 
with this
approach?

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


