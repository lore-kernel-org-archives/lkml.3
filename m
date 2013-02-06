Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab3BFEsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:48:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12103 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3BFEs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:48:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Feb 2013 20:47:57 -0800
Message-ID: <5111E093.4060600@nvidia.com>
Date: Wed, 6 Feb 2013 13:48:19 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 5/9] gpiolib: use gpio_chips list in gpiochip_find_base
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <1359822572-26009-7-git-send-email-acourbot@nvidia.com> <CACRpkdYT4p8uez8DHTSsjKFb=KmWbtCXJQtyXLAJkCC7fKaErw@mail.gmail.com>
In-Reply-To: <CACRpkdYT4p8uez8DHTSsjKFb=KmWbtCXJQtyXLAJkCC7fKaErw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 02:21 AM, Linus Walleij wrote:
> This looks like it is preserving this userspace-sensitive semantic
> so that dynamically added chips will still get the same assigned
> numbers.

It does (it should, at least), the assigned ranges should be strictly 
identical to the previous version. While testing I also made sure all 
chips had the same GPIO range.

> But I want some guarantees, so state clearly in the commit
> that any dynamically assigned chip will get the same base
> address after this change as it got before it, and please take
> this opportunity to add a comment stating that this search
> method is vital for userspace ABIs, and must be preserved.

Done. I will take the blame if something goes wrong. :)

Thanks,
Alex.


