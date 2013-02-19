Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab3BSOKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:10:06 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:64049 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab3BSOKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:10:04 -0500
Message-ID: <51238628.7000000@linaro.org>
Date: Tue, 19 Feb 2013 15:03:20 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Timer broadcast question
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi John, Frederic,

I am working on identifying the different wakeup sources from the
interrupts and I have a question regarding the timer broadcast.

The broadcast timer is setup to the next event and that will wake up any
cpu, right ?

The time framework will look at the different cpus next-event and send
them an IPI to wake them up.

Although, it is possible the sender of this IPI may not be concerned by
the timer expiration and has been woken up just for sending the IPI, right ?

If this is correct, is it possible to setup the timer irq affinity to a
cpu which will be concerned by the timer expiration ? so we prevent an
unnecessary wake up for a cpu.

Did I missed something or does it sound correct ?

Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

