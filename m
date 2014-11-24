Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaKXMbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:31:10 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37056 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaKXMbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:31:08 -0500
MIME-Version: 1.0
In-Reply-To: <5470711C.5080707@kernel.org>
References: <1415623535-24337-1-git-send-email-daniel.baluta@intel.com>
	<1415623535-24337-7-git-send-email-daniel.baluta@intel.com>
	<54706DE7.7070107@kernel.org>
	<5470711C.5080707@kernel.org>
Date: Mon, 24 Nov 2014 14:31:06 +0200
X-Google-Sender-Auth: K8aR8K32LSpQj5SkLAJBVBsM2q4
Message-ID: <CAEnQRZDLiAH9vSTamxKChMQQwGJ+z7W-f7VHMQcaha3w+woy0w@mail.gmail.com>
Subject: Re: [PATCH v4 6/7] iio: dummy: Demonstrate the usage of new channel types
From: Daniel Baluta <daniel.baluta@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>
Cc: Daniel Baluta <daniel.baluta@intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        irina.tirdea@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 1:18 PM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 22/11/14 11:05, Jonathan Cameron wrote:
>> On 10/11/14 12:45, Daniel Baluta wrote:
>>> Adds support for the new channel types in the dummy driver:
>>>   * a new channel IIO_ACTIVITY
>>>   * two state transition events (running and walking)
>>>   * a new channel IIO_STEPS and support for reading and writing
>>>     pedometer step counter
>>>   * step detect event
>>>   * a new IIO_CHAN_INFO_CALIBHEIGHT mask bit for reading and writing
>>>     user's height.
>>>
>>> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
>>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>> The only bit that makes me wonder in here is allowing writing to the steps
>> and activity _input attributes.
>>
>> Now I can see that it makes sense from the point of view of testing the
>> interface and any userspace code, but the question here is whether the
>> 'normal IIO intefaces' of this dummy driver should correspond to real sensors
>> where writing to input channels isn't ever valid!.
>>
>> The alternative would be to create some deliberately not standard ABI for
>> these with a suitably obvious, 'I don't normally exist' naming - which
>> would then need documenting.  Perhaps what you have is the best option.
>> Pitty there isn't an out_steps_* interface.  Human interface control :)
>> Or even better out_activity_run_* which would be fun...
>>
>> Upshot is - leave this be.  It's our dummy driver afterall and we can
>> change the ABI as much as we like without anyone having a valid argument
>> that we broke their system ;)
>
> Applied to the togreg branch of iio.git - initially pushed out as testing.
>
> Nicely done with cc'ing a miss-spelt version of your own email address ;)

:)), I noticed that when was already too late.

Jonathan, Hartmut thanks for reviews!

Daniel.
