Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab3DUGjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 02:39:13 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38187 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3DUGjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 02:39:12 -0400
Message-ID: <51738972.5040005@ahsoftware.de>
Date: Sun, 21 Apr 2013 08:38:42 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] rtc: rtc-hid-sensor-time
References: <1366384452-14367-1-git-send-email-holler@ahsoftware.de> <alpine.LNX.2.00.1304210144050.11076@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1304210144050.11076@pobox.suse.cz>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.04.2013 01:46, schrieb Jiri Kosina:
> On Fri, 19 Apr 2013, Alexander Holler wrote:
>
>> as I'm not sure if the maintainer of the RTC subsystem is active again,
>> I've added the people which where involved with rtc-hid-sensor-time
>> before to cc too. That might be a good idea even he is active again,
>> as the driver depends on hid-sensor-hub and as such works a bit
>> outside the stuff other RTC drivers do use.
>
> Agreed. I'd say let's wait if RTC maintainer(s) step up and have anything
> to say to this patchset.
>
> If there's a silence, it'll probably be ok taking it through my review
> process and my tree, but at least for 3/3 I'd definitely like to have Ack
> from someone else as well.
>
> For this reason, this is likely not be 3.10 material, but 3.11.

Thanks a lot.

I already have another patch here to support milliseconds (for hctosys), 
and I might have another patch ready in a few days, which adjusts the 
system time whenever the HID device sends a timestamp which includes 
milliseconds (enabled by a new module option named adjtime for 
rtc-hid-sensor-time, which is by default off). The basics do already 
work, but I'm just starting to look at how to adjust the system time 
best, so suggestions are welcome. ;)

(Therefor I've now added the maintainers for kernel/time/timekeeping.c 
to cc).

Regards,

Alexander
