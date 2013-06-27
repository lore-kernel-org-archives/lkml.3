Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3F0UU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:20:56 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:48359 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3F0UUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:20:55 -0400
MIME-Version: 1.0
In-Reply-To: <2026698.ciHxSBJcBE@amdc1032>
References: <2026698.ciHxSBJcBE@amdc1032>
Date: Thu, 27 Jun 2013 13:20:53 -0700
X-Google-Sender-Auth: tqQ3zscn2VVh-cIhd_zciDv0Hj4
Message-ID: <CAA9_cmf0WE=hFm8B_hk1GY87fk-R-Zv+iGXuBnqpiMA+bJ2oMg@mail.gmail.com>
Subject: Re: [resend2 PATCH] DMA: remove unused support for MEMSET operations
From: Dan Williams <djbw@fb.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 6:31 AM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> There have never been any real users of MEMSET operations
> since they have been introduced in January 2007 (commit
> 7405f74badf46b5d023c5d2b670b4471525f6c91 "dmaengine: refactor
> dmaengine around dma_async_tx_descriptor").  Therefore remove
> support for them for now, it can be always brought back when
> needed.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

I see Andrew has already picked this up.

Acked-by: Dan Williams <djbw@fb.com>
