Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3LPJI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:08:26 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:56966 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3LPJIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:08:23 -0500
Date: Mon, 16 Dec 2013 09:08:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/3] mfd: mc13xxx: Remove duplicate mc13xxx_get_flags()
 declaration
Message-ID: <20131216090818.GH18769@lee--X1>
References: <1387026192-21234-1-git-send-email-shc_work@mail.ru>
 <1387026192-21234-2-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387026192-21234-2-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Dec 2013, Alexander Shiyan wrote:

> mc13xxx_get_flags() declaration given twice.
> This patch removes this duplicate.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  include/linux/mfd/mc13xxx.h | 2 --
>  1 file changed, 2 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
