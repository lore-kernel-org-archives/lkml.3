Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbaE1QS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:18:59 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:61615 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaE1QS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:18:57 -0400
MIME-Version: 1.0
In-Reply-To: <1400792413-21618-2-git-send-email-sboyd@codeaurora.org>
References: <1400792413-21618-1-git-send-email-sboyd@codeaurora.org>
	<1400792413-21618-2-git-send-email-sboyd@codeaurora.org>
Date: Wed, 28 May 2014 11:18:56 -0500
Message-ID: <CAL_JsqK1wkXMkJCag5g72enGcss2Cr1fYjEo--KkgQBDGuqyEQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] devicetree: bindings: Document micrel vendor prefix
From: Rob Herring <robherring2@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 4:00 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> There's one existing use of 'micrel' in the documentation so use
> 'micrel' instead of the company's ticker symbol 'mcrl'.
>
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Applied for 3.16.

Rob

> ---
>
> This is mostly here as the first patch to make checkpatch quiet. I expect DT
> maintainers to pick this one up.
>
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 1bc2174e1a05..2fe06ad1d248 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -76,6 +76,7 @@ linux Linux-specific binding
>  lsi    LSI Corp. (LSI Logic)
>  marvell        Marvell Technology Group Ltd.
>  maxim  Maxim Integrated Products
> +micrel Micrel Inc.
>  microchip      Microchip Technology Inc.
>  mosaixtech     Mosaix Technologies, Inc.
>  moxa   Moxa
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
