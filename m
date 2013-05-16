Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3EPPUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:20:44 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59821 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab3EPPUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:20:43 -0400
Message-ID: <5194F944.2040803@free-electrons.com>
Date: Thu, 16 May 2013 17:20:36 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robherring2@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ARM: Remove boilerplate debug_ll_io_init code
References: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com> <201305160040.54399.arnd@arndb.de>
In-Reply-To: <201305160040.54399.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Le 16/05/2013 00:40, Arnd Bergmann a écrit :
> On Monday 13 May 2013, Maxime Ripard wrote:
>> The recent introduction of debug_ll_io_init made possible to not rely
>> anymore on a custom map_io function but on debug_ll_io_init for the
>> early mapping and then on the various drivers to do the needed mappings for
>> the kernel to boot.
>>
>> Some architectures begin to use only this function as the map_io callback in
>> the machine description.
>>
>> In order to remove some boilerplate code, make the ARM mm code call
>> debug_ll_io_init by itself when no .map_io callback is defined.
>>
>> This has been tested on the sunxi platform.
> 
> Great stuff!
> 
> I didn't notice the addition of debug_ll_io_init, so this is a nice surprise
> for me.

Well, you can thank Rob for that, I wasn't involved in it in the first
place :)

> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks,

How will we merge this? The first patch would be merged by Russel and
the 3 others by their respective maintainers?

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
