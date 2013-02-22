Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab3BVUzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:55:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab3BVUzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:55:18 -0500
Message-ID: <5127DB2B.3030700@redhat.com>
Date: Fri, 22 Feb 2013 15:55:07 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, linux-efi@vger.kernel.org
Subject: Re: [RFE PATCH 2/2] rtc, add write functionality to sysfs
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-3-git-send-email-prarit@redhat.com> <5127D884.6020701@linaro.org>
In-Reply-To: <5127D884.6020701@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/22/2013 03:43 PM, John Stultz wrote:
> On 02/14/2013 09:02 AM, Prarit Bhargava wrote:
>> /sys/class/rtc/rtcX/date and /sys/class/rtc/rtcX/time currently have
>> read-only access.  This patch introduces write functionality which will
>> set the rtc time.
>>
>> Usage: echo YYYY-MM-DD > /sys/class/rtc/rtcX/date
>>         echo HH:MM:SS > /sys/class/rtc/rtcX/time
> 
> Why do we want to add a new interface here?

John,

I'm not adding a new interface.  The current date/time interface only handles
read and I'm introducing write.

Sorry -- maybe my description was too short ...

P.

> 
> thanks
> -john
> 
