Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaBCOrC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:47:02 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:49717 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaBCOq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:46:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAAfyv37SenewbPw9BeLyS_djbxdZf+3aizbgOhhOPNdbmUJrUg@mail.gmail.com>
References: <1390685924-11877-1-git-send-email-marek@goldelico.com>
	<CAOesGMhFEMNFbAC4rUdccYVHM8yX9Mz+Vx73jGxBYGrSOa4Gaw@mail.gmail.com>
	<CAAfyv37SenewbPw9BeLyS_djbxdZf+3aizbgOhhOPNdbmUJrUg@mail.gmail.com>
Date: Mon, 3 Feb 2014 08:46:58 -0600
Message-ID: <CAL_Jsq++pxMmJrn+=dreFJMCT2EUxbOuhrGetBecUTb2ax4YOw@mail.gmail.com>
Subject: Re: [PATCH] of: add vendor prefix for Honeywell
From: Rob Herring <robherring2@gmail.com>
To: Belisko Marek <marek.belisko@gmail.com>, NeilBrown <neilb@suse.de>
Cc: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 3:46 PM, Belisko Marek <marek.belisko@gmail.com> wrote:
> On Fri, Jan 31, 2014 at 7:53 PM, Olof Johansson <olof@lixom.net> wrote:
>> On Sat, Jan 25, 2014 at 1:38 PM, Marek Belisko <marek@goldelico.com> wrote:
>>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>>> ---
>>>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
>>> index 3f900cd..b14c617 100644
>>> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>>> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>>> @@ -40,6 +40,7 @@ gmt   Global Mixed-mode Technology, Inc.
>>>  gumstix        Gumstix, Inc.
>>>  haoyu  Haoyu Microelectronic Co. Ltd.
>>>  hisilicon      Hisilicon Limited.
>>> +honeywell      Honeywell
>>
>> The norm has usually been to use the the stock ticker symbol of a
>> public company if it is available. In other words, I think the prefix
>> here should be 'hon', since Honeywell is a publicly traded company
>> under that ticker.
> OK I didn't know about that. I just pick name from here:
> Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt
> So we need to update also compatible property in mentioned file.

It appears this is already used in omap4-sdp dts for some time, so I'm
inclined to leave it as honeywell to avoid breaking old dtbs.

Rob
