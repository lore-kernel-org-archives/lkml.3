Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3LSQls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:41:48 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:48486 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab3LSQlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:41:46 -0500
MIME-Version: 1.0
In-Reply-To: <20131219163623.GB12255@kroah.com>
References: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
	<20131219163623.GB12255@kroah.com>
Date: Thu, 19 Dec 2013 22:11:45 +0530
Message-ID: <CAMpEsFGi7hj8EXUJ78zS0g6ZWRTW5FpGD5Q7tz1DgEJSNAWSZQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] drivers: usb: Include appropriate header file in hcd.c
From: Rashika Kheria <rashika.kheria@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthias Beyer <mail@beyermatthias.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 10:06 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Dec 19, 2013 at 03:36:00PM +0530, Rashika Kheria wrote:
>> Include appropriate header file include/linux/usb/otg.h in core/hcd.c
>> because function usb_bus_start_enum() has its prototype declaration in
>> include/linux/usb/otg.h.
>>
>> This eliminates the following warning in core/hcd.c:
>> drivers/usb/core/hcd.c:2295:5: warning: no previous prototype for ‘usb_bus_start_enum’ [-Wmissing-prototypes]
>
> What is generating this warning?  I don't see it here on my machines,
> nor do I see any of the other warnings you have fixed in this series.
> How do I duplicate them?
>
> thanks,
>
> greg k-h

Hi Greg,

These warning are non-default GCC warnings. These can be seen either
by adding W=1 while running make (i.e. make W=1) or adding
-Wmissing-prototypes in KBUILD_CFLAGS in the toplevel Makefile.

Thanks,
-- 
Rashika Kheria
B.Tech CSE
IIIT Hyderabad
