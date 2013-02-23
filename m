Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab3BWXUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 18:20:11 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:42043 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759051Ab3BWXUJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 18:20:09 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2013 18:20:09 EST
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-3-git-send-email-prarit@redhat.com> <5127D884.6020701@linaro.org> <5127DB2B.3030700@redhat.com> <5127DDAF.2000403@linaro.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <5127DDAF.2000403@linaro.org>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <B22B05C4-B8D2-44B9-971B-37913DE59EF6@towertech.it>
Cc: Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
X-Mailer: iPad Mail (10B141)
From: Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [RFE PATCH 2/2] rtc, add write functionality to sysfs
Date: Sun, 24 Feb 2013 00:11:32 +0100
To: John Stultz <john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/feb/2013, at 22:05, John Stultz <john.stultz@linaro.org> wrote:

> On 02/22/2013 12:55 PM, Prarit Bhargava wrote:
>> 
>> On 02/22/2013 03:43 PM, John Stultz wrote:
>>> On 02/14/2013 09:02 AM, Prarit Bhargava wrote:
>>>> /sys/class/rtc/rtcX/date and /sys/class/rtc/rtcX/time currently have
>>>> read-only access.  This patch introduces write functionality which will
>>>> set the rtc time.
>>>> 
>>>> Usage: echo YYYY-MM-DD > /sys/class/rtc/rtcX/date
>>>>         echo HH:MM:SS > /sys/class/rtc/rtcX/time
>>> Why do we want to add a new interface here?
>> John,
>> 
>> I'm not adding a new interface.  The current date/time interface only handles
>> read and I'm introducing write.
>> 
> 
> Right, but what benefit does that provide?
> (I'm not saying there isn't any, its just not clear from your patch why this is a good thing.)
> 
> Also CC'ing Alessandro for his input.

I'd like to keep the interfaces as simple as possible but I'm open to improvements if there are good use cases.


--
Best regards,
 Alessandro Zummo
    Tower Technologies