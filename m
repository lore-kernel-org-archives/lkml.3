Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbbAJI6D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 03:58:03 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:35050 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbAJI6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 03:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdY-pW98cymyAKpV4s8x00e-7MPksMX1_0Tj+1QT3WskMw@mail.gmail.com>
References: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
	<1418302951-9309-3-git-send-email-octavian.purdila@intel.com>
	<CACRpkdZq4r+3yLvumxM-+f-VyMCb-ZF8xE7_kOx7uAoxrPzpTw@mail.gmail.com>
	<CAE1zotKu0f+169_WO3O=+Q1hpU_r-x60FLpJRWyd-na7B9T_VA@mail.gmail.com>
	<CACRpkdY-pW98cymyAKpV4s8x00e-7MPksMX1_0Tj+1QT3WskMw@mail.gmail.com>
Date: Sat, 10 Jan 2015 21:57:59 +1300
Message-ID: <CAE1zot+FF-6TVJKaqmQ0Shouhtvo0eWytxGJG1VgqWFAen5JZg@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio: dln2: use bus_sync_unlock instead of scheduling work
From: Octavian Purdila <octavian.purdila@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 7:58 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Jan 9, 2015 at 12:40 AM, Octavian Purdila
> <octavian.purdila@intel.com> wrote:
>> On Thu, Jan 1, 2015 at 9:56 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> On Thu, Dec 11, 2014 at 2:02 PM, Octavian Purdila
>>> <octavian.purdila@intel.com> wrote:
>>>
>>>> Use the irq_chip bus_sync_unlock method to update hardware registers
>>>> instead of scheduling work from the mask/unmask methods. This simplifies
>>>> a bit the driver and make it more uniform with the other GPIO IRQ
>>>> drivers.
>>>>
>>>> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
>>>
>>> Patch applied for fixes.
>>>
>>
>> Hi Linus,
>>
>> I don't see the patch applied, could you please consider it for the
>> -for-next branch?
>
> Ah sorry I thought only the first patch was a critical fix.
> Applied this to fixes too now. Working on queueing the
> GPIO fixes.

Hi Linus,

Its not a critical fix, its just a clean-up. I thought it would go in
the the for-next branch (for 3.20) and since I did not see it there I
thought it got lost.

Sorry for any confusion I may have caused, I am not familiar with the
GPIO branch work-flow.
