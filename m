Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaG3Fd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 01:33:26 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:60703 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaG3FdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 01:33:25 -0400
MIME-Version: 1.0
In-Reply-To: <0c84bc47f6fe383b7d2cf2f77ed831be570aba0b.1406691397.git.joe@perches.com>
References: <cover.1406691397.git.joe@perches.com> <0c84bc47f6fe383b7d2cf2f77ed831be570aba0b.1406691397.git.joe@perches.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 30 Jul 2014 11:03:04 +0530
Message-ID: <CAO_48GEHFxGq8kW0BLQTcDLk_t23zmQSbQ+h38WFK_REe2tgQA@mail.gmail.com>
Subject: Re: [PATCH 1/6] MAINTAINERS: Update DMA BUFFER SHARING patterns
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe!

On 30 July 2014 09:08, Joe Perches <joe@perches.com> wrote:
> One pattern per F: line please...
Thanks for catching this;
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
>
> Signed-off-by: Joe Perches <joe@perches.com>
> CC: Sumit Semwal <sumit.semwal@linaro.org>
> ---
>  MAINTAINERS | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5e5478b..66d5894 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2941,7 +2941,9 @@ L:        linux-media@vger.kernel.org
>  L:     dri-devel@lists.freedesktop.org
>  L:     linaro-mm-sig@lists.linaro.org
>  F:     drivers/dma-buf/
> -F:     include/linux/dma-buf* include/linux/reservation.h include/linux/*fence.h
> +F:     include/linux/dma-buf*
> +F:     include/linux/reservation.h
> +F:     include/linux/*fence.h
>  F:     Documentation/dma-buf-sharing.txt
>  T:     git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
>
> --
> 1.8.1.2.459.gbcd45b4.dirty
>


Best regards,
~Sumit.
