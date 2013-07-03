Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab3GCUn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:43:56 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33644 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3GCUnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:43:55 -0400
MIME-Version: 1.0
In-Reply-To: <CANEJEGunjLOTzyPybRrL7VwkuwDQGJGtwyyg4qogT0A+B2hvjA@mail.gmail.com>
References: <CANEJEGunjLOTzyPybRrL7VwkuwDQGJGtwyyg4qogT0A+B2hvjA@mail.gmail.com>
Date: Wed, 3 Jul 2013 13:43:53 -0700
X-Google-Sender-Auth: vQx5yP2LWsPPxUKYr8lZq6Y-3C4
Message-ID: <CANEJEGvAYxdyq7iK6Y+YcgCFOKhA4+01=m4ofUs3ZE=Mwf7PRw@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] iommu/exynos: add missing cache flush for
 removed pagetable entries
From: Grant Grundler <grundler@chromium.org>
To: Joerg Roedel <joro@8bytes.org>, KyongHo Cho <pullip.cho@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Mon, Jul 1, 2013 at 6:49 PM, Grant Grundler <grundler@chromium.org> wrote:
> On Tuesday, December 25, 2012 6:00:01 PM UTC-8, Cho KyongHo wrote:
>> This commit adds cache flush for removed small page and large page
>> entries in exynos_iommu_unmap(). Missing cache flush of removed
>> page table entries can cause missing page fault interrupt when a
>> master IP accesses an unmapped area.
>
> KyongHo,
> It appears this patch was never applied and got caught up in the
> device tree binding discussion. AFAICT, this patch is still necessary.
> Can you resubmit this patch separately. Or ok if I do?
>
> Original patch is here:
>     https://patchwork.kernel.org/patch/1910261/
>
> thanks,
> grant
