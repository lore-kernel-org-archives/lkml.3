Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3GXGlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:41:32 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37880 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3GXGlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:41:31 -0400
Message-ID: <51EF773F.40903@gmail.com>
Date: Wed, 24 Jul 2013 14:42:07 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cmcgT3R0ZQ==?= <jrg.otte@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rafael.j.wysocki@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v3.11-rc2] regression: brightness always on maximum.
References: <CADDKRnBRyJZCoy3G53b6tY7J21XZp5bGn7nJi87WUgEGhSuT_w@mail.gmail.com>
In-Reply-To: <CADDKRnBRyJZCoy3G53b6tY7J21XZp5bGn7nJi87WUgEGhSuT_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 03:52 PM, Jörg Otte wrote:
> The brightness of my laptop is always on maximum and can't be scaled
> down.
> Brightness control via function keys was always working on this
> laptop, so this is a regression in v3.11-rc2.

Please list /sys/class/backlight.

If there is a intel_backlight, please try to adjust brightness level
through brightness file like this:
# echo XXX > /sys/class/backlight/intel_backlight/brightness
Does it work?

Thanks,
Aaron

> 
> It is a FUJITSU LIFEBOOK AH532/FJNBB1C, BIOS Version 1.09 05/22/2012
> Video driver is i915.
> 
> Please Cc me in answeres , I am not subscribed.
> 
> Thanks, Jörg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

