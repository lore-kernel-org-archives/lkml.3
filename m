Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbaHHGkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:40:15 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50723 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHHGkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:40:12 -0400
Date: Thu, 7 Aug 2014 23:40:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Subject: Re: [PATCH v2] Input - wacom: update the ABI doc according to latest
 changes
Message-ID: <20140808064008.GB8103@core.coreip.homeip.net>
References: <1407444232-4005-1-git-send-email-benjamin.tissoires@redhat.com>
 <CAF8JNhJuWMPMQzur2rHOSNVSsa6-sM5kZDA2pBNT5ABws340vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8JNhJuWMPMQzur2rHOSNVSsa6-sM5kZDA2pBNT5ABws340vg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 01:54:22PM -0700, Ping Cheng wrote:
> On Thu, Aug 7, 2014 at 1:43 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> > Now the devices show up under hid no matter the connection (for USB
> > and Bluetooth, not serial nor i2c).
> >
> > The USB devices can now be easily found under
> > /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>
> >
> > The Bluetooth devices could also be found under this path since their
> > inclusion (April 2010), so this patch fixes the unprecise "hidraw*" path
> > for them.
> >
> > The ABI has been unified while setting the LEDs and OLEDs. So Bluetooth
> > devices lost their own LED selector but use the USB sysfs attribute.
> > For OLEDs, Bluetooth devices handle only 1-bit images instead of 4 for USB.
> > The documentation has been updated to match this.
> >
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> Reviewed-by: Ping Cheng <pingc@wacom.com>

Applied, thank you.

-- 
Dmitry
