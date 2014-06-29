Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaF2OPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 10:15:25 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:32833 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaF2OPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 10:15:24 -0400
X-ME-Helo: beldin
X-ME-Date: Sun, 29 Jun 2014 16:15:23 +0200
X-ME-IP: 90.38.42.162
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] clocksource: move PXA timer to clocksource framework
References: <1403388588-11956-1-git-send-email-robert.jarzmik@free.fr>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 29 Jun 2014 16:15:19 +0200
In-Reply-To: <1403388588-11956-1-git-send-email-robert.jarzmik@free.fr>
	(Robert Jarzmik's message of "Sun, 22 Jun 2014 00:09:46 +0200")
Message-ID: <87bntbpzt4.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Move time.c from arch/arm/mach-pxa/time.c to
> drivers/clocksource/pxa_timer.c.
>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Ping ?

Cheers.

--
Robert
