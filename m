Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaDRQyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:54:43 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:56933 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDRQyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:54:39 -0400
MIME-Version: 1.0
In-Reply-To: <7706B5FF-45EB-4860-BD12-204B341A510D@konsulko.com>
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com>
	<CANk1AXTb=ob52AfK2z--HvFkxJnjnfYWuTCch_Gw99OCoS1ABg@mail.gmail.com>
	<7706B5FF-45EB-4860-BD12-204B341A510D@konsulko.com>
Date: Fri, 18 Apr 2014 11:54:38 -0500
Message-ID: <CANk1AXSCfpYCgZaqPKqPo1wafXaD_t3f4C0YXGfTYCZE8oL8yw@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Introducing (yet again) Device Tree Overlays
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:12 AM, Pantelis Antoniou
<pantelis.antoniou@konsulko.com> wrote:
> Hi Alan,
>
> Ugh, very sorry for the late reply; my mailer filed this somewhere I don't look at very frequently.
>
> On Mar 28, 2014, at 8:27 PM, delicious quinoa wrote:
>
>> On Tue, Mar 18, 2014 at 4:55 PM, Pantelis Antoniou
>> <pantelis.antoniou@konsulko.com> wrote:
>>> The following patchset introduces Device Tree overlays, a method
>>> of dynamically altering the kernel's live Device Tree, along with
>>> a generic interface to use it in a board agnostic manner.
>>>
>
> [snip]
>
>> \
>> I did some debug, haven't figured anything out yet.
>>
>> I have been able to successfully add/remove an overlay if it was to a
>> fpga node that was at /fpga and used 'target = <&fpga>;'   Also
>> 'target-path="/fpga";' works fine.
>>
>
> Yes, platform devices are broken; I carry a patch that fixes all of that mess, and I intend to follow up with it.

That's great.  I like this patchset and what it can do.

Regards,
Alan

>
>> Alan Tull
>> aka
>> delicious quinoa
>> --
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Regards
>
> -- Pantelis
>
