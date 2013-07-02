Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3GBBt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 21:49:56 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:42040 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab3GBBtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 21:49:36 -0400
MIME-Version: 1.0
Date: Mon, 1 Jul 2013 18:49:34 -0700
X-Google-Sender-Auth: IPFrzuw_D0ee18x7DT37zCx9wL4
Message-ID: <CANEJEGunjLOTzyPybRrL7VwkuwDQGJGtwyyg4qogT0A+B2hvjA@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] iommu/exynos: add missing cache flush for
 removed pagetable entries
From: Grant Grundler <grundler@chromium.org>
To: linux-arm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 25, 2012 6:00:01 PM UTC-8, Cho KyongHo wrote:
> This commit adds cache flush for removed small page and large page
> entries in exynos_iommu_unmap(). Missing cache flush of removed
> page table entries can cause missing page fault interrupt when a
> master IP accesses an unmapped area.

KyongHo,
It appears this patch was never applied and got caught up in the
device tree binding discussion. AFAICT, this patch is still necessary.
Can you resubmit this patch separately. Or ok if I do?

Original patch is here:
    https://patchwork.kernel.org/patch/1910261/

thanks,
grant
