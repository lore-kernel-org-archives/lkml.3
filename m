Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3KFMLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:11:53 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:49315 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab3KFMLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:11:52 -0500
Date: Wed, 6 Nov 2013 12:11:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 01/13] dma: ste_dma40: Expand DT binding to accept
 'high-priority channel' flag
Message-ID: <20131106121146.GI30901@lee--X1>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
 <1383732985-18928-2-git-send-email-lee.jones@linaro.org>
 <CACRpkdaVPy8yuhYKohL7ewnmT5y7QrQ7ig2qf4t49YZ-+noDvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaVPy8yuhYKohL7ewnmT5y7QrQ7ig2qf4t49YZ-+noDvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Nov 2013, Linus Walleij wrote:

> On Wed, Nov 6, 2013 at 11:16 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > --- a/Documentation/devicetree/bindings/dma/ste-dma40.txt
> > +++ b/Documentation/devicetree/bindings/dma/ste-dma40.txt
> > @@ -50,6 +50,9 @@ Each dmas request consists of 4 cells:
> >          0x00000008: Use fixed channel:
> >                  Use automatic channel selection when unset
> >                  Use DMA request line number when set
> > +        0x00000010: Set channel as high priority:
> > +                Normal priority when unset
> > +                High priority when set
> 
> We should probably switch these magic numbers to #defines
> but it's another subject so
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Happy to do that in a subsequent set.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
