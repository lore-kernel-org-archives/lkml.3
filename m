Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3LPNx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:53:56 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:52327 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3LPNxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:53:53 -0500
Date: Mon, 16 Dec 2013 13:53:48 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/3] mfd: mc13xxx: Simplify "probe" & "remove"
Message-ID: <20131216135348.GL18769@lee--X1>
References: <1387026192-21234-1-git-send-email-shc_work@mail.ru>
 <1387026192-21234-3-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387026192-21234-3-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Dec 2013, Alexander Shiyan wrote:

> This patch simplifies "probe" and "remove" functions by moving
> some initialization code in the driver core.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/mfd/mc13xxx-core.c | 36 +++++++++++++++++-------------------
>  drivers/mfd/mc13xxx-i2c.c  | 18 ++++--------------
>  drivers/mfd/mc13xxx-spi.c  | 19 ++++++-------------
>  drivers/mfd/mc13xxx.h      |  6 ++----
>  4 files changed, 29 insertions(+), 50 deletions(-)

I've changed the commit message a little and applied the patch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
