Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3GBCVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 22:21:12 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:59927 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3GBCVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 22:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <CANEJEGunjLOTzyPybRrL7VwkuwDQGJGtwyyg4qogT0A+B2hvjA@mail.gmail.com>
References: <CANEJEGunjLOTzyPybRrL7VwkuwDQGJGtwyyg4qogT0A+B2hvjA@mail.gmail.com>
Date: Mon, 1 Jul 2013 19:21:09 -0700
X-Google-Sender-Auth: yA9kVLzqGm1yjdsz0pE7cLGH4Ls
Message-ID: <CANEJEGs5agaLbap-3ae+Qh6MEmGd5Nw9Nvm7WvPjjZfDrZP2zA@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] iommu/exynos: add missing cache flush for
 removed pagetable entries
From: Grant Grundler <grundler@chromium.org>
To: Grant Grundler <grundler@chromium.org>
Cc: Joerg Roedel <joro@8bytes.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-linux-arm (wrong email address - sorry)

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
