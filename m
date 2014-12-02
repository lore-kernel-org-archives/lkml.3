Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbaLBRb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:31:27 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55004 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaLBRbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:31:25 -0500
Message-ID: <547DF76A.4090302@googlemail.com>
Date: Tue, 02 Dec 2014 18:31:22 +0100
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression: suspend to ram completely broken since at least 3.13-rc5,
 works with 3.12.
References: <54624E40.30802@googlemail.com> <20141202144615.GA3178@xo-6d-61-c0.localdomain>
In-Reply-To: <20141202144615.GA3178@xo-6d-61-c0.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.12.2014 um 15:46 schrieb Pavel Machek:
> Hi!
>
>> with kernel 3.12.X with X tested up to .23 suspend to ram works
>> flawlessly. My machine suspends quickly and wakes up reliably, giving me
>> uptimes measured in weeks.
>>
>> Every kernel I tried between 3.13.0-rc5 and 3.16.7 on the other hand
>> shows this behaviour:
>>
>> IF suspend works it takes ages. Video blanks quickly, harddisks are
>> turned off, then it is stuck for a long time (more minute than tens of
>> seconds), and at some point suspends.
>>
>> Afterwards there is a 50% chance it will wake up. In that case: nothing
>> in dmesg.
>> If it does not wake up on pressing any button, I have to press power
>> button for a nice cold boot.
>>
>> Even if it does suspend and resume successfully, it will NOT suspend the
>> next time. Never.
>>
>> The much more likely failure mode looks like this:
>> It will blank video and turn of harddisks and then nothing happens. usb
>> dead, ps2 keyboard dead, no harddisk activity, fans are spinning,
>> mainboard is powered - and nothing happens. I can turn off or hit reset
>> button.
>>
>> Of course, after a reboot nothing will show up in the logs.
>>
>> So this is a severe regression. Box worked, it stopped working.
> Any chance to do a bisect? Any chance to try with minimum drivers?
>
> 								Pavel
>

hadn't had the time yet. Will do the bisect run this weekend.

Glück Auf,

Volker

