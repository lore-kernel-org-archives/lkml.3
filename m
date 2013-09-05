Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935554Ab3IEDIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:08:42 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:51660 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762253Ab3IEDIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <002201cea9e1$5e99da40$1bcd8ec0$%han@samsung.com>
References: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
	<002201cea9e1$5e99da40$1bcd8ec0$%han@samsung.com>
Date: Thu, 5 Sep 2013 08:38:40 +0530
Message-ID: <CAK9yfHxR6nfEcCVxviD_=-ffNkcrazM8nWZRTFt2jOJuvaaSjA@mail.gmail.com>
Subject: Re: [PATCH 1/6] backlight: lp855x_bl: support new LP8555 device
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>, Milo Kim <milo.kim@ti.com>,
        Daniel Jeong <gshark.jeong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On 5 September 2013 08:11, Jingoo Han <jg1.han@samsung.com> wrote:
> LP8555 is one of LP855x family device.
> This device needs pre_init_device() and post_init_device() driver structure.
> It's same as LP8557, so the device configuration code is shared with LP8557.
> Backlight outputs are generated from dual DC-DC boost converters.
> It's configurable EPROM settings which are defined in the platform data.
>
> Driver documentation and device tree bindings are updated.
>
> Signed-off-by: Milo Kim <milo.kim@ti.com>

Looks like the author information is lost for this patch and patch 2
(atleast it does not match
whatever is mentioned in the cover letter). Please check.
-- 
With warm regards,
Sachin
