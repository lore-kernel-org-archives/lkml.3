Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3AQN7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:59:00 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:57944 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3AQN67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:58:59 -0500
MIME-Version: 1.0
In-Reply-To: <50F7D47A.7070508@nvidia.com>
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
	<1357210020-19876-4-git-send-email-ldewangan@nvidia.com>
	<CACRpkdazCa_GMfrCnoYukiQKbKD41RiTG-MyO-5p+B-6-+Y=hA@mail.gmail.com>
	<20130117103529.GB7504@opensource.wolfsonmicro.com>
	<50F7D47A.7070508@nvidia.com>
Date: Thu, 17 Jan 2013 14:58:58 +0100
Message-ID: <CACRpkdY613HDX7OVEzttkCMUmZSWEzqNYHbP1yBbtewDVm14VA@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [PATCH 3/4] gpio: palmas: Add support for Palams GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: rtc-linux@googlegroups.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 11:37 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> On Thursday 17 January 2013 04:05 PM, Mark Brown wrote:
>>
>> On Thu, Jan 17, 2013 at 11:34:42AM +0100, Linus Walleij wrote:
>>
>>> Do you want me to apply it to my GPIO tree or does it have
>>> dependencies so you'll take it through MFD or something?
>>
>> The MFD has been merged for a couple of releases now.
>
> Yes, Although this driver used the new API introduced in patch 1/4 but I
> think it is fine to apply this in GPIO subsystem here as it is independent
> driver.

OK that's what fooled me.

Patch applied!

Yours,
Linus Walleij
