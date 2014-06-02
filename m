Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbaFBPQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:16:17 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:41387 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbaFBPQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:16:14 -0400
Message-ID: <538C953B.9020304@mutualink.net>
Date: Mon, 02 Jun 2014 11:16:11 -0400
From: Mike Remski <mremski@mutualink.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: ftdi_sio BUG: NULL pointer dereference
References: <538C8963.4010909@mutualink.net> <20140602143347.GA1902@localhost>
In-Reply-To: <20140602143347.GA1902@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Johan, that's why I looked at the cross references for ftdi_sio.c 
over on
http://lxr.free-electrons.com/source/drivers/usb/serial/ftdi_sio.c, 
latest version it's showing is 3.14.  It appears that the ftdi_sio code 
is largely the same as in 2.6.32, particularly in the 
ftdi_set_max_packet_size() function.

I'm trying to verify if the "number of endpoints is 0" is a valid 
situation.

Just a typical day of "fun with kernels and devices".


On 06/02/2014 10:33 AM, Johan Hovold wrote:
> On Mon, Jun 02, 2014 at 10:25:39AM -0400, Mike Remski wrote:
>> Please CC me as not subscribed to list.
>> Third party device, with FTDI chip on it.  Get this when plugging device
>> in.  Discovered in kernel 2.6.32
> Wow, that kernel is ancient. Please upgrade to a more recent kernel such
> as v3.14.5, or you need to get support from whatever vendor is forcing
> you to use such an old kernel.
>
> Good luck,
> Johan


-- 
Office: (978)401-4032 (x123 internally)
Cell: (603) 759-6953

