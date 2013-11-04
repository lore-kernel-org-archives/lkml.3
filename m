Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3KDIN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:13:26 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:36787 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3KDINY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:13:24 -0500
MIME-Version: 1.0
In-Reply-To: <1383223953-28803-2-git-send-email-zwu.kernel@gmail.com>
References: <1383223953-28803-1-git-send-email-zwu.kernel@gmail.com>
	<1383223953-28803-2-git-send-email-zwu.kernel@gmail.com>
Date: Mon, 4 Nov 2013 16:13:23 +0800
Message-ID: <CAEH94LjN4ZEFg_UFASpTs4TH+6c_KyMddgoF5Ymk5_1d1EVD3A@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: fix the comment in zlc_setup()
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCed Andrew Morton

On Thu, Oct 31, 2013 at 8:52 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dd886fa..3d94d0c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1711,7 +1711,7 @@ bool zone_watermark_ok_safe(struct zone *z, int order, unsigned long mark,
>   * comments in mmzone.h.  Reduces cache footprint of zonelist scans
>   * that have to skip over a lot of full or unallowed zones.
>   *
> - * If the zonelist cache is present in the passed in zonelist, then
> + * If the zonelist cache is present in the passed zonelist, then
>   * returns a pointer to the allowed node mask (either the current
>   * tasks mems_allowed, or node_states[N_MEMORY].)
>   *
> --
> 1.7.11.7
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



-- 
Regards,

Zhi Yong Wu
