Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3BVRCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:02:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:15015 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984Ab3BVRCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:02:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,717,1355126400"; 
   d="scan'208";a="290652472"
Message-ID: <5127A493.8040900@intel.com>
Date: Sat, 23 Feb 2013 01:02:11 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Lan Tianyu <lantianyu1986@gmail.com>
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
References: <20130221184010.GA24692@kroah.com> <20130222085954.GA4352@redhat.com> <51273F8E.3020807@intel.com> <20130222164318.GA27619@redhat.com>
In-Reply-To: <20130222164318.GA27619@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/23 0:43, Dave Jones wrote:
> On Fri, Feb 22, 2013 at 05:51:10PM +0800, Lan Tianyu wrote:
>
>   > >   > Nothing major, lots of gadget fixes, and of course, xhci stuff.
>   > >
>   > > I get no USB devices recognised when I insert them any more, which
>   > > I think is pretty major.  I suspect it has something to do with this ?
>   > >
>   > >   > Lan Tianyu (12):
>   > >   >       usb: add runtime pm support for usb port device
>   > >   >       usb: add usb port auto power off mechanism
>   > >
>   > > It looks like every port on my laptop is powered down, as I can't
>   > > even charge devices with it.
>   >
>   > 	Do you enable the port/power/pm_qos_no_power_off?
>   > 	cat /sys/bus/usb/devices/(dev)/port/power/pm_qos_no_power_off to show.
>
> /sys/bus/usb/devices/1-1.4/port/power/pm_qos_no_power_off:1
> /sys/bus/usb/devices/1-1.6/port/power/pm_qos_no_power_off:1
> /sys/bus/usb/devices/1-1/port/power/pm_qos_no_power_off:1
> /sys/bus/usb/devices/2-1/port/power/pm_qos_no_power_off:1
>
At last, this mean usb port power off mechanism should not work.

> I changed them to 0, made no difference.
>
>   > > What can I do to debug this ?
>   > 	Can you attach the output of dmesg with CONFIG_USB_DEBUG?
>
> http://paste.fedoraproject.org/3620
How about"sudo lsusb -s 1:1 -v" or "2:1"?
>
> 	Dave
>

-- 
Best Regards
Tianyu Lan
linux kernel enabling team
