Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbaELNPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:15:10 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:42754 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaELNPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:15:07 -0400
MIME-Version: 1.0
In-Reply-To: <1399839324-21773-1-git-send-email-emilio@elopez.com.ar>
References: <1399839324-21773-1-git-send-email-emilio@elopez.com.ar>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 12 May 2014 07:14:46 -0600
Message-ID: <CAErSpo6uU4E-WLXBPp79q8fsu-YMytAaVGyEBOD7-1iZcJDgwQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation/DMA-API-HOWTO.txt: fix duplicated word
To: =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 2:15 PM, Emilio López <emilio@elopez.com.ar> wrote:
> "coherent" is written twice when it should be just once
>
> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> ---
>
> The sentence still doesn't sound entirely correct in my head, maybe
> someone can propose a better rewording.

I added this patch to my series.  I agree the wording is awkward, but
I don't have a better proposal right now.

>  Documentation/DMA-API-HOWTO.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
> index 5e98303..4ede25a 100644
> --- a/Documentation/DMA-API-HOWTO.txt
> +++ b/Documentation/DMA-API-HOWTO.txt
> @@ -192,7 +192,7 @@ the case would look like this:
>                 goto ignore_this_device;
>         }
>
> -The coherent coherent mask will always be able to set the same or a
> +The coherent mask will always be able to set the same or a
>  smaller mask as the streaming mask. However for the rare case that a
>  device driver only uses consistent allocations, one would have to
>  check the return value from dma_set_coherent_mask().
> --
> 1.9.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
