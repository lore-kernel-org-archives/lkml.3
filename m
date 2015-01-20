Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbbATN4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:56:47 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:61310 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbbATN4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:56:46 -0500
Message-ID: <54BE5E9A.8070502@linaro.org>
Date: Tue, 20 Jan 2015 14:56:42 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: clocksource: add asm9260_timer driver
References: <1417193657-31602-2-git-send-email-linux@rempel-privat.de> <1420708042-22906-1-git-send-email-linux@rempel-privat.de> <1420708042-22906-2-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1420708042-22906-2-git-send-email-linux@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 10:07 AM, Oleksij Rempel wrote:
> In some cases asm9260 looks similar to iMX2x. One of exceptions is
> timer controller. So this patch introduces new driver for this special case.
>
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Fixed conflict in the Makefile and applied to my tree.

Thanks !

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

