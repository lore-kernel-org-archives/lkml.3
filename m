Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561AbaLEDKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:10:52 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53774 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaLEDKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:10:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141203131240.GD75099@vmdeb7>
References: <1417675325-14921-1-git-send-email-coproscefalo@gmail.com>
	<1417675325-14921-3-git-send-email-coproscefalo@gmail.com>
	<20141203131240.GD75099@vmdeb7>
Date: Thu, 4 Dec 2014 20:10:49 -0700
Message-ID: <CAGdLNWFpvSLZorQ6WNpEBZ+rkxcP7CR0vxtW4ugmyxojNRWLVg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] toshiba_acpi: Change notify funtion to handle more events
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

2014-12-03 6:12 GMT-07:00 Darren Hart <dvhart@infradead.org>:
> On Wed, Dec 03, 2014 at 11:42:04PM -0700, Azael Avalos wrote:
>> @@ -1971,41 +2008,22 @@ error:
>>  static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
>>  {
>>       struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
>> -     u32 hci_result, value;
>> -     int retries = 3;
>> -     int scancode;
>> -
>> -     if (event != 0x80)
>> -             return;
>> +     int ret;
>
>   CC      drivers/platform/x86/toshiba_acpi.o
> drivers/platform/x86/toshiba_acpi.c: In function ‘toshiba_acpi_notify’:
> drivers/platform/x86/toshiba_acpi.c:2012:6: warning: unused variable ‘ret’ [-Wunused-variable]
>     int ret;
>           ^
>
> Please compile check each patch.

Sorry about that, was a left over from the split.
Want me to send a V3? I can send them in few minutes.

>
> --
> Darren Hart
> Intel Open Source Technology Center



-- 
-- El mundo apesta y vosotros apestais tambien --
