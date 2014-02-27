Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaB0KME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:12:04 -0500
Received: from mail.active-venture.com ([67.228.131.205]:64583 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaB0KL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:11:59 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <530F0F6C.4040401@roeck-us.net>
Date: Thu, 27 Feb 2014 02:11:56 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The sheer number of sparse warnings in the kernel
References: <530E6F76.1070605@zytor.com> <20140226232859.GA9213@kroah.com> <530E82B2.3040305@zytor.com> <20140227013424.GA9991@kroah.com>
In-Reply-To: <20140227013424.GA9991@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> So getting this to the point where it is genuinely useful and can be
>> made a ubiquitous part of the Linux development process is going to take
>> more work and probably involve improvements to sparse so we can indicate
>> in the kernel sources when something is okay or removing completely
>> bogus warnings, and so on.
>
> Yes, for some areas of the kernel it will take some work, but for
> others, sparse works really well.  As an example, building all of

Works quite nicely for me. I run both spatch and smatch on drivers/hwmon
and (partially) on drivers/watchdog. There is only one (false) warning
in hwmon from spatch, plus about a dozen smatch warnings. I find it very
valuable; even if warnings are false positives they often point to
less than perfect code.

I filter out some noise from smatch, but at least so far I did not have
to do any filtering for spatch.

Guenter

