Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaHUN5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:57:39 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46141 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbaHUN5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:57:37 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.97.15]
In-Reply-To: <53F5F600.4040803@ti.com>
References: <1408627195-18421-1-git-send-email-nm@ti.com>
	<53F5F600.4040803@ti.com>
Date: Thu, 21 Aug 2014 15:57:36 +0200
Message-ID: <CABxcv==iGonj_cHXGWJgJFadCm8rZQ8tF5OEmAi2m-j9MtWukA@mail.gmail.com>
Subject: Re: [PATCH] gpio: omap: Fix interrupt names
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 21, 2014 at 3:37 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> On Thursday 21 August 2014 09:19 AM, Nishanth Menon wrote:
>> When viewing the /proc/interrupts, there is no information about which
>> GPIO bank a specific gpio interrupt is hooked on to. This is more than a
>> bit irritating as such information can esily be provided back to the
>> user and at times, can be crucial for debug.
>>
>> So, instead of displaying something like:
>> 31:   0       0  GPIO   0  palmas
>> 32:   0       0  GPIO  27  mmc0
>>
>> Display the following with appropriate device name:
>> 31:   0       0  4ae10000.gpio   0  palmas
>> 32:   0       0  4805d000.gpio  27  mmc0
>>
>> This requires that we create irq_chip instance specific for each GPIO
>> bank which is trivial to achieve.
>>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
>> based on v3.17-rc1
> Looks good..
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>

Looks good to me as well.

Acked-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
