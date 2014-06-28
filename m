Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaF1HSa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 03:18:30 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:59482 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaF1HS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 03:18:29 -0400
Message-ID: <53AE6C3C.5090308@ahsoftware.de>
Date: Sat, 28 Jun 2014 09:18:20 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: John Whitmore <arigead@gmail.com>, Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 0/2][RFC] Try to handle hctosys w/ rtc modules
References: <1403890031-26419-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1403890031-26419-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.06.2014 19:27, schrieb John Stultz:
> Its been pointed out that the RTC hctosys functionality doesn't
> work well with RTC modules, which may not be loaded until after
> late_init().
>
> While there have been other attempts to sovle this, this patchset
> is a very quick 10 minute effort to show how I'd try to resolve
> this. There likely are still issues here, but I'd be happy to
> make fixes and adjustments to ensure it works.
>
> Feedback and comments always appreciated!

And it still uses the non-deterministic and therefor almost unusable 
rtcN. Well done.

