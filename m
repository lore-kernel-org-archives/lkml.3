Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaIJP2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:28:48 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:56241 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaIJP2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140910033520.GC39541@vmdeb7>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
	<1409937247-2525-4-git-send-email-coproscefalo@gmail.com>
	<20140906024253.GB11389@vmdeb7>
	<CAGdLNWGhdQU3Fpud9Zgvx3AQ5Lb=WdEkJb_wWTb1hJoHxXPXpQ@mail.gmail.com>
	<20140909000429.GB5835@vmdeb7>
	<20140909013553.GC16363@kroah.com>
	<20140910033520.GC39541@vmdeb7>
Date: Wed, 10 Sep 2014 09:28:44 -0600
Message-ID: <CAGdLNWEgJmNQ_F7kozn4tGCq_AseuE95xHKoxTWgtNqdBwSm5A@mail.gmail.com>
Subject: Re: [PATCH 3/5] toshiba_acpi: Add accelerometer input polled device
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-iio@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

2014-09-09 21:35 GMT-06:00 Darren Hart <dvhart@infradead.org>:
>
> I immediately went to a tablet with a marble maze game and it didn't seem too
> crazy, but I don't suppose that is what people are actually doing with it...
>
> What are people actually doing with this thing Azael?

Gaming mostly (supertuxkart anyone?), but some others (including myself)
want to use it as a movement detection (one exists for the IBM/Lenovo
Thinkpads).

Digging into platform drivers, I've found that the hdaps and also the lis3lv02d
drivers report the axes via polldev, and since I don't want to break userspace,
I'm left with two choices:

1 - Keep sysfs entry and adapt it to properly report direction, and no
polled device.

2 - Keep sysfs entry and adapt it to properly report direction, and also
a polled device.

Let me know your decision so I can send an updated patch.

>
> --
> Darren Hart
> Intel Open Source Technology Center

Cheers
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
