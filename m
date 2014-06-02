Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaFBQJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:09:40 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:52641 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaFBQJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:09:39 -0400
Message-ID: <538CA1C0.1080205@mutualink.net>
Date: Mon, 02 Jun 2014 12:09:36 -0400
From: Mike Remski <mremski@mutualink.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: ftdi_sio BUG: NULL pointer dereference
References: <538C8963.4010909@mutualink.net> <20140602143347.GA1902@localhost> <538C953B.9020304@mutualink.net> <20140602154036.GA8662@localhost>
In-Reply-To: <20140602154036.GA8662@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 11:40 AM, Johan Hovold wrote:
> [ Please avoid top-posting. ]
>
> On Mon, Jun 02, 2014 at 11:16:11AM -0400, Mike Remski wrote:
>> Thanks Johan, that's why I looked at the cross references for ftdi_sio.c
>> over on
>> http://lxr.free-electrons.com/source/drivers/usb/serial/ftdi_sio.c,
>> latest version it's showing is 3.14.  It appears that the ftdi_sio code
>> is largely the same as in 2.6.32, particularly in the
>> ftdi_set_max_packet_size() function.
> Lots of things have changed since v2.6.32 and not just in the driver
> itself but in all the infrastructure it relies on.
>
>> I'm trying to verify if the "number of endpoints is 0" is a valid
>> situation.
> No, that is not normal, but it should not crash the driver if it's a
> hardware issue. What is the lsusb -v output of your device (make sure
> the ftdi_sio driver isn't loaded when connecting the device).
>
> And what happens if you plug it into a machine running a recent kernel?
>
> Thanks,
> Johan
Plugging device into a system running Redhat, kernel 3.3.4 crashes the 
system.

-- 
Office: (978)401-4032 (x123 internally)
Cell: (603) 759-6953

