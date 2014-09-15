Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbaIOXNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:13:11 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:64845 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309AbaIOXNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:13:07 -0400
Date: Mon, 15 Sep 2014 16:13:03 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Sean Cross <xobs@kosagi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, bunnie@kosagi.com
Subject: Re: [PATCH v2 2/2] mfd: stmpe: Document DT binding for irq_over_gpio
Message-ID: <20140915231303.GM25162@lee--X1>
References: <1410491914-23378-1-git-send-email-xobs@kosagi.com>
 <1410491914-23378-3-git-send-email-xobs@kosagi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410491914-23378-3-git-send-email-xobs@kosagi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Sean Cross wrote:

> STMPE now supports using a GPIO as an IRQ source.  Document the device
> tree binding for this option.
> 
> Signed-off-by: Sean Cross <xobs@kosagi.com>
> ---
>  Documentation/devicetree/bindings/mfd/stmpe.txt | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

> diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
> index 56edb55..3fb68bf 100644
> --- a/Documentation/devicetree/bindings/mfd/stmpe.txt
> +++ b/Documentation/devicetree/bindings/mfd/stmpe.txt
> @@ -13,6 +13,7 @@ Optional properties:
>   - interrupt-parent             : Specifies which IRQ controller we're connected to
>   - wakeup-source                : Marks the input device as wakable
>   - st,autosleep-timeout         : Valid entries (ms); 4, 16, 32, 64, 128, 256, 512 and 1024
> + - irq-gpio                     : If present, which GPIO to use for event IRQ
>  
>  Example:
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
