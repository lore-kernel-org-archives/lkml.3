Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaFJVK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:10:58 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58653 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFJVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:10:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140609114222.GC9307@localhost>
References: <1402003746-6354-1-git-send-email-janne.kanniainen@gmail.com>
	<20140606094752.GB9307@localhost>
	<CAEEjW04UAsi7yOdmF3FZ3sLE7m7B-VAH0prDPYjaMXarAfNwcw@mail.gmail.com>
	<20140609114222.GC9307@localhost>
Date: Wed, 11 Jun 2014 00:10:55 +0300
Message-ID: <CAEEjW06BnCiLyDDL82fjhFtwg5LyaGzKP+swzLFNKKwmZcvViQ@mail.gmail.com>
Subject: Re: [PATCH v2] leds: USB: Add support for MSI GT683R led panels
From: Janne Kanniainen <janne.kanniainen@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Where did you get these (HID report) values from by the way?
>>
>> I got them by reverse engineering.
>
> Traffic sniffing?
>

Yes.


> In fact, it seems you can get away with not adding any locking here.
> Just do the (mutex) locking in gt683r_led_set (or gt683r_led_work).

Ok I will fix it.

Janne
