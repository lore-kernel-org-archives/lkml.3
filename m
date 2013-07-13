Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab3GMW0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 18:26:19 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:48243 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3GMW0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 18:26:18 -0400
Message-ID: <51E1D406.9090702@cogentembedded.com>
Date: Sun, 14 Jul 2013 02:26:14 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] misc: add driver for Renesas R-Car Gyro-ADC/speed-pulse
 interfaces
References: <201307130351.42967.sergei.shtylyov@cogentembedded.com> <20130713005702.GA14788@kroah.com> <51E0AA24.6070203@cogentembedded.com> <201307130958.16533.arnd@arndb.de>
In-Reply-To: <201307130958.16533.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/13/2013 11:58 AM, Arnd Bergmann wrote:

>>> And are you sure you want to control this through sysfs?  There's no
>>> other better user/kernel apis for it?

>>      I found none, besides ioctl(), as the device driven is rather
>> unique. But I thought that sysfs is "ioctl() today", so I went with it...

> It does sound like it would fit better into IIO than just a misc driver,
> even if it's the only hardware of its kind.

    I got somewhat familiarized myself with drivers/iio/ infrastructure 
and I have found a place only the for ADC device in which the customer 
currently has no interest.
    The other trouble is that I'll have to backport this driver to 3.4 
which doesn't contain the IIO infrastructure at all. :-(

> 	Arnd

WBR, Sergei


