Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaKSIJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:09:37 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61201 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaKSIJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:09:36 -0500
Message-ID: <546C5039.10107@samsung.com>
Date: Wed, 19 Nov 2014 17:09:29 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Kukjin Kim <kgene@kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Kevin Hilman <khilman@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: exynos_defconfig: Enable max77802 rtc and clock
 drivers
References: <1414401440-10972-1-git-send-email-javier.martinez@collabora.co.uk> <04e101cff29f$4021ea00$c065be00$@kernel.org> <CABxcv=kaOa1+6a1n_+GjoH=PgG=LzAnXLU7U_E5NvYYP-0WedA@mail.gmail.com>
In-Reply-To: <CABxcv=kaOa1+6a1n_+GjoH=PgG=LzAnXLU7U_E5NvYYP-0WedA@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/14 17:45, Javier Martinez Canillas wrote:
> Hello Kukjin,
> 
Hi Javier,

> On Tue, Oct 28, 2014 at 12:06 PM, Kukjin Kim <kgene@kernel.org> wrote:
>> Javier Martinez Canillas wrote:
>>> Commit 6e80e3d87549 ("ARM: exynos_defconfig: Enable MAX77802")
>>> enabled support for the max77802 regulators but the PMIC also
>>> has a Real-Time-Clock (RTC) and 2-channel 32kHz clock outputs.
>>>
>>
>> I'll apply this, thanks.
>>
>> - Kukjin
>>
> 
> You say that you will apply this patch but I can't find it in any of
> your branches.
> 
Sorry for missing the patch in my tree. You can see it in a couple of
mins ;)

Thanks,
Kukjin
