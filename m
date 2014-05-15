Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaEOWCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:02:14 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57774 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754125AbaEOWCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:02:12 -0400
X-Sasl-enc: Tcm8fUu7+lmBzWQ6GqxN0Uo+pfnmSzNFDdciQWRvVWo+ 1400191331
Date: Thu, 15 May 2014 15:05:29 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?Cl=E9ment?= Calmels <clement.calmels@free.fr>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: sep: fix coding style issue
Message-ID: <20140515220529.GA8459@kroah.com>
References: <1399398881-2611-1-git-send-email-clement.calmels@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399398881-2611-1-git-send-email-clement.calmels@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 07:54:41PM +0200, Clément Calmels wrote:
> This is a patch to fix coding style issue found by
> scripts/checkpatch.pl utility.
> 
> Signed-off-by: Clément Calmels <clement.calmels@free.fr>
> ---
>  drivers/staging/sep/sep_dev.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/staging/sep/sep_dev.h b/drivers/staging/sep/sep_dev.h
> index 5f6a07f..5faeefa1 100644
> --- a/drivers/staging/sep/sep_dev.h
> +++ b/drivers/staging/sep/sep_dev.h
> @@ -139,12 +139,14 @@ struct sep_queue_info {
>  static inline void sep_write_reg(struct sep_device *dev, int reg, u32 value)
>  {
>  	void __iomem *addr = dev->reg_addr + reg;
> +
>  	writel(value, addr);
>  }
>  
>  static inline u32 sep_read_reg(struct sep_device *dev, int reg)
>  {
>  	void __iomem *addr = dev->reg_addr + reg;
> +
>  	return readl(addr);
>  }
>  
> @@ -152,6 +154,7 @@ static inline u32 sep_read_reg(struct sep_device *dev, int reg)
>  static inline void sep_wait_sram_write(struct sep_device *dev)
>  {
>  	u32 reg_val;
> +
>  	do {
>  		reg_val = sep_read_reg(dev, HW_SRAM_DATA_READY_REG_ADDR);
>  	} while (!(reg_val & 1));

Someone else already sent in this same patch, sorry.

greg k-h
