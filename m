Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab3ARKmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 05:42:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab3ARKmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 05:42:09 -0500
Date: Fri, 18 Jan 2013 11:42:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] HID: i2c-hid: add ACPI support
In-Reply-To: <CAN+gG=GBYbCxrOKk2S1n9K2e68Rbxvt4CuoV40NJiE9LDNR=Zw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1301181141400.8266@pobox.suse.cz>
References: <1357742588-11366-1-git-send-email-mika.westerberg@linux.intel.com> <CAN+gG=GrrEdgrCLXvO=xJ6SNeKgHFRobq6RSAfLMfesKkJcijA@mail.gmail.com> <alpine.LNX.2.00.1301091551580.12134@pobox.suse.cz>
 <CAN+gG=GBYbCxrOKk2S1n9K2e68Rbxvt4CuoV40NJiE9LDNR=Zw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Benjamin Tissoires wrote:

> >> > The HID over I2C protocol specification states that when the device is
> >> > enumerated from ACPI the HID descriptor address can be obtained by
> >> > executing "_DSM" for the device with function 1. Enable this.
> >> >
> >> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >>
> >> I'm eager to test it (hopefully next week).
> >>
> >> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > Perfect. I will wait for your Tested-by: as well before applying to public
> > git tree.
> 
> Hi Jiri,
> 
> well, we tried yesterday to make all those things working, but the
> Haswell platform I was able to have access was not very cooperative.
> So I wasn't able to test the whole autodetection mechanism through
> ACPI (I even not managed to communicate with the various HID over i2c
> devices that were available to test).
> 
> However, Mika managed to test this ACPI stuff, and he is able to
> retrieve the HID descriptor address. Given that, I think it's safe to
> include it right now. There will still be the last point with the
> gpios, but it will come when someone get access to a device presenting
> this feature.

Thanks a lot for the update. I have now applied Mika's patch.

-- 
Jiri Kosina
SUSE Labs
