Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbaJ2Ol7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:41:59 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35021 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870AbaJ2Ol6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:41:58 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1410291048320.20256@pobox.suse.cz>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
	<alpine.LNX.2.00.1410011016160.26311@pobox.suse.cz>
	<20141001131008.GB18756@mail.corp.redhat.com>
	<CAG_cf+fYGATBL9Sgvvp7CaScP112fiqiyuR0gBdkS-424S3Kog@mail.gmail.com>
	<alpine.LNX.2.00.1410031308360.14259@pobox.suse.cz>
	<CAN+gG=GET=FLmte9kQOtS+x=HPaTdgEu4HxuydHXBx1GZksNRw@mail.gmail.com>
	<alpine.LNX.2.00.1410291048320.20256@pobox.suse.cz>
Date: Wed, 29 Oct 2014 10:41:57 -0400
Message-ID: <CAN+gG=GXHUFz7y1AFyPcV2YP6dYzd-CBStJf5UAENbrpnVuOJg@mail.gmail.com>
Subject: Re: [PATCH 00/13] HID: add support of Logitech touchpads and special devices
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew de los Reyes <andrew-vger@gizmolabs.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 5:49 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 28 Oct 2014, Benjamin Tissoires wrote:
>
>> >> I've tested these patches successfully on a Chromebook Pixel with the
>> >> following devices:
>> >>
>> >> - T650 touchpad
>> >> - TK820 keyboard/touchpad
>> >> - Original WTP touchpad
>> >>
>> >> I also tested a touch mouse and as expected it continued to function
>> >> as a plain USB mouse. The TK820 was indeed broken into two devices,
>> >> with autorepeat enabled for the keyboard only. The other two devices
>> >> behaved as expected with no perceived regressions.
>> >>
>> >> In short, from a functionality perspective I'm happy with these
>> >> patches. I will let others discuss code structure.
>> >
>> > Thank you. Can I use
>> >
>> >         Tested-by: Andrew de los Reyes <andrew-vger@gizmolabs.org>
>> >
>> > once / if I am merging this patchset?
>> >
>>
>> I am pretty sure this is not required too, but I am raising this one
>> again in Jiri's pile of things to review.
>> Sorry Jiri, I did not forget about it :)
>
> It absolutely hasn't been forgotten, I've been just a bit busy during past
> weeks.

No worries. I definitively understand. Being close to the merge window
is never a good time to send you patches and I am sure SuSE asks you a
lot also :)

>
> I am almost done with the review, expect to hear from me in a 1-2 days
> timeframe regarding this series.

Cool, thanks. That is much appreciated.

Cheers,
Benjamin
