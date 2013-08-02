Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3HBOzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:55:22 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44547 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3HBOzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:55:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130802114159.GK2884@e106331-lin.cambridge.arm.com>
References: <1375098093-8975-1-git-send-email-jonas.jensen@gmail.com>
	<1375101228-10930-1-git-send-email-jonas.jensen@gmail.com>
	<20130802114159.GK2884@e106331-lin.cambridge.arm.com>
Date: Fri, 2 Aug 2013 16:55:20 +0200
Message-ID: <CACmBeS3M+3Bah849N9jC6TFft4SN=ZhZfUh=65zf5Lf2d+VoQg@mail.gmail.com>
Subject: Re: [PATCH v7] watchdog: Add MOXA ART watchdog driver
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>, "arm@kernel.org" <arm@kernel.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for the replies.

On 2 August 2013 13:41, Mark Rutland <mark.rutland@arm.com> wrote:
> It would be nice to have a fuller description here.

I have tried to elaborate the commit message, please point out if it
should be formatted differently.

>> +Example:
>> +
>> +     watchdog: watchdog@98500000 {
>> +             compatible = "moxa,moxart-watchdog";
>> +             reg = <0x98500000 0x10>;
>> +             clocks = <&coreclk>;
>> +     };
>
> This seems sensible to me. I assume the watchdog is a standalone unit,
> and not part of some larger piece of IP?

I think it's standalone, unfortunately documentation on the SoC (which
this is likely part of) is not publicly available.

The register is not shared with anything else.

> This is a probe path. Is the use of unlikely() really appropriate here?
> I suspect it doesn't make any appreciable difference, and should go.

No, it just happened to get copied from a reference driver.

Best regards,
Jonas
