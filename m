Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3HRNdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 09:33:10 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65495 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab3HRNdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 09:33:07 -0400
MIME-Version: 1.0
X-Originating-IP: [176.92.241.197]
In-Reply-To: <20130816202151.b47fae1e9ed249d06baa37d1@samsung.com>
References: <1374766502-14823-1-git-send-email-a.motakis@virtualopensystems.com>
	<1374766502-14823-2-git-send-email-a.motakis@virtualopensystems.com>
	<003101ce89ed$52317330$f6945990$@samsung.com>
	<20130814131547.GA5889@8bytes.org>
	<20130816202151.b47fae1e9ed249d06baa37d1@samsung.com>
Date: Sun, 18 Aug 2013 15:33:07 +0200
Message-ID: <CAG8rG2zf8CUu+1qRURRhvX8RsNx8CLXJU85qnsFjCvm0FYYuRg@mail.gmail.com>
Subject: Re: [PATCH 2/2] iommu/exynos: Follow kernel coding style for
 __sysmmu_enable return type
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, of course, I have no objections.

On Fri, Aug 16, 2013 at 1:21 PM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> On Wed, 14 Aug 2013 15:15:49 +0200, 'Joerg Roedel' wrote:
>> KyongHo,
>>
>> On Fri, Jul 26, 2013 at 07:46:01PM +0900, Cho KyongHo wrote:
>> > __sysmmu_enable() must return 1 if it is called with the same page table.
>> > I have fixed it exynos_iommu_attach_device() to always return zero on success
>> > in the next patchset which I will post today.
>> >
>> > Thank you.
>>
>> When you are fine with these patches please put them on-top of your
>> patch-set when you re-submit. I will take them from there then.
>>
>
> Ok.
>
> Antonios,
>
> Would you mind
> if I submit your 2 patches on top of my patches with your signed-off?
>
> KyongHo.
>
>>
>>       Joerg
>>
>>
