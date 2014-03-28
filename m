Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaC1QJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:09:30 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:37202 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbaC1QJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:09:28 -0400
Date: Fri, 28 Mar 2014 09:09:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Christopher Heiny <cheiny@synaptics.com>,
        Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Stephen Chandler Paul <thatslyude@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] Input: synaptics add manual min/max quirk
Message-ID: <20140328160924.GB22658@core.coreip.homeip.net>
References: <1394207364-4235-1-git-send-email-benjamin.tissoires@redhat.com>
 <20140328082949.GJ22093@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140328082949.GJ22093@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 01:29:50AM -0700, Dmitry Torokhov wrote:
> On Fri, Mar 07, 2014 at 10:49:24AM -0500, Benjamin Tissoires wrote:
> > The new Lenovo Haswell series (-40's) contains a new Synaptics touchpad.
> > However, these new Synaptics devices report bad axis ranges.
> > Under Windows, it is not a problem because the Windows driver uses RMI4
> > over SMBus to talk to the device. Under Linux, we are using the PS/2
> > fallback interface and it occurs the reported ranges are wrong.
> > 
> > Of course, it would be too easy to have only one range for the whole
> > series, each touchpad seems to be calibrated in a different way.
> > 
> > We can not use SMBus to get the actual range because I suspect the firmware
> > will switch into the SMBus mode and stop talking through PS/2 (this is the
> > case for hybrid HID over I2C / PS/2 Synaptics touchpads).
> > 
> > So as a temporary solution (until RMI4 land into upstream), start a new
> > list of quirks with the min/max manually set.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > CC: stable@vger.kernel.org
> 
> 
> Applied, thank you.

That was giving compiler errors when configured without synaptics
support so I had fiddle with the patch a bit. I'll take full
responsibility for any breakage ;)

Thanks.

-- 
Dmitry
