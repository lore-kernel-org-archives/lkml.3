Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaEZJwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:52:14 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53137 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaEZJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:52:13 -0400
Message-ID: <53830ED9.9060001@linaro.org>
Date: Mon, 26 May 2014 11:52:25 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Matthew Leach <matthew.leach@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Xiubo Li <Li.Xiubo@freescale.com>, "Yang,Wei" <Wei.Yang@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "" <khilman@linaro.org>
Subject: Re: [GIT PULL] clockevents: new material for 3.16
References: <537F214C.8000700@linaro.org> <20140526194512.032c6630@canb.auug.org.au>
In-Reply-To: <20140526194512.032c6630@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 11:45 AM, Stephen Rothwell wrote:
> Hi all,
>
> On Fri, 23 May 2014 12:22:04 +0200 Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>>
>>         clocksource: sun5i: Add support for reset controller
>
> This commit caused a build failure on arm in linux-next today ...

Thanks Stephen.

Maxime ?


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

