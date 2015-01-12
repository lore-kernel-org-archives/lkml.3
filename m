Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbbALRgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:36:22 -0500
Received: from mx02.posteo.de ([89.146.194.165]:59048 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbbALRgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:36:21 -0500
Message-ID: <54B4060C.4010004@posteo.de>
Date: Mon, 12 Jan 2015 18:36:12 +0100
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: peterz@infradead.org, mingo@kernel.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] hwmon: jc42: use bitops' sign_extend16
References: <1418660317-21750-1-git-send-email-martink@posteo.de> <1418660317-21750-4-git-send-email-martink@posteo.de> <20141215212948.GA23765@roeck-us.net> <548FDC85.3060400@posteo.de> <54B251A7.3000403@posteo.de> <54B2AA69.80305@roeck-us.net>
In-Reply-To: <54B2AA69.80305@roeck-us.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2015-01-11 um 17:52 schrieb Guenter Roeck:
> On 01/11/2015 02:34 AM, Martin Kepplinger wrote:
>> Am 2014-12-16 um 08:17 schrieb Martin Kepplinger:
>>> Am 2014-12-15 um 22:29 schrieb Guenter Roeck:
>>>> On Mon, Dec 15, 2014 at 05:18:34PM +0100, Martin Kepplinger wrote:
>>>>> ---
>>>>
>>>> Some description would be nice. Also, please consider adding
>>>> relevant subsystem mailing lists and maintainers to your patches.
>>>>
>>>
>>> I shouldn't have added the Signed-off-by line to some of them. Sorry.
>>>
>>> The driver-patches are meant to be examples of what can be changed if
>>> the sign_extend functions are added. I don't know if they are taken and
>>> planned to post the driver patches (probably more) thereafter, and of
>>> course to the relevant people.
>>
>> Is this sign_extendXX() set of functions considered to be added to
>> bitops.h ?
>>
>> Just checking if I can prepare some driver-patches (the ones I posted
>> are just examples, meant to be re-sent to relevant maintainers when it's
>> time), or not.
>>
> 
> You should probably ask the question as response to patch 1/6.
> 
> In general, it might be useful to send example patches like this one as
> RFC.
> Sending it as real patch and then saying "it is just an example" may result
> in the entire series being ignored. This is not a matter of Signed-off
> or not
> (originally I didn't even understand what you wanted to say with your
> reply),
> but a matter of a non-misleading headline.
> 
> Thanks,
> Guenter
> 

Thanks for the advice. I resent, https://lkml.org/lkml/2015/1/12/590
because the thing is easier than it might now seem, and hope that
doesn't add confusion.

thanks again,
                         martin
