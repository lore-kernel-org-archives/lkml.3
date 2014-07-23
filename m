Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaGWAoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:44:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:45636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaGWAoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:44:06 -0400
Message-ID: <53CF0550.2040309@kernel.org>
Date: Tue, 22 Jul 2014 20:44:00 -0400
From: Sasha Levin <sashal@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, mail@beyermatthias.de,
        hdegoede@redhat.com, dan.j.williams@intel.com,
        valentine.barshak@cogentembedded.com,
        Ming Lei <ming.lei@canonical.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-core: Remove Fix mes in file hcd.c
References: <1405704880-10036-1-git-send-email-xerofoify@gmail.com>	<53C9D997.7000409@kernel.org>	<CAPDOMVj6ex8GgMz6id+fgnCLg9hTbNoYxG4pebxDvMmf9xKTcQ@mail.gmail.com> <CAPDOMVg1Ga1wQserL=P9cmFgtPM+XLNFpY+t45QV0GvPLbTmwA@mail.gmail.com>
In-Reply-To: <CAPDOMVg1Ga1wQserL=P9cmFgtPM+XLNFpY+t45QV0GvPLbTmwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 10:52 PM, Nick Krause wrote:
> On Fri, Jul 18, 2014 at 10:45 PM, Nick Krause <xerofoify@gmail.com> wrote:
>> Sorry didn't run spell check. I will resend this patch with the
>> correct information
>> as needed. Thanks for the advice, Sasha.
>>
>> Cheers Nick
>>
>> On Fri, Jul 18, 2014 at 10:36 PM, Sasha Levin <sashal@kernel.org> wrote:
>>> On 07/18/2014 01:34 PM, Nicholas Krause wrote:
>>>> I am removing two fix mes in this file as after dicussing then it  seems
>>>> there is no reason to check against Null for usb_device as it can never
>>>> be NULL and this is check is therefore not needed.
>>>>
>>>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>>
>>> Please explain exactly why it's not needed, why it can never be NULL, and
>>> what prevents it from being NULL.
>>>
>>> "after dicussing" (do you run spellcheck on your mails?) won't mean anything
>>> to someone looking at this commit in a year.
>>>
>>> Your commit message also mentions usb_device which has nothing to do with
>>> your patch.
>>>
>>>
>>> Thanks,
>>> Sasha
> 
> Sasha ,
> Greg seems to have signed it off.
> Cheers Nick

Greg?

Even if the patch is correct (and I'm not saying it is) the commit message is way off.


Thanks,
Sasha
