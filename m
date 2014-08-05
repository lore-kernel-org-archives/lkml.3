Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaHEPxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:53:33 -0400
Received: from si-002-i47.relay.mailchannels.net ([184.154.112.221]:51354 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753119AbaHEPxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:53:31 -0400
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-MC-Relay: Good
X-MailChannels-SenderId: arvixe|x-authuser|przemo@firszt.eu
X-MailChannels-Auth-Id: arvixe
Date: Tue, 05 Aug 2014 15:53:22 +0000
Message-ID: <20140805155322.Horde.z62yLr1B-ZT7v4rMGcPaVA9@webmail.firszt.eu>
From: Przemo Firszt <przemo@firszt.eu>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input - wacom: update the ABI doc according to latest
 changes
References: <1407252899-10293-1-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1407252899-10293-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Internet Messaging Program (IMP) H5 (6.1.4)
Accept-Language: en,pl
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-AuthUser: przemo@firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Benjamin Tissoires <benjamin.tissoires@redhat.com>:

> Now the devices show up under hid no matter the connection. So update the
> sysfs path to the shortest and common one.
> The ABI has also been unified regarding the OLEDs, but Bluetooth handle
> only 1-bit images instead of 4.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>
> Guys,
>
> by updating this and working on the g-s-d client side for OLEDs, I think now
> that we should also keep the oled*_img for Bluetooth and implement this file
> for USB too. The user space code gets messy quite fast due to the need to
> support old and new kernels, whereas if we handle the scrambling in  
> the kernel,
> it should be quite straightforward.
> Of course, we have to keep the current button<n>_rawimg for backward
> compatibility.
[..]
Hi Benjamin,
For whatever it's worth, you have my vote for scrambling for usb/bt in  
the kernel.
I'm not sure about requirement for backward compatibility (the user space will
be broken anyway).

I proposed it a while ago [1]

[1] http://www.gossamer-threads.com/lists/linux/kernel/1593583

Regards,
Przemo Firszt

