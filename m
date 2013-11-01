Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab3KAMfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:35:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46857 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3KAMfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:35:52 -0400
Message-ID: <1383309354.11155.23.camel@hornet>
Subject: Re: [PATCH] vexpress: remove declaration of vexpress_clk_of_init()
From: Pawel Moll <pawel.moll@arm.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>
Date: Fri, 01 Nov 2013 12:35:54 +0000
In-Reply-To: <1383018033-1864-1-git-send-email-wangkefeng.wang@huawei.com>
References: <1383018033-1864-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 01 Nov 2013 12:35:49.0271 (UTC) FILETIME=[E5059A70:01CED6FE]
X-MC-Unique: 113110112354902201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-29 at 03:40 +0000, Kefeng Wang wrote:
> After commit:6e973d2c(clk: vexpress: Add separate SP810 driver),
> vexpress_clk_of_init() is unnecessary and removed, so kill it.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/vexpress.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
> index 617c01b..0e65172 100644
> --- a/include/linux/vexpress.h
> +++ b/include/linux/vexpress.h
> @@ -122,6 +122,5 @@ struct clk *vexpress_osc_setup(struct device *dev);
>  void vexpress_osc_of_setup(struct device_node *node);
>  
>  void vexpress_clk_init(void __iomem *sp810_base);
> -void vexpress_clk_of_init(void);
>  
>  #endif

I've got this covered by some other patches, but thanks for pointing it
out anyway.

Cheers!

Pawel




