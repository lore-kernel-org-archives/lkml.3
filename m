Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3A2MBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:01:05 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:60002 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab3A2MBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:01:01 -0500
MIME-Version: 1.0
In-Reply-To: <2944580.3eEfUK6kfJ@linux-5eaq.site>
References: <1359456765-7335-1-git-send-email-gautam.vivek@samsung.com>
	<2944580.3eEfUK6kfJ@linux-5eaq.site>
Date: Tue, 29 Jan 2013 17:31:00 +0530
Message-ID: <CAFp+6iGpbSmCsdFVzk1W+cKXMzzUtnreP+bTCab7xOtBs60tXg@mail.gmail.com>
Subject: Re: [PATCH] usb: ehci: s5p: Power-off VBUS during suspend.
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        jg1.han@samsung.com, Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,


On Tue, Jan 29, 2013 at 5:07 PM, Oliver Neukum <oneukum@suse.de> wrote:
> On Tuesday 29 January 2013 16:22:45 Vivek Gautam wrote:
>> This change de-asserts vbus_gpio on suspend and
>> re-asserts on resume in order to save power.
>> NOTE, this change means no USB charging in suspend
>> mode.
>
> What happens if a device on the bus is a source of wakeups?
>

The device will not be powered in suspend state,
so the corresponding wakeup will get missed ?


>         Regards
>                 Oliver
>



-- 
Thanks & Regards
Vivek
