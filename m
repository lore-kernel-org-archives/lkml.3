Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbbAKL0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 06:26:14 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:48354 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbbAKL0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 06:26:12 -0500
MIME-Version: 1.0
In-Reply-To: <s5h8uh94nce.wl-tiwai@suse.de>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
	<s5h8uh94nce.wl-tiwai@suse.de>
Date: Sun, 11 Jan 2015 11:26:12 +0000
Message-ID: <CAJSP0QVc2VkxNZ0AOx+LQZ=_z_bYEfEVvYQ0tnCbfP6FvErFsw@mail.gmail.com>
Subject: Re: [PATCH 00/25] line6usb cleanup
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Chris Rorvick <chris@rorvick.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?Q?L=2E_Alberto_Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 10:34 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri,  9 Jan 2015 23:35:46 -0600,
> Chris Rorvick wrote:
>>
>> The line6usb driver references the device's idProduct and, in some
>> cases, the interface number in a number of places to determine device-
>> specific configuration values and to call device-specific functionality.
>> Rework code to leverage the device table matching more effectively.
>> Consolidate configuration settings into the properties entries and use
>> function pointers setup at initialization to remove much of the
>> conditional logic.
>>
>> I have a TonePort UX2 that I've used for testing, meaning that some of
>> this is really only compile-tested.
>
> BTW, are there any active developers for this driver?  It doesn't make
> sense to sit in staging directory forever.  It should be promoted to
> the official sound directory, or dropped from the kernel tree if not.
> If anyone is responsible for testing with real hardware, I'll happily
> review.

I am not active but willing to help with review and advice if anyone
wants to tackle this driver.

Stefan
