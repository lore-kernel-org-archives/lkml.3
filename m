Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaHWRUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 13:20:23 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64281 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaHWRUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 13:20:21 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53F8CD4F.7030609@roeck-us.net>
Date: Sat, 23 Aug 2014 10:20:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@kernel.org>
CC: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 02/11] power/restart: Call machine_restart instead
 of arm_pm_restart
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net> <1408495538-27480-3-git-send-email-linux@roeck-us.net> <20140821203904.GA26620@earth.universe>
In-Reply-To: <20140821203904.GA26620@earth.universe>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 01:39 PM, Sebastian Reichel wrote:
> Hi,
>
> On Tue, Aug 19, 2014 at 05:45:29PM -0700, Guenter Roeck wrote:
>> machine_restart is supported on non-ARM platforms, and and ultimately calls
>> arm_pm_restart, so dont call arm_pm_restart directly but use the more
>> generic function.
>>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> Acked-by: Heiko Stuebner <heiko@sntech.de>
>
> Acked-by: Sebastian Reichel <sre@kernel.org>
>
> Do you want me to take the patch via battery-2.6.git?
>

Hi Sebastian,

thanks a lot for the Ack. I am not sure if it is better to submit all
patches together or through individual maintainer trees. Let's wait for
Andrew's suggestion how we should proceed.

Thanks,
Guenter

