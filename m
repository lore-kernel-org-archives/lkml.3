Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740Ab3BYO6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:58:20 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:41478 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661Ab3BYO6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:58:17 -0500
Date: Mon, 25 Feb 2013 15:58:12 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [RFE PATCH 2/2] rtc, add write functionality to sysfs
Message-ID: <20130225155812.0758e093@linux.lan.towertech.it>
In-Reply-To: <512A47C5.3010500@redhat.com>
References: <1360861375-24131-1-git-send-email-prarit@redhat.com>
	<1360861375-24131-3-git-send-email-prarit@redhat.com>
	<5127D884.6020701@linaro.org>
	<5127DB2B.3030700@redhat.com>
	<5127DDAF.2000403@linaro.org>
	<B22B05C4-B8D2-44B9-971B-37913DE59EF6@towertech.it>
	<512A47C5.3010500@redhat.com>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013 12:03:01 -0500
Prarit Bhargava <prarit@redhat.com> wrote:

> 
> AFAICT there is no way for me to "test" or use the write from userspace.
> hwclock uses the SET_TIME ioctl, which is a different code path AFAICT.
> 
> I'd like to be at least able to test this stuff when we make changes to it so I
> think having write functionality for date & time is worthwhile.
> 
> For me, I'm using these to heavily test ntp and ntpdate over system reboots.

 the point is: who will benefit from this patch? users? distributions?
 embedded distributions? if it's useful, then just go for it.


> OOC, Alessandro, why is the date & time split into two fields?

 because date and time are two different things and we expect
 sysfs to preferably have one value for each entry.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

