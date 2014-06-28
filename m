Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaF1CDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 22:03:47 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:43407 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaF1CDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 22:03:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140624085418.GB2782@8bytes.org>
References: <20140624085418.GB2782@8bytes.org>
Date: Fri, 27 Jun 2014 19:03:45 -0700
Message-ID: <CAADWXX_TzcJQ3K07MsK1Ua6QqmTwDiqUM7aZYnZXWj9t9A_OmQ@mail.gmail.com>
Subject: Re: [git pull] IOMMU Fixes for Linux v3.16-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: lkml <linux-kernel@vger.kernel.org>, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,
 this email was in my spam-box. No real indication as to why, although
the usual suspect is

   Received-SPF: none (google.com: joro@8bytes.org does not designate
permitted sender hosts) client-ip=85.214.48.195;

presumably together with some other trigger that makes gmail unhappy.

Anyway, pulled,

              Linus

On Tue, Jun 24, 2014 at 1:54 AM, Joerg Roedel <joro@8bytes.org> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.16-rc1
>
> IOMMU Fixes for Linux v3.16-rc1
>
>         * Fix VT-d regression with handling multiple RMRR entries per
>           device
>         * Fix a small race that was left in the mmu_notifier handling in
>           the AMD IOMMUv2 driver
