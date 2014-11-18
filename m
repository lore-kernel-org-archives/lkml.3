Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaKRSFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:05:07 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39235 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaKRSFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:05:05 -0500
MIME-Version: 1.0
In-Reply-To: <1413971343-27554-3-git-send-email-geert+renesas@glider.be>
References: <1413971343-27554-1-git-send-email-geert+renesas@glider.be> <1413971343-27554-3-git-send-email-geert+renesas@glider.be>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 18 Nov 2014 12:04:43 -0600
Message-ID: <CAL_Jsq+XgTRp7S-ymtx92NeX_h=OFL1jY15puaTp2C1oPWn8ag@mail.gmail.com>
Subject: Re: [PATCH/TRIVIAL 3/5] of: Spelling s/stucture/structure/
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 4:49 AM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>

Applied, thanks.

Rob

> ---
>  drivers/of/dynamic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
> index f297891d852908ae..d4994177dec25506 100644
> --- a/drivers/of/dynamic.c
> +++ b/drivers/of/dynamic.c
> @@ -247,7 +247,7 @@ void of_node_release(struct kobject *kobj)
>   * @allocflags:        Allocation flags (typically pass GFP_KERNEL)
>   *
>   * Copy a property by dynamically allocating the memory of both the
> - * property stucture and the property name & contents. The property's
> + * property structure and the property name & contents. The property's
>   * flags have the OF_DYNAMIC bit set so that we can differentiate between
>   * dynamically allocated properties and not.
>   * Returns the newly allocated property or NULL on out of memory error.
> --
> 1.9.1
>
