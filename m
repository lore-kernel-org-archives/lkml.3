Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3IKMXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:23:20 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:53742 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3IKMXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:23:19 -0400
Message-ID: <523060B4.5080109@linaro.org>
Date: Wed, 11 Sep 2013 08:23:16 -0400
From: Matt Porter <matt.porter@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@inai.de>
CC: Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Introducing libgadget 0.0.1
References: <20130904172532.GA10973@ohporter.com> <alpine.LSU.2.11.1309110940430.29134@nerf07.vanv.qr>
In-Reply-To: <alpine.LSU.2.11.1309110940430.29134@nerf07.vanv.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 03:42 AM, Jan Engelhardt wrote:
> On Wednesday 2013-09-04 19:25, Matt Porter wrote:
>
>> With the move to configfs for creation of arbitrary USB composite gadgets,
>> I found myself wanting a simple C library to configure and parse gadgets
>> in a system. It has no other dependencies other than libc itself.
>>
>> It can be found at:
>>
>> 	git://git.linaro.org/people/mporter/libgadget.git
>
> Hm but there is already a libgadget (and not just one) if you query a
> particular search engine entitled Google :}

Yes, looked a bit at this before and both were seemingly defunct. 
However, to avoid confusion, the 0.0.2 release is becoming libusbg.

>
>> $ mkdir /config
>> $ mount -t configfs none /config
>
> Do your tools support input of a different location?
> (systemd mounts configfs at /sys/kernel/config.)
>
>> $ gadget-acm-ecm
>> $ show-gadgets
>> ID 1d6b:0104 'g1'
>> [...]
>

Also being addressed in 0.0.2. One of my test platforms is now using a 
systemd-based rootfs so it became readily apparent. Hopefully I'll have 
that release tagged in a few days.

Thanks for taking a look!

-Matt
