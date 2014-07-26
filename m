Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaGZKJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 06:09:49 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:35833 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaGZKJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 06:09:47 -0400
Date: Sat, 26 Jul 2014 11:09:35 +0100 (BST)
From: Jamie Lentin <jm@lentin.co.uk>
X-X-Sender: lentinj@marmot.wormnet.eu
To: Antonio Ospite <ao2@ao2.it>
cc: Jiri Kosina <jkosina@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] HID: lenovo: Add support for Lenovo Compact
 Keyboard
In-Reply-To: <20140725160527.13cbeae1108fce5e09b6daae@ao2.it>
Message-ID: <alpine.DEB.2.02.1407261047480.24969@marmot.wormnet.eu>
References: <1406154648-14000-1-git-send-email-jm@lentin.co.uk> <20140725160527.13cbeae1108fce5e09b6daae@ao2.it>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, Antonio Ospite wrote:

> On Wed, 23 Jul 2014 23:30:44 +0100
> Jamie Lentin <jm@lentin.co.uk> wrote:
>
>> This patchset follows on from my previous attempts to add support for
>> these keyboards from Lenovo.
>>
>> Antonio, I've used cptkbd_data and left data_pointer for now. It'd be
>> an easy patch to change data_pointer to tpkbd_data, but is drifting
>> away from what this patchset is supposed to do. Could send that
>> afterwards though.
>>
>
> Sure, no problem. I think we are good to go.
>
> BTW I was considering picking up one of such compact keyboards myself,
> but I read that the BT one uses the USB cable only for charging
> and it does not show as a USB HID device when plugged in, can you
> confirm that?

Yes, nothing happens over USB other than charging. It's slightly 
irritating since I have to keep something else to hand for booting, or try 
and get a dongle that goes into a HID proxy mode.

That said, I quite like it as a keyboard and happily use it for working 
all day. Interestingly the bluetooth version is nicer to type on than the 
USB version, even though they look physically identical. This could be 
they came from different batches rather than using better keys for the 
Bluetooth version.

> Thanks,
>   Antonio
