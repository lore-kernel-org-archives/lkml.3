Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaE1Q2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:28:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41974 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbaE1Q2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:28:43 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Heesub Shin <heesub.shin@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Dongjun Shin <d.j.shin@samsung.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] staging: ion: system heap and page pool fixes
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
	<1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
Date: Wed, 28 May 2014 09:28:49 -0700
In-Reply-To: <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
	(Heesub Shin's message of "Wed, 28 May 2014 15:52:51 +0900")
Message-ID: <vnkw8uplkgu6.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27 2014 at 11:52:51 PM, Heesub Shin <heesub.shin@samsung.com> wrote:
> Hi,
>
> Here is my patchset with some modification, hoping reviews or comments
> from you guys.
>
> v2:
>  o No changes in the code, just reworded changelog
>  o Reorder patch 

Some very nice cleanup. And I learned a new trick with page.lru :).

Reviewed-by: Mitchel Humpherys <mitchelh@codeaurora.org>

>
> Heesub Shin (9):
>   staging: ion: tidy up a bit
>   staging: ion: simplify ion_page_pool_total()
>   staging: ion: remove struct ion_page_pool_item
>   staging: ion: use compound pages on high order pages for system heap
>   staging: ion: remove order from struct page_info
>   staging: ion: remove struct page_info
>   staging: ion: remove order argument from free_buffer_page()
>   staging: ion: shrink highmem pages on kswapd
>   staging: ion: optimize struct ion_system_heap
>
>  drivers/staging/android/ion/ion_page_pool.c   |  49 ++++-------
>  drivers/staging/android/ion/ion_priv.h        |   2 +-
>  drivers/staging/android/ion/ion_system_heap.c | 121 ++++++++++----------------
>  3 files changed, 67 insertions(+), 105 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
