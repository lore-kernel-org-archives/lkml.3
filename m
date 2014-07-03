Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbaGCS21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:28:27 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63229 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaGCS2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-LBU72Z_dnV9XUyMTVgFF2C1xRhKNhC_cziO5GMx__zhA@mail.gmail.com>
References: <20140703082830.GB16590@localhost>
	<1404407829-1815-1-git-send-email-janne.kanniainen@gmail.com>
	<1404407829-1815-2-git-send-email-janne.kanniainen@gmail.com>
	<20140703174017.GP16590@localhost>
	<CAK5ve-LBU72Z_dnV9XUyMTVgFF2C1xRhKNhC_cziO5GMx__zhA@mail.gmail.com>
Date: Thu, 3 Jul 2014 21:28:23 +0300
Message-ID: <CAEEjW04+GAc_vXO_=UMzEmL4dLeKQ7jyFakYs=WsVmBLwYfcNw@mail.gmail.com>
Subject: Re: [PATCH 2/2 v6] HID: gt683r: move mode attribute to led-class devices
From: Janne Kanniainen <janne.kanniainen@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <greg@kroah.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-03 21:17 GMT+03:00 Bryan Wu <cooloney@gmail.com>:
> On Thu, Jul 3, 2014 at 10:40 AM, Johan Hovold <johan@kernel.org> wrote:
>> On Thu, Jul 03, 2014 at 08:17:09PM +0300, Janne Kanniainen wrote:
>>> Move led_mode attribute from HID device to led-class devices and rename
>>> it msi_mode. This will also fix race condition by using
>>
>> There's a typo here (s/msi_mode/mode) but perhaps Bryan can just fix
>> that up before applying?
>>
>>> attribute-groups.
>>>
>>> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
>>
>> Reviewed-by: Johan Hovold <johan@kernel.org>
>>
>> Otherwise both patches (v6) are ready to be merged, Bryan.
>>
>> Thanks, Janne!
>>
>
> No problem. I fixed the typo and merged it.
>
> Thanks,
> -Bryan

Thanks again to both of you!

Janne
