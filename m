Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab3BTFz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 00:55:59 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:58008 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab3BTFz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 00:55:57 -0500
MIME-Version: 1.0
In-Reply-To: <1361289343.16206.35.camel@anish-Inspiron-N5050>
References: <CAJ8diHTq6ayQjciiu_9fXyHYTk4DorT=5uw=759zHo7B81-e4w@mail.gmail.com>
	<CAJ8diHT5Ze3bsPGO7yLqPHu6niuDC_gtjJB=gKGoUXOfvoHtyw@mail.gmail.com>
	<1361289343.16206.35.camel@anish-Inspiron-N5050>
Date: Wed, 20 Feb 2013 11:25:57 +0530
Message-ID: <CAJ8diHSUhqgKugY3Yvnst_cPxdXHAXPWe-itGJjQOiztu-obhw@mail.gmail.com>
Subject: Re: Fwd: mmc card probe not getting called
From: chetan cr123 <chetancr123@gmail.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anish,

Thanks for your reply,

I was doing device registration for device by giving same name as
driver name, This i used to do in platform driver registration,

But i dont know how to do for mmc device registration,

And i also want to know which part of the code(file name) is doing the
string compare with the driver and device names and calling the probe
function. can u please point me to that part of code. from many days i
was searching from which part of code where string compare is done and
calls the probe function.


Kindly point me out to that part of code.



On Tue, Feb 19, 2013 at 9:25 PM, anish kumar
<anish198519851985@gmail.com> wrote:
> On Tue, 2013-02-19 at 12:16 +0530, chetan cr123 wrote:
>> HI All,
>>
>> I am working on Sd Card/Block driver
>>
>> I am registering it as both
>>
>> 1. register_blkdev()-------------  BLOCK Regsiter
>> 2. mmc_register_driver ------  MMC regsiter
>>
>> and filling the mmc_driver structure.
>>
>> I am not able to see the probe of MMC, But i see the return value of
>> mmc_register function returning success.
> I am not an expert on MMC driver but AFAIK it is no different in terms
> of following device/driver model.
> Probe of a function is only called when device name matches with driver
> name and when it happens driver calls your probe.
>
> So in your case even though you have registered the driver, looks like
> you are missing the device registration part.Do that and see the magic.
> If this is SOC then that is done in the board file i.e.
> arch/arm/plat-xyz/....
>
>>
>> Kindly let me know how i make the probe of mmc getting called
>>
>> Thanks
>>
>>
>> Chetan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
