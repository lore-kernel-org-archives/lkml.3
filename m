Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935195AbaKNKFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:05:08 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:56193 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838AbaKNKFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:05:01 -0500
MIME-Version: 1.0
In-Reply-To: <20141110174355.GM24004@x1>
References: <1415281685-14866-1-git-send-email-octavian.purdila@intel.com>
	<20141110151226.GD24004@x1>
	<20141110160426.GK24004@x1>
	<20141110174355.GM24004@x1>
Date: Fri, 14 Nov 2014 11:05:00 +0100
Message-ID: <CACRpkdYrwrjh5RztNSo+owCp8Kf=tVb0V-08dhzMO3zbR7hFNQ@mail.gmail.com>
Subject: Re: [GIT PULL] Immutable branch between MFD, GPIO and I2C
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Johan Hovold <johan@kernel.org>,
        Daniel Baluta <daniel.baluta@intel.com>, laurentiu.palcu@intel.com,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 6:43 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> Please don't pull this -- it is missing a patch.
>>
>> Will fix.
>
> Okay, dependency fixed.  Sorry for the fuss.  Pull when ready.

Letting it just sit around unless there are conflicts coming up...
Seems like this can go through MFD alone from the GPIO side
of things.

Yours,
Linus Walleij
