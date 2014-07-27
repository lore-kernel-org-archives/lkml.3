Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaG0BtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 21:49:23 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:48699 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaG0BtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 21:49:22 -0400
MIME-Version: 1.0
In-Reply-To: <53D3672A.20206@roeck-us.net>
References: <CAPDOMVjiT8JKyzLdcFpVVC337p9nC=V66MjePk+1KwNm3owZQg@mail.gmail.com>
	<53D3672A.20206@roeck-us.net>
Date: Sat, 26 Jul 2014 21:49:21 -0400
Message-ID: <CAPDOMVjMs=y6QpnFSW5uwAmT6meALsmdBHJq7VVk6YJ7U4ZSrQ@mail.gmail.com>
Subject: Re: Bug on Boot of Ubuntu 14.04 with kernel 3.16 r6 release
From: Nick Krause <xerofoify@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 4:30 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 07/25/2014 06:34 PM, Nick Krause wrote:
>>
>> Hey Guys,
>> After building my first rc kernel. I am sad to state it doesn't
>> boot.It states that it can't find my root uuid for my ssd boot drive.
>> I am using GSP with UEFI, on a Sandy Bridge i5 2500k build I have  had
>> for a few years. The kernel boots and after a few seconds
>> drops to a busybox ash shell stating it can't find my root device. I
>> am using the default Ubuntu build for this and it did boot
>> before with x86_64 defconfig without my sound through. Seems to me an
>> issue with the Ubuntu built kernel and not upstream
>> at least from what I can tell. I will attach my .config to help
>> through or my sound drivers.
>
>
> I'd put in a wild guess that you did not install a matching initramfs.
>
> Guenter
>
Guenter,
Thanks your probably right there.
Cheers Nick
