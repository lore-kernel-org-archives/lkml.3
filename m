Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaCFGTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:19:18 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:37537 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaCFGTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:19:17 -0500
MIME-Version: 1.0
In-Reply-To: <20140304192014.GA28665@kroah.com>
References: <1393960599-21379-1-git-send-email-valentina.manea.m@gmail.com>
	<20140304192014.GA28665@kroah.com>
Date: Thu, 6 Mar 2014 08:14:01 +0200
Message-ID: <CABdoFFdXzRE7wnkmwFo7Dt6vzM8KtunGo-vtOTTszekDfAOMVA@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: userspace: increase version to 2.0
From: Valentina Manea <valentina.manea.m@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>, Andy Grover <andy.grover@gmail.com>
Cc: devel@driverdev.osuosl.org, shuah.kh@samsung.com,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        tobias.polzer@fau.de, linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        dominik.paulus@fau.de, ihadzic@research.bell-labs.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 9:20 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Mar 04, 2014 at 09:16:39PM +0200, Valentina Manea wrote:
>> Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
>> ---
>>  drivers/staging/usbip/userspace/configure.ac | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
>> index 25bf160..607d05c 100644
>> --- a/drivers/staging/usbip/userspace/configure.ac
>> +++ b/drivers/staging/usbip/userspace/configure.ac
>> @@ -1,7 +1,7 @@
>>  dnl Process this file with autoconf to produce a configure script.
>>
>>  AC_PREREQ(2.59)
>> -AC_INIT([usbip-utils], [1.1.1], [linux-usb@vger.kernel.org])
>> +AC_INIT([usbip-utils], [2.0], [linux-usb@vger.kernel.org])
>
> Why?
>
> What does this mean?  What warrents the version change?  Why have a
> version at all?
>
> thanks,
>
> greg k-h

This was part of an effort to "refresh" USB/IP by moving userspace out
of kernel.git.
Since some major changes have been made (libudev migration), Andy (cc'ed) and me
thought it was worth to be promoted to version 2.0.

Thanks,
Valentina
