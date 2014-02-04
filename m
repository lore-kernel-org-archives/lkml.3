Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaBDJDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:03:32 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62284 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBDJDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:03:21 -0500
Date: Tue, 4 Feb 2014 09:03:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] drivers/mfd: fix pointer-integer size mismatch warnings
Message-ID: <20140204090316.GB13529@lee--X1>
References: <1391496143-6660-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391496143-6660-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix the pointer-integer size mismatch warnings below:
> 	drivers/mfd/wm8994-core.c: In function ‘wm8994_i2c_probe’:
> 	mfd/wm8994-core.c:639:19: warning: cast from pointer to integer of
> 			different size [-Wpointer-to-int-cast]
> 	    wm8994->type = (int)of_id->data;
> 	                   ^
> 	drivers/mfd/max8997.c: In function ‘max8997_i2c_get_driver_data’:
> 	drivers/mfd/max8997.c:173:10: warning: cast from pointer to integer of
> 			different size [-Wpointer-to-int-cast]
> 	   return (int)match->data;
> 	          ^

Already fixed:
  https://lkml.org/lkml/2014/1/23/309
  https://lkml.org/lkml/2014/1/23/326

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
