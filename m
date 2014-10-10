Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaJJAZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 20:25:18 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64721 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaJJAZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 20:25:15 -0400
MIME-Version: 1.0
In-Reply-To: <20141009172120.GB2410@roeck-us.net>
References: <1412872877-1771-1-git-send-email-linux@roeck-us.net>
 <CACna6rzOeGcKrrftLx_3uWe_bAXQaQMmWb3wWHP0CjtdO8D0eg@mail.gmail.com>
 <5436C2B4.6030801@broadcom.com> <20141009172120.GB2410@roeck-us.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 10 Oct 2014 11:24:53 +1100
Message-ID: <CAGRGNgWWSX8rYatphNAmx+j3wZ7RAXgucUzi_7M6-3NeUjQDEg@mail.gmail.com>
Subject: Re: [PATCH] bcma: Add dependency on OF_ADDRESS
To: Guenter Roeck <linux@roeck-us.net>,
        sparclinux <sparclinux@vger.kernel.org>
Cc: Arend van Spriel <arend@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 10, 2014 at 4:21 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Thu, Oct 09, 2014 at 07:15:32PM +0200, Arend van Spriel wrote:
>> On 10/09/14 18:54, Rafał Miłecki wrote:
>> >On 9 October 2014 18:41, Guenter Roeck<linux@roeck-us.net>  wrote:
>> >>Commit 2101e533f41a ("bcma: register bcma as device tree driver")
>> >>introduces a hard dependency on OF_ADDRESS into the bcma driver.
>> >>OF_ADDRESS is specifically disabled for the sparc architecture.
>> >>This results in the following error when building sparc64:allmodconfig.
>>
>> Does this mean on sparc (using allmodconfig) you will get CONFIG_OF
>> and !CONFIG_OF_ADDRESS? Does that makes sense?
>>
>
> You tell me. From drivers/of/Kconfig:
>
> config OF_ADDRESS
>         def_bool y
>         depends on !SPARC
>         select OF_ADDRESS_PCI if PCI
>
> Presumably there is a reason to disable OF_ADDRESS for sparc.

Why not ask the sparclinux list? (CC'd)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
