Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3BVQnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:43:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381Ab3BVQn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:43:29 -0500
Date: Fri, 22 Feb 2013 11:43:18 -0500
From: Dave Jones <davej@redhat.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Message-ID: <20130222164318.GA27619@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Lan Tianyu <tianyu.lan@intel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20130221184010.GA24692@kroah.com>
 <20130222085954.GA4352@redhat.com>
 <51273F8E.3020807@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51273F8E.3020807@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 05:51:10PM +0800, Lan Tianyu wrote:

 > >   > Nothing major, lots of gadget fixes, and of course, xhci stuff.
 > >
 > > I get no USB devices recognised when I insert them any more, which
 > > I think is pretty major.  I suspect it has something to do with this ?
 > >
 > >   > Lan Tianyu (12):
 > >   >       usb: add runtime pm support for usb port device
 > >   >       usb: add usb port auto power off mechanism
 > >
 > > It looks like every port on my laptop is powered down, as I can't
 > > even charge devices with it.
 >
 > 	Do you enable the port/power/pm_qos_no_power_off?
 > 	cat /sys/bus/usb/devices/(dev)/port/power/pm_qos_no_power_off to show.

/sys/bus/usb/devices/1-1.4/port/power/pm_qos_no_power_off:1
/sys/bus/usb/devices/1-1.6/port/power/pm_qos_no_power_off:1
/sys/bus/usb/devices/1-1/port/power/pm_qos_no_power_off:1
/sys/bus/usb/devices/2-1/port/power/pm_qos_no_power_off:1

I changed them to 0, made no difference.

 > > What can I do to debug this ?
 > 	Can you attach the output of dmesg with CONFIG_USB_DEBUG?

http://paste.fedoraproject.org/3620

	Dave

