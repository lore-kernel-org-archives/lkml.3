Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab3FDLYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:24:41 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:60768 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3FDLYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:24:38 -0400
Message-ID: <51ADCE73.3060802@linaro.org>
Date: Tue, 04 Jun 2013 13:24:35 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Daniel Tang <dt.tangr@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] Add TI-Nspire timer support
References: <AE2AF524-C495-4D6B-B622-816B3254D384@gmail.com> <CACRpkdbx1xugH_T6KBnui=JtoheH9H6=iv5yR1oejc_WxUfdkQ@mail.gmail.com> <347F9A91-70C0-4CD4-B0F6-C5E1DB0C3784@gmail.com>
In-Reply-To: <347F9A91-70C0-4CD4-B0F6-C5E1DB0C3784@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 11:37 AM, Daniel Tang wrote:
> 
> On 04/06/2013, at 7:36 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> 
>> On Sat, Jun 1, 2013 at 8:02 AM, Daniel Tang <dt.tangr@gmail.com> wrote:
>>
>>> The interrupt acknowledgement mechanism is a little strange because the interrupt mask and acknowledge registers are located in another memory mapped I/O peripheral. The address of this register is passed to the driver through device tree bindings.
>>
>> I can't see any linebreaks there. This looks horrible in git log.
>>
>> But I guess Daniel can fix it up directly in his tree.
>>
> 
> Apologies, I can fix it up if it needs be.


It is ok, I already fixed it.

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

