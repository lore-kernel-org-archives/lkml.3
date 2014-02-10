Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaBJLN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:13:58 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:55575 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaBJLN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:13:56 -0500
Date: Mon, 10 Feb 2014 11:13:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Levente Kurusa'" <levex@linux.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'FBDEV list'" <linux-fbdev@vger.kernel.org>,
        "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH] backlight: replace kfree with put_device
Message-ID: <20140210111349.GA21522@lee--X1>
References: <1391762601-4560-1-git-send-email-levex@linux.com>
 <003701cf25f6$3807c6d0$a8175470$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <003701cf25f6$3807c6d0$a8175470$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As per the comments on device_register, we shouldn't call kfree()
> > right after a device_register() failure. Instead call put_device(),
> > which in turn will call bl_device_release resulting in a kfree to the
> > full structure.
> > 
> > Signed-off-by: Levente Kurusa <levex@linux.com>
> 
> (+cc Bryan Wu, Lee Jones)
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>

Applied to temporary Backlight repo [1], thanks.

[1] git://git.linaro.org/people/lee.jones/backlight.git

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
