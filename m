Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaDUR6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:58:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33388 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaDUR6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:58:52 -0400
Message-ID: <53555C56.1040900@infradead.org>
Date: Mon, 21 Apr 2014 10:58:46 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, rtc-linux@googlegroups.com,
        a.zummo@towertech.it
CC: John Stultz <john.stultz@linaro.org>, Prarit Bhargava <prarit@redhat.com>
Subject: Re: X86: Impossible select Enhanced Real Time Clock Support (legacy
 PC RTC driver)
References: <1397415946.1555.16.camel@vger.seibold.net>
In-Reply-To: <1397415946.1555.16.camel@vger.seibold.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding more patch committers]

On 04/13/2014 12:05 PM, Stefani Seibold wrote:
> Since some kernel version it is impossible to select the Enhanced Real
> Time Clock Support (legacy PC RTC driver) because RTC_LIB is set by
> default in arch/x86/Kconfig, but the rule for selecting CONFIG_RTC is
> RTC_LIB=n. So the code of driver/char/rtc is still useless.
> 
> This breaks the API since there is no more misc device /dev/rtc
> available without a udev rule or a link to /dev/rtc0. 


-- 
~Randy
