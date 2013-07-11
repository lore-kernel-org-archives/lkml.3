Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3GKKaC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:30:02 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:52169 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3GKKaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:30:00 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1307092236140.26857@pobox.suse.cz>
References: <1315638713-3731-1-git-send-email-benjamin.tissoires@gmail.com>
	<20110910072826.GA1611@x4.trippels.de>
	<CAN+gG=H2jfT2zdn5H19hyn9JtDU7U1ensX_aUDgv0jk4d81jXg@mail.gmail.com>
	<CAN+gG=E90-y--6C-Ok8TibcFZGAaL2X-KxnchquDLCUUniip1Q@mail.gmail.com>
	<alpine.LNX.2.00.1306271513180.3538@pobox.suse.cz>
	<CAE7qMrosUkhF3Yak11Mh81NcGhYduUKRoHiUwH4RbTN1KXqi8A@mail.gmail.com>
	<CAN+gG=HNSzg_W-26vMb2seWNU+QcO3+wv4Z1AmZ36LqPhbzdEg@mail.gmail.com>
	<alpine.LNX.2.00.1307092236140.26857@pobox.suse.cz>
Date: Thu, 11 Jul 2013 12:29:59 +0200
Message-ID: <CAN+gG=G5CFQ+qxrPPBvQn7p+6ggOv_bOYXasFbYqDKXdJq7ifg@mail.gmail.com>
Subject: Re: Logitech M705: Thumb button (was Re: [PATCH v4] HID: Add full
 support for Logitech Unifying receivers)
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Richard Titmuss <rtitmuss@logitech.com>,
        Olivier Gay <ogay@logitech.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Franti=C5=A1ek_Fuka?= <fuka@fuxoft.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 10:41 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 9 Jul 2013, Benjamin Tissoires wrote:
>
>> For those who wants to try, I have set up a project [1] to implement
>> part of the spec Nestor released. I implemented various features: list
>> devices paired to a receiver, pair/unpair a device, and toggle the
>> button 6 on M705 mouse with the faulty firmware. When switching mode for
>> the M705, as Nestor said, we lose the AC panning ability until the
>> correct remapping is done in the kernel.
>>
>> Cheers,
>> Benjamin
>>
>> [1] https://github.com/bentiss/uLogitech
>
> Thanks for your work on this, Benjamin.
>
> I have a followup question -- why not do this in the kernel completely
> though? I have actually been asked by Linus directly (so we'd rather do
> that :) ) to include pairing trigger as a sysfs toggle instead of having
> to use userspace utilitites, and it actually makes sense to me.

yep, the sysfs toggle for the pairing makes sense. In the same way, we
should retrieve the actual name of the device instead of building a
complex string "Logitech Unifying Device. Wireless PID:XXXX"...
And for the M705, it really should be implemented in the kernel (I
guess it will not be a lot of effort).

>
> Are you aware of any particular reason to not have all that's provided by
> uLogitech in the kernel?

I'm afraid the very first reason is that we (Nestor or myself) don't
have much allowed time to implement it properly in the kernel... :(
Nestor is working on other projects, and for me, I did not had any
customer requests for it in RHEL nor Fedora.

Cheers,
Benjamin
