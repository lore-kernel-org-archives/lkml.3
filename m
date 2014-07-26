Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaGZVSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 17:18:09 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:23681 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaGZVSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 17:18:07 -0400
X-ME-Helo: beldin
X-ME-Date: Sat, 26 Jul 2014 23:18:05 +0200
X-ME-IP: 92.156.128.9
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH ] ARM: pxa: fix section mismatch warning for pxa_timer_nodt_init
References: <1405356724-32207-1-git-send-email-robert.jarzmik@free.fr>
	<53CD25A4.7030606@linaro.org> <87oawivarv.fsf@free.fr>
	<12220413.BdRleC0Xf5@wuerfel>
X-URL: http://belgarath.falguerolles.org/
Date: Sat, 26 Jul 2014 23:17:55 +0200
In-Reply-To: <12220413.BdRleC0Xf5@wuerfel> (Arnd Bergmann's message of "Sat,
	26 Jul 2014 20:50:36 +0200")
Message-ID: <871tt7om4c.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> commit a38b1f60b5245a3 ("ARM: pxa: Add non device-tree timer link to
> clocksource") introduced a harmless section mismatch warning for
> all pxa platforms, by introducing a new pxa_timer_init() function
> that is not marked __init but that calls pxa_timer_nodt_init(),
> which is. The function is only called at init time, so it is safe
> to also annotate it this way.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Indeed.

Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
