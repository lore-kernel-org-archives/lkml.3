Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab3AQKiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:38:50 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4204 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759527Ab3AQKis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:38:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 17 Jan 2013 02:38:18 -0800
Message-ID: <50F7D47A.7070508@nvidia.com>
Date: Thu, 17 Jan 2013 16:07:46 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH 3/4] gpio: palmas: Add support for Palams GPIO
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com> <1357210020-19876-4-git-send-email-ldewangan@nvidia.com> <CACRpkdazCa_GMfrCnoYukiQKbKD41RiTG-MyO-5p+B-6-+Y=hA@mail.gmail.com> <20130117103529.GB7504@opensource.wolfsonmicro.com>
In-Reply-To: <20130117103529.GB7504@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2013 04:05 PM, Mark Brown wrote:
> On Thu, Jan 17, 2013 at 11:34:42AM +0100, Linus Walleij wrote:
>
>> Do you want me to apply it to my GPIO tree or does it have
>> dependencies so you'll take it through MFD or something?
> The MFD has been merged for a couple of releases now.
Yes, Although this driver used the new API introduced in patch 1/4 but I 
think it is fine to apply this in GPIO subsystem here as it is 
independent driver.


