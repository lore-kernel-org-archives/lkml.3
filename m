Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbbARKne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 05:43:34 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:47153 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbARKnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 05:43:33 -0500
Date: Sun, 18 Jan 2015 10:43:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH 10/10] mfd: rtsx: using pcr_dbg replace dev_dbg
Message-ID: <20150118104327.GI3574@x1>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <7d0f1b3fe7f9f323480286d50b4ee7066a0fa4c6.1421320541.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d0f1b3fe7f9f323480286d50b4ee7066a0fa4c6.1421320541.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> pcr_dbg is a wrapper of dev_dbg, which can save some code,
> and help to enable/disable debug message static.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/rtl8411.c  | 11 +++++------
>  drivers/mfd/rts5209.c  |  4 ++--
>  drivers/mfd/rts5227.c  |  4 ++--
>  drivers/mfd/rts5229.c  |  4 ++--
>  drivers/mfd/rts5249.c  |  4 ++--
>  drivers/mfd/rtsx_pcr.c | 49 ++++++++++++++++++++++---------------------------
>  6 files changed, 35 insertions(+), 41 deletions(-)

Looks fine.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
