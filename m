Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491AbaGXQRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:17:19 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:41414 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbaGXQRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:17:17 -0400
MIME-Version: 1.0
In-Reply-To: <53D1051D.4060204@suse.cz>
References: <1405704880-10036-1-git-send-email-xerofoify@gmail.com>
	<53C9D997.7000409@kernel.org>
	<CAPDOMVj6ex8GgMz6id+fgnCLg9hTbNoYxG4pebxDvMmf9xKTcQ@mail.gmail.com>
	<CAPDOMVg1Ga1wQserL=P9cmFgtPM+XLNFpY+t45QV0GvPLbTmwA@mail.gmail.com>
	<53CF0550.2040309@kernel.org>
	<CAPDOMVjezfw36YPaPKSDoFt7Ybmv_a1HFTA25uKh4S6J08wt5w@mail.gmail.com>
	<53D1051D.4060204@suse.cz>
Date: Thu, 24 Jul 2014 12:17:15 -0400
Message-ID: <CAPDOMViazLUR0Vs=5g3La8PfMB=d=tF9yxdfw0v+b=V_+PwoiA@mail.gmail.com>
Subject: Re: [PATCH] usb-core: Remove Fix mes in file hcd.c
From: Nick Krause <xerofoify@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Sasha Levin <sashal@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, mail@beyermatthias.de,
        hdegoede@redhat.com, dan.j.williams@intel.com,
        valentine.barshak@cogentembedded.com,
        Ming Lei <ming.lei@canonical.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 9:07 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> On 07/23/2014 05:24 AM, Nick Krause wrote:
>>
>> On Tue, Jul 22, 2014 at 8:44 PM, Sasha Levin <sashal@kernel.org> wrote:
>>>
>>> On 07/18/2014 10:52 PM, Nick Krause wrote:
>>>>>>
>>>>>> Please explain exactly why it's not needed, why it can never be NULL,
>>>>>> and
>>>>>> what prevents it from being NULL.
>>>>>>
>>>>>> "after dicussing" (do you run spellcheck on your mails?) won't mean
>>>>>> anything
>>>>>> to someone looking at this commit in a year.
>>>>>>
>>>>>> Your commit message also mentions usb_device which has nothing to do
>>>>>> with
>>>>>> your patch.
>>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Sasha
>>>>
>>>>
>>>> Sasha ,
>>>> Greg seems to have signed it off.
>>>> Cheers Nick
>>>
>>>
>>> Greg?
>>>
>>> Even if the patch is correct (and I'm not saying it is) the commit
>>> message is way off.
>>>
>>>
>>> Thanks,
>>> Sasha
>>
>>
>>
>> Sasha,
>> The patch is in the  kernel now.
>
>
> Greg's tree is not Linus' tree, so it's not set to stone in git commit
> history yet.
>
>
>> I am not going through the trouble of removing
>>
>> it, if you want to fix the commit message go on ahead.
>> Nick
>
>
> This kind of attitude might significantly lower your chances of future
> patches being accepted.
>
> Vlastimil
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>

I thought Greg's tree get's directly into the mainline and after
checking it seems to me in
 the mainline.
Cheers Nick
