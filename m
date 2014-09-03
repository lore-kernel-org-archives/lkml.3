Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaICTcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:32:10 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36727 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaICTcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:32:08 -0400
Message-ID: <54076CB2.6040004@suse.cz>
Date: Wed, 03 Sep 2014 21:32:02 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org
CC: satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 00/56] 3.12.28-stable review
References: <cover.1409735865.git.jslaby@suse.cz> <5407170F.2070701@roeck-us.net>
In-Reply-To: <5407170F.2070701@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014, 03:26 PM, Guenter Roeck wrote:
> On 09/03/2014 02:26 AM, Jiri Slaby wrote:
>> This is the start of the stable review cycle for the 3.12.28 release.
>> There are 56 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri Sep  5 11:17:45 CEST 2014.
>> Anything received after that time might be too late.
>>
> 
> Jiri,
> 
> I get a large number of build failures.
...
> In file included from drivers/usb/host/ohci-hcd.c:85:0:
> drivers/usb/host/ohci-dbg.c:411:20: error: conflicting types for
> 'ohci_dump'
> drivers/usb/host/ohci-hcd.c:81:13: note: previous declaration of
> 'ohci_dump' was here
> drivers/usb/host/ohci-hcd.c: In function 'ohci_run':
> drivers/usb/host/ohci-hcd.c:757:2: error: too few arguments to function
> 'ohci_dump'

Oh, !USB_DEBUG. It should be fixed, could you retry?

thanks,
-- 
js
suse labs
