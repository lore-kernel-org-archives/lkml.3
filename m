Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3FNTYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:24:14 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58149 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3FNTYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:24:12 -0400
Message-ID: <51BB6DD9.6010200@linaro.org>
Date: Fri, 14 Jun 2013 12:24:09 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 5/9 v3] RFC: timekeeping: rtc: Introduce new kernel parameter
 hctosys
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-6-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1371228732-5749-6-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:52 AM, Alexander Holler wrote:
> hctosys= specifies the driver (RTC) name which sets the system clock at
> boot, if and only if userspace hasn't set the time before the driver will
> be loaded.
>
> If hctosys will not be specified, the first available hardware clock
> with a valid time will be used (again, if and only if ...).
>
> If you don't want that the system clock will be set by any hardware clock,
> just specify a non-existent RTC driver name, e.g. with hctosys=none.

So what was the rational for this to be a boot time argument instead of 
using the existing compile time CONFIG_RTC_HCTOSYS_DEVICE?

If we need a boot argument, that's still doable, but it probably should 
fall back to CONFIG_RTC_HCTOSYS_DEVICE if not specified.

thanks
-john

