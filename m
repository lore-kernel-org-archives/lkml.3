Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbaHUXKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:10:44 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:65139 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaHUXKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:10:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140821080715.GE24090@localhost>
References: <1408533887-22727-1-git-send-email-daniel.baluta@intel.com>
	<1408533887-22727-2-git-send-email-daniel.baluta@intel.com>
	<20140821080715.GE24090@localhost>
Date: Fri, 22 Aug 2014 02:10:40 +0300
Message-ID: <CAE1zotJBB=wxx=v2_e4+O5KjBUhF++ER83rHO1R1zunDs7ksVg@mail.gmail.com>
Subject: Re: [PATCH 1/3] usb: add support for Diolan DLN-2 devices
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Daniel Baluta <daniel.baluta@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, wsa@the-dreams.de,
        linux-i2c@vger.kernel.org, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-gpio@vger.kernel.org, pratyush.anand@st.com, pebolle@tiscali.nl,
        Alan Stern <stern@rowland.harvard.edu>, matthew@mjdsystems.ca,
        lkml <linux-kernel@vger.kernel.org>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, jdelvare@suse.de,
        arnd@arndb.de, sjg@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 11:07 AM, Johan Hovold <johan@kernel.org> wrote:
> On Wed, Aug 20, 2014 at 02:24:45PM +0300, Daniel Baluta wrote:
>> From: Octavian Purdila <octavian.purdila@intel.com>
>>
>> This patch implements the USB part of the Diolan USB-I2C/SPI/GPIO
>> Master Adapter DLN-2. Details about the device can be found here:
>>
<snip>
>
> I think you want to implement this driver as an MFD driver, rather than
> invent your own module registration.
>

Hi Johan,

Thank you for the detailed reviewed. We will rewrite the drivers to
use the MFD interface and address the rest of your comments and we
will resubmit them next week.

Thanks,
Tavi
