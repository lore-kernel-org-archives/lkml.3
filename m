Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaLAMx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:53:56 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:48967 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaLAMxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:53:54 -0500
Date: Mon, 1 Dec 2014 12:53:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Andrzej Hajda <a.hajda@samsung.com>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH/RFC v8 09/14] mfd: max77693: adjust
 max77693_led_platform_data
Message-ID: <20141201125347.GC12068@x1>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-10-git-send-email-j.anaszewski@samsung.com>
 <20141201113430.GC15845@x1>
 <547C63F4.4060203@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547C63F4.4060203@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2014, Jacek Anaszewski wrote:
> On 12/01/2014 12:34 PM, Lee Jones wrote:
> >On Fri, 28 Nov 2014, Jacek Anaszewski wrote:
> >
> >I'm guessing this will effect the other patches in the set?
> >
> 
> max77692 flash driver depends on it and it has to be
> in synch with the related DT bindings patch.

Very well.  Providing you address the commitlog issues:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
