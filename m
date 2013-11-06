Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab3KFLkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:40:20 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:40971 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab3KFLkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:40:17 -0500
MIME-Version: 1.0
In-Reply-To: <1383732985-18928-2-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
	<1383732985-18928-2-git-send-email-lee.jones@linaro.org>
Date: Wed, 6 Nov 2013 12:40:17 +0100
Message-ID: <CACRpkdaVPy8yuhYKohL7ewnmT5y7QrQ7ig2qf4t49YZ-+noDvQ@mail.gmail.com>
Subject: Re: [PATCH 01/13] dma: ste_dma40: Expand DT binding to accept
 'high-priority channel' flag
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 11:16 AM, Lee Jones <lee.jones@linaro.org> wrote:

> --- a/Documentation/devicetree/bindings/dma/ste-dma40.txt
> +++ b/Documentation/devicetree/bindings/dma/ste-dma40.txt
> @@ -50,6 +50,9 @@ Each dmas request consists of 4 cells:
>          0x00000008: Use fixed channel:
>                  Use automatic channel selection when unset
>                  Use DMA request line number when set
> +        0x00000010: Set channel as high priority:
> +                Normal priority when unset
> +                High priority when set

We should probably switch these magic numbers to #defines
but it's another subject so
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
