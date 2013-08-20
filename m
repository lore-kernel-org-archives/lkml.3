Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab3HTPbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:31:39 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:54538 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3HTPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:31:37 -0400
Message-ID: <52138BD6.7070502@linaro.org>
Date: Tue, 20 Aug 2013 17:31:34 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Can you act as backup for timers/core and timers/urgent ?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

As I understood Thomas is in vacation. I sent a pull request for the
clocksource drivers.

I have another bunch of patches depending on it and on -rc4.

The kernel release is approaching -rc7 but timers/core is still -rc1.

Is it possible you act as a backup and you update timers/core which is
in -rc1 to the latest -rc where I will rebase my tree on and resend a
pull request with all the patches in (previous PR should be ignored) ?

Thanks in advance
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

