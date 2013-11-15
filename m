Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3KOPCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:02:44 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:63381 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3KOPCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:02:32 -0500
Date: Fri, 15 Nov 2013 15:02:25 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        wei_wang@realsil.com.cn, rogerable@realtek.com
Subject: Re: [PATCH 3/3] mfd: rtsx: Prevent 'used uninitialised' warnings
Message-ID: <20131115150225.GD4996@lee--X1>
References: <cover.1384503048.git.micky_ching@realsil.com.cn>
 <a94db6f718e42afbe363af2fc0f006c92f223e54.1384503048.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <a94db6f718e42afbe363af2fc0f006c92f223e54.1384503048.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013, micky_ching@realsil.com.cn wrote:

> From: Lee Jones <lee.jones@linaro.org>
> 
> drivers/mfd/rtl8411.c: In function -F¡rtl8411_fetch_vendor_settings¢:-A
> drivers/mfd/rtl8411.c:58:7: warning: -F¡reg1¢ is used uninitialized in this function [-Wuninitialized]-A
> drivers/mfd/rtl8411.c: In function -F¡rtl8411b_fetch_vendor_settings¢:-A
> drivers/mfd/rtl8411.c:79:7: warning: -F¡reg¢ is used uninitialized in this function [-Wuninitialized]-A
> drivers/mfd/rtl8411.c: In function -F¡rtl8411_fetch_vendor_settings¢:-A
> drivers/mfd/rtl8411.c:69:26: warning: -F¡reg3¢ may be used uninitialized in this function [-Wuninitialized]-A

Something wrong with your email client here.

Using `git send-mail` is preferable.

Please read:
  Documentation/email-clients.txt

> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>

All you need to do with this patch is reply to the one I sent with an
Acked-by, Reviewed-by or Tested-by.

Please read:
  Documentation/SubmittingPatches

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
