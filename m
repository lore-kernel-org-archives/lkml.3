Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3IINCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:02:52 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49743 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3IINCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:02:51 -0400
Date: Mon, 9 Sep 2013 14:02:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: wei_wang@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, micky_ching@realsil.com.cn
Subject: Re: [PATCH v2] mfd: rtsx: Modify rts5249_optimize_phy
Message-ID: <20130909130247.GH22938@lee--X1>
References: <cover.1378437776.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1378437776.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep 2013, wei_wang@realsil.com.cn wrote:

> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> v2:
> Name those new-added register values
> 
> Wei WANG (1):
>   mfd: rtsx: Modify rts5249_optimize_phy
> 
>  drivers/mfd/rts5249.c        |   35 ++++++++++++++++++++++++++++++++--
>  include/linux/mfd/rtsx_pci.h |   43 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+), 2 deletions(-)

You don't need to add a cover letter to a single patch submission.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
