Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaJJJYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:24:50 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:54978 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaJJJYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:24:46 -0400
Date: Fri, 10 Oct 2014 10:24:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH v2] mfd: rtsx: fix PM suspend for 5227 & 5249
Message-ID: <20141010092440.GF26795@lee--X1>
References: <1412920724-27945-1-git-send-email-micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412920724-27945-1-git-send-email-micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> Fix rts5227&5249 failed send buffer cmd after suspend,
> PM_CTRL3 should reset before send any buffer cmd after suspend.
> Otherwise, buffer cmd will failed, this will lead resume fail.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/Makefile         |  2 +-
>  drivers/mfd/rts5227.c        |  6 ++++++
>  drivers/mfd/rts5249.c        |  4 ++++
>  drivers/mfd/rtsx_gops.c      | 37 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/rtsx_pcr.h       |  3 +++
>  include/linux/mfd/rtsx_pci.h | 28 ++++++++++++++++++++++++++++

These are Card Reader drivers right?

Do you know why these are in MFD?

>  6 files changed, 79 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/mfd/rtsx_gops.c


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
