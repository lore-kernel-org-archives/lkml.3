Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbaC0R03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:26:29 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57626 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbaC0R01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:26:27 -0400
Message-ID: <53345F40.70608@linaro.org>
Date: Thu, 27 Mar 2014 10:26:24 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timekeeping: check params before use them
References: <1395907978-6202-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1395907978-6202-1-git-send-email-zhangwm@marvell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 01:12 AM, Neil Zhang wrote:
> Sometimes we won't need all the information from
> get_xtime_and_monotonic_and_sleep_offset(),
> so let's check the params before assign the value to them.

So I think the single in-kernel user of this function does use all of
the information.

Can you expand on how your using this and why the extra conditionals are
worth while?

thanks
-john

