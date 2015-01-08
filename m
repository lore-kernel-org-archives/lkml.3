Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbbAHXkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 18:40:31 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53451 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbbAHXka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 18:40:30 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZq4r+3yLvumxM-+f-VyMCb-ZF8xE7_kOx7uAoxrPzpTw@mail.gmail.com>
References: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
	<1418302951-9309-3-git-send-email-octavian.purdila@intel.com>
	<CACRpkdZq4r+3yLvumxM-+f-VyMCb-ZF8xE7_kOx7uAoxrPzpTw@mail.gmail.com>
Date: Fri, 9 Jan 2015 12:40:28 +1300
Message-ID: <CAE1zotKu0f+169_WO3O=+Q1hpU_r-x60FLpJRWyd-na7B9T_VA@mail.gmail.com>
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

On Thu, Jan 1, 2015 at 9:56 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Dec 11, 2014 at 2:02 PM, Octavian Purdila
> <octavian.purdila@intel.com> wrote:
>
>> Use the irq_chip bus_sync_unlock method to update hardware registers
>> instead of scheduling work from the mask/unmask methods. This simplifies
>> a bit the driver and make it more uniform with the other GPIO IRQ
>> drivers.
>>
>> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
>
> Patch applied for fixes.
>

Hi Linus,

I don't see the patch applied, could you please consider it for the
-for-next branch?

Thanks,
Tavi
