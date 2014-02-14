Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaBNKOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:14:51 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:35084 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBNKOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:14:48 -0500
Date: Fri, 14 Feb 2014 10:14:39 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 00/10] Support TI Light Management Unit devices
Message-ID: <20140214101439.GA9462@lee--X1>
References: <1392359410-6852-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392359410-6852-1-git-send-email-milo.kim@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Milo Kim (10):
>   mfd: Add TI LMU driver
>   backlight: Add TI LMU backlight common driver
>   backlight: ti-lmu-backlight: Add LM3532 driver
>   backlight: ti-lmu-backlight: Add LM3631 driver
>   backlight: ti-lmu-backlight: Add LM3633 driver
>   backlight: ti-lmu-backlight: Add LM3695 driver
>   backlight: ti-lmu-backlight: Add LM3697 driver
>   leds: Add LM3633 driver
>   regulator: Add LM3631 driver
>   Documentation: Add device tree bindings for TI LMU devices

It makes it much easier to track if you send your patch set (shallow)
threaded i.e. all patches attached to [PATCH 0/x]. Having all of the
patches sent individually they will get split up and spread out all
over the reviewers INBOX, which becomes unwieldy very quickly.

Please see git send-email options:
  `--[no-]thread` and `--[no-]chain-reply-to`

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
