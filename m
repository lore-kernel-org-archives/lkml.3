Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab3BUAWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 19:22:38 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34547 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3BUAWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 19:22:37 -0500
MIME-Version: 1.0
In-Reply-To: <20130221000649.GB14395@kroah.com>
References: <1361404671-11713-1-git-send-email-maxin.john@gmail.com>
	<20130221000649.GB14395@kroah.com>
Date: Thu, 21 Feb 2013 02:22:35 +0200
Message-ID: <CAMhs6YxGWaLgt58HeumVzstU=373WRYMTsf8uFKnQ9nEFboj7w@mail.gmail.com>
Subject: Re: [PATCH] tools: usb: ffs-test: Fix build failure
From: "Maxin B. John" <maxin.john@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: mina86@mina86.com, matt.fleming@intel.com, matthias.fend@wolfvision.net,
        balbi@ti.com, linux-usb@vger.kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Maxin B. John" <maxin.john@enea.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 21, 2013 at 2:06 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Feb 21, 2013 at 01:57:51AM +0200, maxin.john@gmail.com wrote:
>> From: "Maxin B. John" <maxin.john@enea.com>
>>
>> Fixes this build failure:
>> gcc -Wall -Wextra -g -lpthread -I../include -o testusb testusb.c
>> gcc -Wall -Wextra -g -lpthread -I../include -o ffs-test ffs-test.c
>> In file included from ffs-test.c:41:0:
>> ../../include/linux/usb/functionfs.h:4:39: fatal error:
>> uapi/linux/usb/functionfs.h: No such file or directory
>> compilation terminated.
>> make: *** [ffs-test] Error 1
>
> This is a build failure where, 3.8, or linux-next, or somewhere else?

It is in 3.8

> thanks,
>
> greg k-h

Best Regards,
Maxin
