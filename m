Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaHVXy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:54:26 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:33124 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbaHVXyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:54:25 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2014 19:54:24 EDT
From: Michal Sojka <sojka@merica.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bryan Wu <cooloney@gmail.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>, michal.vokac@comap.cz,
        Richard Purdie <rpurdie@rpsys.net>, Felipe Balbi <balbi@ti.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] leds: usb: Add LED trigger for USB gadget activity
In-Reply-To: <20140822214244.GA25922@kroah.com>
References: <1408708399-20423-1-git-send-email-sojka@merica.cz> <CAK5ve-LaGPgsAVMMMw3=EWpjom5NF29btu0Yxjg=6iwPpioQFg@mail.gmail.com> <20140822214244.GA25922@kroah.com>
User-Agent: Notmuch/0.18.1+70~ge8d943c (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 23 Aug 2014 01:44:04 +0200
Message-ID: <87k3609jjv.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22 2014, Greg Kroah-Hartman wrote:
> On Fri, Aug 22, 2014 at 10:39:03AM -0700, Bryan Wu wrote:
>> On Fri, Aug 22, 2014 at 4:53 AM, Michal Sojka <sojka@merica.cz> wrote:
>> > With this patch, USB gadget activity can be signaled by blinking a LED.
>> >
>> > Since there is no generic code where to put the trigger for all USB
>> > controllers, each USB controller needs to call the trigger individually.
>> > This patch adds the call only for the musb controller where I can test
>> > it.
>> >
>> 
>> Generally I think one led trigger for both USB host and USB gadget
>> activity is good enough. We don't need 2 same led trigger here.
>
> What about systems that have both running at the same time?  Don't you
> want individual control?

Yes, I have a device with two USB connectors (host, device) and a LED
next to each. From the LEDs it should be clear, which connector is being
used.

Thanks,
-Michal
