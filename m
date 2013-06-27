Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3F0Ttc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:49:32 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:43334 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab3F0Tta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:49:30 -0400
MIME-Version: 1.0
In-Reply-To: <1990033.Jb3giURhtn@vostro.rjw.lan>
References: <1372331314-31010-1-git-send-email-naresh.bhat@linaro.org>
	<6743122.cV0P3hQa28@vostro.rjw.lan>
	<CAFoFrHaUbjHbvDDVO0+1j4WSTdhdrWF64MrNvzKNJXaLKSv_jw@mail.gmail.com>
	<1990033.Jb3giURhtn@vostro.rjw.lan>
Date: Fri, 28 Jun 2013 01:19:30 +0530
Message-ID: <CAFoFrHba+O0OL8YNAedXGoY=_LsnuH-NfHJ5iLO20g_P3tX-JQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI/fan: Initialize acpi_state variable
From: Naresh Bhat <naresh.bhat@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, len.brown@intel.com,
        Patch Tracking <patches@linaro.org>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done.

Thank you very much

-Naresh Bhat

On 28 June 2013 00:59, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, June 27, 2013 06:37:35 PM Naresh Bhat wrote:
>> Hi Rafael,
>>
>> You mean I need to initialize using ACPI_STATE_D0 ? and resend the patch ?
>
> Yes, please.
>
> Although this is a false positive anyway ...
>
> Thanks,
> Rafael
>
>
>> On 27 June 2013 17:58, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Thursday, June 27, 2013 04:38:34 PM naresh.bhat@linaro.org wrote:
>> >> From: Naresh Bhat <naresh.bhat@linaro.org>
>> >>
>> >>   CC      drivers/acpi/fan.o
>> >> drivers/acpi/fan.c: In function ‘fan_get_cur_state’:
>> >> drivers/acpi/fan.c:96:9: warning: ‘acpi_state’ may be used uninitialized in this function [-Wuninitialized]
>> >> ---
>> >>  drivers/acpi/fan.c |    2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
>> >> index f815da8..f61f7fd 100644
>> >> --- a/drivers/acpi/fan.c
>> >> +++ b/drivers/acpi/fan.c
>> >> @@ -84,7 +84,7 @@ static int fan_get_cur_state(struct thermal_cooling_device *cdev, unsigned long
>> >>  {
>> >>       struct acpi_device *device = cdev->devdata;
>> >>       int result;
>> >> -     int acpi_state;
>> >> +     int acpi_state = 0;
>> >
>> > Please use an appropriate symbol here.
>> >
>> >>
>> >>       if (!device)
>> >>               return -EINVAL;
>> >>
>> >
>> > Thanks,
>> > Rafael
>> >
>> >
>> > --
>> > I speak only for myself.
>> > Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
