Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaD1K1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:27:46 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:57613 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaD1K1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:27:43 -0400
Date: Mon, 28 Apr 2014 11:27:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: jg1.han@samsung.com, cooloney@gmail.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video/backlight: Fix string type mismatch in s6e63m0.c
Message-ID: <20140428102738.GG21279@lee--X1>
References: <1398354436-25467-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398354436-25467-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix string type mismatch in s6e63m0_sysfs_show_gamma_table().
> gamma_table_count is defined as unsigned int.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/video/backlight/s6e63m0.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
