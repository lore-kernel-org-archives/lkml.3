Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3FNR3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:29:00 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50882 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3FNR27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:28:59 -0400
Message-ID: <51BB52D8.3030506@linaro.org>
Date: Fri, 14 Jun 2013 10:28:56 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 7/9] RFC: rtc: implement rtc_read_timeval()
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-8-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1371228732-5749-8-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:52 AM, Alexander Holler wrote:
> Some RTCs offer a higher resolution than seconds. To support reading such
> high resolution timestamps from inside the kernel implement
> rtc_read_timeval() and add a read_timeval to the rtc-ops.
>
> This is done to support high precision read-only clocks (like radio- or
> GPS-clocks) from inside the kernel (mainly hctosys). Therfor there is
> currently no need to set the clock or to extend the (rtc-)userspace api to
> support high precision timestamps.

And is there really no reason to eventually pass this out to userland? 
Also won't we need an equivalent resolution settime method?

thanks
-john

