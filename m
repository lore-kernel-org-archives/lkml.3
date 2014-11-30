Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaK3JBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 04:01:12 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:32976 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaK3JBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 04:01:10 -0500
Date: Sun, 30 Nov 2014 01:01:06 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Zhou Wang <wangzhou.bry@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        galak@codeaurora.org, caizhiyong@huawei.com, haojian.zhuang@gmail.com,
        xuwei5@hisilicon.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] mtd: hisilicon: add device tree binding
 documentation
Message-ID: <20141130090106.GF3608@norris-Latitude-E6410>
References: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com>
 <1415105221-7732-3-git-send-email-wangzhou.bry@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415105221-7732-3-git-send-email-wangzhou.bry@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more thing:

On Tue, Nov 04, 2014 at 08:47:01PM +0800, Zhou Wang wrote:
> diff --git a/Documentation/devicetree/bindings/mtd/hisi504-nand.txt b/Documentation/devicetree/bindings/mtd/hisi504-nand.txt
> new file mode 100644
> index 0000000..c8b3988
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/hisi504-nand.txt
> @@ -0,0 +1,40 @@
> +Hisilicon Hip04 Soc NAND controller DT binding
> +
> +Required properties:
> +- compatible:          Should be "hisilicon,504-nfc".

I notice you use "NFC" naming throughout. I know others have had
complaints about overloading the acronym NFC which sometimes means "Near
Field Communication", instead of the intended "NAND Flash Controller."
Is there any kind of naming convention within Hisilicon documentation
that insists on calling this NFC, or can we avoid that confusing name?

If possible, I'd suggest "hisilicon,504-nand" as an alternative.

Brian
