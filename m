Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab3DVLlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:41:40 -0400
Received: from void.printf.net ([89.145.121.20]:56334 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab3DVLlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:41:39 -0400
From: Chris Ball <cjb@laptop.org>
To: Neil Armstrong <narmstrong@neotion.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-mmc@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/3] Add boot_enable attribute to eMMC device for boot mode operation selection
References: <51713B86.2090001@neotion.com>
	<CAKYAXd_xa--1QpFCdz3Kj0mKF3cvtxFn-xL3QGWZyXPO4Y79ng@mail.gmail.com>
	<5174E58E.8090307@neotion.com>
Date: Mon, 22 Apr 2013 07:41:27 -0400
In-Reply-To: <5174E58E.8090307@neotion.com> (Neil Armstrong's message of "Mon,
	22 Apr 2013 09:23:58 +0200")
Message-ID: <87a9oqvllk.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Mon, Apr 22 2013, Neil Armstrong wrote:
> Thanks for the reply, I was not aware of the mmc-utils tools. I think
> the tool and the MMC_IOC_CMD interface should be documented in the kernel.

Where do you think a good place for documentating the mmc tool would
be, such that you would have seen it while investigating?

It'd be nice to avoid having to document the commands themselves,
since the userspace tool may be updated out of sync with the kernel.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
